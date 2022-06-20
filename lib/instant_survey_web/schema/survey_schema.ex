defmodule InstantSurveyWeb.Schemas.Survey do
  defmodule Params do
    alias OpenApiSpex.Schema
    require OpenApiSpex

    OpenApiSpex.schema(%{
      # The title is optional. It defaults to the last section of the module name.
      # So the derived title for MyApp.User is "User".
      title: "Survey",
      description: "A survey of the app",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Survey ID"},
        title: %Schema{
          type: :string,
          description: "Survey Title",
          pattern: ~r/[a-zA-Z][a-zA-Z0-9_]+/
        },
        inserted_at: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updated_at: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      example: %{
        "survey" => %{
          "title" => "That Survey Title",
          "user_id" => 1
        }
      }
    })
  end

  defmodule Response do
    alias InstantSurveyWeb.Schemas.Survey.Params
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "SurveyResponse",
      description: "Response schema for single survey",
      type: :object,
      properties: %{
        data: Params
      },
      example: %{
        "data" => %{
          "id" => 1,
          "title" => "Joe User",
          "inserted_at" => "2017-09-12T12:34:55Z",
          "updated_at" => "2017-09-13T10:11:12Z"
        }
      }
    })
  end
end
