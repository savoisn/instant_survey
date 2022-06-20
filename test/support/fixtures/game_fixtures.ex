defmodule InstantSurvey.GameFixtures do
  alias InstantSurvey.Repo

  @moduledoc """
  This module defines test helpers for creating
  entities via the `InstantSurvey.Game` context.
  """

  @doc """
  Generate a survey.
  """
  def survey_fixture(attrs \\ %{}) do
    user = InstantSurvey.AccountsFixtures.user_fixture()

    {:ok, survey} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> InstantSurvey.Game.create_survey(user)

    survey
  end

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    survey = survey_fixture()

    {:ok, question} =
      attrs
      |> Enum.into(%{
        text: "some text"
      })
      |> InstantSurvey.Game.create_question(survey)

    question
  end

  @doc """
  Generate a choice.
  """
  def choice_fixture(attrs \\ %{}) do
    question = question_fixture()

    {:ok, choice} =
      attrs
      |> Enum.into(%{
        text: "some text"
      })
      |> InstantSurvey.Game.create_choice(question)

    choice
  end

  @doc """
  Generate a answer.
  """
  def answer_fixture(_attrs \\ %{}) do
    user = InstantSurvey.AccountsFixtures.user_fixture()

    survey_data = %{
      title: "super questionnaire"
    }

    survey =
      Ecto.build_assoc(user, :surveys, survey_data)
      |> Repo.insert!()

    question_data = %{
      text: "question 1 de la survey nsavois"
    }

    question =
      Ecto.build_assoc(survey, :questions, question_data)
      |> Repo.insert!()

    choice_data = %{
      text: "choice question 1"
    }

    choice =
      Ecto.build_assoc(question, :choices, choice_data)
      |> Repo.insert!()

    answer = Ecto.build_assoc(question, :answers, %{})
    answer = Ecto.build_assoc(choice, :answers, answer)
    answer = Ecto.build_assoc(user, :answers, answer)

    answer = Repo.insert!(answer)

    answer
  end
end
