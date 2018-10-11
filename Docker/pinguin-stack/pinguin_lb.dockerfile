FROM nginx:1.14.0

LABEL maintenance="DOSCOM Team" \
    version="0.5" \
    description="blablabla"

HEALTHCHECK CMD curl --fail http://localhost/ || exit 1