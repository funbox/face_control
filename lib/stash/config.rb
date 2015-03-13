require 'yaml'

module Stash
  class Config
    def initialize(config_file = "#{ENV['HOME']}/.stashconfig.yml")
      @config_file = config_file

      fail "#{@config_file} does not exist" unless File.exist?(@config_file)
    end

    def host
      config['stash_url']
    end

    def user
      config['username']
    end

    def password
      config['password']
    end

    private

    def config
      @config ||= YAML.load_file(@config_file)
    end
  end
end
