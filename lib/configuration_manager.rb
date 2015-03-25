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

    differences = differing_configs(current, generated)

    if differences.any? && !AppConfig['allow_custom_configuration']
      raise "Current application.yml does not match the default for #{AppConfig.current_theme}. " +
        "Either run `rake config:update` or set allow_custom_configuration to true" +
        " in your application.yml. Differences: #{differences}"
    end
  end

  private

  def differing_configs(one, two)
    relevant_configs_one = relevant_configs(one)
    relevant_configs_two = relevant_configs(two)

    deep_diff(relevant_configs_one, relevant_configs_two)
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

  # https://gist.github.com/henrik/146844, modified to not use monkey patching
  def deep_diff(a, b)
    (a.keys | b.keys).inject({}) do |diff, k|
      if a[k] != b[k]
        if a[k].is_a?(Hash) && b[k].is_a?(Hash)
          diff[k] = deep_diff(a[k], b[k])
        else
          diff[k] = [a[k], b[k]]
        end
      end
      diff
    end
  end
end
