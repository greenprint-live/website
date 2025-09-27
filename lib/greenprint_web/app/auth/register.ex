defmodule GreenprintWeb.App.Auth.Register do
  use GreenprintWeb, :live_view

  alias Greenprint.Users
  alias Greenprint.Users.User

  @impl true
  def render(assigns) do
    form_errors = if assigns[:form], do: translate_errors(assigns.form), else: %{}

    props = %{
      errors: form_errors,
      check_errors: Map.get(assigns, :check_errors, false),
      trigger_submit: Map.get(assigns, :trigger_submit, false)
    }

    ~H"""
    <.svelte name="app/pages/auth/Register" props={props} socket={@socket} />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    changeset = Users.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Users.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Users.deliver_user_confirmation_instructions(
            user,
            &url(~p"/auth/confirm/#{&1}")
          )

        # Create a form for auto-login after registration
        changeset = Users.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Users.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  defp translate_errors(form) do
    form.errors
    |> Enum.reduce(%{}, fn {field, {message, _opts}}, acc ->
      field_errors = Map.get(acc, field, [])
      Map.put(acc, field, [message | field_errors])
    end)
  end
end
