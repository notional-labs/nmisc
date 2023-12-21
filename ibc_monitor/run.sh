pacman -Syu --noconfirm
pacman -S --noconfirm git base-devel wget dnsutils python python-pip screen

cd $HOME
git clone --single-branch --branch main https://github.com/notional-labs/nmisc

########################################################################################################################
# ibc_monitor api
cd $HOME/nmisc/ibc_monitor/api

# add --break-system-packages to fix error: externally-managed-environment
pip install -r requirements.txt --break-system-packages

wget "http://tasks.web_config/config/NOTIONAL_API_KEY_RELAYING" -O $HOME/NOTIONAL_API_KEY_RELAYING.txt
NOTIONAL_API_KEY=$(cat $HOME/NOTIONAL_API_KEY_RELAYING.txt)
export NOTIONAL_API_KEY="$NOTIONAL_API_KEY"

screen -S api -dm /usr/sbin/python app.py

########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 5; done
