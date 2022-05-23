defmodule InstantSurvey.Repo.Migrations.CreateSurveys do
  use Ecto.Migration

  def change do
    create table(:surveys) do
      add :title, :string
      add :owner_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:surveys, [:owner_id])
  end
end
