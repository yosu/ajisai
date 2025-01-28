defmodule Ajisai.Repo do
  use Ecto.Repo,
    otp_app: :ajisai,
    adapter: Ecto.Adapters.Postgres
end
