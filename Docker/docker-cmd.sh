# remove old container
# docker container rm -f nextcloud mariadb
# sudo rm -rf /docker/nextcloud
# sudo rm -rf /docker/mariadb

# Run new container
docker-compose -p ProjectName -f YMLFileName up -d

# Please first set nextcloud database connect
# https://IP-Address

# After set nextcloud database connect, Copy key file
cp nextcloud.xwinds.top.key /docker/nextcloud/config/keys/cert.key
cp nextcloud.xwinds.top.crt /docker/nextcloud/config/keys/cert.crt