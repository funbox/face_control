require 'httparty'
require 'stash/repository'

module Stash
  class Server
    class CommunicationError < StandardError; end

    attr_accessor :root_uri, :user, :password, :logger

    def initialize(root_uri, user, password, logger = nil)
      self.root_uri = root_uri
      self.user = user
      self.password = password
      self.logger = logger
    end

    def repository(project_key, repository_slug)
      key = "#{project_key}/#{repository_slug}"
      @repositories      ||= {}
      @repositories[key] ||= Repository.new(self, project_key, repository_slug)
    end

    def get(path)
      with_error_handling do
        logged('Response') do
          HTTParty.get(endpoint + path, auth.merge(logging))
        end
      end
    end

    def post(path, data)
      with_error_handling do
        logged('Response') do
          HTTParty.post(endpoint + path, auth.merge(content_type).merge(body: data.to_json).merge(logging))
        end
      end
    end

    private

    def endpoint
      "#{root_uri}/rest/api/1.0"
    end

    def auth
      {
        basic_auth: {
          username: user,
          password: password
        }
      }
    end

    def content_type
      {
        headers: {
          'Content-Type' => 'application/json'
        }
      }
    end

    def logged(label)
      if logger
        result = yield
        logger.debug("#{label}:\n#{result}")
        result
      else
        yield
      end
    end

    def logging
      if logger
        {
          logger: logger,
          log_level: :debug
        }
      else
        {}
      end
    end

    def with_error_handling
      yield.tap do |response|
        unless response.success?
          fail CommunicationError, 'Stash responded with an error'
        end
      end
    end
  end
end
