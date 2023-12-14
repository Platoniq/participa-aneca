# frozen_string_literal: true
# This migration comes from decidim_centers (originally 20231130125631)

class CreateDecidimCentersCenterUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_centers_center_users do |t|
      t.references :decidim_centers_center, foreign_key: true, index: { name: "index_decidim_center_users_on_decidim_center_id" }
      t.references :decidim_user, foreign_key: true, index: { name: "index_decidim_center_users_on_decidim_user_id" }

      t.timestamps
    end
  end
end
