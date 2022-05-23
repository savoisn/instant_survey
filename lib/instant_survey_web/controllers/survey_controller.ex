defmodule InstantSurveyWeb.SurveyController do
  use InstantSurveyWeb, :controller

  alias InstantSurvey.Game
  alias InstantSurvey.Game.Survey

  action_fallback InstantSurveyWeb.FallbackController

  def index(conn, _params) do
    surveys = Game.list_surveys()
    render(conn, "index.json", surveys: surveys)
  end

  def create(conn, %{"survey" => survey_params}) do
    with {:ok, %Survey{} = survey} <- Game.create_survey(survey_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.survey_path(conn, :show, survey))
      |> render("show.json", survey: survey)
    end
  end

  def show(conn, %{"id" => id}) do
    survey = Game.get_survey!(id)
    render(conn, "show.json", survey: survey)
  end

  def update(conn, %{"id" => id, "survey" => survey_params}) do
    survey = Game.get_survey!(id)

    with {:ok, %Survey{} = survey} <- Game.update_survey(survey, survey_params) do
      render(conn, "show.json", survey: survey)
    end
  end

  def delete(conn, %{"id" => id}) do
    survey = Game.get_survey!(id)

    with {:ok, %Survey{}} <- Game.delete_survey(survey) do
      send_resp(conn, :no_content, "")
    end
  end
end
