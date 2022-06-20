defmodule InstantSurvey.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :firstname, :string
    field :lastname, :string
    field :username, :string

    has_many :surveys, InstantSurvey.Game.Survey, foreign_key: :owner_id
    has_many :answers, InstantSurvey.Game.Answer
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :firstname, :lastname])
    |> validate_required([:username])
  end
end
