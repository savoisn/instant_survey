defmodule InstantSurveyWeb.AnswerController do
  use InstantSurveyWeb, :controller

  alias InstantSurvey.Game
  alias InstantSurvey.Game.Answer

  action_fallback InstantSurveyWeb.FallbackController

  def index(conn, _params) do
    answers = Game.list_answers()
    render(conn, "index.json", answers: answers)
  end

  def create(conn, %{"answer" => answer_params}) do
    with {:ok, %Answer{} = answer} <- Game.create_answer(answer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.answer_path(conn, :show, answer))
      |> render("show.json", answer: answer)
    end
  end

  def show(conn, %{"id" => id}) do
    answer = Game.get_answer!(id)
    render(conn, "show.json", answer: answer)
  end

  def update(conn, %{"id" => id, "answer" => answer_params}) do
    answer = Game.get_answer!(id)

    with {:ok, %Answer{} = answer} <- Game.update_answer(answer, answer_params) do
      render(conn, "show.json", answer: answer)
    end
  end

  def delete(conn, %{"id" => id}) do
    answer = Game.get_answer!(id)

    with {:ok, %Answer{}} <- Game.delete_answer(answer) do
      send_resp(conn, :no_content, "")
    end
  end
end
