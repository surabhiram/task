require 'bundler/capistrano'
# require 'new_relic/recipes'

set :application, "opac"
set :repository,  "git@github.com:surabhiram/task.git"
set :scm, :git
set :scm_username, 'akil_rails'
set :use_sudo, false
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]
delayed_job_flag = false

# set ssh password if passed through script
def deploy_password
  set :password, deploy_script_password rescue nil
end
deploy_password

def aws name
  task name do
    yield
    set :branch, "production"
    set :default_environment, { "PATH" =>
      "/rails/common/ruby-1.9.2-p290/bin:#{deploy_to}/shared/bundle/ruby/1.9.1/bin:$PATH",
      "LD_LIBRARY_PATH" => "/rails/common/oracle/instantclient_11_2",
      "TNS_ADMIN" => "/rails/common/oracle/network/admin" }
    role :app, location
    role :web, location
    role :db, location, :primary => true
    set :user, 'rails'
    ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]
  end
end

def aws_staging name
  task name do
    yield
    set :branch, "master"
    set :default_environment, { "PATH" =>
    "/rails/common/ruby-1.9.2-p290/bin:#{deploy_to}/shared/bundle/ruby/1.9.1/bin:$PATH",
    "LD_LIBRARY_PATH" => "/rails/common/oracle/instantclient_11_2",
    "TNS_ADMIN" => "/rails/common/oracle/network/admin" }
    role :app, location
    role :web, location
    role :db, location, :primary => true
    set :user, 'rails'
    ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]
  end
end

aws :ec2_production_te do
  set :application, "opac_te"
  set :deploy_to, "/rails/apps/opac_te"
  set :location, "107.21.238.175"
  delayed_job_flag = true
end

aws :ec2_production_munnudi do
  set :application, "opac_kan"
  set :deploy_to, "/rails/apps/opac_kan"
  set :location, "107.21.238.175"
  delayed_job_flag = true
end

aws :ec2_production_rainbow do
  set :application, "opac_rainbow"
  set :deploy_to, "/rails/apps/opac_rainbow"
  set :location, "107.21.238.175"
  delayed_job_flag = true
end

aws :ec2_production do
  set :application, "opac"
  set :deploy_to, "/rails/apps/opac"
  set :location, "107.21.238.175"
end

aws :ec2_web do
  set :application, "opac"
  set :deploy_to, "/rails/apps/opac"
  set :location, "23.21.137.238"
  delayed_job_flag = true
end

aws_staging :ec2_staging_procure do
  set :branch, "procurement_confirmation"
  set :application, "opac"
  set :deploy_to, "/rails/apps/procurement_confirmation"
  set :location, "staging.justbooksclc.com"
  delayed_job_flag = true
end

aws_staging :ec2_staging do
  set :bundle_without, [:newrelic, :development, :test]
  set :application, "task"
  set :deploy_to, "/rails/apps/task"
  set :location, "107.23.108.186"
  delayed_job_flag = true

end


# after "deploy:create_symlink", "deploy:update_crontab"
# after "deploy:create_symlink", "deploy:delayed_job_restart"
# after "deploy:update", "newrelic:notice_deployment"

namespace :deploy do
  after "deploy:update_code" do
    run "cp #{deploy_to}/database.yml #{release_path}/config/database.yml"
    run "cp #{deploy_to}/opac.yml #{release_path}/config/opac.yml"
    run "cp #{deploy_to}/member_cross_ref.yml #{release_path}/config/member_cross_ref.yml"
    run "cp #{deploy_to}/setup_mail.rb #{release_path}/config/initializers/setup_mail.rb"
    run "cp #{deploy_to}/sunspot.yml #{release_path}/config/sunspot.yml"
    run "cp #{deploy_to}/data-config.xml #{release_path}/config/data-config.xml"
    run "cp #{deploy_to}/omniauth.rb #{release_path}/config/initializers/omniauth.rb"
    # run "cp #{deploy_to}/newrelic.yml #{release_path}/config/newrelic.yml"
    run "cp #{deploy_to}/schedule.rb #{release_path}/config/schedule.rb"
    run "cp #{deploy_to}/security.yml #{release_path}/config/security.yml"
    run "cp #{deploy_to}/ams_settings.yml #{release_path}/config/ams_settings.yml"
    run "cp #{deploy_to}/amazon_ses.rb #{release_path}/config/initializers/amazon_ses.rb"
  end

  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && bundle exec whenever --update-crontab #{application}"
  end

  desc "Restart the delayed_job process"
  task :delayed_job_restart, :roles => :app do
    if delayed_job_flag
      run "cd #{current_path} && RAILS_ENV=production script/delayed_job restart"
    end
  end

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

