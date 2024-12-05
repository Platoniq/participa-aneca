# frozen_string_literal: true
# This migration comes from decidim_centers (originally 20241204134913)

class CreateDecidimCentersRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_centers_roles do |t|
      t.references :decidim_organization, foreign_key: true, index: true
      t.jsonb :title, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
