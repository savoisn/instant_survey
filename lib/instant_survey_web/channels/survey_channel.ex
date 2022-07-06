defmodule InstantSurveyWeb.SurveyChannel do
  use InstantSurveyWeb, :channel

  alias Phoenix.PubSub
  alias InstantSurveyWeb.Presence
  alias InstantSurvey.Game

  @impl true
  def join("survey:" <> channel_id = topic, payload, socket) do
    send(self(), {:after_join, channel_id})

    if authorized?(payload) do
      {:ok, %{channel_id: channel_id}, assign(socket, :channel_id, topic)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def join("survey:lobby", payload, socket) do
    send(self(), :after_join)

    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_info({:after_join, channel_id}, socket) do
    IO.inspect(socket.assigns)

    {:ok, _} =
      Presence.track(socket, socket.assigns["name"], %{
        online_at: inspect(System.system_time(:second)),
        channel_id: channel_id
      })

    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (survey:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)

    {:noreply, socket}
  end

  @impl true
  def handle_in("push_to_next_question", %{"next_question_id" => question_id}, socket) do
    IO.inspect(question_id)
    broadcast(socket, "next_question", %{next_question_id: question_id})

    {:noreply, socket}
  end

  @impl true
  def handle_in("display_question_result", %{"question_id" => question_id}, socket) do
    IO.inspect(question_id)
    broadcast(socket, "display_question_result", %{question_id: question_id})

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
