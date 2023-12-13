# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::RegistrationForm.include(Decidim::AccountFormOverride)
  Decidim::OmniauthRegistrationForm.include(Decidim::AccountFormOverride)
  Decidim::AccountForm.include(Decidim::AccountFormOverride)
end
