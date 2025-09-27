defmodule Greenprint.Data.GPDataSourceConfiguration do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "gp_data_source_configurations" do
    field :alarms, :map
    field :data_source_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(gp_data_source_configuration, attrs) do
    gp_data_source_configuration
    |> cast(attrs, [:alarms])
    |> validate_required([])
  end
end
