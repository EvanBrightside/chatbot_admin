web: bin/rails server -p $PORT -e $RAILS_ENV
bot: bin/rake telegram:bot:poller
sidekiq: sidekiq -C config/sidekiq.yml
