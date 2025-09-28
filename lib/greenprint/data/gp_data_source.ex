defmodule Greenprint.Data.GPDataSource do
  @moduledoc """
  GPDataSource schema representing a data source with comprehensive type specifications.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Greenprint.Types
  alias Greenprint.Data.GPHub

  @type t :: %__MODULE__{
    id: Types.id(),
    owner_gp_hub_id: Types.gp_hub_id(),
    owner_gp_hub: GPHub.t() | Ecto.Association.NotLoaded.t() | nil,
    display_name: Types.display_name(),
    description: Types.description(),
    type: Types.sensor_type(),
    agent_mail_inbox: Types.email() | nil,
    inserted_at: Types.timestamp(),
    updated_at: Types.timestamp()
  }

  @derive {Jason.Encoder, only: [:id, :owner_gp_hub_id, :display_name, :description, :type, :agent_mail_inbox, :inserted_at, :updated_at]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "gp_data_sources" do
    belongs_to :owner_gp_hub, GPHub
    field :type, :string
    field :description, :string
    field :display_name, :string
    field :agent_mail_inbox, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  @spec changeset(t(), Types.attrs()) :: Types.changeset(t())
  def changeset(gp_data_source, attrs) do
    gp_data_source
    |> cast(attrs, [:owner_gp_hub_id, :display_name, :description, :type, :agent_mail_inbox])
    |> validate_required([:owner_gp_hub_id, :display_name, :description, :type])
    |> validate_format(:agent_mail_inbox, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
  end
end
