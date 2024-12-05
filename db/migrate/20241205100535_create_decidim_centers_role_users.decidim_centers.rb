# frozen_string_literal: true
# This migration comes from decidim_centers (originally 20241204135138)

class CreateDecidimCentersRoleUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_centers_role_users do |t|
      t.references :decidim_centers_role, foreign_key: true, index: { name: "index_decidim_role_users_on_decidim_role_id" }
      t.references :decidim_user, foreign_key: true, index: { name: "index_decidim_role_users_on_decidim_user_id" }

      t.timestamps
    end
  end
end
