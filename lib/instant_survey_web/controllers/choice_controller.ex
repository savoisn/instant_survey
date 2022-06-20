defmodule InstantSurveyWeb.ChoiceController do
  use InstantSurveyWeb, :controller

  use OpenApiSpex.ControllerSpecs
  alias OpenApiSpex.Schema

  alias InstantSurveyWeb.Schemas.Choice.Responses, as: ChoicesResponse
  alias InstantSurveyWeb.Schemas.Choice.Response, as: ChoiceResponse
  alias InstantSurveyWeb.Schemas.Choice.Params, as: ChoiceParams
  alias InstantSurvey.Game
  alias InstantSurvey.Game.Choice

  action_fallback InstantSurveyWeb.FallbackController
  tags(["Choice"])

  operation :index,
    summary: "Add a choice.",
    parameters: [
      survey_id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :integer, minimum: 1},
        description: "Survey ID",
        example: 1,
        required: true
      ],
      question_id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :integer, minimum: 1},
        description: "Question ID",
        example: 1,
        required: true
      ]
    ],
    responses: [
      ok: {"Choice response", "application/json", ChoicesResponse}
    ]

  def index(conn, _params) do
    choices = Game.list_choices()
    render(conn, "index.json", choices: choices)
  end

  operation :create,
    summary: "Add a choice.",
    parameters: [
      survey_id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :integer, minimum: 1},
        description: "Survey ID",
        example: 1,
        required: true
      ],
      question_id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :integer, minimum: 1},
        description: "Question ID",
        example: 1,
        required: true
      ]
    ],
    request_body: {"choice params", "application/json", ChoiceParams},
    responses: [
      ok: {"choice response", "application/json", ChoiceResponse}
    ]

  def create(conn, %{
        "choice" => choice_params,
        "question_id" => question_id,
        "survey_id" => survey_id
      }) do
    question = Game.get_question!(question_id)

    with {:ok, %Choice{} = choice} <- Game.create_choice(choice_params, question) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.survey_question_choice_path(conn, :show, choice, survey_id, question_id)
      )
      |> render("show.json", choice: choice)
    end
  end

  operation :new, false
  operation :edit, false

  operation :show,
    summary: "Add a choice.",
    parameters: [
      survey_id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :integer, minimum: 1},
        description: "Survey ID",
        example: 1,
        required: true
      ],
      question_id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :integer, minimum: 1},
        description: "Question ID",
        example: 1,
        required: true
      ],
      id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :integer, minimum: 1},
        description: "Choice ID",
        example: 1,
        required: true
      ]
    ],
    responses: [
      ok: {"choice response", "application/json", ChoiceResponse}
    ]

  def show(conn, %{"id" => id}) do
    choice = Game.get_choice!(id)
    render(conn, "show.json", choice: choice)
  end

  operation :update, false

  def update(conn, %{"id" => id, "choice" => choice_params}) do
    choice = Game.get_choice!(id)

    with {:ok, %Choice{} = choice} <- Game.update_choice(choice, choice_params) do
      render(conn, "show.json", choice: choice)
    end
  end

  operation :delete,
    summary: "Delete a choice.",
    parameters: [
      survey_id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :integer, minimum: 1},
        description: "Survey ID",
        example: 1,
        required: true
      ],
      question_id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :integer, minimum: 1},
        description: "Question ID",
        example: 1,
        required: true
      ],
      id: [
        in: :path,
        # `:type` can be an atom, %Schema{}, or %Reference{}
        type: %Schema{type: :integer, minimum: 1},
        description: "Choice ID",
        example: 1,
        required: true
      ]
    ],
    responses: %{
      204 => "nothing to show"
    }

  def delete(conn, %{"id" => id}) do
    choice = Game.get_choice!(id)

    with {:ok, %Choice{}} <- Game.delete_choice(choice) do
      send_resp(conn, :no_content, "")
    end
  end
end
