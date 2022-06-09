defmodule InstantSurveyWeb.AnswerController do
  use InstantSurveyWeb, :controller

  alias InstantSurvey.Game
  alias InstantSurvey.Game.{Question, Choice}
  alias InstantSurvey.Accounts
  alias InstantSurvey.Accounts.{User}
  alias InstantSurvey.Game.Answer

  action_fallback InstantSurveyWeb.FallbackController

  def index(conn, _params) do
    answers = Game.list_answers()
    render(conn, "index.json", answers: answers)
  end

  def create(conn, %{
        "answer" => answer_params,
        "question_id" => question_id,
        "survey_id" => survey_id
      }) do
    IO.inspect(answer_params)
    question = Game.get_question(question_id)

    with choice_id when not is_nil(choice_id) <- answer_params["choice_id"],
         user_id when not is_nil(user_id) <- answer_params["user_id"] do
      choice = Game.get_choice(choice_id)

      user = Accounts.get_user(user_id)

      # survey = Game.get_survey!(survey_id)

      with {:ok, %Answer{} = answer} <- Game.create_answer(user, question, choice) do
        conn
        |> put_status(:created)
        |> put_resp_header(
          "location",
          Routes.survey_question_answer_path(conn, :show, answer, survey_id, question_id)
        )
        |> render("show.json", answer: answer)
      end
    else
      _ ->
        {:error, :bad_params}
    end
  end

  def show(conn, %{"id" => id}) do
    answer = Game.get_answer!(id)
    render(conn, "show.json", answer: answer)
  end

  def delete(conn, %{"id" => id}) do
    answer = Game.get_answer!(id)

    with {:ok, %Answer{}} <- Game.delete_answer(answer) do
      send_resp(conn, :no_content, "")
    end
  end
end
