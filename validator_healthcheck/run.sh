pacman -Syu --noconfirm
pacman -S --noconfirm git base-devel wget dnsutils python python-pip screen

cd $HOME
git clone --single-branch --branch main https://github.com/notional-labs/nmisc

########################################################################################################################
# validator_healthcheck api
cd $HOME/nmisc/validator_healthcheck/api

# add --break-system-packages to fix error: externally-managed-environment
pip install -r requirements.txt --break-system-packages

screen -S api -dm /usr/sbin/python app.py

########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 5; done
