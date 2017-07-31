# Where the I18n library should search for translation files
I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]
 
# Set default locale to something other than :en
I18n.enforce_available_locales = false
I18n.available_locales = [:de, :en]
I18n.default_locale = :en

RouteTranslator.config do |config|
  config.generate_unnamed_unlocalized_routes = true
end