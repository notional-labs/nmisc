# delete existing service
docker service rm qs_healthcheck

# create new service
docker service create \
  --name qs_healthcheck \
  --replicas 1 \
  --network net1 \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/nmisc/38-qs-healthcheck/qs_healthcheck/run.sh > ~/run.sh && /bin/bash ~/run.sh"


