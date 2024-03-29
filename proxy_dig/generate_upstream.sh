SERVICES=$(cat <<-END
dig-archive
dig
END
)
UPSTREAM_CONFIG_FILE="/etc/nginx/upstream.conf"

# generate upstream.conf
echo "" > $UPSTREAM_CONFIG_FILE
for service_name in $SERVICES; do
  cat <<EOT >> $UPSTREAM_CONFIG_FILE
    upstream backend_rpc_$service_name {
        keepalive 16;
        server r-${service_name}--${NOTIONAL_API_KEY}.gw.notionalapi.net:80;
    }

    upstream backend_api_$service_name {
        keepalive 16;
        server a-${service_name}--${NOTIONAL_API_KEY}.gw.notionalapi.net:80;
    }

    upstream backend_grpc_$service_name {
        keepalive 16;
        server g-${service_name}--${NOTIONAL_API_KEY}.gw.notionalapi.net:9090;
    }
EOT

  sleep 0.5
done

sleep 1