# config/initializers/session_store.rb

Rails.application.config.session_store :cookie_store, key: '_decidim_session', secure: Rails.env.production?, same_site: :lax
