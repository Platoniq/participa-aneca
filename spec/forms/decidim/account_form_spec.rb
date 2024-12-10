# frozen_string_literal: true

require "rails_helper"

describe Decidim::AccountForm do
  subject do
    described_class.new(
      name: user.name,
      nickname: user.nickname,
      email: user.email,
      password: user.password,
      password_confirmation: user.password,
      tos_agreement: "1",
      center_id: user.center.id,
      role_id: user.center_role.id,
      document_id: document_id
    ).with_context(
      current_organization: organization,
      current_user: user
    )
  end

  let(:organization) { create :organization, extra_user_fields: { "enabled" => true, "document_id" => { "enabled" => true } } }
  let(:user) { create :user, organization: organization }
  let!(:center_user) { create :center_user, user: user }
  let!(:role_user) { create :role_user, user: user }

  context "with valid citizen number" do
    let(:document_id) { Faker::IDNumber.spanish_citizen_number }

    it { is_expected.to be_valid }
  end

  context "with invalid citizen number" do
    let(:document_id) { "12345678-A" }

    it { is_expected.not_to be_valid }
  end

  context "with valid foreign citizen number" do
    let(:document_id) { Faker::IDNumber.spanish_foreign_citizen_number }

    it { is_expected.to be_valid }
  end

  context "with invalid foreign citizen number" do
    let(:document_id) { "Z-1234567-A" }

    it { is_expected.not_to be_valid }
  end

  context "with invalid document id" do
    let(:document_id) { "foo" }

    it { is_expected.not_to be_valid }
  end

  context "with document id disabled" do
    let(:organization) { create :organization, extra_user_fields: { "enabled" => false } }

    context "with invalid citizen number" do
      let(:document_id) { "12345678-A" }

      it { is_expected.to be_valid }
    end

    context "with invalid foreign citizen number" do
      let(:document_id) { "Z-1234567-A" }

      it { is_expected.to be_valid }
    end

    context "with invalid document id" do
      let(:document_id) { "foo" }

      it { is_expected.to be_valid }
    end
  end
end
