defmodule InstantSurvey.Game.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :text, :string

    belongs_to :surveys, InstantSurvey.Game.Survey, foreign_key: :survey_id
    has_many :questions, InstantSurvey.Game.Question

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
