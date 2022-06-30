defmodule InstantSurvey.Game do
  @moduledoc """
  The Game context.
  """

  import Ecto.Query, warn: false
  alias InstantSurvey.Repo

  alias InstantSurvey.Game.Survey

  @doc """
  Returns the list of surveys.

  ## Examples

      iex> list_surveys()
      [%Survey{}, ...]

  """
  def list_surveys do
    Repo.all(Survey)
  end

  @doc """
  Returns the list of surveys for a user.

  ## Examples

      iex> list_surveys_by_user()
      [%Survey{}, ...]

  """
  def list_surveys_by_user(user_id) do
    query = from s in Survey, where: s.owner_id == ^user_id

    Repo.all(query)
  end

  @doc """
  Gets a single survey.

  Raises `Ecto.NoResultsError` if the Survey does not exist.

  ## Examples

      iex> get_survey!(123)
      %Survey{}

      iex> get_survey!(456)
      ** (Ecto.NoResultsError)

  """
  def get_survey!(id), do: Repo.get!(Survey, id)
  def get_survey(id), do: Repo.get(Survey, id)

  @doc """
  Creates a survey.

  ## Examples

      iex> create_survey(%{field: value})
      {:ok, %Survey{}}

      iex> create_survey(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_survey(
        attrs,
        %InstantSurvey.Accounts.User{} = user
      ) do
    attrs = AtomicMap.convert(attrs)
    survey = Ecto.build_assoc(user, :surveys, attrs)
    survey = Survey.changeset(survey, attrs)
    Repo.insert(survey)
  end

  @doc """
  Updates a survey.

  ## Examples

      iex> update_survey(survey, %{field: new_value})
      {:ok, %Survey{}}

      iex> update_survey(survey, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_survey(%Survey{} = survey, attrs) do
    survey
    |> Survey.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a survey.

  ## Examples

      iex> delete_survey(survey)
      {:ok, %Survey{}}

      iex> delete_survey(survey)
      {:error, %Ecto.Changeset{}}

  """
  def delete_survey(%Survey{} = survey) do
    Repo.delete(survey)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking survey changes.

  ## Examples

      iex> change_survey(survey)
      %Ecto.Changeset{data: %Survey{}}

  """
  def change_survey(%Survey{} = survey, attrs \\ %{}) do
    Survey.changeset(survey, attrs)
  end

  alias InstantSurvey.Game.Question

  @doc """
  Returns the list of questions.

  ## Examples

      iex> list_questions()
      [%Question{}, ...]

  """
  def list_questions do
    Repo.all(Question)
  end

  def list_questions_by_survey(survey_id) do
    query = from q in Question, where: q.survey_id == ^survey_id

    Repo.all(query)
  end

  @doc """
  Gets a single question.

  Raises `Ecto.NoResultsError` if the Question does not exist.

  ## Examples

      iex> get_question!(123)
      %Question{}

      iex> get_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question!(id), do: Repo.get!(Question, id)
  def get_question(id), do: Repo.get(Question, id)

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  # def create_question(attrs \\ %{}) do
  # %Question{}
  # |> Question.changeset(attrs)
  # |> Repo.insert()
  # end

  def create_question(attrs, %Survey{} = survey) do
    attrs = AtomicMap.convert(attrs)

    # attrs =
    # %Question{}
    # |> Question.changeset(attrs)

    question = Ecto.build_assoc(survey, :questions, attrs)
    question = Question.changeset(question, attrs)
    Repo.insert(question)
  end

  @doc """
  Updates a question.

  ## Examples

      iex> update_question(question, %{field: new_value})
      {:ok, %Question{}}

      iex> update_question(question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question changes.

  ## Examples

      iex> change_question(question)
      %Ecto.Changeset{data: %Question{}}

  """
  def change_question(%Question{} = question, attrs \\ %{}) do
    Question.changeset(question, attrs)
  end

  alias InstantSurvey.Game.Choice

  @doc """
  Returns the list of choices.

  ## Examples

      iex> list_choices()
      [%Choice{}, ...]

  """
  def list_choices do
    Repo.all(Choice)
  end

  def list_choices_by_question(question_id, survey_id) do
    query =
      from c in Choice,
        join: q in Question,
        on: q.id == c.question_id,
        join: s in Survey,
        on: s.id == q.survey_id,
        where: c.question_id == ^question_id and s.id == ^survey_id

    Repo.all(query)
  end

  @doc """
  Gets a single choice.

  Raises `Ecto.NoResultsError` if the Choice does not exist.

  ## Examples

      iex> get_choice!(123)
      %Choice{}

      iex> get_choice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_choice!(id), do: Repo.get!(Choice, id)
  def get_choice(id), do: Repo.get(Choice, id)

  @doc """
  Creates a choice.

  ## Examples

      iex> create_choice(%{field: value})
      {:ok, %Choice{}}

      iex> create_choice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_choice(attrs \\ %{}, question) do
    attrs = AtomicMap.convert(attrs)

    # attrs =
    # %Question{}
    # |> Question.changeset(attrs)

    choice = Ecto.build_assoc(question, :choices, attrs)
    choice = Choice.changeset(choice, attrs)
    Repo.insert(choice)
  end

  @doc """
  Updates a choice.

  ## Examples

      iex> update_choice(choice, %{field: new_value})
      {:ok, %Choice{}}

      iex> update_choice(choice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_choice(%Choice{} = choice, attrs) do
    choice
    |> Choice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a choice.

  ## Examples

      iex> delete_choice(choice)
      {:ok, %Choice{}}

      iex> delete_choice(choice)
      {:error, %Ecto.Changeset{}}

  """
  def delete_choice(%Choice{} = choice) do
    Repo.delete(choice)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking choice changes.

  ## Examples

      iex> change_choice(choice)
      %Ecto.Changeset{data: %Choice{}}

  """
  def change_choice(%Choice{} = choice, attrs \\ %{}) do
    Choice.changeset(choice, attrs)
  end

  alias InstantSurvey.Game.Answer

  @doc """
  Returns the list of answers.

  ## Examples

      iex> list_answers()
      [%Answer{}, ...]

  """
  def list_answers do
    Repo.all(Answer)
  end

  def list_answers_by_question(question_id, survey_id) do
    query =
      from a in Answer,
        join: q in Question,
        on: q.id == a.question_id,
        join: s in Survey,
        on: s.id == q.survey_id,
        where: a.question_id == ^question_id and s.id == ^survey_id

    Repo.all(query)
  end

  @doc """
  Gets a single answer.

  Raises `Ecto.NoResultsError` if the Answer does not exist.

  ## Examples

      iex> get_answer!(123)
      %Answer{}

      iex> get_answer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_answer!(id), do: Repo.get!(Answer, id)
  def get_answer(id), do: Repo.get(Answer, id)

  @doc """
  Creates a answer.

  ## Examples

      iex> create_answer(%{field: value})
      {:ok, %Answer{}}

      iex> create_answer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_answer(
        %InstantSurvey.Accounts.User{} = user,
        %Question{} = question,
        %Choice{} = choice
      ) do
    answer = Ecto.build_assoc(question, :answers, %Answer{})
    answer = Ecto.build_assoc(choice, :answers, answer)
    answer = Ecto.build_assoc(user, :answers, answer)
    Repo.insert(answer)
  end

  @doc """
  Deletes a answer.

  ## Examples

      iex> delete_answer(answer)
      {:ok, %Answer{}}

      iex> delete_answer(answer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
  end

  def aggregate_answers(question_id, survey_id) do
    IO.inspect([question_id, survey_id])

    query =
      from a in Answer,
        join: q in Question,
        on: q.id == a.question_id,
        join: c in Choice,
        on: c.id == a.choice_id,
        join: s in Survey,
        on: s.id == q.survey_id,
        group_by: c.text,
        where: a.question_id == ^question_id and s.id == ^survey_id,
        select: {c.id, c.text, count(c.id)}

    Repo.all(query)
  end

  def create_survey_questions_with_choices(user, %{survey: survey_text, questions: questions}) do
    survey_data = %{
      title: survey_text
    }

    survey_assoc = Ecto.build_assoc(user, :surveys, survey_data)

    survey = Repo.insert!(survey_assoc)

    Enum.each(questions, fn question ->
      create_question_with_choices(survey, question, user)
    end)

    Repo.preload(survey, questions: [:choices, :answers])
  end

  def create_question_with_choices(
        survey,
        %{question: text, choices: choices, answers: answers},
        user
      ) do
    question_data = %{
      text: text
    }

    question_assoc = Ecto.build_assoc(survey, :questions, question_data)

    question =
      Repo.insert!(question_assoc)
      |> Repo.preload(:surveys)

    choices_db =
      Enum.map(choices, fn choice_text ->
        create_choice_preload(question, choice_text)
      end)

    Enum.each(answers, fn answer ->
      choice = Enum.at(choices_db, answer)
      create_answer_seed(choice, question, user)
    end)

    Repo.preload(question, :choices)
  end

  defp create_choice_preload(question, choice_text) do
    choice_data = %{
      text: choice_text
    }

    choice_assoc = Ecto.build_assoc(question, :choices, choice_data)

    Repo.insert!(choice_assoc)
    |> Repo.preload(:question)
  end

  defp create_answer_seed(choice, question, user) do
    answer = %{}
    answer = Ecto.build_assoc(choice, :answers, answer)
    answer = Ecto.build_assoc(question, :answers, answer)
    answer = Ecto.build_assoc(user, :answers, answer)

    Repo.insert!(answer)
    |> Repo.preload([:choice, :question, :user])
  end
end
