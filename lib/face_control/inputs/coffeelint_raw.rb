require 'json'
require 'comment'

module FaceControl
  module Inputs
    class CoffeeLintRaw
      attr_accessor :filename

      def initialize(filename = 'coffeelint_report.json')
        self.filename = filename

        fail "#{filename} does not exist" unless File.exist?(filename)
      end

      def comments
        report.map do |file, problems|
          problems.map do |problem|
            Comment.new(
              file: file,
              line: problem['lineNumber'],
              text: "(#{problem['level']}) #{problem['message']}"
            )
          end
        end.flatten
      end

      private

      def report
        JSON.parse(File.read(filename))
      end
    end
  end
end
