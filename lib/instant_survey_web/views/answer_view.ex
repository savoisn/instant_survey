defmodule InstantSurveyWeb.AnswerView do
  use InstantSurveyWeb, :view
  alias InstantSurveyWeb.AnswerView

  def render("index.json", %{answers: answers}) do
    %{data: render_many(answers, AnswerView, "answer.json")}
  end

  def render("show.json", %{answer: answer}) do
    %{data: render_one(answer, AnswerView, "answer.json")}
  end

  def render("answer.json", %{answer: answer}) do
    %{
      id: answer.id,
      question_id: answer.question_id,
      choice_id: answer.choice_id,
      user_id: answer.user_id
    }
  end
end
