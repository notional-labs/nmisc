cd $HOME

pacman -Syu --noconfirm
pacman -S --noconfirm base-devel jq dnsutils python haproxy screen wget cronie

########################################################################################################################
# haproxy
curl -Ls "https://raw.githubusercontent.com/notional-labs/nmisc/main/xcc/lb/haproxy.cfg" > /etc/haproxy/haproxy.cfg

# start
haproxy -D -f /etc/haproxy/haproxy.cfg -sf $(cat /var/run/haproxy.pid)

########################################################################################################################
echo "Done!"
# loop forever for debugging only
while true; do sleep 5; done

