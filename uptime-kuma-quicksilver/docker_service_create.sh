# delete existing service
docker service rm uptime-kuma-quicksilver

docker service create \
  --name uptime-kuma-quicksilver \
  --replicas 1 \
  --mount type=bind,source=/mnt/data/uptime-kuma-quicksilver,destination=/app/data \
  --network net1 \
  --constraint 'node.hostname==nmisc1' \
  --restart-condition any \
  louislam/uptime-kuma:1.23.3