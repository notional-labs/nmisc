# delete existing service
docker service rm validator_healthcheck

# create new service
docker service create \
  --name validator_healthcheck \
  --replicas 1 \
  --network net1 \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/nmisc/main/validator_healthcheck/run.sh > ~/run.sh && /bin/bash ~/run.sh"


