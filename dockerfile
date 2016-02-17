FROM ubuntu:15.10


RUN apt-get update && apt-get install -y wget libterm-readline-perl-perl

#Install ccl

RUN wget -P /opt/ ftp://ftp.clozure.com/pub/release/1.11/ccl-1.11-linuxx86.tar.gz && mkdir -p /opt/ccl && tar xvzf /opt/ccl-1.11-linuxx86.tar.gz -C /opt/ccl --strip-components=1

RUN ls /opt/ccl

#install quicklisp
COPY quicklisp_install /quicklisp_install
RUN wget https://beta.quicklisp.org/quicklisp.lisp
RUN cat /quicklisp_install | /opt/ccl/lx86cl64 --load /quicklisp.lisp

#RethinkDB

RUN echo "deb http://download.rethinkdb.com/apt wily main" | tee /etc/apt/sources.list.d/rethinkdb.list && wget -qO- https://download.rethinkdb.com/apt/pubkey.gpg | apt-key add - && apt-get update && apt-get install rethinkdb -y

RUN apt-get install libuv-dev -y

RUN apt-get install git -y

RUN cd /opt/ && git clone https://github.com/turtl/api.git

COPY config.lisp /opt/api/config/

RUN cd /opt/api && echo '(load "start")' | /opt/ccl/lx86cl64 -l /root/quicklisp/setup.lisp


