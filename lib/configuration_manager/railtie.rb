module ConfigurationManager
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path('../../tasks/config.rake',  __FILE__)
    end
  end
end
