VERSION=v1.0.0-alpha.0

# delete existing service
docker service rm icq_1
docker service rm icq_2

docker service create \
  --name icq_1 \
  --replicas 1 \
  --network net1 \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition any \
  --secret source=icq_prod_seed,target=seed \
  --entrypoint /usr/local/bin/entrypoint.sh \
  quicksilverzone/interchain-queries:$VERSION \
  icq-relayer start --home /icq/.icq-relayer

docker service create \
  --name icq_2 \
  --replicas 1 \
  --network net1 \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition any \
  --secret source=icq_prod_seed2,target=seed \
  --entrypoint /usr/local/bin/entrypoint.sh \
  quicksilverzone/interchain-queries:$VERSION \
  icq-relayer start --home /icq/.icq-relayer
