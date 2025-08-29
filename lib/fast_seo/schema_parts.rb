module FastSEO
  # Manages SEO schema parts.
  module SchemaParts
    @parts = {}

    def self.register(name, &block)
      @parts[name] = block
    end

    def self.build_all(page)
      page.schema_parts.map { |p| @parts[p]&.call(page) }.compact
    end
  end
end

# Starter schemas
FastSEO::SchemaParts.register(:breadcrumb_list) do |page|
  crumbs = page.respond_to?(:breadcrumbs) ? page.breadcrumbs : []
  {
    "@type": "BreadcrumbList",
    itemListElement: crumbs.each_with_index.map do |crumb, i|
      { "@type": "ListItem", position: i + 1, name: crumb[:name], item: crumb[:item] }
    end
  }
end

FastSEO::SchemaParts.register(:profile_page) do |page|
  u = page.obj
  { "@type": "Person", name: u.try(:full_name_for_seo), jobTitle: u.try(:primary_role_for_seo) }.compact
end
