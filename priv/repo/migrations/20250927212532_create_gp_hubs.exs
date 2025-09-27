defmodule Greenprint.Repo.Migrations.CreateGpHubs do
  use Ecto.Migration

  def change do
    create table(:gp_hubs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :owner_user_id, :string
      add :serial_number, :string
      add :display_name, :string
      add :description, :string
      add :location, :string

      timestamps(type: :utc_datetime)
    end
  end
end
