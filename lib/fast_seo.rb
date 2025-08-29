# frozen_string_literal: true

require_relative "fast_seo/version"
require "fast_seo/version"
require "fast_seo/configuration"
require "fast_seo/pages"
require "fast_seo/schema_parts"
require "fast_seo/providers"
require "fast_seo/helper"
require "fast_seo/railtie" if defined?(Rails)

# The main module for the FastSEO gem.
module FastSEO
  class << self
    def configure(&block)
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def page(*args, **options, &block)
      Pages.page(*args, **options, &block)
    end
  end
end
