FROM ubuntu:16.04

RUN apt-get update && apt-get install -y wget libterm-readline-perl-perl gcc libuv1-dev git nano

# Install ccl
RUN wget -P /opt/ ftp://ftp.clozure.com/pub/release/1.11/ccl-1.11-linuxx86.tar.gz && mkdir -p /opt/ccl && tar xvzf /opt/ccl-1.11-linuxx86.tar.gz -C /opt/ccl --strip-components=1

# install quicklisp
COPY quicklisp_install /quicklisp_install
RUN wget https://beta.quicklisp.org/quicklisp.lisp
RUN cat /quicklisp_install | /opt/ccl/lx86cl64 --load /quicklisp.lisp

# install RethinkDB
RUN echo "deb http://download.rethinkdb.com/apt xenial main" | tee /etc/apt/sources.list.d/rethinkdb.list && wget -qO- https://download.rethinkdb.com/apt/pubkey.gpg | apt-key add - && apt-get update && apt-get install rethinkdb -y

# install turtl API
RUN cd /opt/ && git clone https://github.com/turtl/api.git --depth 1
RUN cd /root/quicklisp/local-projects && git clone git://github.com/orthecreedence/cl-hash-util
RUN /opt/ccl/lx86cl64 -l /root/quicklisp/setup.lisp

# config
COPY config.footer /opt/api/config/
COPY turtl-setup /opt/
COPY turtl-start /opt/
RUN chmod a+x /opt/turtl-setup
RUN chmod a+x /opt/turtl-start
COPY launch.lisp /opt/api/
COPY rethinkdb.conf /etc/rethinkdb/instances.d/instance1.conf

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# general settings
EXPOSE 8181
WORKDIR /opt/api
VOLUME /var/lib/rethinkdb/instance1
CMD /opt/turtl-setup
