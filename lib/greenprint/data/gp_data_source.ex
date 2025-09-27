defmodule Greenprint.Data.GPDataSource do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :owner_gp_hub_id, :display_name, :description, :type, :inserted_at, :updated_at]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "gp_data_sources" do
    belongs_to :owner_gp_hub, Greenprint.GPHub
    field :type, :string
    field :description, :string
    field :display_name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(gp_data_source, attrs) do
    gp_data_source
    |> cast(attrs, [:owner_gp_hub_id, :display_name, :description, :type])
    |> validate_required([:owner_gp_hub_id, :display_name, :description, :type])
  end
end
