module ConfigurationManager
  class Merger
    class << self

      def write(theme_name)
        File.open("#{Rails.root}/config/application.yml", "w") do |file|
          file.write config(theme_name).to_yaml
        end
      end

      def config(theme_name)
        common = YAML.load_file "#{Rails.root}/config/application.common.dev.yml"
        theme = YAML.load_file "#{Rails.root}/config/application.#{theme_name}.dev.yml"

        {
          "development" => get(common, "development").deep_merge( get(theme, "development") ),
          "test" => get(common, "test").deep_merge( get(theme, "test") )
        }
      end

      private

      def get(config, env_name)
        common = config["common"] || {}
        env = config[env_name] || {}

        common.deep_merge(env)
      end

    end
  end
end
