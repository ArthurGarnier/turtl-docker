# turtl-docker
Docker file to install turtl (turtl.it) api

You must copy config.lisp.default to config.lisp ; and edit it before the build

## How to build ?

sudo docker build -t turtl_docker .

I didn't find the proper way to wait the end of turtl installation (sleep 120), maybe you have to increase this value to have enought time (depend of your server capabilities). If you have any idea, pull request is welcome !

## How to run ?

```
sudo docker run -d -p 8181:8181 -v $(pwd)/volume:/var/lib/rethinkdb/instance1 -t turtl_docker
```

## How to run behind an Apache proxy ? (safer)

First, listen only on localhost :

```
sudo docker run -d --name turtl -p 127.0.0.1:8181:8181 -v $(pwd)/volume:/var/lib/rethinkdb/instance1 -t turtl_docker
```

Secondly add your reverse proxy in Apache conf :

```
<VirtualHost *:443>
ServerName turtl.MYDOMAIN.com

SSLEngine on
SSLProtocol all -SSLv2 -SSLv3
SSLCipherSuite ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA
SSLHonorCipherOrder     on
SSLCompression          off
SSLOptions +StrictRequire
#If you're using let's encrypt
SSLCertificateFile /etc/letsencrypt/live/turtl.MYDOMAIN.com/cert.pem
SSLCertificateKeyFile /etc/letsencrypt/live/turtl.MYDOMAIN.com/privkey.pem
SSLCertificateChainFile	/etc/letsencrypt/live/turtl.MYDOMAIN.com/chain.pem


ProxyPreserveHost On
ProxyRequests off
ProxyPass / http://127.0.0.1:8181/ Keepalive=On timeout=1600
ProxyPassReverse / http://127.0.0.1:8181/

	LogLevel info

	CustomLog ${APACHE_LOG_DIR}/turtl.log combined

</VirtualHost>
```