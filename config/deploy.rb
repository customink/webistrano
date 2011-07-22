require "bundler/capistrano"

set :application, "webistrano"
set :repository,  "git@github.com:customink/webistrano.git"
set :branch, "deployable"

set :scm, :git

set :deploy_to, "/opt/#{application}"

set :rails_env, "production"

set :user, 'apache'
set :use_sudo, false

role :web, "deploy.dc.customink.com"                          # Your HTTP server, Apache/etc
role :app, "deploy.dc.customink.com"                          # This may be the same as your `Web` server
role :db,  "deploy.dc.customink.com", :primary => true # This is where Rails migrations will run

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after "deploy:restart", "deploy:cleanup"