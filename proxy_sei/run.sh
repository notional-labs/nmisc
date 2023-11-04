pacman -Syu --noconfirm
pacman -S --noconfirm base-devel wget dnsutils nginx cronie screen

########################################################################################################################
# SSL (fullchain.pem and privkey.pem files)
wget "http://tasks.web_config/config/notional.ventures.fullchain.pem" -O /etc/nginx/fullchain.pem
wget "http://tasks.web_config/config/notional.ventures.privkey.pem" -O /etc/nginx/privkey.pem

########################################################################################################################
# nginx
curl -s "https://raw.githubusercontent.com/notional-labs/nmisc/main/proxy_sei/nginx.conf" > $HOME/nginx.conf.template
wget "http://tasks.web_config/config/NOTIONAL_API_KEY_SEI" -O $HOME/NOTIONAL_API_KEY_SEI.txt
XAPIKEY=$(cat $HOME/NOTIONAL_API_KEY_SEI.txt)
export NOTIONAL_API_KEY="$XAPIKEY"
cat $HOME/nginx.conf.template |envsubst '$NOTIONAL_API_KEY' > /etc/nginx/nginx.conf

curl -Ls "https://raw.githubusercontent.com/notional-labs/nmisc/main/proxy_sei/generate_upstream.sh" > $HOME/generate_upstream.sh
sleep 1
source $HOME/generate_upstream.sh

# run nginx with screen to avoid log to docker
screen -S nginx -dm /usr/sbin/nginx -g "daemon off;"

########################################################################################################################
echo "Done!"

# loop forever for debugging only
while true; do sleep 60; done
