defmodule Greenprint.Data.GPHub do
  use Ecto.Schema
  import Ecto.Changeset

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
  def changeset(gp_hub, attrs) do
    gp_hub
    |> cast(attrs, [:owner_user_id, :serial_number, :display_name, :description, :location])
    |> validate_required([:owner_user_id, :serial_number, :display_name, :description, :location])
  end
end
