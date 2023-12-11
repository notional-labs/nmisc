# delete existing service
docker service rm uptime-kuma-relayer

docker service create \
  --name uptime-kuma-relayer \
  --replicas 1 \
  --mount type=bind,source=/mnt/data/uptime-kuma-relayer,destination=/app/data \
  --network net1 \
  --constraint 'node.hostname==nmisc1' \
  --restart-condition any \
  louislam/uptime-kuma:1.23.3