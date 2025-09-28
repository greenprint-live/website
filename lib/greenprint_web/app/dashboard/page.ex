defmodule GreenprintWeb.App.Dashboard do
  use GreenprintWeb, :live_view

  alias Greenprint.Types
  alias Greenprint.Data

  @impl true
  @spec render(Types.assigns()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    hubs = Data.list_user_gp_hubs(assigns.current_user.id)
    |> Enum.map(&convert_hub_to_camel_case/1)

    assigns = assign(assigns, :props, %{hubs: hubs, current_user: assigns.current_user})

    ~H"""
      <.svelte name="app/pages/Dashboard" props={@props} socket={@socket} />
    """
  end

  @spec convert_hub_to_camel_case(Data.GPHub.t()) :: map()
  defp convert_hub_to_camel_case(hub) do
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

  @impl true
  @spec mount(Types.lv_params(), Types.lv_session(), Types.socket()) :: Types.lv_mount_result()
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
