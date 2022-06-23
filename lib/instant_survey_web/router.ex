defmodule InstantSurveyWeb.Router do
  use InstantSurveyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug, origin: "*"

    plug OpenApiSpex.Plug.PutApiSpec, module: InstantSurveyWeb.ApiSpec
  end

  scope "/api", InstantSurveyWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]

    get "/surveys/user/:user_id", SurveyController, :index_by_user

    resources "/surveys", SurveyController, except: [:new, :edit] do
      resources "/questions", QuestionController, except: [:new, :edit] do
        resources "/choices", ChoiceController, except: [:new, :edit]
        resources "/answers", AnswerController, except: [:new, :edit]
        get("/result", QuestionController, :result)
      end
    end
  end

  scope "/api" do
    pipe_through :api
    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/" do
    # Use the default browser stack
    pipe_through :browser

    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: InstantSurveyWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
