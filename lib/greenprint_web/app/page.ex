defmodule GreenprintWeb.App do
  use GreenprintWeb, :live_view

  @impl true
  def render(assigns) do
    props = if Map.has_key?(assigns, :current_user) do
      %{ current_user: assigns.current_user }
    else
      %{}
    end

    ~H"""
      <.svelte name="app/pages/Home" props={props} socket={@socket} />
    """
  end
end
