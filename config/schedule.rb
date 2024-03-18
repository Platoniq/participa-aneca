# frozen_string_literal: true

set :output, "log/cron.log"

every "30 1 * * *" do
  rake "decidim:metrics:all"
end

every "3 3 * * *" do
  rake "decidim:delete_download_your_data_files"
  rake "decidim:open_data:export"
end
