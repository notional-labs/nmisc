# functions
loop_forever () {
  echo "loop forever for debugging only"
  while true; do sleep 5; done
}



pacman-key --init
pacman -Syu --noconfirm
pacman -Sy --noconfirm archlinux-keyring
pacman -Sy --noconfirm git go base-devel pigz jq cronie screen
pacman -Syu --noconfirm

echo "#################################################################################################################"
echo "install go..."

export GOPATH="$HOME/go"
export GOROOT="/usr/lib/go"
export GOBIN="${GOPATH}/bin"
export PATH="${PATH}:${GOROOT}/bin:${GOBIN}"
export GOROOT_BOOTSTRAP=$GOROOT
mkdir -p $GOBIN

echo "#################################################################################################################"
echo "build icq-relayer..."

cd $HOME

# branch or tag
version="icq-v1.0.0-alpha"
git_repo="https://github.com/quicksilver-zone/quicksilver"

git clone --single-branch --branch $version $git_repo
cd quicksilver/icq-relayer
make build

echo "#################################################################################################################"
echo "config..."
curl -Ls "https://raw.githubusercontent.com/notional-labs/nmisc/58-update-icq-relayer-to-have-cronjob-to-restart/icq-relayer/config.toml" > $HOME/.icq-relayer/config.toml

cat <<EOT > $HOME/start.sh
while true; do
  $HOME/quicksilver/icq-relayer/icq-relayer start --home $HOME/.icq-relayer
  sleep 5;
done
EOT

cat <<EOT > $HOME/restart.sh
while true; do
  killall icq-relayer
  # 4 hours
  sleep 14400;
done
EOT

echo "#################################################################################################################"
echo "run..."

screen -S icq -dm /bin/bash $HOME/start.sh
screen -S restart -dm /bin/bash $HOME/restart.sh

echo "#################################################################################################################"
echo "Done!"
loop_forever