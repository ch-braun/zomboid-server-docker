FROM steamcmd/steamcmd:ubuntu-24

USER root

# Install dependencies
RUN apt-get update
RUN apt-get install -y tmux

# Add user
RUN useradd -m -u 1069 -g 1069 pzuser

# Create install dir
RUN mkdir -p /opt/pzserver
RUN chown pzuser:pzuser /opt/pzserver

RUN mkdir -p /opt/steamcmd

COPY --chown=pzuser:pzuser ./update_zomboid.txt /opt/steamcmd/update_zomboid.txt

RUN steamcmd +runscript /opt/steamcmd/update_zomboid.txt

# Switch to user
USER pzuser

# Expose ports
# 16261/udp - Game Server Port
# 16262/udp - Direct Connection Port
EXPOSE 16261/udp
EXPOSE 16262/udp

WORKDIR /opt/pzserver

ENTRYPOINT ["bash", "./start-server.sh"]