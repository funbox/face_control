require 'json'
require 'face_control/comment'

module FaceControl
  module Inputs
    class RubocopJson
      attr_accessor :ignored_severities, :filename

      def initialize(ignored_severities = [], filename = 'rubocop.json')
        self.ignored_severities = ignored_severities
        self.filename = filename

        fail "#{filename} does not exist" unless File.exist?(filename)
      end

      def comments
        report['files'].map do |file|
          file['offenses'].reject do |offense|
            ignored_severities.include?(offense['severity'])
          end.map do |offense|
            Comment.new(
              file: file['path'],
              line: offense['location']['line'],
              text: text(offense)
            )
          end
        end.flatten
      end

      private

      def report
        JSON.parse(File.read(filename))
      end

      def text(offense)
        offense['message']
      end
    end
  end
end
