[![Code Climate](https://codeclimate.com/github/bedwarsnetwork/www.bedwars.network/badges/gpa.svg)](https://codeclimate.com/github/bedwarsnetwork/www.bedwars.network) [![Issue Count](https://codeclimate.com/github/bedwarsnetwork/www.bedwars.network/badges/issue_count.svg)](https://codeclimate.com/github/bedwarsnetwork/www.bedwars.network)

# How To Run

## Development
Add a file called `env.list` to the cloned repository.
```sh
###############
## setEnv.sh ##
###############

export SECRET_KEY_BASE=<SECRET_KEY_BASE>
export MYSQL_DATABASE=<MYSQL_DATABASE>
export MYSQL_HOST=<MYSQL_HOST>
export MYSQL_USER=<MYSQL_USER>
export MYSQL_PASSWORD<MYSQL_PASSWORD>
export MONGODB_DATABASE=<MONGODB_DATABASE>
export MONGODB_HOST=<MONGODB_HOST>
export MONGODB_USER=<MONGODB_USER>
export MONGODB_PASSWORD=<MONGODB_PASSWORD>
export PIWIK_URL=<PIWIK_URL>
export PIWIK_ID=<PIWIK_ID>
export GOOGLE_API_KEY=<GOOGLE_API_KEY>
```
Then run the following commands:
```sh
bundle install
source setEnv.sh && rails s
```

# How To Deploy
On your server in directory `/var/www/www.bedwars.network/(production|staging)/` add a file called `env.list`.
```sh
##############
## env.list ##
##############
RAILS_ENV=<RAILS_ENV>
SECRET_KEY_BASE=<SECRET_KEY_BASE>
MYSQL_DATABASE=<MYSQL_DATABASE>
MYSQL_HOST=<MYSQL_HOST>
MYSQL_USER=<MYSQL_USER>
MYSQL_PASSWORD<MYSQL_PASSWORD>
MONGODB_DATABASE=<MONGODB_DATABASE>
MONGODB_HOST=<MONGODB_HOST>
MONGODB_USER=<MONGODB_USER>
MONGODB_PASSWORD=<MONGODB_PASSWORD>
PIWIK_URL=<PIWIK_URL>
PIWIK_ID=<PIWIK_ID>
GOOGLE_API_KEY=<GOOGLE_API_KEY>
```
Add the following to your local `setEnv.sh`
```sh
###############
## setEnv.sh ##
###############

export DEPLOY_HOST=<DEPLOY_HOST>
export DEPLOY_USER=<DEPLOY_HOST>
export DEPLOY_PASSWORD=<DEPLOY_PASSWORD>
export DEPLOY_LISTEN_PORT_PRODUCTION=<DEPLOY_LISTEN_PORT_PRODUCTION>
export DEPLOY_LISTEN_PORT_STAGING=<DEPLOY_LISTEN_PORT_STAGING>
```
Then run the following commands:
```sh
source setEnv.sh && cap (production|staging) deploy
```
