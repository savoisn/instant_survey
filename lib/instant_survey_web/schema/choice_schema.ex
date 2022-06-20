defmodule InstantSurveyWeb.Schemas.Choice do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  defmodule Params do
    OpenApiSpex.schema(%{
      title: "Choice",
      description: "A choice of the app",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Choice ID"},
        text: %Schema{
          type: :string,
          description: "Choice Text",
          pattern: ~r/[a-zA-Z][a-zA-Z0-9_]+/
        },
        survey_id: %Schema{type: :integer, description: "Choice ID"}
      },
      example: %{
        "choice" => %{
          "text" => "That Choice Text"
        }
      }
    })
  end

  defmodule Response do
    alias InstantSurveyWeb.Schemas.Choice.Params, as: ChoiceParams

    OpenApiSpex.schema(%{
      title: "Choice Response",
      description: "Response schema for single choice",
      type: :object,
      properties: %{
        data: ChoiceParams
      },
      example: %{
        "data" => %{
          "id" => 1,
          "text" => "the choice text",
          "survey_id" => 1
        }
      }
    })
  end

  defmodule Responses do
    alias InstantSurveyWeb.Schemas.Choice.Params, as: ChoiceParams

    OpenApiSpex.schema(%{
      title: "Choices Response",
      description: "Response schema for a list of choices",
      type: :object,
      properties: %{
        data: %Schema{description: "The choices details", type: :array, items: ChoiceParams}
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
