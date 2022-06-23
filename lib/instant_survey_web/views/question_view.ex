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
    IO.inspect(params)
    %{data: render_many(params, QuestionView, "res.json", as: :param)}
  end

  def render("res.json", %{param: param}) do
    IO.inspect(param)

    %{
      choice_text: elem(param, 0),
      choice_count: elem(param, 1)
    }
  end
end
