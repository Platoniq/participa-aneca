# frozen_string_literal: true

every "30 1 * * *" do
  rake "decidim:metrics:all"
end

every "3 3 * * *" do
  rake "decidim:delete_data_portability_files"
  rake "decidim:open_data:export"
end
