defmodule GreenprintWeb.UserSessionController do
  @moduledoc """
  Controller for user session management with comprehensive type specifications.
  """

  use GreenprintWeb, :controller

  alias Greenprint.{Users, Types}
  alias GreenprintWeb.UserAuth

  @spec create(Types.conn(), Types.params()) :: Types.conn()
  def create(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "Account created successfully!")
  end

  @spec create(Types.conn(), Types.params()) :: Types.conn()
  def create(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:user_return_to, ~p"/auth/settings")
    |> create(params, "Password updated successfully!")
  end

  @spec create(Types.conn(), Types.params()) :: Types.conn()
  def create(conn, params) do
    create(conn, params, "Welcome back!")
  end

  @spec create(Types.conn(), Types.params(), String.t()) :: Types.conn()
  defp create(conn, %{"user" => user_params}, info) do
    %{"email" => email, "password" => password} = user_params

    if user = Users.get_user_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, info)
      |> UserAuth.log_in_user(user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_flash(:error, "Invalid email or password")
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/auth/login")
    end
  end

  @spec delete(Types.conn(), Types.params()) :: Types.conn()
  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
