#### Pinguin Repo
[Pinguin Repo](http://repo.doscom.org)

#### Image Caddy
Image caddy is from here [mangucub-caddy](https://github.com/ucub/docker-alpine-caddy).

#### Installation
1. Just write command ```docker-compose up -d```
2. Or if you use docker images by yourself, write ```docker-compose build```

#### Traefik Section
1. Just edit at ```"traefik.http.routers.web-repo.rule=Host(`repo.doscom.org`)"``` sections.