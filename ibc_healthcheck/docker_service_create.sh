# delete existing service
docker service rm ibc_healthcheck

# create new service
docker service create \
  --name ibc_healthcheck \
  --replicas 1 \
  --network net1 \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/nmisc/main/ibc_healthcheck/run.sh > ~/run.sh && /bin/bash ~/run.sh"


