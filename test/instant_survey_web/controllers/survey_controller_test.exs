defmodule InstantSurveyWeb.SurveyControllerTest do
  use InstantSurveyWeb.ConnCase

  import InstantSurvey.GameFixtures

  alias InstantSurvey.Game.Survey

  @create_attrs %{
    title: "some title"
  }
  @update_attrs %{
    title: "some updated title"
  }
  @invalid_attrs %{title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all surveys", %{conn: conn} do
      conn = get(conn, Routes.survey_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create survey" do
    test "renders survey when data is valid", %{conn: conn} do
      conn = post(conn, Routes.survey_path(conn, :create), survey: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.survey_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.survey_path(conn, :create), survey: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update survey" do
    setup [:create_survey]

    test "renders survey when data is valid", %{conn: conn, survey: %Survey{id: id} = survey} do
      conn = put(conn, Routes.survey_path(conn, :update, survey), survey: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.survey_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, survey: survey} do
      conn = put(conn, Routes.survey_path(conn, :update, survey), survey: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete survey" do
    setup [:create_survey]

    test "deletes chosen survey", %{conn: conn, survey: survey} do
      conn = delete(conn, Routes.survey_path(conn, :delete, survey))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.survey_path(conn, :show, survey))
      end
    end
  end

  defp create_survey(_) do
    survey = survey_fixture()
    %{survey: survey}
  end
end
