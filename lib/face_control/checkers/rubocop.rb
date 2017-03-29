# encoding: UTF-8

require 'json'
require 'rubocop'
require 'face_control/comment'

module FaceControl
  module Checkers
    class RuboCop
      attr_writer :options

      def relevant_globs
        %w(
          *.gemspec
          *.rb
          *.rake
          Capfile
          Gemfile
          Rakefile
          Vagrantfile
        )
      end

      def command(filenames)
        "rubocop --format json #{filenames}"
      end

      def parse(command_output)
        JSON.parse(command_output)['files'].map do |file|
          file['offenses'].reject do |offense|
            ignored_severities.include?(offense['severity'])
          end.map do |offense|
            Comment.new(
              file: file['path'],
              line: offense['location']['line'],
              text: text(offense, file)
            )
          end
        end
      end

      private

      def ignored_severities
        @options.fetch(:ignored_severities, [])
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
        config = ::RuboCop::ConfigLoader.default_configuration
        ::RuboCop::Cop::MessageAnnotator.new(config, config.for_cop(cop_name), {}).urls.first
      end

      def can_be_autocorrected?(offense)
        !offense['corrected'].nil?
      end
    end
  end
end
