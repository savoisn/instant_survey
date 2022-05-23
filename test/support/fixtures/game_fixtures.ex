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
end
