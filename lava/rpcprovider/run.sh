# usage: ./run.sh chain_name
# eg., ./run.sh osmosis-testnet

chain_name="$1"
if [[ -z $chain_name ]]; then
  echo "No chain_name. usage eg., ./run.sh cosmoshub"
  exit
fi


pacman -Syu --noconfirm
pacman -S --noconfirm go git base-devel wget pigz jq cronie screen unzip logrotate

########################################################################################################################
# install lava
cd $HOME
git clone https://github.com/lavanet/lava
cd lava
git checkout v0.24.0
make install

$HOME/go/bin/lavad config chain-id lava-testnet-2

# create ${chain_name}-provider.yml
wget "http://tasks.web_config/config/lava.${chain_name}-provider.yml" -O $HOME/.lava/${chain_name}-provider.yml

# keyring-file
wget -O - "http://tasks.web_config/config/lava.keyring-file.tar.gz" |tar -xzf - -C $HOME/.lava/

# start_rpcprovider.sh script
cat <<EOT > $HOME/start_rpcprovider.sh
cd $HOME/.lava
echo "notional" | /root/go/bin/lavad rpcprovider ${chain_name}-provider.yml --from notional --geolocation 2 --chain-id lava-testnet-2 --log_level debug --node https://public-rpc-testnet2.lavanet.xyz:443/rpc/
EOT

# run
screen -S rpcprovider -dm /bin/bash $HOME/start_rpcprovider.sh

########################################################################################################################
echo "Done!"

# loop forever for debugging only
while true; do sleep 60; done
