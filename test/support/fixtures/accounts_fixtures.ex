defmodule InstantSurvey.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InstantSurvey.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        firstname: "some firstname",
        lastname: "some lastname",
        username: "some username"
      })
      |> InstantSurvey.Accounts.create_user()

    user
  end
end
