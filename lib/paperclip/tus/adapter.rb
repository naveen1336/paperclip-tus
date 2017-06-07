require 'paperclip'
require 'tus-server'

module Paperclip
  module Tus
    class Adapter < Paperclip::AbstractAdapter
      REGEXP = /\A[\da-f]{32}\Z/

      def initialize(target)
        ensure_tus_filesystem_storage!

        @uid = target
        @file_path = tus_file_path.to_s
        @info = tus_info
        cache_current_values
      end

      private

      def cache_current_values
        self.original_filename = @info.metadata['filename']
        @tempfile = copy_to_tempfile(@file_path)
        @content_type = Paperclip::ContentTypeDetector.new(@file_path).detect
        @size = @info.length
      end

      def tus_info
        ::Tus::Info.new(tus_storage.read_info(@uid))
      end

      def tus_file_path
        # FIXME: private method
        tus_storage.send(:file_path, @uid)
      end

      def tus_storage
        ::Tus::Server.opts[:storage]
      end

      def ensure_tus_filesystem_storage!
        return if tus_storage.class == ::Tus::Storage::Filesystem

        raise 'Paperclip tus adapter does not support ' \
          "#{tus_storage.class.name}! Please set Tus::Server.opts[:storage] " \
          'to Tus::Storage::Filesystem.new(cache_directory)'
      end

      def copy_to_tempfile(src_path)
        FileUtils.cp(src_path, destination.path)
        destination
      end
    end
  end
end

Paperclip.io_adapters.register Paperclip::Tus::Adapter do |target|
  target.is_a?(String) && target =~ Paperclip::Tus::Adapter::REGEXP
end
