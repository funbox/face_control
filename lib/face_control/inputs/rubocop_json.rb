require 'json'
require 'rubocop'
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
              text: text(offense, file)
            )
          end
        end.flatten
      end

      private

      def report
        JSON.parse(File.read(filename))
      end

      def text(offense, file)
        text = offense['message']

        if (link = style_guide_url(offense))
          text << " — [Guide](#{link})"
        end

        if can_be_autocorrected?(offense)
          text << " (Run `rubocop -a #{file['path']}` to fix.)"
        end

        text
      end

      def style_guide_url(offense)
        cop_name = offense['cop_name']
        cop_config = RuboCop::ConfigLoader.default_configuration[cop_name]
        cop_config['StyleGuide']
      end

      def can_be_autocorrected?(offense)
        !offense['corrected'].nil?
      end
    end
  end
end
