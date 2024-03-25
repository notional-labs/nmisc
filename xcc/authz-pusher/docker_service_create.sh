# delete existing service
docker service rm xcc-pusher

# create new service
docker service create \
  --name xcc-pusher \
  --replicas 1 \
  --network net2 \
  --sysctl 'net.ipv4.tcp_tw_reuse=1' \
  --restart-condition any \
  --secret source=authz_pusher_prod_seed,target=seed \
  --secret source=auth_push_prod_dbpassword,target=dbpassword \
  --entrypoint /usr/bin/entrypoint.sh \
  quicksilverzone/authz-pusher:v1.2.1
