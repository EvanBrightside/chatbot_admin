server 'chatbot_template.staging', user: 'app', roles: %w(web app db)

set :domain, "chatbot_template.molinos.dev"
set :keep_releases, 5
set :rails_env, :staging
set :branch, :develop
set :user, :app
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:rails_env)}"

set :nginx_ssl_certificate, "/ssl/molinos.dev/fullchain.pem"
set :nginx_ssl_certificate_key, "/ssl/molinos.dev/privkey.pem"
set :nginx_ssl_dhparam, "/ssl/config/dhparams.pem"

# CentOS
set :nginx_sites_available_path, "#{fetch(:deploy_to)}/shared"
set :nginx_sites_enabled_path, '/etc/nginx/conf.d'

# Ubuntu
# set :nginx_sites_available_path, "/etc/nginx/sites-available"
# set :nginx_sites_enabled_path, "/etc/nginx/sites-enabled"
