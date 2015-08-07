require 'test_helper'
require 'face_control/checker_runner'

class TestChecker
  def relevant_globs
    %w(*.rb Rakefile)
  end
end

class CheckerRunnerTest < Minitest::Test
  def setup
    @runner = FaceControl::CheckerRunner.new(TestChecker, %w(config/file.yml Rakefile assets/foo.coffee lib/foo.rb))
  end

  def test_relevant_filenames
    assert_equal %w(lib/foo.rb Rakefile), @runner.send(:relevant_filenames)
  end
end
