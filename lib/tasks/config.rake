namespace :config do
  desc "Switch configurations to another theme, specieid by THEME"
  task :switch do
    theme = ENV['THEME']

    puts "= Switching to the #{theme} configuration"
    copy_theme(theme)

    puts "= Clearing temp files"
    Rake::Task["tmp:clear"].invoke
  end

  desc "Update the current configuration"
  task :update do
    theme = AppConfig.theme

    puts "= Updating config, using the #{theme} configuration"
    copy_theme(theme)
  end

  def copy_theme(theme)
    source = "#{Rails.root}/config/application.#{theme}.dev.yml"
    dest = "#{Rails.root}/config/application.yml"

    system "cp #{source} #{dest}"
  end
end