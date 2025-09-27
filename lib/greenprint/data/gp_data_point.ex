defmodule Greenprint.Data.GPDataPoint do
  @moduledoc """
  GPDataPoint schema representing individual sensor data points with comprehensive type specifications.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Greenprint.Types

  @type t :: %__MODULE__{
    id: Types.id(),
    value: Types.sensor_value(),
    owner_gp_data_source_id: Types.gp_data_source_id(),
    inserted_at: Types.timestamp(),
    updated_at: Types.timestamp()
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "gp_data_points" do
    field :value, :float
    field :owner_gp_data_source_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  @spec changeset(t(), Types.attrs()) :: Types.changeset(t())
  def changeset(gp_data_point, attrs) do
    gp_data_point
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
