#!/bin/sh

# Script to deploy a Let's Encrypt DNS challenge using nsupdate
#
# Idea and some code stolen from
# https://www.crc.id.au/using-centralised-management-with-lets-encrypt/

set -e

# Sanity check: environment variables $CERTBOT_DOMAIN and $CERTBOT_VALIDATION
# need to be set. They're set by certbot when using method 'manual'.
if [ -z ${CERTBOT_DOMAIN} ]; then
    echo "Error: variable \$CERTBOT_DOMAIN is unset" >&2
    exit 1
fi
if [ -z ${CERTBOT_VALIDATION} ]; then
    echo "Error: variable \$CERTBOT_VALIDATION is unset" >&2
    exit 1
fi


# Key for the dynamic DNS updates
DDNS_KEY='/home/xyro/dns/Kmochi.network.+157+30706.key'

# Nameserver with the dynamic zone
SERVER="dns2.mochi.network"

# Name of the dynamic zone
ZONE="mochi.network"

# Time to live for the TXT records
TTL=300

case "$1" in
    "auth")
        nsupdate -k "$DDNS_KEY" <<-EOF
                server ${SERVER}
                debug yes
                zone ${ZONE}
                update add _acme-challenge.${CERTBOT_DOMAIN} ${TTL} IN TXT "${CERTBOT_VALIDATION}"
                send
EOF
        sleep 20
        ;;
    "cleanup")
        nsupdate -k "$DDNS_KEY" <<-EOF
                server ${SERVER}
                zone ${ZONE}
                update delete _acme-challenge.${CERTBOT_DOMAIN} ${TTL} IN TXT "${CERTBOT_VALIDATION}"
                send
EOF
        ;;
    *)
        echo "Usage: $0 [auth|cleanup]" >&2
        exit 1
        ;;
esac

exit 0
