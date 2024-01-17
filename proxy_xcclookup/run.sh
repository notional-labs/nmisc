pacman -Syu --noconfirm
pacman -S --noconfirm base-devel wget dnsutils nginx cronie screen

########################################################################################################################
# SSL (fullchain.pem and privkey.pem files)
wget "http://tasks.web_config/config/quicksilver.zone_fullchain.pem" -O /etc/nginx/fullchain.pem
wget "http://tasks.web_config/config/quicksilver.zone_privkey.pem" -O /etc/nginx/privkey.pem

########################################################################################################################
# nginx
curl -s "https://raw.githubusercontent.com/notional-labs/nmisc/main/proxy_xcclookup/nginx.conf" > /etc/nginx/nginx.conf

# run nginx with screen to avoid log to docker
screen -S nginx -dm /usr/sbin/nginx -g "daemon off;"

########################################################################################################################
echo "Done!"

# loop forever for debugging only
while true; do sleep 60; done
