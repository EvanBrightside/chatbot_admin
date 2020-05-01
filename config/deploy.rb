set :application, 'chatbot_template'
set :repo_url, 'git@github.com:EvanBrightside/chatbot_template.git'

set :config_files, %w[config/database.yml .env]
append :linked_files, 'config/database.yml', 'config/secrets.yml', '.env'
append :linked_dirs,  'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets',
       'vendor/bundle', 'public/system', 'public/uploads', 'storage'

set :rvm_ruby_version, Pathname(__dir__).join('../.ruby-version').read.chomp
append :rvm_map_bins, 'puma', 'pumactl'#, 'sidekiq', 'sidekiqctl'

set :db_local_clean, true
set :assets_dir, %w[public/system storage]
set :local_assets_dir, %w(public/assets storage)

set :nginx_server_name, -> { "#{fetch(:domain)} localhost #{fetch(:application)}.local" }
set :nginx_upstream_name, -> { "#{fetch(:application)}_#{fetch(:stage)}" }
set :nginx_config_name, -> { "#{fetch(:domain)}.conf" }
set :nginx_use_ssl, true

set :sidekiq_config, 'config/sidekiq.yml'

# after 'deploy:publishing', 'deploy:restart' # if TG will be disconnected
after 'deploy:publishing', 'deploy:restart', 'bot:restart'

namespace :deploy do
  after :publishing, :restart
  after :restart, 'systemd:puma:reload-or-restart'
  after :restart, 'systemd:sidekiq:restart'

  services = %i[puma sidekiq]
  namespace :setup do
    task systemd: services.map { |service| "systemd:#{service}:setup" }
  end

  task setup: %i[setup:systemd]
end

namespace :telegram do
  namespace :bot do
    namespace :poller do
      {
        start:         'start an instance of the application',
        stop:          'stop all instances of the application',
        restart:       'stop all instances and restart them afterwards',
        reload:        'send a SIGHUP to all instances of the application',
        # run:           'start the application and stay on top',
        zap:           'set the application to a stopped state',
        status:        'show status (PID) of application instances',
      }.each do |action, description|
        desc description
        task action do
          on roles(:app) do
            within current_path do
              with rails_env: fetch(:rails_env) do
                execute :bundle, :exec, 'bin/telegram_bot_ctl', action
              end
            end
          end
        end
      end
    end
  end
end

after 'deploy:finished', 'telegram:bot:poller:restart'
