module FaceControl
  class Comment
    attr_accessor :file, :line, :text

    def initialize(options)
      self.file = options.fetch(:file)
      self.line = options.fetch(:line)
      self.text = options.fetch(:text)
    end
  end
end
