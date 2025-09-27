defmodule GreenprintWeb.App.Auth.Confirm do
  @moduledoc """
  Email confirmation LiveView with comprehensive type specifications.
  """

  use GreenprintWeb, :live_view

  alias Greenprint.{Users, Types}

  @impl true
  @spec render(Types.assigns()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    props = %{
      mode: Map.get(assigns, :mode, "confirm"),
      token: Map.get(assigns, :token)
    }

    ~H"""
    <.svelte name="app/pages/auth/Confirm" props={props} socket={@socket} />
    """
  end

  # Email confirmation with token
  @impl true
  @spec mount(Types.lv_params(), Types.lv_session(), Types.socket()) :: Types.lv_mount_result()
  def mount(%{"token" => token}, _session, socket) do
    form = to_form(%{"token" => token}, as: "user")
    {:ok, assign(socket, form: form, mode: "confirm", token: token), temporary_assigns: [form: nil]}
  end

  # Resend confirmation instructions
  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"), mode: "resend")}
  end

  @impl true
  @spec handle_event(Types.event_name(), Types.event_params(), Types.socket()) :: Types.lv_event_result()
  def handle_event("confirm_account", %{"user" => %{"token" => token}}, socket) do
    case Users.confirm_user(token) do
      {:ok, _} ->
        {:noreply,
         socket
         |> redirect(to: ~p"/")}

      :error ->
        # If there is a current user and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the user themselves, so we redirect without
        # a warning message.
        case socket.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            {:noreply, redirect(socket, to: ~p"/")}

          %{} ->
            {:noreply,
             socket
             |> redirect(to: ~p"/")}
        end
    end
  end

  def handle_event("send_instructions", %{"user" => %{"email" => email}}, socket) do
    if user = Users.get_user_by_email(email) do
      Users.deliver_user_confirmation_instructions(
        user,
        &url(~p"/auth/confirm/#{&1}")
      )
    end

    info =
      "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."

    {:noreply,
     socket
     |> redirect(to: ~p"/")}
  end
end
