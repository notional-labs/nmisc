pacman -Syu --noconfirm
pacman -S --noconfirm go git base-devel wget jq screen


# build
cd $HOME
# mkdir -p $HOME/go/bin

git clone https://github.com/ingenuity-build/evince
cd evince
make build


# download config
curl -Ls https://raw.githubusercontent.com/notional-labs/nmisc/1-add-evince-service/evince/conf.yaml > $HOME/conf.yaml

# run
cd $HOME
screen -S evince -dm $HOME/evince/bin/evinced -f $HOME/conf.yaml

########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 5; done
