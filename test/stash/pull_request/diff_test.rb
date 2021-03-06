require 'test_helper'

class DiffTest < Minitest::Test
  def setup
    diff = JSON.parse(File.read('test/fixtures/diff.json'))
    @diff = Stash::PullRequest::Diff.new(diff)
  end

  def test_filenames_with_added_lines
    assert_equal %w(
      Gemfile
      lib/batman-rails/version.rb
      lib/templates/batman/html/index.html
      lib/templates/batman/main_controller.coffee
      test/fixtures/application.js.coffee
    ), @diff.filenames_with_added_lines
  end
end
