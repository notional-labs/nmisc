# functions
loop_forever () {
  echo "loop forever for debugging only"
  while true; do sleep 5; done
}


echo "#################################################################################################################"
echo "install..."

pacman-key --init
pacman -Syu --noconfirm
pacman -Sy --noconfirm archlinux-keyring
pacman -Sy --noconfirm base-devel wget pigz jq cronie screen
pacman -Syu --noconfirm

#export GOPATH="$HOME/go"
#export GOROOT="/usr/lib/go"
#export GOBIN="${GOPATH}/bin"
#export PATH="${PATH}:${GOROOT}/bin:${GOBIN}"
#export GOROOT_BOOTSTRAP=$GOROOT
#mkdir -p $GOBIN

echo "#################################################################################################################"
echo "build icq-relayer..."

cd $HOME

## branch or tag
#version="v1.5.6-hotfix.0"
#git_repo="https://github.com/quicksilver-zone/quicksilver"
#
#git clone --single-branch --branch $version $git_repo
#cd quicksilver/icq-relayer
#make build

# download instead
wget -O - "https://github.com/notional-labs/nmisc/releases/download/untagged-9f3b002ff36bb86895f3/icq-relayer_v1.0.0-alpha.0.tar.gz" |pigz -dc |tar -xf -


echo "#################################################################################################################"
echo "config..."
mkdir -p $HOME/.icq-relayer
curl -Ls "https://raw.githubusercontent.com/notional-labs/nmisc/58-update-icq-relayer-to-have-cronjob-to-restart/icq-relayer/config.toml" > $HOME/.icq-relayer/config.toml

cat <<EOT > $HOME/start.sh
while true; do
  $HOME/icq-relayer start --home $HOME/.icq-relayer
  sleep 5;
done
EOT

cat <<EOT > $HOME/restart.sh
while true; do
  killall icq-relayer

  # 1 hour
  sleep 3600
done
EOT

echo "#################################################################################################################"
echo "run..."

screen -S icq -dm /bin/bash $HOME/start.sh
screen -S restart -dm /bin/bash $HOME/restart.sh

echo "#################################################################################################################"
echo "Done!"
loop_forever