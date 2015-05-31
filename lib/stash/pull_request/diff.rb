module Stash
  class PullRequest
    class Diff
      def initialize(diff)
        @diff = diff
      end

      def added_line?(file, line)
        added_lines(file).include?(line)
      end

      private

      def added_lines(file)
        @added_lines ||= {}
        @added_lines[file] ||= begin
          file_diff(file)['hunks'].map do |hunk|
            hunk['segments'].select{|segment| segment['type'] == 'ADDED' }.map do |segment|
              segment['lines'].map do |line|
                line['destination']
              end
            end
          end.flatten
        end
      end

      def file_diff(file)
        @diff['diffs'].detect{|diff| diff['destination'] && diff['destination']['toString'] == file } || {'hunks' => []}
      end
    end
  end
end
