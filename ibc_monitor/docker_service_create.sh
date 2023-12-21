# delete existing service
docker service rm ibc_monitor

# create new service
docker service create \
  --name ibc_monitor \
  --replicas 1 \
  --network net1 \
  --restart-condition any \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/nmisc/main/ibc_monitor/run.sh > ~/run.sh && /bin/bash ~/run.sh"


