# delete existing service
docker service rm icq

# create new service
docker service create \
  --name icq \
  --replicas 1 \
  --network net1 \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition any \
  --secret source=icq_prod_seed,target=seed \
  --entrypoint /usr/local/bin/entrypoint.sh \
  quicksilverzone/interchain-queries:v1.0.0-alpha.0 \
  icq-relayer start
