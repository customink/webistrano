require "bundler/capistrano"

set :application, "webistrano"
set :repository,  "git@github.com:customink/webistrano.git"
set :branch, "deployable"

set :scm, :git

set :deploy_to, "/opt/#{application}"

set :rails_env, "production"

set :user, 'apache'
set :use_sudo, false

role :web, "deploy.dc.customink.com"
role :app, "deploy.dc.customink.com"
role :db, "deploy.dc.customink.com", {:primary => true}

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

desc "links the webistrano_config and database.yml files from the shared directory"
task :link_config_files, :roles => [:app] do
  %w(database.yml webistrano_config.rb).each do |f|
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/#{f} #{release_path}/config/#{f}"
  end
end

after "deploy:update_code", "link_config_files"
after "deploy:update_code", "deploy:migrate", :roles => :db
after "deploy:restart", "deploy:cleanup"