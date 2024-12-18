# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Proposals
    module ProposalFormOverride
      extend ActiveSupport::Concern

      included do
        validates :category, presence: true
      end
    end
  end
end
