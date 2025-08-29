FastSEO.configure do |c|
  c.default_title    = "MySite"
  c.default_desc     = "Default site description"
  c.default_image    = "default.png"
  c.default_keywords = "site, keywords"
  c.twitter_handle   = "@mysite"
  c.site_name        = "MySite"
  c.facebook_app_id  = nil

  # Global providers (can be overridden per page)
  c.providers        = [:open_graph, :twitter]
end
