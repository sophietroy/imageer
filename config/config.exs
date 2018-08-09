# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :imageer,
  ecto_repos: [Imageer.Repo]

# Configures the endpoint
config :imageer, Imageer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/rAwdPdM0ykaHLyesafHeVvXJlWrJ91YItms/l24ydjXHMyDOqiE7TP+uKcvGqHE",
  render_errors: [view: Imageer.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Imageer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :cloudex,
  api_key: System.get_env("CLOUDINARY_API_KEY"),
  secret: System.get_env("CLOUDINARY_SECRET"),
  cloud_name: System.get_env("CLOUDINARY_CLOUD_NAME")


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
