FROM nginx:1.14.0

LABEL maintenance="DOSCOM Team" \
    version="0.5" \
    description="Load Balance"

RUN apt-get update && \
	apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# HEALTHCHECK CMD curl --fail http://localhost/ || exit 1