defmodule InstantSurvey.GameFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InstantSurvey.Game` context.
  """

  @doc """
  Generate a survey.
  """
  def survey_fixture(attrs \\ %{}) do
    {:ok, survey} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> InstantSurvey.Game.create_survey()

    survey
  end

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    {:ok, question} =
      attrs
      |> Enum.into(%{
        text: "some text"
      })
      |> InstantSurvey.Game.create_question()

    question
  end
end
