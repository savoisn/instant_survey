defmodule InstantSurveyWeb.ChoiceControllerTest do
  use InstantSurveyWeb.ConnCase

  import InstantSurvey.GameFixtures

  alias InstantSurvey.Game.Choice

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
    test "lists all choices", %{conn: conn} do
      conn = get(conn, Routes.choice_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create choice" do
    test "renders choice when data is valid", %{conn: conn} do
      conn = post(conn, Routes.choice_path(conn, :create), choice: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.choice_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "text" => "some text"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.choice_path(conn, :create), choice: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update choice" do
    setup [:create_choice]

    test "renders choice when data is valid", %{conn: conn, choice: %Choice{id: id} = choice} do
      conn = put(conn, Routes.choice_path(conn, :update, choice), choice: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.choice_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "text" => "some updated text"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, choice: choice} do
      conn = put(conn, Routes.choice_path(conn, :update, choice), choice: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete choice" do
    setup [:create_choice]

    test "deletes chosen choice", %{conn: conn, choice: choice} do
      conn = delete(conn, Routes.choice_path(conn, :delete, choice))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.choice_path(conn, :show, choice))
      end
    end
  end

  defp create_choice(_) do
    choice = choice_fixture()
    %{choice: choice}
  end
end
