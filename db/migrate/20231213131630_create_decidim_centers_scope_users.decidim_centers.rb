# frozen_string_literal: true
# This migration comes from decidim_centers (originally 20231205153627)

class CreateDecidimCentersScopeUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_centers_scope_users do |t|
      t.references :decidim_scope, foreign_key: true, index: { name: "index_decidim_scope_users_on_decidim_scope_id" }
      t.references :decidim_user, foreign_key: true, index: { name: "index_decidim_scope_users_on_decidim_user_id" }

      t.timestamps
    end
  end
end
