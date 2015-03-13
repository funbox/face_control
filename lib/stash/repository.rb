require 'stash/pull_request'

module Stash
  class Repository
    attr_accessor :server, :project, :repo

    def initialize(server, project, repo)
      self.server = server
      self.project = project
      self.repo = repo
    end

    def pull_request(id)
      PullRequest.new(self, id)
    end

    def get(path)
      server.get(endpoint + path)
    end

    def post(path, data)
      server.post(endpoint + path, data)
    end

    def endpoint
      "/projects/#{project}/repos/#{repo}"
    end

    def logger
      server.logger
    end
  end
end
