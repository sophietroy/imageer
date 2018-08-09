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

config :ex_aws,
  region: System.get_env("AWS_REGION"),
  access_key_id: [System.get_env("AWS_ACCESS_KEY_ID"), :instance_role],
  secret_access_key: [System.get_env("AWS_SECRET_ACCESS_KEY"), :instance_role]

config :arc,
  asset_host: "https://s3-#{System.get_env("AWS_REGION")}.amazonaws.com/#{System.get_env("AWS_S3_BUCKET")}",
  storage: Arc.Storage.S3,
  bucket: System.get_env("AWS_S3_BUCKET")



# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
