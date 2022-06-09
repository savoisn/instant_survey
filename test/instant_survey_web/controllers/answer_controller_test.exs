defmodule InstantSurveyWeb.AnswerControllerTest do
  use InstantSurveyWeb.ConnCase

  import InstantSurvey.GameFixtures
  import InstantSurvey.AccountsFixtures

  alias InstantSurvey.Game.Answer

  @create_attrs %{choice_id: 1, user_id: 1}
  @update_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all answers", %{conn: conn} do
      conn = get(conn, Routes.survey_question_answer_path(conn, :index, 1, 1))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create answer" do
    setup [:create_choice, :create_question, :create_survey, :create_user]

    test "renders answer when data is valid", %{conn: conn} do
      conn =
        post(conn, Routes.survey_question_answer_path(conn, :create, 1, 1), answer: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.survey_question_answer_path(conn, :show, id, 1, 1))

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.survey_question_answer_path(conn, :create, 1, 1), answer: @invalid_attrs)

      # assert json_response(conn, 422)["errors"] != %{}
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete answer" do
    setup [:create_answer]

    test "deletes chosen answer", %{conn: conn, answer: answer} do
      conn = delete(conn, Routes.survey_question_answer_path(conn, :delete, answer, 1, 1))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.survey_question_answer_path(conn, :show, answer, 1, 1))
      end
    end
  end

  defp create_answer(_) do
    answer = answer_fixture()
    %{answer: answer}
  end

  defp create_survey(_) do
    survey = survey_fixture()
    %{survey: survey}
  end

  defp create_question(_) do
    question = question_fixture()
    %{question: question}
  end

  defp create_choice(_) do
    choice = choice_fixture()
    %{choice: choice}
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
