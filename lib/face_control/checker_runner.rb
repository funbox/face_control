module FaceControl
  class CheckerRunner
    def initialize(checker_class, filenames = [], options = {})
      @checker = checker_class.new
      if @checker.respond_to?(:options=)
        @checker.options = options
      end

      @filenames = filenames
    end

    def comments
      return [] if relevant_filenames.empty?

      report = `#{@checker.command(relevant_filenames.join(' '))}`
      return [] if report.strip.empty?

      @checker.parse(report)
    end

    private

    def relevant_filenames
      return @filenames unless @checker.respond_to?(:relevant_globs)

      @relevant_filenames ||= @checker.relevant_globs.map do |glob|
        @filenames.select do |filename|
          File.fnmatch?(glob, filename)
        end
      end.flatten.uniq
    end
  end
end
