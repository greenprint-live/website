defmodule GreenprintWeb.App.Dashboard do
  @moduledoc """
  Dashboard LiveView with comprehensive type specifications.
  """

  use GreenprintWeb, :live_view

  alias Greenprint.Types

  @impl true
  @spec render(Types.assigns()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
      <.svelte name="app/pages/Dashboard" props={%{current_user: @current_user}} socket={@socket} />
    """
  end

  @impl true
  @spec mount(Types.lv_params(), Types.lv_session(), Types.socket()) :: Types.lv_mount_result()
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
