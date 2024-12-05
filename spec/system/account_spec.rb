# frozen_string_literal: true

require "rails_helper"
require "decidim/centers/test/shared_contexts"

describe "Account", type: :system do
  let(:organization) { create :organization, extra_user_fields: { "enabled" => true, "document_id" => { "enabled" => true } } }
  let(:user) { create :user, :confirmed, organization: organization }
  let!(:center) { create :center, organization: organization }
  let!(:other_center) { create :center, organization: organization }
  let!(:role) { create :role, organization: organization }
  let!(:other_role) { create :role, organization: organization }
  let(:document_id) { Faker::IDNumber.spanish_citizen_number }
  let(:other_document_id) { Faker::IDNumber.spanish_citizen_number }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  shared_context "when visiting account path" do
    before do
      visit decidim.account_path
    end
  end

  shared_context "with authorization" do
    let!(:authorization) { create :authorization, name: "center", user: user, metadata: { centers: [center.id], roles: [role&.id].compact } }
  end

  shared_context "with user with center" do
    let!(:center_user) { create :center_user, center: center, user: user }
  end

  shared_context "with user with role" do
    let!(:role_user) { create :role_user, role: role, user: user }
  end

  shared_context "with user with document id" do
    let(:user) { create :user, :confirmed, organization: organization, extended_data: { document_id: document_id } }
  end

  shared_examples_for "user without center changes the center" do
    include_context "when visiting account path"

    it "shows an empty value on the center input" do
      expect(find("#user_center_id").value).to eq("")
    end

    include_examples "user changes the center"
  end

  shared_examples_for "user with center changes the center" do
    include_context "when visiting account path"

    it "has an authorization for the center" do
      check_center_authorization(Decidim::Authorization.last, user, center)
    end

    it "shows the current center on the center input" do
      expect(find("#user_center_id").value).to eq(center.id.to_s)
    end

    include_examples "user changes the center"
  end

  shared_examples_for "user cannot be saved without changes" do
    include_context "when visiting account path"

    it "cannot save without selecting center" do
      within "form.edit_user" do
        find("*[type=submit]").click
      end

      expect(page).to have_content("There's an error in this field").or have_content("can't be blank")
    end
  end

  shared_examples_for "user changes the center" do
    it "can update the center and changes the authorization" do
      within "form.edit_user" do
        within "#user_center_id" do
          find("option[value='#{other_center.id}']").click
        end

        find("*[type=submit]").click
      end

      within_flash_messages do
        expect(page).to have_content("successfully")
      end

      expect(find("#user_center_id").value).to eq(other_center.id.to_s)

      perform_enqueued_jobs
      check_center_authorization(Decidim::Authorization.last, user, other_center)
    end
  end

  shared_examples_for "user without role changes the role" do
    include_context "when visiting account path"

    it "shows an empty value on the role input" do
      expect(find("#user_role_id").value).to eq("")
    end

    include_examples "user changes the role"
  end

  shared_examples_for "user with role changes the role" do
    include_context "when visiting account path"

    it "has an authorization for the center and the role" do
      check_center_authorization(Decidim::Authorization.last, user, center, role: role)
    end

    it "shows the current role on the role input" do
      expect(find("#user_role_id").value).to eq(role.id.to_s)
    end

    include_examples "user changes the role"
  end

  shared_examples_for "user changes the role" do
    it "can update the role and changes the authorization" do
      within "form.edit_user" do
        within "#user_role_id" do
          find("option[value='#{other_role.id}']").click
        end

        find("*[type=submit]").click
      end

      within_flash_messages do
        expect(page).to have_content("successfully")
      end

      expect(find("#user_role_id").value).to eq(other_role.id.to_s)

      perform_enqueued_jobs
      check_center_authorization(Decidim::Authorization.last, user, center, role: other_role)
    end
  end

  shared_examples_for "user without document id changes the document id" do
    include_context "when visiting account path"

    it "shows an empty value on the document input" do
      expect(find("#user_document_id").value).to eq("")
    end

    include_examples "user changes the document id"
  end

  shared_examples_for "user with document id changes the document id" do
    include_context "when visiting account path"

    it "has a document id" do
      expect(user.extended_data["document_id"]).to eq(document_id)
    end

    it "shows the current document id on the document id input" do
      expect(find("#user_document_id").value).to eq(document_id)
    end

    include_examples "user changes the document id"
  end

  shared_examples_for "user changes the document id" do
    it "can update the document id" do
      within "form.edit_user" do
        fill_in :user_document_id, with: other_document_id, currently_with: user.extended_data["document_id"] || ""

        find("*[type=submit]").click
      end

      within_flash_messages do
        expect(page).to have_content("successfully")
      end

      expect(find("#user_document_id").value).to eq(other_document_id)
    end
  end

  context "when the user doesn't have role" do
    context "when the user doesn't have center" do
      context "when the user doesn't have document id" do
        include_examples "user cannot be saved without changes"
      end

      context "when the user has document id" do
        include_context "with user with document id"

        include_examples "user cannot be saved without changes"
      end
    end

    context "when the user has center" do
      include_context "with user with center"
      include_context "with authorization"

      context "when the user doesn't have document id" do
        include_examples "user cannot be saved without changes"
      end

      context "when the user has document id" do
        include_context "with user with document id"

        include_examples "user cannot be saved without changes"
      end
    end
  end

  context "when the user has role" do
    include_context "with user with role"

    context "when the user doesn't have center" do
      context "when the user doesn't have document id" do
        include_examples "user cannot be saved without changes"
      end

      context "when the user has document id" do
        include_context "with user with document id"

        include_examples "user cannot be saved without changes"
      end
    end

    context "when the user has center" do
      include_context "with user with center"
      include_context "with authorization"

      context "when the user doesn't have document id" do
        include_examples "user cannot be saved without changes"
        include_examples "user without document id changes the document id"
      end

      context "when the user has document id" do
        include_context "with user with document id"

        include_examples "user with document id changes the document id"
      end
    end
  end

  context "when the user has document id" do
    include_context "with user with document id"

    context "when the user has center" do
      include_context "with user with center"
      include_context "with authorization"

      context "when the user doesn't have role" do
        include_examples "user cannot be saved without changes"
        include_examples "user without role changes the role"
      end

      context "when the user has role" do
        include_context "with user with role"

        include_examples "user with role changes the role"
      end
    end

    context "when the user has role" do
      include_context "with user with role"
      include_context "with authorization"

      context "when the user doesn't have center" do
        include_examples "user cannot be saved without changes"
        include_examples "user without center changes the center"
      end

      context "when the user has center" do
        include_context "with user with center"

        include_examples "user with center changes the center"
      end
    end
  end
end
