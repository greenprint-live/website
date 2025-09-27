defmodule GreenprintWeb.App do
  use GreenprintWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
      <.svelte name="app/home/HomePage" socket={@socket} />
    """
  end
end
