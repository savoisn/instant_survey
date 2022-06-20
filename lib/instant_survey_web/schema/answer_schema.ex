defmodule InstantSurveyWeb.Schemas.Answer do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  defmodule Params do
    OpenApiSpex.schema(%{
      title: "Answer",
      description: "A choice of the app",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Answer ID"},
        choice_id: %Schema{type: :integer, description: "Answer ID"},
        question_id: %Schema{type: :integer, description: "Answer ID"},
        user_id: %Schema{type: :integer, description: "Answer ID"}
      },
      example: %{
        "answer" => %{
          "choice_id" => 1,
          "user_id" => 1
        }
      }
    })
  end

  defmodule Response do
    alias InstantSurveyWeb.Schemas.Answer.Params, as: AnswerParams

    OpenApiSpex.schema(%{
      title: "Answer Response",
      description: "Response schema for single choice",
      type: :object,
      properties: %{
        data: AnswerParams
      },
      example: %{
        "data" => %{
          "id" => 1,
          "choice_id" => 1,
          "question_id" => 1,
          "user_id" => 1
        }
      }
    })
  end

  defmodule Responses do
    alias InstantSurveyWeb.Schemas.Answer.Params, as: AnswerParams

    OpenApiSpex.schema(%{
      title: "Answers Response",
      description: "Response schema for a list of choices",
      type: :object,
      properties: %{
        data: %Schema{description: "The choices details", type: :array, items: AnswerParams}
      },
      example: %{
        "data" => [
          %{
            "id" => 1,
            "text" => "the choice text",
            "survey_id" => 1
          },
          %{
            "id" => 2,
            "text" => "another choice text",
            "survey_id" => 1
          }
        ]
      }
    })
  end
end
