# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-centers",
    files: {
      "/app/forms/concerns/decidim/centers/account_form_override.rb" => "37573e0671c327aa6fa449be28b22dd9"
    }
  },
  {
    package: "decidim-core",
    files: {
      "/app/views/layouts/decidim/_logo.html.erb" => "ab01dd1df9ce62cbd62f640a3b5018b2",
      "/app/views/layouts/decidim/_mini_footer.html.erb" => "5a842f3e880f24f49789ee2f72d96f60"
    }
  },
  {
    package: "decidim-extra_user_fields",
    files: {
      "/app/forms/concerns/decidim/extra_user_fields/forms_definitions.rb" => "22694cd34eb45f7189a7b899828c7a69"
    }
  },
  {
    package: "decidim-proposals",
    files: {
      "/app/cells/decidim/proposals/participatory_text_proposal/buttons.erb" => "0810f2a8eebf476b67632227a5c73ff2",
      "/app/cells/decidim/proposals/participatory_text_proposal/show.erb" => "a6fd0029e01e712314f555a9397485f8",
      "/app/forms/decidim/proposals/admin/participatory_text_proposal_form.rb" => "00d3e80982cc65d51c0fd9a85445526d",
      "/app/forms/decidim/proposals/proposal_form.rb" => "5fbf98057d0e60a7beae161a37fdd31c",
      "/app/views/decidim/proposals/proposals/_edit_form_fields.html.erb" => "3cf530a07e4498195dab8d94b7df19d1",
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
