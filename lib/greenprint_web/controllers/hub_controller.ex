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

  def index(conn, _params) do
    # Skip authentication for agent access
    # current_user = conn.assigns.current_user
    # hubs = Data.list_user_gp_hubs(current_user.id)

    # For agent access, list all hubs (or implement hub filtering by agent context)
    hubs = Data.list_gp_hubs()

    formatted_hubs = Enum.map(hubs, &format_hub/1)

    conn
    |> put_status(:ok)
    |> json(%{
      success: true,
      hubs: formatted_hubs,
      count: length(formatted_hubs)
    })
  end

  def show(conn, %{"hub_id" => hub_id}) do
    case Data.get_gp_hub(hub_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{success: false, error: "Hub not found"})

      hub ->
        conn
        |> put_status(:ok)
        |> json(%{
          success: true,
          hub: format_hub(hub)
        })
    end
  end

  def data_sources(conn, %{"hub_id" => hub_id}) do
    case Data.get_gp_hub(hub_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{success: false, error: "Hub not found"})

      _hub ->
        data_sources = Data.list_gp_hub_data_sources(hub_id)
        formatted_data_sources = Enum.map(data_sources, &format_data_source/1)

        conn
        |> put_status(:ok)
        |> json(%{
          success: true,
          data_sources: formatted_data_sources,
          count: length(formatted_data_sources)
        })
    end
  end

  def overview(conn, %{"hub_id" => hub_id}) do
    case Data.get_gp_hub(hub_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{success: false, error: "Hub not found"})

      hub ->
        data_sources_with_latest = Data.get_hub_data_sources_with_latest_points(hub_id)

        formatted_overview = %{
          hub: format_hub(hub),
          data_sources: Enum.map(data_sources_with_latest, fn %{data_source: ds, latest_point: latest} ->
            %{
              data_source: format_data_source(ds),
              latest_point: if(latest, do: format_data_point(latest), else: nil)
            }
          end)
        }

        conn
        |> put_status(:ok)
        |> json(%{
          success: true,
          overview: formatted_overview
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

  defp format_hub(hub) do
    %{
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
