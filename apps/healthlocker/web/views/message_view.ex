defmodule Healthlocker.MessageView do
  use Healthlocker.Web, :view

  def dom_id(message) do
    "message-" <> Integer.to_string(message.id)
  end

  def user_name(message) do
    message.user.first_name <> " " <> message.user.last_name
  end

  def sent_at(message) do
    Timex.from_now(message.inserted_at)
  end

  @base_classes "w-80 br2 mb2 pa1 pa3-ns"
  @align_right "fr"
  @align_left "fl"
  @sender_classes "hl-bg-light-yellow"
  @receiver_classes "hl-bg-light-aqua"
  @teacher_classes "hl-bg-lilac"

  def classes(message, nil) do
    if message.user.role == "teacher" do
      @base_classes <> " " <> @teacher_classes
    else
      @base_classes
    end
  end

  def classes(message, current_user_id) do
    alignement = get_alignement(message.user, current_user_id)
    colour = get_message_colour(message.user, current_user_id)

    @base_classes <> " " <> alignement <> " " <> colour
  end

  defp message_from_current_user?(message_user, current_user_id) do
    message_user.id == current_user_id
  end

  defp get_alignement(message_user, current_user_id) do
    if message_from_current_user?(message_user, current_user_id) do
      @align_right
    else
      @align_left
    end
  end

  defp get_message_colour(message_user, current_user_id) do
    if message_user.role == "teacher" do
      @teacher_classes
    else
      if message_from_current_user?(message_user, current_user_id) do
        @sender_classes
      else
        @receiver_classes
      end
    end
  end
end
