# turtl-docker

Docker file to run turtl (turtl.it) api server

## How to build ?

```
sudo docker build -t turtl_docker .
```


## How to run ?

```
sudo docker run -d -p 8181:8181 -v $(pwd)/volume:/var/lib/rethinkdb/instance1 -t turtl_docker
```
## Configuration

The image supports the following environment variables that will be injected in the configuration at each restart of the container :

- PIDFILE: defaults to 'nil'
- BINDADDR: defaults to '0.0.0.0'
- BINDPORT: defaults to '8181'
- PROD_ERR_HANDLING: defaults to 't'
- FQDN: defaults to 'turtl.local'
- SITE_URL: defaults to 'http://turtl.local'
- ADMIN_EMAIL: defaults to 'root@example.com'
- EMAIL_FROM: defaults to 'noreply@example.com'
- SMTP_USER: defaults to empty
- SMTP_PASS: defaults to empty
- DISPLAY_ERRORS: defaults to 't'
- DEFAULT_STORAGE_LIMIT: defaults to 100
- STORAGE_INVITE_CREDIT: defaults to 25
- LOCAL_UPLOAD_URL: defaults to http://turtl.local
- LOCAL_UPLOAD_PATH: defaults to "/opt/api/uploads"
- AWS_S3_TOKEN: defaults to "(:token ''
                              :secret ''
                              :bucket ''
                              :endpoint 'https://s3.amazonaws.com')"

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
