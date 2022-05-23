defmodule InstantSurvey.Repo do
  use Ecto.Repo,
    otp_app: :instant_survey,
    adapter: Ecto.Adapters.SQLite3
end
