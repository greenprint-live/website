defmodule Greenprint.Repo.Migrations.AddAgentMailInboxToGpHubsAndGpDataSources do
  use Ecto.Migration

  def change do
    alter table(:gp_hubs) do
      add :agent_mail_inbox, :string, null: true
    end

    alter table(:gp_data_sources) do
      add :agent_mail_inbox, :string, null: true
    end
  end
end
