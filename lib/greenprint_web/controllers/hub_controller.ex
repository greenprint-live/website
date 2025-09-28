defmodule GreenprintWeb.HubController do
  use GreenprintWeb, :controller

  alias Greenprint.Data

  def create(conn, %{"hub" => hub_params}) do
    current_user = conn.assigns.current_user

    hub_attrs = Map.put(hub_params, "owner_user_id", current_user.id)

    case Data.create_gp_hub(hub_attrs) do
      {:ok, hub} ->
        conn
        |> put_status(:created)
        |> json(%{
          success: true,
          hub: %{
            id: hub.id,
            ownerUserId: hub.owner_user_id,
            serialNumber: hub.serial_number,
            displayName: hub.display_name,
            description: hub.description,
            location: hub.location,
            agentMailInbox: hub.agent_mail_inbox,
            insertedAt: hub.inserted_at,
            updatedAt: hub.updated_at
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

  def delete(conn, %{"hub_id" => hub_id}) do
    current_user = conn.assigns.current_user

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
          case Data.delete_gp_hub(hub) do
            {:ok, _deleted_hub} ->
              conn
              |> put_status(:ok)
              |> json(%{success: true, message: "Hub deleted successfully"})

            {:error, changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> json(%{
                success: false,
                errors: format_changeset_errors(changeset)
              })
          end
        end
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
