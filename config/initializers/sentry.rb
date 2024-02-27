# frozen_string_literal: true

if Rails.application.secrets.sentry_enabled
  Sentry.init do |config|
    config.dsn = ENV.fetch("SENTRY_DSN")
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    config.traces_sample_rate = ENV.fetch("SENTRY_TRACES_SAMPLE_RATE", "0.5").to_f
  end
end
