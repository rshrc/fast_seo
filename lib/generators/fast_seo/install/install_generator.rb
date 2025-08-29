require "rails/generators"

module FastSeo
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)
      desc "Creates a FastSEO initializer in config/initializers/fast_seo.rb"

      def copy_initializer
        template "initializer.rb", "config/initializers/fast_seo.rb"
      end
    end
  end
end
