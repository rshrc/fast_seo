require "rails/generators"

module FastSeo
  module Generators
    class PageGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)
      argument :name, type: :string, desc: "The page key (e.g. user, work_job)"
      argument :model, type: :string, desc: "The model name (e.g. User, Work::Job)"

      def create_page_file
        underscored = name.underscore
        template "page_seo.rb.tt", "app/seo/pages/#{underscored}_seo.rb"
      end
    end
  end
end
