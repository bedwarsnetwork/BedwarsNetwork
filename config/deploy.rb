# config valid only for current version of Capistrano
lock '3.8.0'

set :application, 'www.bedwars.network'
set :repo_url, 'git@github.com:bedwarsnetwork/www.bedwars.network.git'

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
  server ENV["DEPLOY_HOST"],
  user: ENV["DEPLOY_USER"],
  roles: %w{web app},
  ssh_options: {
    user: ENV["DEPLOY_USER"],
    password: ENV["DEPLOY_PASSWORD"]
  }
   
desc 'deploy'
task :deploy do
  on roles(:app) do
    Rake::Task['deploy:build'].invoke
  end
end


set :name, "www.bedwars.network"

namespace :deploy do
  after :updated, :build
  task :build do
    on roles(:app) do
      execute "cd #{fetch(:release_path)} && echo 'NAME=#{fetch(:name)}-#{fetch(:rails_env)}' > .env"
      execute "cd #{fetch(:release_path)} && echo 'EXTERNAL_PORT=#{fetch(:external_port)}' >> .env"
      execute "cd #{fetch(:release_path)} && docker-compose build"
    end
  end
  after :build, :stop
  task :stop do
    on roles(:app) do
      # in case the app isn't running on the other end
      execute "cd #{fetch(:release_path)} && docker stop #{fetch(:name)}-#{fetch(:rails_env)};true"
      execute "cd #{fetch(:release_path)} && docker rm #{fetch(:name)}-#{fetch(:rails_env)};true"
    end
  end
  after :stop, :start
  task :start do
    on roles(:app) do
      # in case the app isn't running on the other end
      execute "cd #{fetch(:release_path)} && docker-compose up -d"
    end
  end
end