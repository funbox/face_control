require 'stash/pull_request/diff'

module Stash
  class PullRequest
    def initialize(server, project, repo, id)
      @server = server
      @project = project
      @repo = repo
      @id = id
    end

    def filenames_with_added_lines
      diff.filenames_with_added_lines
    end

    def add_comment(file, line, text)
      return unless diff.added_line?(file, line)
      return if already_commented?(file, line, text)

      post_comment(file, line, text)
    end

    private

    def already_commented?(file, line, text)
      file_comments(file).detect do |comment|
        comment['anchor']['line'] == line && comment['text'] == text
      end
    end

    def file_comments(file)
      @file_comments ||= {}
      @file_comments[file] ||= get("/comments?path=#{file}")['values']
    end

    def post_comment(file, line, text)
      data = {
        text: text,
        anchor: {
          path: file,
          line: line,
          lineType: 'ADDED'
        }
      }

      logger.info(%(Commenting #{file}, line #{line}: "#{text}"...))
      post('/comments', data)
    end

    def diff
      @diff ||= Diff.new(get('/diff?withComments=false'))
    end

    def get(path)
      @server.get(endpoint + path)
    end

    def post(path, data)
      @server.post(endpoint + path, data)
    end

    def endpoint
      "/projects/#{@project}/repos/#{@repo}/pull-requests/#{@id}"
    end

    def logger
      @server.logger
    end
  end
end
