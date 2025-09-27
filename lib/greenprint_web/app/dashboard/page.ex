defmodule GreenprintWeb.App.Dashboard do
  use GreenprintWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
      <.svelte name="app/pages/Dashboard" socket={@socket} />
    """
  end
end
