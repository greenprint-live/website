defmodule GreenprintWeb.App.HubDisplay do
  use GreenprintWeb, :live_view

  alias Greenprint.Types
  alias Greenprint.Data

  @impl true
  @spec render(Types.assigns()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
      <div phx-hook="RealtimeData" id="hub-display-container">
        <.svelte name="app/pages/HubDisplay" props={@props} socket={@socket} />
      </div>
    """
  end

  @impl true
  @spec mount(Types.lv_params(), Types.lv_session(), Types.socket()) :: Types.lv_mount_result()
  def mount(%{"hub_id" => hub_id}, _session, socket) do
    current_user = socket.assigns.current_user

    case Data.get_gp_hub(hub_id) do
      nil ->
        {:ok,
         socket
         |> redirect(to: "/dashboard")}

      hub ->
        if hub.owner_user_id != current_user.id do
          {:ok,
           socket
           |> redirect(to: "/dashboard")}
        else
          data_sources = Data.list_gp_hub_data_sources(hub_id)

          # Subscribe to PubSub for real-time updates
          if connected?(socket) do
            Enum.each(data_sources, fn ds ->
              Phoenix.PubSub.subscribe(Greenprint.PubSub, "data_source:#{ds.id}")
            end)
          end

          # Get real data for each data source
          data_sources_with_data = Enum.map(data_sources, fn ds ->
            data_info = Data.get_data_source_with_latest(ds.id)
            format_data_source_with_data(ds, data_info)
          end)

          props = %{
            hub: format_hub(hub),
            data_sources: data_sources_with_data,
            current_user: current_user
          }

          {:ok, assign(socket, :props, props)}
        end
    end
  end

  @impl true
  def handle_info({:data_point_updated, data_source_id}, socket) do
    # Update the specific data source with new data
    current_props = socket.assigns.props

    # Fetch fresh data for the updated data source
    data_source = Data.get_gp_data_source!(data_source_id)
    data_info = Data.get_data_source_with_latest(data_source_id)
    updated_data_source = format_data_source_with_data(data_source, data_info)

    updated_data_sources = Enum.map(current_props.data_sources, fn ds ->
      if ds.id == data_source_id do
        updated_data_source
      else
        ds
      end
    end)

    updated_props = %{current_props | data_sources: updated_data_sources}

    # Push the update to the frontend via the hook
    socket =
      socket
      |> assign(:props, updated_props)
      |> push_event("data_source_updated", %{
        data_source_id: data_source_id,
        data_source: updated_data_source
      })

    {:noreply, socket}
  end

  defp format_hub(hub) do
    %{
      id: hub.id,
      ownerUserId: hub.owner_user_id,
      serialNumber: hub.serial_number,
      displayName: hub.display_name,
      description: hub.description,
      location: hub.location,
      insertedAt: hub.inserted_at,
      updatedAt: hub.updated_at
    }
  end

  defp format_data_source_with_data(data_source, %{latest: latest, trend: trend}) do
    %{
      id: data_source.id,
      ownerGpHubId: data_source.owner_gp_hub_id,
      displayName: data_source.display_name,
      description: data_source.description,
      type: data_source.type,
      insertedAt: data_source.inserted_at,
      updatedAt: data_source.updated_at,
      # Real data fields
      currentValue: if(latest, do: latest.value, else: nil),
      lastUpdated: if(latest, do: latest.inserted_at, else: nil),
      trend: trend,
      status: determine_status(latest)
    }
  end

  defp determine_status(nil), do: "inactive"
  defp determine_status(latest_point) do
    # Consider data stale if it's older than 5 minutes
    five_minutes_ago = DateTime.add(DateTime.utc_now(), -5, :minute)

    if DateTime.compare(latest_point.inserted_at, five_minutes_ago) == :gt do
      "active"
    else
      "inactive"
    end
  end
end
