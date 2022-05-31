defmodule InstantSurvey.Game.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answers" do
    # field :question_id, :id
    # field :user_id, :id
    # field :choice_id, :id

    belongs_to :question, InstantSurvey.Game.Question, foreign_key: :question_id
    belongs_to :user, InstantSurvey.Accounts.User, foreign_key: :user_id
    belongs_to :choice, InstantSurvey.Game.Choice, foreign_key: :choice_id
    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [])
    |> validate_required([:question_id, :user_id, :choice_id])
  end
end
