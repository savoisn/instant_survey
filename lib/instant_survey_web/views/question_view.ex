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

  def render("result.json", %{result: params}) do
    %{data: render_many(params, QuestionView, "res.json", as: :param)}
  end

  def render("res.json", %{param: param}) do
    %{
      choice_id: elem(param, 0),
      choice_text: elem(param, 1),
      choice_count: elem(param, 2)
    }
  end
end
