# turtl-docker
Docker file to install turtl (turtl.it) api

You must copy config.lisp.default to config.lisp ; and edit it before the build

## How to build ?

sudo docker build -t turtl_docker .

I didn't find the proper way to wait the end of turtl installation (sleep 120), maybe you have to increase this value to have enought time (depend of your server capabilities). If you have any idea, pull request is welcome !

## How to run ?

sudo docker run -d -p 8181:8181 -v $(pwd)/volume:/var/lib/rethinkdb/instance1 -t turtl_docker