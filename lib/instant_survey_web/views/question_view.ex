defmodule InstantSurveyWeb.QuestionView do
  use InstantSurveyWeb, :view
  alias InstantSurveyWeb.QuestionView

  def render("index.json", %{questions: questions}) do
    %{data: render_many(questions, QuestionView, "question.json")}
  end

  def render("show.json", %{question: question}) do
    %{data: render_one(question, QuestionView, "question.json")}
  end

  def render("question.json", %{question: question}) do
    %{
      id: question.id,
      text: question.text,
      survey_id: question.survey_id
    }
  end
end
