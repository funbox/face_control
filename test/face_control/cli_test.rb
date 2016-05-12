require 'test_helper'

class CLITest < Minitest::Test
  def test_check
    pull_request = OpenStruct.new(filenames_with_added_lines: %w(test/fixtures/foo.rb test/fixtures/commented.rb test/fixtures/foo.coffee))
    logger = Logger.new('/dev/null')
    comments = FaceControl::CLI.new.check(pull_request, %w(foo), logger)
    assert_equal 5, comments.size
  end
end
