FROM ubuntu:16.04

ENV CCL_VERSION 1.11
ENV DEBIAN_FRONTEND noninteractive

ADD https://download.rethinkdb.com/apt/pubkey.gpg /tmp/rethinkdb-pubkey.gpg

RUN echo "deb http://download.rethinkdb.com/apt xenial main" | tee /etc/apt/sources.list.d/rethinkdb.list && \
	apt-key add - < /tmp/rethinkdb-pubkey.gpg && \
	apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y wget libterm-readline-perl-perl gcc libuv1-dev git libssl-dev \
						rethinkdb dos2unix && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

RUN ln -sf /lib/x86_64-linux-gnu/libcrypto.so.1.0.0  /lib/x86_64-linux-gnu/libcrypto.so.1.1

# Install ccl
RUN wget -P /opt/ ftp://ftp.clozure.com/pub/release/${CCL_VERSION}/ccl-${CCL_VERSION}-linuxx86.tar.gz && \
	mkdir -p /opt/ccl && \
	tar xvzf /opt/ccl-${CCL_VERSION}-linuxx86.tar.gz -C /opt/ccl --strip-components=1

# install quicklisp
COPY quicklisp_install /quicklisp_install
RUN wget https://beta.quicklisp.org/quicklisp.lisp
RUN cat /quicklisp_install | /opt/ccl/lx86cl64 --load /quicklisp.lisp

# install turtl API
RUN cd /opt/ && \
	git clone https://github.com/turtl/api.git --depth 1
RUN cd /root/quicklisp/local-projects && \
	git clone git://github.com/orthecreedence/cl-hash-util
RUN /opt/ccl/lx86cl64 -l /root/quicklisp/setup.lisp

# config
COPY config.footer /opt/api/config/
COPY turtl-setup /opt/
COPY turtl-start /opt/
COPY launch.lisp /opt/api/
COPY rethinkdb.conf /etc/rethinkdb/instances.d/instance1.conf

RUN chmod a+x \
	/opt/turtl-setup \
	/opt/turtl-start

RUN dos2unix \
	/opt/turtl-setup \
	/opt/turtl-start \
	/opt/api/config/config.footer \
	/opt/api/launch.lisp \
	/etc/rethinkdb/instances.d/instance1.conf

# general settings
EXPOSE 8181
WORKDIR /opt/api
VOLUME /var/lib/rethinkdb/instance1
CMD /opt/turtl-setup
