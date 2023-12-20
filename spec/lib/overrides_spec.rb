# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-centers",
    files: {
      "/app/forms/concerns/decidim/centers/account_form_override.rb" => "e68397eccf208adef7c77fcfb679d8cf"
    }
  },
  {
    package: "decidim-extra_user_fields",
    files: {
      "/app/forms/concerns/decidim/extra_user_fields/forms_definitions.rb" => "b59f5bf2a48e27213a8cacf22aaf6723"
    }
  },
  {
    package: "decidim-proposals",
    files: {
      "/app/cells/decidim/proposals/participatory_text_proposal/buttons.erb" => "0810f2a8eebf476b67632227a5c73ff2",
      "/app/cells/decidim/proposals/participatory_text_proposal/show.erb" => "a6fd0029e01e712314f555a9397485f8",
      "/app/views/decidim/proposals/proposals/participatory_texts/_index.html.erb" => "6d3666c3c116689bae657da537d9deef"
    }
  }
]

describe "Overriden files", type: :view do
  checksums.each do |item|
    # rubocop:disable Rails/DynamicFindBy
    spec = ::Gem::Specification.find_by_name(item[:package])
    # rubocop:enable Rails/DynamicFindBy
    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
