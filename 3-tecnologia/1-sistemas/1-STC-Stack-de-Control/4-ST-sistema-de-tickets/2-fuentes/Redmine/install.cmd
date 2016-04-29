call bundle install --without development test rmagick

call bundle exec rake redmine:plugins RAILS_ENV=production

call thin start -e production -p 3000