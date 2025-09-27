defmodule Greenprint.Data.GPHub do
  @moduledoc """
  GPHub schema representing a data collection hub with comprehensive type specifications.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Greenprint.Types
  alias Greenprint.Users.User

  @type t :: %__MODULE__{
    id: Types.id(),
    owner_user_id: Types.user_id(),
    owner_user: User.t() | Ecto.Association.NotLoaded.t() | nil,
    serial_number: Types.serial_number(),
    display_name: Types.display_name(),
    description: Types.description(),
    location: Types.location(),
    inserted_at: Types.timestamp(),
    updated_at: Types.timestamp()
  }

  @derive {Jason.Encoder, only: [:id, :owner_user_id, :serial_number, :display_name, :description, :location, :inserted_at, :updated_at]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "gp_hubs" do
    belongs_to :owner_user, Greenprint.Users.User
    field :description, :string
    field :location, :string
    field :serial_number, :string
    field :display_name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  @spec changeset(t(), Types.attrs()) :: Types.changeset(t())
  def changeset(gp_hub, attrs) do
    gp_hub
    |> cast(attrs, [:owner_user_id, :serial_number, :display_name, :description, :location])
    |> validate_required([:owner_user_id, :serial_number, :display_name, :description, :location])
  end
end
