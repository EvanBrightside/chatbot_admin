# Chatbot template

## Setup

* git clone `git@github.com:EvanBrightside/chatbot_admin.git`
* bundle install
* yarn
* cp config/database.yml.example config/database.yml
* rails db:setup
* rails db:migrate
* rails s

## Tech

* Ruby on Rails 6.1.3
* Ruby 3.0.1
* PostgreSQL 12.2
* Redis 5.0.7

## Usage

* start web - bundle exec rails s
* start bot - bin/rake telegram:bot:poller
* admin panel - localhost:3000
