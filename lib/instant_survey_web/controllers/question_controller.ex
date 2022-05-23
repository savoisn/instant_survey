defmodule InstantSurveyWeb.QuestionController do
  use InstantSurveyWeb, :controller

  alias InstantSurvey.Game
  alias InstantSurvey.Game.Question

  action_fallback InstantSurveyWeb.FallbackController

  def index(conn, _params) do
    questions = Game.list_questions()
    render(conn, "index.json", questions: questions)
  end

  def create(conn, %{"question" => question_params}) do
    with {:ok, %Question{} = question} <- Game.create_question(question_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.question_path(conn, :show, question))
      |> render("show.json", question: question)
    end
  end

  def show(conn, %{"id" => id}) do
    question = Game.get_question!(id)
    render(conn, "show.json", question: question)
  end

  def update(conn, %{"id" => id, "question" => question_params}) do
    question = Game.get_question!(id)

    with {:ok, %Question{} = question} <- Game.update_question(question, question_params) do
      render(conn, "show.json", question: question)
    end
  end

  def delete(conn, %{"id" => id}) do
    question = Game.get_question!(id)

    with {:ok, %Question{}} <- Game.delete_question(question) do
      send_resp(conn, :no_content, "")
    end
  end
end
