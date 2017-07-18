defmodule App.FeedbackController do
  use App.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, %{"feedback" => %{"subject" => subject, "content" => content}}) do
    App.Email.send_feedback(subject, content)
    |> App.Mailer.deliver_now()

    conn
    |> put_flash(:info, "Feedback Sent")
    |> redirect(to: feedback_path(conn, :index))
  end
end
