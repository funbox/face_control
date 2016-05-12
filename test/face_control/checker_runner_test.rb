require 'test_helper'

class CheckerWithoutGlobs
end

class CheckerWithGlobs
  def relevant_globs
    %w(*.rb Rakefile)
  end
end

class CheckerRunnerTest < Minitest::Test
  def test_relevant_filenames_without_globs
    runner = FaceControl::CheckerRunner.new(CheckerWithoutGlobs, %w(config/file.yml lib/foo.rb))
    assert_equal %w(config/file.yml lib/foo.rb), runner.send(:relevant_filenames)
  end

  def test_relevant_filenames_with_globs
    runner = FaceControl::CheckerRunner.new(CheckerWithGlobs, %w(config/file.yml Rakefile assets/foo.coffee lib/foo.rb))
    assert_equal %w(lib/foo.rb Rakefile), runner.send(:relevant_filenames)
  end
end
