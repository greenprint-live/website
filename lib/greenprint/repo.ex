defmodule Greenprint.Repo do
  use Ecto.Repo,
    otp_app: :greenprint,
    adapter: Ecto.Adapters.SQLite3
end
