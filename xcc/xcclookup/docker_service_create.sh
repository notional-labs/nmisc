# delete existing service
docker service rm xcclookup

# create new service
docker service create \
  --name xcclookup \
  --replicas 1 \
  --network net1 \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/nmisc/main/xcc/xcclookup/run.sh > ~/run.sh && /bin/bash ~/run.sh"
