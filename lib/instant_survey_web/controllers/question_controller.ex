defmodule InstantSurveyWeb.QuestionController do
  use InstantSurveyWeb, :controller

  use OpenApiSpex.ControllerSpecs
  alias OpenApiSpex.Schema

  alias InstantSurveyWeb.Schemas.Question.Responses, as: QuestionsResponse
  alias InstantSurveyWeb.Schemas.Question.Response, as: QuestionResponse
  alias InstantSurveyWeb.Schemas.Question.Params, as: QuestionParams
  alias InstantSurvey.Game
  alias InstantSurvey.Game.Question

  action_fallback InstantSurveyWeb.FallbackController
  tags(["Question"])

  operation :index,
    summary: "Add a question.",
    parameters: [
      survey_id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :integer, minimum: 1},
        description: "Survey ID",
        example: 1,
        required: true
      ]
    ],
    responses: [
      ok: {"Question response", "application/json", QuestionsResponse}
    ]

  def index(conn, %{"survey_id" => survey_id}) do
    questions = Game.list_questions_by_survey(survey_id)
    render(conn, "index.json", questions: questions)
  end

  operation :create,
    summary: "Add a question.",
    parameters: [
      survey_id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :integer, minimum: 1},
        description: "Survey ID",
        example: 1,
        required: true
      ]
    ],
    request_body: {"Question params", "application/json", QuestionParams},
    responses: [
      ok: {"Question response", "application/json", QuestionResponse}
    ]

  def create(conn, %{"question" => question_params, "survey_id" => survey_id}) do
    survey = Game.get_survey!(survey_id)

    with {:ok, %Question{} = question} <- Game.create_question(question_params, survey) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.survey_question_path(conn, :show, survey_id, question)
      )
      |> render("show.json", question: question)
    end
  end

  operation :new, false
  operation :edit, false

  operation :show,
    summary: "Add a question.",
    parameters: [
      survey_id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :integer, minimum: 1},
        description: "Survey ID",
        example: 1,
        required: true
      ],
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
      ok: {"Question response", "application/json", QuestionResponse}
    ]

  def show(conn, %{"id" => id}) do
    question = Game.get_question!(id)
    render(conn, "show.json", question: question)
  end

  operation :update, false

  def update(conn, %{"id" => id, "question" => question_params}) do
    question = Game.get_question!(id)

    with {:ok, %Question{} = question} <- Game.update_question(question, question_params) do
      render(conn, "show.json", question: question)
    end
  end

  operation :delete,
    summary: "Delete a question.",
    parameters: [
      survey_id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :integer, minimum: 1},
        description: "Survey ID",
        example: 1,
        required: true
      ],
      id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :integer, minimum: 1},
        description: "Survey ID",
        example: 1,
        required: true
      ]
    ],
    responses: %{
      204 => "nothing to show"
    }

  def delete(conn, %{"id" => id}) do
    question = Game.get_question!(id)

    with {:ok, %Question{}} <- Game.delete_question(question) do
      send_resp(conn, :no_content, "")
    end
  end
end
