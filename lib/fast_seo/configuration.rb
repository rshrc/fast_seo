module FastSEO
  # Holds the configuration for the FastSEO gem.
  class Configuration
    attr_accessor :default_title, :default_desc, :default_image,
                  :default_keywords, :twitter_handle, :site_name,
                  :facebook_app_id, :providers

    def initialize
      @default_title    = "MySite"
      @default_desc     = "Default site description"
      @default_image    = "default.png"
      @default_keywords = "default, keywords"
      @twitter_handle   = "@mysite"
      @site_name        = "MySite"
      @facebook_app_id  = nil
      @providers        = %i[open_graph twitter] # global default
    end
  end
end
