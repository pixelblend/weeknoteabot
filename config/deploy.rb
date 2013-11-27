require 'mina/bundler'
require 'mina/git'

# Basic settings:
# domain     - The hostname to SSH to
# deploy_to  - Path to deploy into
# repository - Git repo to clone from (needed by mina/git)
# user       - Username in the  server to SSH to (optional)

set :user, ENV['DEPLOY_USER']
set :domain, ENV['DEPLOY_DOMAIN']
set :deploy_to, ENV['DEPLOY_PATH']
set :repository, 'https://github.com/pixelblend/weeknoteabot.git'
set :commit, ENV['GIT_COMMIT'] if ENV['GIT_COMMIT']
set :shared_paths, ['config/mail.yml', 'db']

desc "Deploys the current version to the server."
task :deploy do
  deploy do
    invoke 'git:clone'
    invoke 'deploy:link_shared_paths'
    invoke 'bundle:install'

    to :launch do
      invoke :foreman
      invoke :start_or_restart
    end
  end
end

task :foreman do
  queue "sudo foreman export --app weeknoteabot upstart /etc/init"
end

task :stop do
  queue "sudo stop weeknoteabot"
end

task :start do
  queue "sudo start weeknoteabot"
end

task :restart do
  queue "sudo restart weeknoteabot"
end

task :start_or_restart do
  queue "sudo restart weeknoteabot || sudo start weeknoteabot"
end

task :logs do
  queue 'echo "Contents of the log file are as follows:"'
  queue "tail -F /var/log/syslog"
end

