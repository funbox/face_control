class Comment
  attr_accessor :file, :line, :text

  def initialize(file:, line:, text:)
    self.file = file
    self.line = line
    self.text = text
  end
end
