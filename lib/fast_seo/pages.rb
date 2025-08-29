module FastSEO
  # Manages SEO page definitions and retrieval.
  module Pages
    @registry = {}
    # DSL for defining SEO pages.
    class DSL
      ATTRS = %i[og_type title description image keywords schema route providers].freeze

      def initialize(name, model:, **options)
        @name   = name
        @model  = model.is_a?(String) ? model.constantize : model
        @config = options.slice(*ATTRS)
      end

      def build(obj, view:, page_type: "default", attr_slug: nil)
        Page.new(@config, obj, view, page_type, attr_slug)
      end
    end

    # Represents a specific SEO page instance.
    class Page
      attr_reader :obj, :view, :page_type, :attr_slug

      def initialize(config, obj, view, page_type, attr_slug)
        @config = config
        @obj = obj
        @view = view
        @page_type = page_type
        @attr_slug = attr_slug
      end

      def method_missing(name, *args, &block)
        return super unless @config.key?(name)

        val = @config[name]
        FastSEO::Pages.resolve(val, @obj, @view, @attr_slug)
      end

      def respond_to_missing?(name, include_private = false)
        @config.key?(name) || super
      end

      def schema_parts
        Array(@config[:schema])
      end

      def providers
        Array(@config[:providers])
      end
    end

    class << self
      def page(name, model:, **options, &block)
        dsl = DSL.new(name, model:, **options)
        @registry[name.to_sym] = dsl
      end

      def for(object, view:, page_type: "default", attribute_page_slug: nil)
        key = object.class.name.underscore.gsub("/", "_").to_sym
        dsl = @registry[page_type.to_sym] || @registry[key]
        raise "No SEO page defined for #{object.class}" unless dsl

        dsl.build(object, view:, page_type:, attr_slug: attribute_page_slug)
      end

      def resolve(val, obj, view, attr_slug)
        case val
        when Symbol
          if obj.respond_to?(val)
            obj.public_send(val)
          elsif view.respond_to?(val)
            view.public_send(val, obj)
          else
            OG_TYPE_MAP[val] || val.to_s
          end
        when Proc
          val.call(obj, view, attr_slug)
        else
          val
        end
      end
    end

    OG_TYPE_MAP = {
      profile: "profile",
      website: "website",
      article: "article",
      movie: "video.movie",
      business: "business.business",
      event: "event"
    }
  end
end
