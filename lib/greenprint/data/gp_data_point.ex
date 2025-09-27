defmodule Greenprint.Data.GPDataPoint do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "gp_data_points" do
    field :value, :float
    field :owner_gp_data_source_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(gp_data_point, attrs) do
    gp_data_point
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
