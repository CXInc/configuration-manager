require "configuration_manager/configuration"
require "configuration_manager/merger"
require "configuration_manager/railtie"
require "configuration_manager/version"

module ConfigurationManager

  def reload_config
    AppConfig.reload!
  rescue Errno::ENOENT
    raise "Missing the application.yml configuration file. Try loading with " +
      "`cp config/application.cx.dev.yml config/application.yml`"
  end

  def check_configuration_freshness
    current = YAML.load_file("#{Rails.root}/config/application.yml")
    generated = Merger.config(AppConfig.current_theme)

    different = configs_different? current, generated

    if different && !AppConfig['allow_custom_configuration']
      raise "Current application.yml does not match the default for #{AppConfig.current_theme}. " +
        "Either run `rake config:update` or set allow_custom_configuration to true" +
        " in your application.yml."
    end
  end

  private

  def configs_different?(one, two)
    relevant_configs_one = relevant_configs(one)
    relevant_configs_two = relevant_configs(two)

    relevant_configs_one != relevant_configs_two
  end

  def relevant_configs(data)
    ignored_configs = ConfigurationManager.configuration.ignored_configs

    ignored_configs.each do |config|
      ["development", "test"].each do |env|
        data[env].delete config.to_s if data[env]
      end
    end

    data
  end
end
