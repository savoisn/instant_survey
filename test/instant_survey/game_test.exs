defmodule InstantSurvey.GameTest do
  use InstantSurvey.DataCase

  alias InstantSurvey.Game

  describe "surveys" do
    alias InstantSurvey.Game.Survey

    import InstantSurvey.GameFixtures

    @invalid_attrs %{title: nil}

    test "list_surveys/0 returns all surveys" do
      survey = survey_fixture()
      assert Game.list_surveys() == [survey]
    end

    test "get_survey!/1 returns the survey with given id" do
      survey = survey_fixture()
      assert Game.get_survey!(survey.id) == survey
    end

    test "create_survey/1 with valid data creates a survey" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Survey{} = survey} = Game.create_survey(valid_attrs)
      assert survey.title == "some title"
    end

    test "create_survey/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_survey(@invalid_attrs)
    end

    test "update_survey/2 with valid data updates the survey" do
      survey = survey_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Survey{} = survey} = Game.update_survey(survey, update_attrs)
      assert survey.title == "some updated title"
    end

    test "update_survey/2 with invalid data returns error changeset" do
      survey = survey_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_survey(survey, @invalid_attrs)
      assert survey == Game.get_survey!(survey.id)
    end

    test "delete_survey/1 deletes the survey" do
      survey = survey_fixture()
      assert {:ok, %Survey{}} = Game.delete_survey(survey)
      assert_raise Ecto.NoResultsError, fn -> Game.get_survey!(survey.id) end
    end

    test "change_survey/1 returns a survey changeset" do
      survey = survey_fixture()
      assert %Ecto.Changeset{} = Game.change_survey(survey)
    end
  end

  describe "questions" do
    alias InstantSurvey.Game.Question

    import InstantSurvey.GameFixtures

    @invalid_attrs %{text: nil}

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Game.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Game.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      valid_attrs = %{text: "some text"}

      assert {:ok, %Question{} = question} = Game.create_question(valid_attrs)
      assert question.text == "some text"
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      update_attrs = %{text: "some updated text"}

      assert {:ok, %Question{} = question} = Game.update_question(question, update_attrs)
      assert question.text == "some updated text"
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_question(question, @invalid_attrs)
      assert question == Game.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Game.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Game.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Game.change_question(question)
    end
  end
end
