

#docker run --detach \
#    --name grafana \
#    --env "VIRTUAL_HOST=grafana.lps.ufrj.br" \
#    --env "VIRTUAL_PORT=3000" \
#    --env "LETSENCRYPT_HOST=grafana.lps.ufrj.br" \
#    --env "LETSENCRYPT_EMAIL=jodafons@lps.ufrj.br" \
#    grafana/grafana
#

docker run --detach \
    --name your-proxied-app \
    --env "VIRTUAL_HOST=nginx.lps.ufrj.br" \
    --env "LETSENCRYPT_HOST=nginx.lps.ufrj.br" \
    nginx