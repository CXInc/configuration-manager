Configuration Manager
=====================

Rails development configuration management and theme switching. This is specific
to how application configuration and theme handling are done at CX, and hasn't
been made more generally useful yet.

Install
-------

Add to your Gemfile:

     gem "configuration_manager"

In your ApplicationController:

    include ConfigurationManager

    if Rails.env.development? || Rails.env.test?
      before_filter :reload_config
      before_filter :check_configuration_freshness
    end

If there are configurations that should be ignored, add them in config/initializers/configuration_manager.rb:

    ConfigurationManager.configure do |config|
      config.ignored_configs = [:key_to_ignore, :another_one]
    end

Add default theme configurations as config/application.{theme name}.dev.yml. All of these will require updates whenever new developement configurations are added.

Usage
-----

Update to the latest config for the current theme:

    rake config:update

Switch themes:

    rake config:switch THEME={theme name}
