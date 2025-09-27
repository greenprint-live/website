defmodule GreenprintWeb.App.Dashboard do
  use GreenprintWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
      <.svelte name="app/pages/Dashboard" props={%{current_user: @current_user}} socket={@socket} />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
