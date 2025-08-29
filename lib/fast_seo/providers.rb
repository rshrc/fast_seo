module FastSEO
  # Manages SEO providers and their meta tag generation.
  module Providers
    @providers = {}

    def self.register(name, &block)
      dsl = ProviderDSL.new
      dsl.instance_eval(&block)
      @providers[name] = dsl.to_proc
    end

    def self.build_all(page, view:, title:, description:, image_url:, current_url:, og_type:)
      selected = page.providers.presence || FastSEO.configuration.providers
      selected.flat_map do |provider|
        @providers[provider]&.call(page, view, title, description, image_url, current_url, og_type)
      end.compact
    end

    # DSL for defining provider mappings.
    class ProviderDSL
      def initialize
        @mappings = []
      end

      def property(var, prop, value_proc = nil)
        @mappings << [:property, var, prop, value_proc]
      end

      def name(var, prop, value_proc = nil)
        @mappings << [:name, var, prop, value_proc]
      end

      def to_proc
        mappings = @mappings
        proc do |page, view, title, description, image_url, current_url, og_type|
          bindings = {
            title: title, description: description,
            image_url: image_url, current_url: current_url,
            og_type: og_type, site_name: FastSEO.configuration.site_name
          }
          mappings.map do |type, var, prop, value_proc|
            content =
              if value_proc
                value_proc.arity.zero? ? value_proc.call : value_proc.call(bindings[var])
              else
                bindings[var]
              end
            next if content.blank?

            attrs = (type == :property ? { property: prop } : { name: prop })
            view.tag.meta(attrs.merge(content: content))
          end.compact
        end
      end
    end
  end
end

# Default providers using DSL
FastSEO::Providers.register(:open_graph) do
  property :title,       "og:title"
  property :description, "og:description"
  property :og_type,     "og:type"
  property :current_url, "og:url"
  property :image_url,   "og:image"
  property :site_name,   "og:site_name", -> { FastSEO.configuration.site_name }
end

FastSEO::Providers.register(:twitter) do
  name :title,       "twitter:title"
  name :description, "twitter:description"
  name :image_url,   "twitter:image"
  name :site_name,   "twitter:site", -> { FastSEO.configuration.twitter_handle }
  name :image_url,   "twitter:card", ->(url) { url.present? ? "summary_large_image" : "summary" }
end

FastSEO::Providers.register(:facebook) do
  property :site_name, "fb:app_id", -> { FastSEO.configuration.facebook_app_id }
end
