FROM httpd:latest

LABEL maintenance="DOSCOM Team" \
    version="0.5" \
    description="Pinguin web"

RUN apt-get update && \
	apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# HEALTHCHECK CMD curl --fail http://localhost/ || exit 1