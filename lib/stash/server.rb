require 'httparty'
require 'stash/pull_request'

module Stash
  class Server
    attr_accessor :root_uri, :user, :password, :logger

    def initialize(root_uri, user, password, logger)
      self.root_uri = root_uri
      self.user = user
      self.password = password
      self.logger = logger

      @pull_requests = {}
    end

    def pull_request(project, repo, id)
      @pull_requests["#{project}/#{repo}/#{id}"] ||= PullRequest.new(self, project, repo, id)
    end

    def get(path)
      log_as('Response') do
        HTTParty.get(endpoint + path, auth.merge(logging))
      end
    end

    def post(path, data)
      log_as('Response') do
        HTTParty.post(endpoint + path, auth.merge(content_type).merge(body: data.to_json).merge(logging))
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

    def log_as(label)
      result = yield
      logger.debug("#{label}:\n#{result}")
      result
    end

    def logging
      {
        logger: logger,
        log_level: :debug
      }
    end
  end
end
