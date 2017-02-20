require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BedwarsNetwork
  class Application < Rails::Application   
    config.encoding = "utf-8"
    config.time_zone = 'Berlin'
    config.action_controller.default_url_options = { :trailing_slash => true }
    
    Yt.configure do |config|
      config.api_key = ENV["GOOGLE_API_KEY"]
      config.log_level = :debug
    end
  end
end
