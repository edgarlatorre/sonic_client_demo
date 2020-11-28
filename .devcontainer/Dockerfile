FROM elixir:1.11-slim

ARG USERNAME=vscode


RUN apt-get update && \
    apt-get install -y postgresql-client && \
    apt-get install -y inotify-tools && \
    apt-get install -y vim && \
    apt-get install -y git && \
    apt-get install -y curl && \
    apt-get install -y wget && \
    apt-get install -y gnupg2 && \
    apt-get install -y rubygems && \
    apt-get install -y zsh && \
    apt-get install -y telnet

RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

RUN useradd -ms /bin/zsh -G sudo $USERNAME

COPY setup.sh .
RUN bash ./setup.sh

ENV MIX_HOME=/home/$USERNAME/.mix
ENV HEX_HOME=/home/$USERNAME/.hex

USER $USERNAME

RUN mix local.hex --force && \
    mix local.rebar --force

RUN mkdir -p /home/$USERNAME/app
WORKDIR /home/$USERNAME/app

# Explicitly creates the directories where were' going to mount
# the volumes so the permissions are correctly kept.
RUN mkdir -p .elixir_ls _build assets/node_modules deps

CMD ["mix", "phx.server"]
