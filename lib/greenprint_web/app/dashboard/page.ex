defmodule GreenprintWeb.App.Dashboard do
  use GreenprintWeb, :live_view

  alias Greenprint.Types
  alias Greenprint.Data

  @impl true
  @spec render(Types.assigns()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    hubs = Data.list_user_gp_hubs(assigns.current_user.id)
    assigns = assign(assigns, :props, %{hubs: hubs, current_user: assigns.current_user})

    ~H"""
      <.svelte name="app/pages/Dashboard" props={@props} socket={@socket} />
    """
  end

  @impl true
  @spec mount(Types.lv_params(), Types.lv_session(), Types.socket()) :: Types.lv_mount_result()
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
