# Extend from the official Elixir image.
FROM elixir:1.13.4

# Create app directory and copy the Elixir projects into it.
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install Hex package manager.
# By using `--force`, we don’t need to type “Y” to confirm the installation.
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get

# Compile the project.
RUN mix do compile
RUN mix ecto.create
RUN mix ecto.migrate
RUN mix run priv/repo/seeds.exs

ENTRYPOINT ["mix", "phx.server"]

