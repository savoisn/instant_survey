defmodule InstantSurveyWeb.QuestionControllerTest do
  use InstantSurveyWeb.ConnCase

  import InstantSurvey.GameFixtures

  alias InstantSurvey.Game.Question

  @create_attrs %{
    text: "some text"
  }
  @update_attrs %{
    text: "some updated text"
  }
  @invalid_attrs %{text: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all questions", %{conn: conn} do
      conn = get(conn, Routes.survey_question_path(conn, :index, 1))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create question" do
    setup [:create_survey]

    test "renders question when data is valid", %{conn: conn} do
      conn = post(conn, Routes.survey_question_path(conn, :create, 1), question: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.survey_question_path(conn, :show, 1, id))

      assert %{
               "id" => ^id,
               "text" => "some text"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.survey_question_path(conn, :create, 1), question: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update question" do
    setup [:create_question]

    test "renders question when data is valid", %{
      conn: conn,
      question: %Question{id: id} = question
    } do
      conn =
        put(conn, Routes.survey_question_path(conn, :update, question, 1), question: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.survey_question_path(conn, :show, 1, id))

      assert %{
               "id" => ^id,
               "text" => "some updated text"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, question: question} do
      conn =
        put(conn, Routes.survey_question_path(conn, :update, question, 1),
          question: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete question" do
    setup [:create_question]

    test "deletes chosen question", %{conn: conn, question: question} do
      conn = delete(conn, Routes.survey_question_path(conn, :delete, question, 1))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.survey_question_path(conn, :show, 1, question))
      end
    end
  end

  defp create_survey(_) do
    survey = survey_fixture()
    %{survey: survey}
  end

  defp create_question(_) do
    question = question_fixture()
    %{question: question}
  end
end
