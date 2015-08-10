require 'test_helper'

class PullRequestTest < Minitest::Test
  PULL_REQUEST_ENDPOINT = 'http://guest:12345@stash.local/rest/api/1.0/projects/baymax/repos/firmware/pull-requests/13'
  HEADERS = {'Content-Type' => 'application/json'}

  def setup
    logger = Logger.new('/dev/null')
    server = Stash::Server.new('http://stash.local', 'guest', '12345', logger)
    repository = server.repository('baymax', 'firmware')
    @pull_request = repository.pull_request(13)

    stub_request(:get, "#{PULL_REQUEST_ENDPOINT}/diff?withComments=false")
      .to_return(status: 200, headers: HEADERS, body: File.read('test/fixtures/diff.json'))
    stub_request(:get, "#{PULL_REQUEST_ENDPOINT}/comments?path=Gemfile").to_return(status: 200, headers: HEADERS, body: '{"values": []}')
    stub_request(:post, "#{PULL_REQUEST_ENDPOINT}/comments").to_return(status: 200, headers: HEADERS, body: '{}')
  end

  def test_add_comment
    @pull_request.add_comment('Gemfile', 3, 'This line is unnecessary.')
  end
end
