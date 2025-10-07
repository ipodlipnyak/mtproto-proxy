#!/bin/sh

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
  mtproto-proxy -u nobody -p 8888 -H 443 -S $(cat /data/secret) -P ${TAG} --aes-pwd proxy-secret proxy-multi.conf -M 1
else
  mtproto-proxy -u nobody -p 8888 -H 443 -S $(cat /data/secret) --aes-pwd proxy-secret proxy-multi.conf -M 1
fi


