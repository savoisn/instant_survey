defmodule InstantSurveyWeb.AnswerController do
  use InstantSurveyWeb, :controller

  use OpenApiSpex.ControllerSpecs
  alias OpenApiSpex.Schema

  alias InstantSurveyWeb.Schemas.Answer.Responses, as: AnswersResponse
  alias InstantSurveyWeb.Schemas.Answer.Response, as: AnswerResponse
  alias InstantSurveyWeb.Schemas.Answer.Params, as: AnswerParams
  alias InstantSurvey.Game
  alias InstantSurvey.Accounts
  alias InstantSurvey.Game.Answer

  action_fallback InstantSurveyWeb.FallbackController
  tags(["Answer"])

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
      ok: {"Answer response", "application/json", AnswersResponse}
    ]

  def index(conn, %{
        "survey_id" => survey_id,
        "question_id" => question_id
      }) do
    answers = Game.list_answers_by_question(question_id, survey_id)
    render(conn, "index.json", answers: answers)
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
    request_body: {"choice params", "application/json", AnswerParams},
    responses: [
      ok: {"choice response", "application/json", AnswerResponse}
    ]

  def create(conn, %{
        "answer" => answer_params,
        "question_id" => question_id,
        "survey_id" => survey_id
      }) do
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
        description: "Answer ID",
        example: 1,
        required: true
      ]
    ],
    responses: [
      ok: {"choice response", "application/json", AnswerResponse}
    ]

  def show(conn, %{"id" => id}) do
    answer = Game.get_answer!(id)
    render(conn, "show.json", answer: answer)
  end

  operation :update, false

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
        description: "Answer ID",
        example: 1,
        required: true
      ]
    ],
    responses: %{
      204 => "nothing to show"
    }

  def delete(conn, %{"id" => id}) do
    answer = Game.get_answer!(id)

    with {:ok, %Answer{}} <- Game.delete_answer(answer) do
      send_resp(conn, :no_content, "")
    end
  end
end
