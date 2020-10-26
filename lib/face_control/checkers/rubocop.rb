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
          *.jbuilder
          *.rake
          *.rb
          *.ru
          Capfile
          Gemfile
          Rakefile
          Vagrantfile
        )
      end

      def command(filenames)
        "rubocop --parallel --format json #{filenames}"
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

        text << " — #{offense['cop_name']}"
      end

      def style_guide_url(offense)
        cop_name = offense['cop_name']
        config = ::RuboCop::ConfigLoader.default_configuration
        ::RuboCop::Cop::MessageAnnotator.new(config, cop_name, config.for_cop(cop_name), {}).urls.first
      end
    end
  end
end
