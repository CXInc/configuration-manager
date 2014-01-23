require "configuration_manager/configuration"
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
    current = "application.yml"
    reference = "application.#{AppConfig.theme}.dev.yml"

    current_path = "#{Rails.root}/config/#{current}"
    reference_path = "#{Rails.root}/config/#{reference}"

    different = configs_different? current_path, reference_path

    if different && !AppConfig['allow_custom_configuration']
      raise "Current configuration #{current} does not match #{reference}. " +
        "Either run `rake config:update` or set allow_custom_configuration to true" +
        " in your application.yml."
    end
  end

  private

  def configs_different?(path_one, path_two)
    one = YAML.load_file(path_one)
    two = YAML.load_file(path_two)

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
