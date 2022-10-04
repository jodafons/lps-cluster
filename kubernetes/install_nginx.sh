
docker run --detach \
    --name nginx-proxy \
    --publish 80:80 \
    --publish 443:443 \
    --volume /home/cluster/volumes/certs:/etc/nginx/certs \
    --volume /home/cluster/volumes/vhost:/etc/nginx/vhost.d \
    --volume /home/cluster/volumes/html:/usr/share/nginx/html \
    --volume /var/run/docker.sock:/tmp/docker.sock:ro \
    nginxproxy/nginx-proxy


docker run --detach \
    --name nginx-proxy-acme \
    --volumes-from nginx-proxy \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --volume /home/cluster/volumes/acme:/etc/acme.sh \
    --env "DEFAULT_EMAIL=jodafons@lps.ufrj.br" \
    nginxproxy/acme-companion
