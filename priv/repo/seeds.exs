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

alias InstantSurvey.Game
alias InstantSurvey.Game.Survey
alias InstantSurvey.Game.Question
alias InstantSurvey.Game.Choice
alias InstantSurvey.Game.Answer

Repo.delete_all(Answer)
Repo.delete_all(Choice)
Repo.delete_all(Question)
Repo.delete_all(Survey)
Repo.delete_all(User)

user = %{
  username: "nsavois",
  firstname: "Nicolas",
  lastname: "Savois"
}

{:ok, %User{id: nsavois_id} = nsavois} = Accounts.create_user(user)

# IO.inspect(nsavois_id)
# IO.inspect(nsavois)

alice_data = %{
  username: "adinuno",
  firstname: "Alice",
  lastname: "Di Nuno"
}

{:ok, alice} = Accounts.create_user(alice_data)

survey_nsavois = %{
  title: "super questionnaire"
}

survey = Ecto.build_assoc(nsavois, :surveys, survey_nsavois)

survey = Repo.insert!(survey)

# IO.inspect(survey)

survey =
  Repo.get!(Survey, survey.id)
  |> Repo.preload(:users)

# IO.inspect(survey)

user = Repo.preload(nsavois, :surveys)

# IO.inspect(user)

question1_survey_nsavois = %{
  text: "question 1 de la survey nsavois"
}

question1_survey_nsavois = Ecto.build_assoc(survey, :questions, question1_survey_nsavois)

question1_survey_nsavois =
  Repo.insert!(question1_survey_nsavois)
  |> Repo.preload(:surveys)

choice_q1_nsa = %{
  text: "choice q1 nsa"
}

choice_q2_nsa = %{
  text: "choice q2 nsa"
}

choice_q1_nsa = Ecto.build_assoc(question1_survey_nsavois, :choices, choice_q1_nsa)

choice_q1_nsa =
  Repo.insert!(choice_q1_nsa)
  |> Repo.preload(:question)

choice_q2_nsa = Ecto.build_assoc(question1_survey_nsavois, :choices, choice_q2_nsa)

choice_q2_nsa =
  Repo.insert!(choice_q2_nsa)
  |> Repo.preload(:question)

question1_survey_nsavois = Repo.preload(question1_survey_nsavois, :choices)

# IO.inspect(question1_survey_nsavois)

answer_q1 = %{}
answer_q1 = Ecto.build_assoc(choice_q1_nsa, :answers, answer_q1)
answer_q1 = Ecto.build_assoc(question1_survey_nsavois, :answers, answer_q1)
answer_q1 = Ecto.build_assoc(nsavois, :answers, answer_q1)

answer_q1 =
  Repo.insert!(answer_q1)
  |> Repo.preload([:choice, :question, :user])

# IO.inspect(answer_q1)

survey_id = survey.id
survey = Game.get_survey!(survey_id)
# IO.inspect(survey)

question_params = %{"text" => "some text"}
question = Game.create_question(question_params, survey)

# IO.inspect(question)

# 1 user
# survey avec 3 ou 4 quesion?
# des questions avec 2 - 3 et 4 reponse
survey_data_1 = %{
  survey: "text de la survey_1",
  questions: [
    %{
      question: "text de la question question_1_1",
      choices: [
        "text du choice_1_1_1",
        "text du choice_1_1_2",
        "text du choice_1_1_3",
        "text du choice_1_1_4"
      ]
    },
    %{
      question: "text de la question question_1_2",
      choices: [
        "text du choice_1_2_1",
        "text du choice_1_2_2",
        "text du choice_1_2_3",
        "text du choice_1_2_4"
      ]
    },
    %{
      question: "text de la question question_1_3",
      choices: [
        "text du choice_1_3_1",
        "text du choice_1_3_2",
        "text du choice_1_3_3",
        "text du choice_1_3_4"
      ]
    },
    %{
      question: "text de la question question_1_4",
      choices: [
        "text du choice_1_4_1",
        "text du choice_1_4_2",
        "text du choice_1_4_3",
        "text du choice_1_4_4"
      ]
    }
  ]
}

survey_1 = Game.create_survey_questions_with_choices(alice, survey_data_1)
IO.inspect(survey_1)

survey_data_2 = %{
  survey: "text de la survey_2",
  questions: [
    %{
      question: "text de la question question_2_1",
      choices: [
        "text du choice_2_1_1",
        "text du choice_2_1_2",
        "text du choice_2_1_3"
      ]
    },
    %{
      question: "text de la question question_2_2",
      choices: [
        "text du choice_2_2_1",
        "text du choice_2_2_2",
        "text du choice_2_2_3",
        "text du choice_2_2_4"
      ]
    },
    %{
      question: "text de la question question_2_3",
      choices: [
        "text du choice_2_3_1",
        "text du choice_2_3_2"
      ]
    },
    %{
      question: "text de la question question_2_4",
      choices: [
        "text du choice_2_4_1",
        "text du choice_2_4_2",
        "text du choice_2_4_3"
      ]
    }
  ]
}

survey_2 = Game.create_survey_questions_with_choices(alice, survey_data_2)
IO.inspect(survey_2)
