# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/www.bedwars.network/production/'

namespace :deploy do
  after :remove, :start
  task :start do
    on roles(:app) do      
      # modify this to suit how you want to run your app
      execute "docker run -d -p #{ENV['DEPLOY_LISTEN_PORT_PRODUCTION']}:80 --restart=always --name=#{fetch(:application)} --env-file #{fetch(:deploy_to)}env.list #{fetch(:application)}"
    end
  end
end