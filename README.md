[![Code Climate](https://codeclimate.com/github/sebastianbinder/BedwarsNetwork/badges/gpa.svg)](https://codeclimate.com/github/sebastianbinder/BedwarsNetwork) [![Issue Count](https://codeclimate.com/github/sebastianbinder/BedwarsNetwork/badges/issue_count.svg)](https://codeclimate.com/github/sebastianbinder/BedwarsNetwork)

# How To Run

## Development

```sh
######################
## setEnv.sh ##
######################

export SECRET_KEY_BASE=<SECRET_KEY_BASE>;
export MYSQL_DATABASE=<MYSQL_DATABASE>;
export MYSQL_HOST=<MYSQL_HOST>;
export MYSQL_USER=<MYSQL_USER>;
export MYSQL_PASSWORD<MYSQL_PASSWORD>;
export MONGODB_DATABASE=<MONGODB_DATABASE>;
export MONGODB_HOST=<MONGODB_HOST>;
export MONGODB_USER=<MONGODB_USER>;
export MONGODB_PASSWORD=<MONGODB_PASSWORD>;
```

```sh
bundle install
source setEnv.sh && rails s
```

## Production
```sh
################
## Dockerfile ##
################

FROM phusion/passenger-ruby23:0.9.19

ENV HOME /root

CMD ["/sbin/my_init"]

RUN bash -lc 'rvm --default use ruby-2.3.1'

RUN rm -f /etc/service/nginx/down

RUN rm /etc/nginx/sites-enabled/default
ADD webapp.conf /etc/nginx/sites-enabled/webapp.conf

ADD environment.conf /etc/nginx/main.d/secret_key.conf
RUN mkdir /home/app/webapp
COPY . /home/app/webapp
RUN ["chown", "-R", "app:users", "/home/app/webapp"]

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER app
RUN bash -lc 'rvm --default use ruby-2.3.1'
WORKDIR /home/app/webapp
ENV RAILS_ENV production
ENV SECRET_KEY_BASE <SECRET_KEY_BASE>
RUN ["bundle", "install"]
RUN ["rake", "assets:precompile"]

USER root
```


```sh
######################
## environment.conf ##
######################

env RAILS_ENV=production;
env SECRET_KEY_BASE=<SECRET_KEY_BASE>;
env MYSQL_DATABASE=<MYSQL_DATABASE>;
env MYSQL_HOST=<MYSQL_HOST>;
env MYSQL_USER=<MYSQL_USER>;
env MYSQL_PASSWORD<MYSQL_PASSWORD>;
env MONGODB_DATABASE=<MONGODB_DATABASE>;
env MONGODB_HOST=<MONGODB_HOST>;
env MONGODB_USER=<MONGODB_USER>;
env MONGODB_PASSWORD=<MONGODB_PASSWORD>;
```


```sh
#################
## webapp.conf ##
#################

server {
    listen 80;
    server_name www.webapp.com;
    root /home/app/webapp/public;

    passenger_enabled on;
    passenger_user app;

    # If this is a Ruby app, specify a Ruby version:
    passenger_ruby /usr/bin/ruby2.3;
}
```

```sh
docker build -t www.bedwars.network .
docker stop www.bedwars.network
docker rm www.bedwars.network
docker run --name www.bedwars.network -p <PORT>:80 -d www.bedwars.network
```