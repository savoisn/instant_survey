defmodule InstantSurvey.Game.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :text, :string

    belongs_to :surveys, InstantSurvey.Game.Survey, foreign_key: :survey_id
    has_many :choices, InstantSurvey.Game.Choice
    has_many :answers, InstantSurvey.Game.Answer

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:text])
    |> validate_required([:text, :survey_id])
    |> validate_not_nil([:text])
  end

  def validate_not_nil(changeset, fields) do
    Enum.reduce(fields, changeset, fn field, changeset ->
      if get_field(changeset, field) == nil do
        add_error(changeset, field, "nil")
      else
        changeset
      end
    end)
  end
end
