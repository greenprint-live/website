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

  defp format_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
