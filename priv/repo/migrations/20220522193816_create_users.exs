defmodule InstantSurvey.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :firstname, :string
      add :lastname, :string

      timestamps()
    end
  end
end
