module Pansophy
  module Helpers
    class PathBuilder
      def initialize(file, source_dir, destination_dir)
        @file            = file
        @source_dir      = source_dir
        @destination_dir = destination_dir
      end

      def destination_path
        @destination_dir.pathname.join(file_source_relative_path)
      end

      private

      def file_source_relative_path
        return @file.pathname if @source_dir.pathname.to_s.empty?
        @file.pathname.sub(::File.join(@source_dir.pathname, '/'), '')
      end
    end
  end
end