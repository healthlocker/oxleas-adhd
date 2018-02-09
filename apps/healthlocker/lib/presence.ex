defmodule Healthlocker.Presence do
  use Phoenix.Presence, otp_app: :my_app,
                        pubsub_server: Healthlocker.PubSub
end
