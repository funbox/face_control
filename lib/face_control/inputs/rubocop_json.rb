require 'json'
require 'comment'

module FaceControl
  module Inputs
    class RubocopJson
      attr_accessor :filename

      def initialize(filename = 'rubocop.json')
        self.filename = filename

        fail "#{filename} does not exist" unless File.exist?(filename)
      end

      def comments
        report['files'].map do |file|
          file['offenses'].map do |offense|
            Comment.new(
              file: file['path'],
              line: offense['location']['line'],
              text: offense['message']
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
