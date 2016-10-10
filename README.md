[![Code Climate](https://codeclimate.com/github/bedwarsnetwork/www.bedwars.network/badges/gpa.svg)](https://codeclimate.com/github/bedwarsnetwork/www.bedwars.network) [![Issue Count](https://codeclimate.com/github/bedwarsnetwork/www.bedwars.network/badges/issue_count.svg)](https://codeclimate.com/github/bedwarsnetwork/www.bedwars.network)

# How To Run

## Development

```sh
######################
## setEnv.sh ##
######################

export SECRET_KEY_BASE=<SECRET_KEY_BASE>
export MYSQL_DATABASE=<MYSQL_DATABASE>
export MYSQL_HOST=<MYSQL_HOST>
export MYSQL_USER=<MYSQL_USER>
export MYSQL_PASSWORD<MYSQL_PASSWORD>
export MONGODB_DATABASE=<MONGODB_DATABASE>
export MONGODB_HOST=<MONGODB_HOST>
export MONGODB_USER=<MONGODB_USER>
export MONGODB_PASSWORD=<MONGODB_PASSWORD>
```

```sh
bundle install
source setEnv.sh && rails s
```

# How To Deploy

```sh
######################
## setEnv.sh ##
######################

export DEPLOY_HOST=<DEPLOY_HOST>
export DEPLOY_USER=<DEPLOY_HOST>
export DEPLOY_PASSWORD=<DEPLOY_PASSWORD>
export DEPLOY_LISTEN_PORT_PRODUCTION=<DEPLOY_LISTEN_PORT_PRODUCTION>
export DEPLOY_LISTEN_PORT_STAGING=<DEPLOY_LISTEN_PORT_STAGING>
```

```sh
source setEnv.sh && cap (production|staging) deploy
```