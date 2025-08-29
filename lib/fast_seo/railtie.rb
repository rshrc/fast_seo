module FastSEO
  class Railtie < Rails::Railtie
    initializer "fast_seo.load_helpers" do
      ActiveSupport.on_load(:action_view) do
        include FastSEO::Helper
      end
    end

    initializer "fast_seo.load_pages" do
      Dir[Rails.root.join("app/seo/pages/**/*.rb")].each { |file| require file }
    end
  end
end
