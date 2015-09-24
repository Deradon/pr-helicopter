require 'yaml'

#
# Encapsulates the config settings.
#

class Helicopter
  # Helicopter::Config
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
      groups.fetch(files[path], [])
    end

    # To show the content of the merged config files.
    def inspect
      config.inspect
    end

    private

    # Returns the github configuration.
    def config
      @cfg ||= YAML.load_file("config/#{env}.yml")
    end
  end
end
