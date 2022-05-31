defmodule InstantSurvey.Repo.Migrations.CreateChoices do
  use Ecto.Migration

  def change do
    create table(:choices) do
      add :text, :string
      add :question_id, references(:questions, on_delete: :nothing)

      timestamps()
    end

    create index(:choices, [:question_id])
  end
end
