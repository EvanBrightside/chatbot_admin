# Chatbot template

## Setup
* git clone `git@github.com:EvanBrightside/chatbot_template.git`
* bundle install
* cp config/database.yml.example config/database.yml
* rails db:setup
* rails db:migrate
* rails db:seed
* yarn
* rails s

## Tech
* Ruby on Rails 6.0.2
* Ruby 2.6.5
* PostgreSQL 12.2
* Redis 5.0.7

## Usage
* start web - bundle exec rails s
* start bot - bin/rake telegram:bot:poller
* admin panel - localhost:3000

## Deployment
For painless deployment, you should configure several sudo commands for specified deploy user
to be executed without asking for password via `sudo visudo` command,
as described in https://capistranorb.com/documentation/getting-started/authentication-and-authorisation/#authorisation

Full list of sudo command could be obtained by running commands mentioned below with `--dry-run` option
(e. g. `bin/cap --dry-run {stage_name} deploy:setup`

1. Set up new deployment in `config/stages/{stage_name}.rb` file
1. Set up new deployment (upload configurations):

    `bin/cap {stage_name} deploy:setup`

1. Deploy new version to `{stage_name}`:

    `bin/cap {stage_name} deploy`

2. On new deployment (or when systemd templates updated), update & enable systemd services for Puma & Sidekiq:

    `bin/cap {stage_name} deploy:setup_systemd`
