# FastSEO

**FastSEO** is a Rails-friendly gem for SEO meta tags + [schema.org](https://schema.org) structured data.
It’s convention-driven, DSL-powered, and fully extensible.

* 🔮 **DSL-first**: declare SEO per page in `app/seo/pages/*_seo.rb`
* ⚡ **Providers**: Open Graph, Twitter, Facebook, LinkedIn, and custom ones via a tiny DSL
* 📦 **Schema registry**: prebuilt schemas (`:profile_page`, `:breadcrumb_list`) and easy extension
* 🎯 **Rails-native**: supports namespaced models (`Profiles::User` → `:profiles_user`) and Rails URL helpers

---

## 🚀 Installation

Since the gem isn’t published to RubyGems yet, install it directly from GitHub:

```ruby
# Gemfile
gem "fast_seo", github: "rshrc/fast_seo"
```

Then bundle:

```sh
bundle install
```

---

## ⚙️ Configuration

Run the installer generator:

```sh
rails generate fast_seo:install
```

This creates `config/initializers/fast_seo.rb`:

```ruby
FastSEO.configure do |c|
  c.default_title    = "MySite"
  c.default_desc     = "Default description"
  c.default_image    = "default.png"
  c.default_keywords = "keywords, here"
  c.twitter_handle   = "@mysite"
  c.site_name        = "MySite"
  c.facebook_app_id  = "123456"
  c.providers        = [:open_graph, :twitter] # global defaults
end
```

---

## 📝 Defining Pages

Create SEO configs under `app/seo/pages/`.

### Example: User

```ruby
# app/seo/pages/user_seo.rb
FastSEO.page :user, model: "User", route: :user_url,
  og_type: :profile,
  title: :full_name_for_seo,
  description: ->(u) { "#{u.full_name_for_seo} is a #{u.primary_role_for_seo}" },
  image: :public_image_url_for_seo,
  schema: [:profile_page, :breadcrumb_list],
  providers: [:open_graph, :twitter]
```

### Example: Namespaced Model

```ruby
# app/seo/pages/work_job_seo.rb
FastSEO.page :work_job, model: "Work::Job", route: :job_url,
  og_type: :article,
  title: :title,
  description: :summary,
  image: :cover_image_url,
  schema: [:job_posting, :breadcrumb_list]
```

👉 `Profiles::User` becomes `:profiles_user` automatically.

---

## 📄 Using in Views

In any view or layout:

```erb
<head>
  <%= seo_tags(@user) %>
  <%= seo_schema(@user) %>
</head>
```

---

## 🔌 Providers DSL

Providers are declared once and reused. Built-ins include `:open_graph`, `:twitter`, `:facebook`.

Example built-in Open Graph:

```ruby
FastSEO::Providers.register(:open_graph) do
  property :title,       "og:title"
  property :description, "og:description"
  property :og_type,     "og:type"
  property :current_url, "og:url"
  property :image_url,   "og:image"
  property :site_name,   "og:site_name", -> { FastSEO.configuration.site_name }
end
```

Custom example:

```ruby
FastSEO::Providers.register(:pinterest) do
  name :title, "pinterest:title"
  name :image_url, "pinterest:image"
end
```

Per-page override:

```ruby
FastSEO.page :movie, model: "Movie", route: :movie_url,
  title: :title,
  providers: [:open_graph, :twitter, :pinterest]
```

---

## 🧩 Schema Parts

Schemas are modular:

```ruby
FastSEO::SchemaParts.register(:book) do |page|
  b = page.obj
  { "@type": "Book", name: b.title, author: b.author }
end
```

Attach via page:

```ruby
FastSEO.page :book, model: "Book", route: :book_url,
  title: :title,
  schema: [:book, :breadcrumb_list]
```

---

## ✅ Conventions

* `Profiles::User` → page key `:profiles_user`
* Works with Rails URL helpers (`:user_url`, `:job_url`)
* Falls back to global config if values are missing
* Global providers from config, overridable per page

---

## 🛠 Development & Local Gem Usage

To build locally:

```sh
gem build fast_seo.gemspec
```

To use locally in another app:

```ruby
gem "fast_seo", path: "../fast_seo"
```

Or push to GitHub (private or public) and use:

```ruby
gem "fast_seo", github: "rshrc/fast_seo"
```

---

