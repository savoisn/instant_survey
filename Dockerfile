# Extend from the official Elixir image.
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update && \
  apt-get -y install wget gnupg build-essential locales

RUN locale-gen en_US.UTF-8 && \
  update-locale LANG=en_US.UTF-8

RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && \
  dpkg -i erlang-solutions_2.0_all.deb && \
  apt-get update && \
  apt-get -y install erlang && \
  apt-get -y install elixir

# Create app directory and copy the Elixir projects into it.
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install Hex package manager.
# By using `--force`, we don’t need to type “Y” to confirm the installation.
RUN mix local.hex --force

# Compile the project.
RUN mix do compile
RUN mix run priv/repo/seeds.exs

ENTRYPOINT ["mix", "phx.server"]

