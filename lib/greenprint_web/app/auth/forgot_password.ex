defmodule GreenprintWeb.App.Auth.ForgotPassword do
  use GreenprintWeb, :live_view

  alias Greenprint.Users

  @impl true
  def render(assigns) do
    form_errors = if assigns[:form], do: translate_errors(assigns.form), else: %{}

    props = %{
      mode: Map.get(assigns, :mode, "forgot"),
      token: Map.get(assigns, :token),
      errors: form_errors
    }

    ~H"""
    <.svelte name="app/pages/auth/ForgotPassword" props={props} socket={@socket} />
    """
  end

  # Forgot password mode
  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"), mode: "forgot")}
  end

  # Reset password mode with token
  def mount(%{"token" => token}, _session, socket) do
    socket = assign_user_and_token(socket, %{"token" => token})

    form_source =
      case socket.assigns do
        %{user: user} ->
          Users.change_user_password(user)

        _ ->
          %{}
      end

    {:ok, assign_form(socket, form_source) |> assign(mode: "reset", token: token), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Users.get_user_by_email(email) do
      Users.deliver_user_reset_password_instructions(
        user,
        &url(~p"/auth/forgot-password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end

  @impl true
  def handle_event("reset_password", %{"user" => user_params}, socket) do
    case Users.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password reset successfully.")
         |> redirect(to: ~p"/auth/login")}

      {:error, changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :insert))}
    end
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Users.change_user_password(socket.assigns.user, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_user_and_token(socket, %{"token" => token}) do
    if user = Users.get_user_by_reset_password_token(token) do
      assign(socket, user: user, token: token)
    else
      socket
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: ~p"/")
    end
  end

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source, as: "user"))
  end

  defp translate_errors(form) do
    form.errors
    |> Enum.reduce(%{}, fn {field, {message, _opts}}, acc ->
      field_errors = Map.get(acc, field, [])
      Map.put(acc, field, [message | field_errors])
    end)
  end
end
