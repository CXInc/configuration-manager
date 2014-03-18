require_relative '../configuration_manager/merger'

namespace :config do

  desc "Switch configurations to another theme, specified by THEME"
  task :switch do
    theme = ENV['THEME']

    puts "= Switching to the #{theme} configuration"
    ConfigurationManager::Merger.write(theme)

    puts "= Clearing temp files"
    Rake::Task["tmp:clear"].invoke
  end

  desc "Update the current configuration"
  task :update do
    theme = AppConfig.theme

    puts "= Updating config, using the #{theme} configuration"
    ConfigurationManager::Merger.write(theme)
  end

end