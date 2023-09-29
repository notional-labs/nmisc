# delete existing service
docker service rm evince

# create new service
docker service create \
  --name evince \
  --replicas 1 \
  --publish mode=host,target=1323,published=1323 \
  --network net1 \
  --restart-condition none \
  --endpoint-mode dnsrr \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/nmisc/1-add-evince-service/evince/run.sh > ~/run.sh && /bin/bash ~/run.sh"
