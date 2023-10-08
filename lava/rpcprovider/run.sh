pacman -Syu --noconfirm
pacman -S --noconfirm go git base-devel wget pigz jq cronie screen unzip logrotate

########################################################################################################################
# SSL (fullchain.pem and privkey.pem files)
wget "http://tasks.web_config/config/notional.ventures.fullchain.pem" -O /etc/nginx/fullchain.pem
wget "http://tasks.web_config/config/notional.ventures.privkey.pem" -O /etc/nginx/privkey.pem

########################################################################################################################
# install lava
cd $HOME
git clone https://github.com/lavanet/lava
cd lava
git checkout v0.21.1.2
make install

$HOME/go/bin/lavad config chain-id lava-testnet-2


# start_rpcprovider.sh script
cat <<EOT > $HOME/start_rpcprovider.sh
/root/go/bin/lavad rpcprovider osmosis-testnet-provider.yml --from notional --geolocation 2 --chain-id lava-testnet-2 --log_level debug --node https://public-rpc-testnet2.lavanet.xyz:443/rpc/
EOT

# create osmosis-testnet-provider.yml
wget "http://tasks.web_config/config/lava.osmosis-testnet-provider.yml" -O cd $HOME/.lava/osmosis-testnet-provider.yml

# run
cd $HOME/.lava
screen -S rpcprovider -dm /bin/bash $HOME/start_rpcprovider.sh

########################################################################################################################
echo "Done!"

# loop forever for debugging only
while true; do sleep 60; done
