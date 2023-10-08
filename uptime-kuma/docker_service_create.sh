docker service create \
  --name uptime-kuma \
  --replicas 1 \
  --publish target=3001,published=3001 \
  --mount type=bind,source=/mnt/data/uptime-kuma,destination=/app/data \
  --network net1 \
  --constraint 'node.hostname==nmisc1' \
  --restart-condition any \
  louislam/uptime-kuma:1.15.1