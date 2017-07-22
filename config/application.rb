require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Intake
  mattr_accessor :provider_api
  class Application < Rails::Application
    CURRENT_APP_ID = 6739
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
     config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
     # Manoj Patil 08/10/2014 - created app/services and app/forms folder.
     # This will autoload the classes from those folder similar to how Rails autoloads Model- classes, hence these
     # classes can be used in the Controller like Model classes.
     config.autoload_paths += %W(#{config.root}/services)
     config.autoload_paths += %W(#{config.root}/entity_services)
     config.autoload_paths += %W(#{config.root}/forms)
     config.autoload_paths += %W(#{config.root}/modules)
     config.autoload_paths += %W(#{config.root}/structures)
     config.autoload_paths += %W(#{config.root}/pdfs)
     config.autoload_paths += %W(#{config.root}/pdfs/provider)
     config.autoload_paths += %W(#{config.root}/pdfs/client)
     config.autoload_paths += %W(#{config.root}/arwins_web_services)

    #Kiran - everydayrails- rspec
    #The following code informs Rails to create a factory corresponding to each new model,
    #while we use rails generate to create a model
    config.generators do |g|
        g.test_framework :rspec,
            :fixtures => true, #specifies to generate a fixture for each model, using a Factory Girl factory, instead of an actual fixture
            :view_specs => false, #skip generating view specs
            :helper_specs => false, #skips generating specs for the helper files Rails generates with each controller.
            :routing_specs => false, #omits a spec file for your config/routes.rb file
            :controller_specs => true,
            :request_specs => true #used instead of view specs
        g.fixture_replacement :factory_girl, :dir => "spec/factories" #informs Rails to generate factories instead of fixtures
    end

  end
end
