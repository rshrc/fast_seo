module FastSEO
  module Helper
    def seo_tags(object, page_type: nil, attribute_page_slug: nil)
      page = FastSEO::Pages.for(object, view: self, page_type:, attribute_page_slug:)

      title       = page.title.presence || FastSEO.configuration.default_title
      description = page.description.presence || FastSEO.configuration.default_desc
      image_url   = page.image.presence || image_url(FastSEO.configuration.default_image)
      keywords    = page.keywords.presence || FastSEO.configuration.default_keywords
      og_type     = page.og_type.presence || "website"
      current_url = resolve_route(page)

      tags = []
      tags << content_tag(:title, title)
      tags << tag.meta(name: "description", content: description)
      tags << tag.meta(name: "keywords", content: keywords)

      tags.concat(FastSEO::Providers.build_all(page,
                                               view: self, title:, description:, image_url:, current_url:, og_type:))

      safe_join(tags.compact, "\n")
    end

    def seo_schema(object, page_type: nil)
      page = FastSEO::Pages.for(object, view: self, page_type:)
      extras = FastSEO::SchemaParts.build_all(page)
      return nil if extras.empty?

      content_tag :script, type: "application/ld+json" do
        { "@context": "https://schema.org", "@graph": extras }.to_json.html_safe
      end
    end

    private

    def resolve_route(page)
      route = page.route
      case route
      when Symbol
        public_send(route, page.obj)
      when Proc
        route.call(page.obj, self)
      when String
        route
      else
        request.original_url
      end
    end
  end
end
