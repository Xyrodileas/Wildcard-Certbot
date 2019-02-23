# Get the certificate
sudo certbot -d *.mochi.network --manual --preferred-challenges dns certonly --non-interactive --agree-tos --manual-public-ip-logging-ok --manual-auth-hook '/opt/certbot-dns-hook.sh auth' --manual-cleanup-hook '/opt/certbot-dns-hook.sh cleanup'
# Copy the certificate and key
cp /etc/letsencrypt/live/mochi.network/privkey.pem /home/xyro/MediaCluster_Perso/nginx/certs/mochi.network.key
cp /etc/letsencrypt/live/mochi.network/fullchain.pem /home/xyro/MediaCluster_Perso/nginx/certs/mochi.network.crt
# Chown it for the user
chown xyro /home/xyro/MediaCluster_Perso/nginx/certs/*