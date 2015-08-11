require 'json'
require 'face_control/comment'

module FaceControl
  module Checkers
    class CoffeeLint
      def relevant_globs
        %w(*.coffee)
      end

      def command(filenames)
        "coffeelint --reporter raw #{filenames}"
      end

      def parse(command_output)
        JSON.parse(command_output).map do |file, problems|
          problems.map do |problem|
            Comment.new(
              file: file,
              line: problem['lineNumber'],
              text: "(#{problem['level']}) #{problem['message']}"
            )
          end
        end
      end
    end
  end
end
