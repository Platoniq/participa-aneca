# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module AccountFormOverride
    extend ActiveSupport::Concern

    DNI_LETTERS = "TRWAGMYFPDXBNJZSQVHLCKE"
    DNI_REGEX = /^(\d{8})([A-Z])$/
    NIE_REGEX = /^[XYZ]\d{7,8}[A-Z]$/

    included do
      validate :check_document_id

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
        self.document_id_name = extended_data[:document_id_name]
        self.document_id = extended_data[:document_id]
      end

      def check_document_id
        return unless document_id?

        case document_type
        when "DNI"
          errors.add(:document_id, :invalid) unless valid_dni?(scaped_document_id)
        when "NIE"
          errors.add(:document_id, :invalid) unless valid_nie?
        else
          errors.add(:document_id, :invalid)
        end
      end

      def scaped_document_id
        @scaped_document_id ||= document_id.upcase.delete("^A-Z0-9")
      end

      def document_type
        @document_type ||= if scaped_document_id =~ DNI_REGEX
                             "DNI"
                           elsif scaped_document_id =~ NIE_REGEX
                             "NIE"
                           end
      end

      def valid_nie?
        nie_prefix = case scaped_document_id[0]
                     when "X"
                       0
                     when "Y"
                       1
                     else
                       2
                     end
        valid_dni?("#{nie_prefix}#{scaped_document_id[1..]}")
      end

      def valid_dni?(dni)
        dni[-1] == DNI_LETTERS[dni.to_i % 23]
      end
    end
  end
end
