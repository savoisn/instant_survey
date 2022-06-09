defmodule InstantSurveyWeb.ChoiceController do
  use InstantSurveyWeb, :controller

  alias InstantSurvey.Game
  alias InstantSurvey.Game.Choice

  action_fallback InstantSurveyWeb.FallbackController

  def index(conn, _params) do
    choices = Game.list_choices()
    render(conn, "index.json", choices: choices)
  end

  def create(conn, %{
        "choice" => choice_params,
        "question_id" => question_id,
        "survey_id" => survey_id
      }) do
    question = Game.get_question!(question_id)

    with {:ok, %Choice{} = choice} <- Game.create_choice(choice_params, question) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.survey_question_choice_path(conn, :show, choice, survey_id, question_id)
      )
      |> render("show.json", choice: choice)
    end
  end

  def show(conn, %{"id" => id}) do
    choice = Game.get_choice!(id)
    render(conn, "show.json", choice: choice)
  end

  def update(conn, %{"id" => id, "choice" => choice_params}) do
    choice = Game.get_choice!(id)

    with {:ok, %Choice{} = choice} <- Game.update_choice(choice, choice_params) do
      render(conn, "show.json", choice: choice)
    end
  end

  def delete(conn, %{"id" => id}) do
    choice = Game.get_choice!(id)

    with {:ok, %Choice{}} <- Game.delete_choice(choice) do
      send_resp(conn, :no_content, "")
    end
  end
end
