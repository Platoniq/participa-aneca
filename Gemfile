# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = "0.27.4"

gem "decidim", DECIDIM_VERSION
# gem "decidim-conferences", DECIDIM_VERSION
# gem "decidim-consultations", DECIDIM_VERSION
# gem "decidim-elections", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
# gem "decidim-templates", DECIDIM_VERSION

gem "decidim-centers", "~> 0.2.1"
gem "decidim-decidim_awesome", "~> 0.10.0"
gem "decidim-extra_user_fields", git: "https://github.com/Platoniq/decidim-module-extra_user_fields"
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer"

gem "bootsnap", "~> 1.3"

gem "puma", ">= 5.0.0"

gem "faker", "~> 2.14"

gem "wicked_pdf", "~> 2.1"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "brakeman"
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "rubocop", require: false
  gem "rubocop-faker", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 4.2"

  gem "capistrano", "~> 3.17"
  gem "capistrano-bundler"
  gem "capistrano-passenger"
  gem "capistrano-rails"
  gem "capistrano-rails-console"
  gem "capistrano-rbenv"
  gem "capistrano-sidekiq"
end

group :production do
  gem "figaro", "~> 1.2"
  gem "sidekiq", "~> 6.0"
  gem "whenever", require: false

  gem "sentry-rails"
  gem "sentry-ruby"
  gem "sentry-sidekiq"
end

group :test do
  gem "coveralls_reborn", require: false
  gem "database_cleaner"
end
