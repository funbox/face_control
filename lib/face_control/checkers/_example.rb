require 'face_control/comment'

module FaceControl
  module Checkers
    class Example
      # @optional
      # Define only if you use @options in the following methods
      attr_writer :options

      # @return [Array<String>] Shell globs to filter only files relevant to this checker
      #                         out of all files with added lines in the pull request
      def relevant_globs
        %w(bin/*)
      end

      # @param filenames [String] Files with added lines in the pull request
      #                           only relevant to this checker (filtered by globs above)
      # @return [String] Command line to check the files
      def command(filenames)
        "ls -l #{filenames}"
      end

      # @param command_output [String] Stdout of the command above
      # @return Array<FaceControl::Comment> Comments to post to the pull request
      def parse(command_output)
        command_output.split("\n").map do |line|
          fields = line.split

          mode = fields.first
          file = fields.last

          if mode != '-rwxr-xr-x'
            Comment.new(file: file, line: 1, text: 'Invalid file mode')
          end
        end
      end
    end
  end
end
