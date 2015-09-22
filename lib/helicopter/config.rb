
require 'yaml'

class Helicopter
  # Encapsulates all config files.
  class Config
    # Returns the environment specified by ENV variable.
    def env
      ENV.fetch('ENV', 'development')
    end

    # To access the config value for the given key.
    def method_missing(name)
      config[name.to_s]
    end

    # To access all receivers for the given file.
    # @param {path} Path of the file
    # @return Array of receiver emails
    def receivers_for(path)
      cfg       = YAML.load_file('config/receivers.yml')
      receivers = cfg['groups'][env]
      group     = cfg['files'][path]

      fail "#{env} not configured in config/receivers.yml" unless receivers

      receivers.fetch(group, [])
    end

    # To show the content of the merged config files.
    def inspect
      config.inspect
    end

    private

    # Returns the github configuration.
    def config
      @cfg ||= begin
        YAML.load_file('config/github.yml')[env].merge(
          YAML.load_file('config/sendgrid.yml')[env])
      end
    end
  end
end
