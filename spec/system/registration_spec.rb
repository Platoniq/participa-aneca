# frozen_string_literal: true

require "rails_helper"
require "decidim/centers/test/shared_contexts"

describe "Registration spec", type: :system do
  let(:organization) { create :organization, extra_user_fields: { "enabled" => true, "document_id" => { "enabled" => true }, "document_id_name" => { "enabled" => true } } }
  let(:email) { Faker::Internet.email }
  let(:name) { Faker::Name.name }
  let(:nickname) { Faker::Internet.username(separators: []) }
  let(:password) { Faker::Internet.password(min_length: 17) }
  let!(:center) { create :center, organization: organization }
  let!(:other_center) { create :center, organization: organization }
  let!(:scope) { create :scope, organization: organization }
  let!(:other_scope) { create :scope, organization: organization }
  let(:document_id) { Faker::IDNumber.spanish_citizen_number }
  let(:document_id_name) { Faker::Name.name }

  before do
    switch_to_host(organization.host)
    visit decidim.new_user_registration_path
  end

  it "contains custom fields as mandatory" do
    within ".card__centers" do
      expect(page).to have_content("Center")
    end
    within ".card__centers label[for='registration_user_center_id']" do
      expect(page).to have_css("span.label-required")
    end
    within all(".card__centers label").last do
      expect(page).to have_css("span.label-required")
    end

    within ".card__centers" do
      expect(page).to have_content("Scope")
    end

    expect(page).to have_content("Document ID")

    within ".card__extra_user_fields label[for='registration_user_document_id']" do
      expect(page).to have_css("span.label-required")
    end

    expect(page).to have_content("Name from Document ID")

    within ".card__extra_user_fields label[for='registration_user_document_id_name']" do
      expect(page).to have_css("span.label-required")
    end
  end

  it "allows to create a new account and authorizes the user with the center and scope provided" do
    fill_in :registration_user_name, with: name
    fill_in :registration_user_nickname, with: nickname
    fill_in :registration_user_email, with: email
    fill_in :registration_user_password, with: password
    fill_in :registration_user_password_confirmation, with: password
    fill_in :registration_user_document_id, with: document_id
    fill_in :registration_user_document_id_name, with: document_id_name

    within ".card__centers" do
      within "#registration_user_center_id" do
        find("option[value='#{center.id}']").click
      end

      scope_pick select_data_picker(:registration_user), scope
    end

    page.check("registration_user_newsletter")
    page.check("registration_user_tos_agreement")

    within "form.new_user" do
      find("*[type=submit]").click
    end

    expect(page).to have_content("message with a confirmation link has been sent")
    expect(Decidim::User.last.center).to eq(center)
    expect(Decidim::User.last.scope).to eq(scope)
    expect(Decidim::User.last.extended_data["document_id"]).to eq(document_id)
    expect(Decidim::User.last.extended_data["document_id_name"]).to eq(document_id_name)

    perform_enqueued_jobs
    check_center_authorization(Decidim::Authorization.last, Decidim::User.last, center, scope)
  end
end
