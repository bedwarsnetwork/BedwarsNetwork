FROM phusion/passenger-ruby23:0.9.19

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

RUN bash -lc 'rvm --default use ruby-2.3.1'

RUN rm -f /etc/service/nginx/down

RUN rm /etc/nginx/sites-enabled/default
ADD docker/webapp.conf /etc/nginx/sites-enabled/webapp.conf

ADD docker/environment.conf /etc/nginx/main.d/environment.conf
RUN mkdir /home/app/webapp
COPY . /home/app/webapp
RUN ["chown", "-R", "app:users", "/home/app/webapp"]

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER app
RUN bash -lc 'rvm --default use ruby-2.3.1'
WORKDIR /home/app/webapp

RUN ["gem", "install", "bundler"]

ENV SECRET_KEY_BASE 687c705fe313cfdcc185b5a0d858666328892ee0eb8e5fb9a090a0bb4f5c64b5fc5bb6c8f8ac2778277e13ac8829ba4995f363a77ca6ab8cbf17249c1e955fa2
RUN ["bundle", "install"]
RUN ["rake", "assets:precompile"]

USER root