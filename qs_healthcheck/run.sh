pacman -Syu --noconfirm
pacman -S --noconfirm git base-devel wget dnsutils python python-pip screen

cd $HOME
git clone --single-branch --branch main https://github.com/ingenuity-build/qsdelcheck

########################################################################################################################
cd $HOME/qsdelcheck

# add --break-system-packages to fix error: externally-managed-environment
pip install -r requirements.txt --break-system-packages

screen -S qsdelcheck -dm /usr/sbin/python check.py

########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 5; done
