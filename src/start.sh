#!/bin/bash

#Obtain a secret
curl -s https://core.telegram.org/getProxySecret -o /config/proxy-secret

#Obtain the most recent config
curl -s https://core.telegram.org/getProxyConfig -o /config/proxy-multi.conf

#Generate the secret that will be used by users to connect to your proxy
if [ ! -f /data/secret ]; then
  head -c 16 /dev/urandom | xxd -ps > /data/secret
fi


#Run your instance
if [[ -z "${TAG}" ]]; then
  echo "Started"
  mtproto-proxy -u nobody -p 8888 -H 443 -S $(cat /data/secret) -D ${DOMAIN} --http-stats --aes-pwd /config/proxy-secret /config/proxy-multi.conf
else
  echo "Started with statistic publishing"
  mtproto-proxy -u nobody -p 8888 -H 443 -S $(cat /data/secret) -D ${DOMAIN} -P ${TAG} --http-stats --aes-pwd /config/proxy-secret /config/proxy-multi.conf
fi


