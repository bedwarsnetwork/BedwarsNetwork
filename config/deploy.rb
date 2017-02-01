# config valid only for current version of Capistrano
lock '3.7.2'

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

namespace :deploy do
  after :updated, :build
  task :build do
    on roles(:app) do
      #build the actual docker image, tagging the push for the remote repo
      execute "cd #{fetch(:release_path)} && docker build -t #{fetch(:application)} ."
    end
  end
  after :build, :stop
  task :stop do
    on roles(:app) do
      # in case the app isn't running on the other end
      execute "docker stop #{fetch(:application)};true"
    end
  end
  after :stop, :remove
  task :remove do
    on roles(:app) do
      # have to remove it otherwise --restart=always will run it again on reboot!
      execute "docker rm #{fetch(:application)};true"
    end
  end
end