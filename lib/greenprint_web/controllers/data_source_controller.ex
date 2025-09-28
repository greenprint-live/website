defmodule GreenprintWeb.DataSourceController do
  use GreenprintWeb, :controller

  alias Greenprint.Data

  def create_batch(conn, %{"hub_id" => hub_id, "data_sources" => data_sources_params}) do
    current_user = conn.assigns.current_user

    # Verify the hub belongs to the current user
    case Data.get_gp_hub(hub_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{success: false, error: "Hub not found"})

      hub ->
        if hub.owner_user_id != current_user.id do
          conn
          |> put_status(:forbidden)
          |> json(%{success: false, error: "Access denied"})
        else
          create_data_sources(conn, hub_id, data_sources_params)
        end
    end
  end

  defp create_data_sources(conn, hub_id, data_sources_params) do
    results =
      Enum.map(data_sources_params, fn data_source_params ->
        attrs = Map.put(data_source_params, "owner_gp_hub_id", hub_id)
        Data.create_gp_data_source(attrs)
      end)

    # Check if all creations were successful
    case Enum.split_with(results, fn {status, _} -> status == :ok end) do
      {successes, []} ->
        # All successful
        data_sources = Enum.map(successes, fn {:ok, ds} -> format_data_source(ds) end)

        conn
        |> put_status(:created)
        |> json(%{
          success: true,
          data_sources: data_sources,
          count: length(data_sources)
        })

      {successes, failures} ->
        # Some failed
        successful_data_sources = Enum.map(successes, fn {:ok, ds} -> format_data_source(ds) end)
        errors = Enum.map(failures, fn {:error, changeset} -> format_changeset_errors(changeset) end)

        conn
        |> put_status(:partial_content)
        |> json(%{
          success: false,
          data_sources: successful_data_sources,
          errors: errors,
          successful_count: length(successes),
          failed_count: length(failures)
        })
    end
  end

  def show(conn, %{"data_source_id" => data_source_id}) do
    case Data.get_gp_data_source(data_source_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{success: false, error: "Data source not found"})

      data_source ->
        conn
        |> put_status(:ok)
        |> json(%{
          success: true,
          data_source: format_data_source(data_source)
        })
    end
  end

  def data_points(conn, %{"data_source_id" => data_source_id} = params) do
    case Data.get_gp_data_source(data_source_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{success: false, error: "Data source not found"})

      _data_source ->
        opts = build_query_opts(params)
        data_points = Data.list_data_source_points(data_source_id, opts)
        formatted_data_points = Enum.map(data_points, &format_data_point/1)

        conn
        |> put_status(:ok)
        |> json(%{
          success: true,
          data_points: formatted_data_points,
          count: length(formatted_data_points)
        })
    end
  end

  def latest(conn, %{"data_source_id" => data_source_id}) do
    case Data.get_gp_data_source(data_source_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{success: false, error: "Data source not found"})

      _data_source ->
        latest_point = Data.get_latest_data_point(data_source_id)

        conn
        |> put_status(:ok)
        |> json(%{
          success: true,
          latest_point: if(latest_point, do: format_data_point(latest_point), else: nil)
        })
    end
  end

  def stats(conn, %{"data_source_id" => data_source_id} = params) do
    case Data.get_gp_data_source(data_source_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{success: false, error: "Data source not found"})

      _data_source ->
        case {Map.get(params, "start_time"), Map.get(params, "end_time")} do
          {nil, nil} ->
            conn
            |> put_status(:bad_request)
            |> json(%{success: false, error: "start_time and end_time parameters are required"})

          {start_time_str, end_time_str} ->
            with {:ok, start_time} <- parse_datetime(start_time_str),
                 {:ok, end_time} <- parse_datetime(end_time_str) do
              stats = Data.get_data_point_stats(data_source_id, start_time, end_time)

              conn
              |> put_status(:ok)
              |> json(%{
                success: true,
                stats: stats
              })
            else
              {:error, reason} ->
                conn
                |> put_status(:bad_request)
                |> json(%{success: false, error: "Invalid datetime format: #{reason}"})
            end
        end
    end
  end

  def trend(conn, %{"data_source_id" => data_source_id}) do
    case Data.get_gp_data_source(data_source_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{success: false, error: "Data source not found"})

      _data_source ->
        trend_data = Data.get_data_source_with_latest(data_source_id)

        conn
        |> put_status(:ok)
        |> json(%{
          success: true,
          data_source: if(trend_data.data_source, do: format_data_source(trend_data.data_source), else: nil),
          latest_point: if(trend_data.latest, do: format_data_point(trend_data.latest), else: nil),
          trend: trend_data.trend
        })
    end
  end

  defp build_query_opts(params) do
    opts = []

    opts = case Map.get(params, "since") do
      nil -> opts
      since_str ->
        case parse_datetime(since_str) do
          {:ok, since_time} -> Keyword.put(opts, :since, since_time)
          {:error, _} -> opts
        end
    end

    opts = case Map.get(params, "until") do
      nil -> opts
      until_str ->
        case parse_datetime(until_str) do
          {:ok, until_time} -> Keyword.put(opts, :until, until_time)
          {:error, _} -> opts
        end
    end

    opts = case Map.get(params, "limit") do
      nil -> opts
      limit_str ->
        case Integer.parse(limit_str) do
          {limit, ""} -> Keyword.put(opts, :limit, limit)
          _ -> opts
        end
    end

    opts
  end

  defp parse_datetime(datetime_str) when is_binary(datetime_str) do
    case DateTime.from_iso8601(datetime_str) do
      {:ok, datetime, _offset} -> {:ok, datetime}
      {:error, reason} -> {:error, reason}
    end
  end

  defp parse_datetime(_), do: {:error, "invalid format"}

  defp format_data_source(data_source) do
    %{
      id: data_source.id,
      ownerGpHubId: data_source.owner_gp_hub_id,
      displayName: data_source.display_name,
      description: data_source.description,
      type: data_source.type,
      agentMailInbox: data_source.agent_mail_inbox,
      insertedAt: data_source.inserted_at,
      updatedAt: data_source.updated_at
    }
  end

  defp format_data_point(data_point) do
    %{
      id: data_point.id,
      value: data_point.value,
      ownerGpDataSourceId: data_point.owner_gp_data_source_id,
      insertedAt: data_point.inserted_at,
      updatedAt: data_point.updated_at
    }
  end

  defp format_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
