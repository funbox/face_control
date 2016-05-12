require 'test_helper'

class CheckerWithoutGlobs
end

class CheckerWithGlobs
  def relevant_globs
    %w(*.rb Rakefile)
  end
end

class CheckerWithEmptyReport
  def command(*)
    'echo " \n "'
  end

  def parse(*)
    fail NotImplementedError, 'There is nothing to parse!'
  end
end

class CheckerWithReport
  def command(*)
    "echo 'Houston, we have a problem!'"
  end

  def parse(command_output)
    command_output.split
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

  def test_not_parsing_empty_report
    runner = FaceControl::CheckerRunner.new(CheckerWithEmptyReport, %w(README))
    assert_equal [], runner.comments
  end

  def test_parsing_report
    runner = FaceControl::CheckerRunner.new(CheckerWithReport, %w(README))
    assert_equal %w(Houston, we have a problem!), runner.comments
  end
end
