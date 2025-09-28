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

  defp format_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
