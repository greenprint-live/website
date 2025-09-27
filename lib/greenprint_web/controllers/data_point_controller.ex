defmodule GreenprintWeb.DataPointController do
  use GreenprintWeb, :controller

  alias Greenprint.Data

  def create(conn, %{"data_source_id" => data_source_id, "value" => value}) do
    current_user = conn.assigns.current_user

    # Verify the data source exists and belongs to a hub owned by the current user
    case Data.get_gp_data_source(data_source_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{success: false, error: "Data source not found"})

      data_source ->
        case Data.get_gp_hub(data_source.owner_gp_hub_id) do
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
              create_data_point(conn, data_source_id, value)
            end
        end
    end
  end

  def create(conn, %{"data_source_id" => data_source_id, "data_point" => data_point_params}) do
    # Handle nested data_point parameter
    case Map.get(data_point_params, "value") do
      nil ->
        conn
        |> put_status(:bad_request)
        |> json(%{success: false, error: "Value is required"})

      value ->
        create(conn, %{"data_source_id" => data_source_id, "value" => value})
    end
  end

  def create(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{success: false, error: "Value is required"})
  end

  defp create_data_point(conn, data_source_id, value) do
    attrs = %{
      "owner_gp_data_source_id" => data_source_id,
      "value" => value
    }

    case Data.create_gp_data_point(attrs) do
      {:ok, data_point} ->
        # Broadcast the update via PubSub
        Phoenix.PubSub.broadcast(
          Greenprint.PubSub,
          "data_source:#{data_source_id}",
          {:data_point_updated, data_source_id}
        )

        conn
        |> put_status(:created)
        |> json(%{
          success: true,
          data_point: %{
            id: data_point.id,
            value: data_point.value,
            dataSourceId: data_point.owner_gp_data_source_id,
            insertedAt: data_point.inserted_at
          }
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          success: false,
          errors: format_changeset_errors(changeset)
        })
    end
  end

  defp format_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
