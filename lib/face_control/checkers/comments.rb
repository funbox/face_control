require 'face_control/comment'

module FaceControl
  module Checkers
    class Comments

      def command(filenames)
        "grep -inEH '(todo|fixme)' #{filenames}"
      end

      def parse(command_output)
        command_output.lines.map do |line|
          file, line_num = line.split(":", 3)
          Comment.new(
            file: file,
            line: line_num.to_i,
            text: "Do not bury this task in code. Do it now or create a JIRA issue."
          )
        end
      end
    end
  end
end
