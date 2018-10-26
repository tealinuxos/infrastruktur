FROM portainer/portainer:latest

LABEL maintenance="DOSCOM Team" \
    version="0.5" \
    description="Pinguin web"

RUN apt update
RUN apt install curl -y

# HEALTHCHECK CMD curl --fail http://localhost/ || exit 1