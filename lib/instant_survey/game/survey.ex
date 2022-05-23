defmodule InstantSurvey.Game.Survey do
  use Ecto.Schema
  import Ecto.Changeset

  schema "surveys" do
    field :title, :string

    belongs_to :users, InstantSurvey.Accounts.User, foreign_key: :owner_id
    has_many :questions, InstantSurvey.Game.Question

    timestamps()
  end

  @doc false
  def changeset(survey, attrs) do
    survey
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
