# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     InstantSurvey.Repo.insert!(%InstantSurvey.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias InstantSurvey.Repo
alias InstantSurvey.Accounts
alias InstantSurvey.Accounts.User

# alias InstantSurvey.Game
alias InstantSurvey.Game.Survey
alias InstantSurvey.Game.Question

Repo.delete_all(Question)
Repo.delete_all(Survey)
Repo.delete_all(User)

user = %{
  username: "nsavois",
  firstname: "Nicolas",
  lastname: "Savois"
}

{:ok, %User{id: nsavois_id} = nsavois} = Accounts.create_user(user)

IO.inspect(nsavois_id)
IO.inspect(nsavois)

survey_nsavois = %{
  title: "super questionnaire"
}

survey = Ecto.build_assoc(nsavois, :surveys, survey_nsavois)

survey = Repo.insert!(survey)

IO.inspect(survey)

survey =
  Repo.get!(Survey, survey.id)
  |> Repo.preload(:users)

IO.inspect(survey)

user = Repo.preload(nsavois, :surveys)

IO.inspect(user)

question1_survey_nsavois = %{
  text: "question 1 de la survey nsavois"
}

question1_survey_nsavois = Ecto.build_assoc(survey, :questions, question1_survey_nsavois)

question1_survey_nsavois =
  Repo.insert!(question1_survey_nsavois)
  |> Repo.preload(:surveys)

IO.inspect(question1_survey_nsavois)
