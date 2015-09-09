
require 'yaml'

class Helicopter
  # Encapsulates all config files.
  class Config
    # Returns the environment specified by ENV variable.
    def env
      ENV.fetch('ENV', 'development')
    end

    # Returns the github configuration.
    def config
      @cfg ||= YAML.load_file('config/github.yml')[env]
    end

    # To access the config value for the given key.
    def method_missing(name)
      config[name.to_s]
    end

    # To access all receivers for the given file.
    # @param {path} Path of the file
    def receivers_for(path)
      cfg       = YAML.load_file('config/receivers.yml')
      receivers = cfg['groups'][env]
      group     = cfg['files'][path]

      receivers[group]
    end
  end
end
