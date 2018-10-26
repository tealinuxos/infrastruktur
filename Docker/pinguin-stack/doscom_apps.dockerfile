FROM httpd:latest

LABEL maintenance="DOSCOM Team" \
    version="0.5" \
    description="Doscom Web"

# HEALTHCHECK CMD curl --fail http://localhost/ || exit 1