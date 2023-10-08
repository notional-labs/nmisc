# usage: ./docker_service_create.sh chain_name
# eg., ./docker_service_create.sh osmosis-testnet

chain_name="$1"

if [[ -z $chain_name ]]; then
  echo "No chain_name. usage eg., ./docker_service_create.sh cosmoshub"
  exit
fi

service_name="lava_rpcprovider_${chain_name}"

# delete existing service
docker service rm $service_name

# create new service
docker service create \
  --name $service_name \
  --replicas 1 \
  --network net1 \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition none \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/nmisc/main/lava/rpcprovider/run.sh > ~/run.sh && /bin/bash ~/run.sh $chain_name"
