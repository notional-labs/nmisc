# delete existing service
docker service rm proxy_sei

# create new service
docker service create \
  --name proxy_sei \
  --replicas 1 \
  --publish mode=host,target=80,published=80 \
  --publish mode=host,target=443,published=443 \
  --network net1 \
  --constraint 'node.hostname==nmisc3' \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/nmisc/main/proxy_sei/run.sh > ~/run.sh && /bin/bash ~/run.sh"
