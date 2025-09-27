defmodule GreenprintWeb.App.Auth.Login do
  use GreenprintWeb, :live_view

  @impl true
  def render(assigns) do
    props = %{
      email: Phoenix.Flash.get(assigns.flash, :email) || ""
    }

    ~H"""
    <.svelte name="app/pages/auth/Login" props={props} socket={@socket} />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
