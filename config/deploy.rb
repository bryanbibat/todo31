require "bundler/capistrano"
load "deploy/assets"

set :application, "todo31"
set :repository,  "git://github.com/bryanbibat/todo31.git"
set :deploy_to, "/home/bry/capistrano/todo31"

set :scm, :git

default_run_options[:pty] = true

server "bryanbibat.net", :app, :web, :db, :primary => true
set :user, "bry"
depend :remote, :gem, "bundler"
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

task :copy_production_database_configuration do
  run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

task :copy_credentials do
  run "cp #{shared_path}/config/initializers/auth.rb #{release_path}/config/initializers/auth.rb"
end

after "deploy:update_code", :copy_production_database_configuration, :copy_credentials
after "deploy:symlink", :create_symlink_to_log 

task :create_symlink_to_log do
  run "cd #{current_path}; rm -rf log; ln -s #{shared_path}/log log"
end
