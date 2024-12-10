# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# You can remove the 'faker' gem if you don't want Decidim seeds.
Decidim.seed!

centers = JSON.parse(File.read(Rails.root.join("examples/centers.json")))
roles = JSON.parse(File.read(Rails.root.join("examples/roles.json")))
scopes = JSON.parse(File.read(Rails.root.join("examples/scopes.json")))
organization = Decidim::Organization.first

centers.each do |center_name|
  # rubocop:disable Rails/IndexWith
  Decidim::Centers::Center.create(title: Decidim.available_locales.to_h { |locale| [locale, center_name] }, organization: organization)
end

roles.each do |role_name|
  Decidim::Centers::Role.create(title: Decidim.available_locales.to_h { |locale| [locale, role_name] }, organization: organization)
end

Decidim::Scope.delete_all
scopes.pluck("children").flatten.each do |scope|
  Decidim::Scope.create(name: Decidim.available_locales.to_h { |locale| [locale, "#{scope["code"]}. #{scope["name"]}"] }, code: scope["code"], organization: organization)
  # rubocop:enable Rails/IndexWith
end
