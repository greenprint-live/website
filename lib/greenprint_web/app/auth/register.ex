defmodule GreenprintWeb.App.Auth.Register do
  @moduledoc """
  Registration LiveView with comprehensive type specifications.
  """

  use GreenprintWeb, :live_view

  alias Greenprint.{Users, Types}
  alias Greenprint.Users.User

  @impl true
  @spec render(Types.assigns()) :: Phoenix.LiveView.Rendered.t()
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
  @spec mount(Types.lv_params(), Types.lv_session(), Types.socket()) :: Types.lv_mount_result()
  def mount(_params, _session, socket) do
    changeset = Users.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  @impl true
  @spec handle_event(Types.event_name(), Types.event_params(), Types.socket()) :: Types.lv_event_result()
  def handle_event("save", %{"user" => user_params}, socket) do
    case Users.register_user(user_params) do
      {:ok, user} ->
        _result =
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

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Users.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  @spec assign_form(Types.socket(), Types.changeset(User.t())) :: Types.socket()
  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  @spec translate_errors(Types.form()) :: Types.form_errors()
  defp translate_errors(form) do
    form.errors
    |> Enum.reduce(%{}, fn {field, {message, _opts}}, acc ->
      field_errors = Map.get(acc, field, [])
      Map.put(acc, field, [message | field_errors])
    end)
  end
end
