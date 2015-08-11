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

      @checker.parse(`#{@checker.command(relevant_filenames.join(' '))}`)
    end

    private

    def relevant_filenames
      @relevant_filenames ||= @checker.relevant_globs.map do |glob|
        @filenames.select do |filename|
          File.fnmatch?(glob, filename)
        end
      end.flatten.uniq
    end
  end
end
