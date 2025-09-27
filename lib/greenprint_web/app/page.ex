defmodule GreenprintWeb.App do
  @moduledoc """
  Main application LiveView with comprehensive type specifications.
  """

  use GreenprintWeb, :live_view

  alias Greenprint.Types

  @impl true
  @spec render(Types.assigns()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    assigns = if Map.has_key?(assigns, :current_user) do
      assign(assigns, :props, %{current_user: assigns.current_user})
    else
      assign(assigns, :props, %{})
    end

    ~H"""
      <.svelte name="app/pages/Home" props={@props} socket={@socket} />
    """
  end

  @impl true
  @spec mount(Types.lv_params(), Types.lv_session(), Types.socket()) :: Types.lv_mount_result()
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
