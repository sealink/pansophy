module Pansophy
  module Remote
    class Directory
      include Adamantium::Flat

      def initialize(bucket_name, path = nil)
        @bucket_name = bucket_name
        @path        = path.to_s
        verify_bucket!
      end

      def pathname
        Pathname.new(@path)
      end
      memoize :pathname

      def files
        remote_files.map { |file| File.new(file) }
      end

      def create(options)
        remove(options)
        directory.files.create(key: pathname.cleanpath.to_s + '/')
      end

      def create_file(path, body, options = {})
        CreateFile.new(@bucket_name, pathname.join(path), body).call(options)
      end

      private

      def directory
        Pansophy.connection.directories.get(@bucket_name, prefix: @path)
      end
      memoize :directory

      def remote_files
        remote_entries.select { |file| !directory?(file) }
      end

      def remote_entries
        directory.files
      end

      def directory?(file)
        file.key.end_with?('/')
      end

      def verify_bucket!
        return unless directory.nil?
        fail ArgumentError, "Could not find bucket #{@bucket_name}"
      end

      def remote_entry
        remote_entries.find { |entry|
          Pathname.new(entry.key).cleanpath == pathname.cleanpath
        }
      end
      memoize :remote_entry

      def exist?
        !remote_entry.nil?
      end

      def remove(options)
        return unless exist?
        prevent_overwrite! unless options[:overwrite]
        remote_entries.each(&:destroy)
      end

      def prevent_overwrite!
        fail ArgumentError,
             "#{pathname} already exists, pass ':overwrite => true' to overwrite"
      end
    end
  end
end
