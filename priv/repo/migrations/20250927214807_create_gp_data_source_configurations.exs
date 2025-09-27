defmodule Greenprint.Repo.Migrations.CreateGpDataSourceConfigurations do
  use Ecto.Migration

  def change do
    create table(:gp_data_source_configurations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :alarms, :map
      add :data_source_id, references(:gp_data_sources, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:gp_data_source_configurations, [:data_source_id])
  end
end
