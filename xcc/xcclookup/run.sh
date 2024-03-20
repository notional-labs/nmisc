pacman -Syu --noconfirm
pacman -S --noconfirm go git base-devel wget jq screen

########################################################################################################################
# build
cd $HOME
gh_access_token="$(curl -s "http://tasks.web_config/config/gh_access_token")"
git clone --single-branch --branch main "https://${gh_access_token}@github.com/ingenuity-build/xcclookup"
cd xcclookup/
go build -ldflags="-s -X main.GitCommit=3fa2d98 -X main.Version=v0.5.3" -a xcc.go
cp $HOME/xcclookup/config.yaml $HOME/

# get the config
curl -Ls https://raw.githubusercontent.com/notional-labs/nmisc/main/xcc/xcclookup/config.yaml > $HOME/config.yaml

# run it
screen -S xcc -dm /root/xcclookup/xcc -f $HOME/config.yaml

########################################################################################################################
echo "Done!"

# loop forever for debugging only
while true; do sleep 60; done
