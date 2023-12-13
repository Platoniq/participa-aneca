# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module AccountFormOverride
    extend ActiveSupport::Concern

    included do

      def map_model(model)
        map_model_centers(model)
        map_model_extra_user_fields(model)
      end

      private

      def map_model_centers(model)
        self.center_id = model.center.try(:id)
        self.scope_id = model.scope.try(:id)
      end

      def map_model_extra_user_fields(model)
        extended_data = model.extended_data.with_indifferent_access

        self.country = extended_data[:country]
        self.postal_code = extended_data[:postal_code]
        self.date_of_birth = Date.parse(extended_data[:date_of_birth]) if extended_data[:date_of_birth].present?
        self.gender = extended_data[:gender]
        self.phone_number = extended_data[:phone_number]
        self.location = extended_data[:location]
        self.profession = extended_data[:profession]
        self.document_id = extended_data[:document_id]
      end
    end
  end
end
