defmodule Greenprint.Types do
  @moduledoc """
  Defines custom types for the Greenprint application to ensure strict typing
  throughout the codebase.
  """

  # Primary key types
  @type id :: binary() | nil
  @type user_id :: binary()
  @type gp_hub_id :: binary()
  @type gp_data_source_id :: binary()
  @type gp_data_point_id :: binary()

  # User-related types
  @type email :: String.t()
  @type password :: String.t()
  @type hashed_password :: String.t()
  @type user_token :: String.t()

  # Data types
  @type sensor_type :: String.t()
  @type sensor_value :: float()
  @type location :: String.t()
  @type description :: String.t()
  @type display_name :: String.t()
  @type serial_number :: String.t()

  # Changeset and result types
  @type changeset :: Ecto.Changeset.t()
  @type changeset(schema) :: Ecto.Changeset.t(schema)
  @type repo_result(schema) :: {:ok, schema} | {:error, changeset(schema)}
  @type maybe_result(value) :: {:ok, value} | {:error, any()}

  # Phoenix-specific types
  @type conn :: Plug.Conn.t()
  @type params :: map()
  @type attrs :: map()
  @type opts :: keyword()

  # Time-related types
  @type utc_datetime :: DateTime.t() | NaiveDateTime.t() | nil
  @type timestamp :: DateTime.t() | NaiveDateTime.t()

  # Authentication types
  @type auth_result ::
    {:ok, Greenprint.Users.User.t()}
    | {:error, :already_confirmed}
    | {:error, atom()}
    | :error

  # Email delivery result type from Swoosh
  @type email_delivery_result ::
    {:ok, Swoosh.Email.t()}
    | {:error, any()}

  @type session_token :: binary()
  @type remember_me_token :: binary()
  @type email_token :: binary()

  # LiveView types
  @type socket :: Phoenix.LiveView.Socket.t()
  @type live_action :: atom()
  @type assigns :: map()

  # Common data structures
  @type json_map :: %{String.t() => any()}
  @type string_map :: %{String.t() => String.t()}
  @type atom_map :: %{atom() => any()}

  # URL and path types
  @type url_fun :: (String.t() -> String.t())
  @type path :: String.t()
  @type url :: String.t()

  # Database query types
  @type query :: Ecto.Query.t()
  @type queryable :: Ecto.Queryable.t()

  # Multi-transaction types
  @type multi :: Ecto.Multi.t()
  @type multi_result :: {:ok, map()} | {:error, atom(), any(), map()}

  # File and external resource types
  @type file_path :: String.t()
  @type file_content :: binary()
end
