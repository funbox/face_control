require 'face_control/comment'

module FaceControl
  module Checkers
    class Comments
      def relevant_globs
        %w(*.rb)
      end

      def command(filenames)
        "grep -inEH '(todo|fixme)' #{filenames}"
      end

      def parse(command_output)
        comments = []
        unless command_output.empty?
          command_output.each_line do |line|
            file, line_num, description = line.split(":", 3)
            comments.push(
              Comment.new(
                file: file,
                line: line_num,
                text: "File includes the annotation keyword: #{description}"
              )
            )
          end
        end
        comments
      end
    end
  end
end
