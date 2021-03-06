defmodule InstantSurveyWeb.Schemas.Question do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  defmodule Params do
    OpenApiSpex.schema(%{
      # The title is optional. It defaults to the last section of the module name.
      # So the derived title for MyApp.User is "User".
      title: "Question",
      description: "A question of the app",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Question ID"},
        text: %Schema{
          type: :string,
          description: "Question Text",
          pattern: ~r/[a-zA-Z][a-zA-Z0-9_]+/
        },
        survey_id: %Schema{type: :integer, description: "Question ID"}
      },
      example: %{
        "question" => %{
          "text" => "That Question Text"
        }
      }
    })
  end

  defmodule Response do
    alias InstantSurveyWeb.Schemas.Question.Params, as: QuestionParams

    OpenApiSpex.schema(%{
      title: "Question Response",
      description: "Response schema for single question",
      type: :object,
      properties: %{
        data: QuestionParams
      },
      example: %{
        "data" => %{
          "id" => 1,
          "text" => "the question text",
          "survey_id" => 1
        }
      }
    })
  end

  defmodule Result do
    OpenApiSpex.schema(%{
      title: "Question Response",
      description: "Response schema for single question",
      type: :object,
      properties: %{
        choice_count: %Schema{type: :integer, description: "number of response of this choice"},
        choice_id: %Schema{type: :integer, description: "Choice ID"},
        choice_text: %Schema{
          type: :string,
          description: "Choice Text",
          pattern: ~r/[a-zA-Z][a-zA-Z0-9_]+/
        }
      },
      example: %{
        "data" => %{
          choice_count: 3,
          choice_id: 9,
          choice_text: "text du choix"
        }
      }
    })
  end

  defmodule Responses do
    alias InstantSurveyWeb.Schemas.Question.Params, as: QuestionParams

    OpenApiSpex.schema(%{
      title: "Questions Response",
      description: "Response schema for a list of questions",
      type: :object,
      properties: %{
        data: %Schema{description: "The questions details", type: :array, items: QuestionParams}
      },
      example: %{
        "data" => [
          %{
            "id" => 1,
            "text" => "the question text",
            "survey_id" => 1
          },
          %{
            "id" => 2,
            "text" => "another question text",
            "survey_id" => 1
          }
        ]
      }
    })
  end

  defmodule Results do
    alias InstantSurveyWeb.Schemas.Question.Result, as: Result

    OpenApiSpex.schema(%{
      title: "Questions Results",
      description: "Results schema for a questions",
      type: :object,
      properties: %{
        data: %Schema{description: "The question result", type: :array, items: Result}
      },
      example: %{
        "data" => [
          %{
            choice_count: 3,
            choice_id: 9,
            choice_text: "text du choix"
          },
          %{
            choice_count: 8,
            choice_id: 12,
            choice_text: "autre choix"
          }
        ]
      }
    })
  end
end
