# usage: ./docker_service_create.sh node_num
# node_num: 1 or 2
# eg., ./docker_service_create.sh 1

node_num="$1"

service_name="icq-relayer_${node_num}"

echo "service_name=${service_name}"

# remove existing service
docker service rm $service_name
sleep 10

secret_opt="--secret source=icq_prod_seed,target=seed"
if [ "$node_num" = "2" ] ; then
  secret_opt="--secret source=icq_prod_seed2,target=seed"
fi

docker service create \
  --name $service_name \
  --replicas 1 \
  --network net1 \
  --endpoint-mode dnsrr \
  --restart-condition none \
  $secret_opt \
  archlinux:latest \
  /bin/bash -c \
  "curl -s https://raw.githubusercontent.com/notional-labs/nmisc/58-update-icq-relayer-to-have-cronjob-to-restart/icq-relayer/run.sh > ~/run.sh && \
  /bin/bash ~/run.sh"