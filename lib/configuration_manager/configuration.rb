module ConfigurationManager
  class Configuration < Struct.new(:ignored_configs)
  end

  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end
  end
end
