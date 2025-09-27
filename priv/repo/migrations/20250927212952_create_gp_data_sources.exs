defmodule Greenprint.Repo.Migrations.CreateGpDataSources do
  use Ecto.Migration

  def change do
    create table(:gp_data_sources, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :owner_gp_hub_id, :string
      add :display_name, :string
      add :description, :string
      add :type, :string

      timestamps(type: :utc_datetime)
    end
  end
end
