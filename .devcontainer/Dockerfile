FROM node:22-bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV USER=cristobal
ENV USER_ID=1000
ENV HOME=/home/${USER}

RUN apt-get update && apt-get install -y --no-install-recommends \
      git curl ca-certificates ripgrep less jq sudo openssh-client \
      zsh locales locales-all fonts-powerline \
      docker.io \
 && update-ca-certificates \
 && sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
 && locale-gen \
 && update-locale LANG=$LANG LC_ALL=$LC_ALL LANGUAGE=$LANGUAGE \
 && rm -rf /var/lib/apt/lists/*

RUN userdel -r node 2>/dev/null || true \
 && groupadd --system --gid $USER_ID $USER \
 && useradd $USER \
      --uid $USER_ID \
      --gid $USER_ID \
      --create-home \
      --shell /usr/bin/zsh \
 && usermod -p '*' $USER \
 && echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER \
 && chmod 440 /etc/sudoers.d/$USER \
 && npm install -g @anthropic-ai/claude-code

# ohmyzsh (as root, installs into $HOME thanks to ENV HOME)
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -- \
      -t agnoster \
      -p git \
      -p colored-man-pages \
 && sed -i 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' "$HOME/.zshrc"
COPY custom.zsh "$HOME/.oh-my-zsh/custom/custom.zsh"

# ssh
RUN mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh" \
 && ssh-keyscan -t rsa,ecdsa,ed25519 github.com > "$HOME/.ssh/known_hosts" 2>/dev/null \
 && chmod 600 "$HOME/.ssh/known_hosts"
COPY ssh_config "$HOME/.ssh/config"
RUN chmod 600 "$HOME/.ssh/config" \
 && chown -R $USER_ID:$USER_ID $HOME

USER $USER
WORKDIR /home/cristobal/cristobal/especialistas/cristobal
CMD ["sleep", "infinity"]
