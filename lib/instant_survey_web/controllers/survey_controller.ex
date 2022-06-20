defmodule InstantSurveyWeb.SurveyController do
  use InstantSurveyWeb, :controller
  use OpenApiSpex.ControllerSpecs
  alias OpenApiSpex.Schema

  alias InstantSurvey.Accounts
  alias InstantSurvey.Game
  alias InstantSurvey.Game.Survey

  alias InstantSurveyWeb.Schemas.Survey.Params, as: SurveyParams
  alias InstantSurveyWeb.Schemas.Survey.Response, as: SurveyResponse

  action_fallback InstantSurveyWeb.FallbackController

  tags(["survey"])

  operation :index,
    summary: "List surveys.",
    responses: [
      ok: {"Survey response", "application/json", SurveyResponse}
    ]

  def index(conn, _params) do
    surveys = Game.list_surveys()
    render(conn, "index.json", surveys: surveys)
  end

  operation :index_by_user,
    summary: "List surveys by user.",
    parameters: [
      user_id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :integer, minimum: 1},
        description: "User ID",
        example: 1,
        required: true
      ]
    ],
    responses: [
      ok: {"Survey response", "application/json", SurveyResponse}
    ]

  def index_by_user(conn, %{"user_id" => user_id}) do
    surveys = Game.list_surveys_by_user(user_id)
    render(conn, "index.json", surveys: surveys)
  end

  operation :new, false
  operation :edit, false

  operation :create,
    summary: "Add a surveys.",
    request_body: {"Survey params", "application/json", SurveyParams},
    responses: [
      ok: {"Survey response", "application/json", SurveyResponse}
    ]

  def create(conn, %{"survey" => survey_params}) do
    with user_id when not is_nil(user_id) <- survey_params["user_id"] do
      user = Accounts.get_user(user_id)

      with {:ok, %Survey{} = survey} <- Game.create_survey(survey_params, user) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.survey_path(conn, :show, survey))
        |> render("show.json", survey: survey)
      end
    else
      _ ->
        {:error, :bad_params}
    end
  end

  operation :show,
    summary: "Show a survey.",
    description: "Show a survey by ID.",
    parameters: [
      id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :integer, minimum: 1},
        description: "Survey ID",
        example: 1,
        required: true
      ]
    ],
    responses: [
      ok: {"Survey", "application/json", SurveyResponse}
    ]

  def show(conn, %{"id" => id}) do
    survey = Game.get_survey!(id)
    render(conn, "show.json", survey: survey)
  end

  operation :update, false

  def update(conn, %{"id" => id, "survey" => survey_params}) do
    survey = Game.get_survey!(id)

    with {:ok, %Survey{} = survey} <- Game.update_survey(survey, survey_params) do
      render(conn, "show.json", survey: survey)
    end
  end

  operation :delete,
    summary: "Delete a survey.",
    description: "Delete a Survey by ID.",
    parameters: [
      id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :integer, minimum: 1},
        description: "Survey ID",
        example: 1,
        required: true
      ]
    ],
    responses: [
      ok: {"Survey", "application/json", SurveyResponse}
    ]

  def delete(conn, %{"id" => id}) do
    survey = Game.get_survey!(id)

    with {:ok, %Survey{}} <- Game.delete_survey(survey) do
      send_resp(conn, :no_content, "")
    end
  end
end
