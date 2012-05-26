require 'stringio'

module Validator

  class FileReader

    def initialize(path)
      raise ArgumentError unless File.exists?(path)
      @file = File.open(path)
    end

    def seek(matcher)
      filesize = @file.stat.size
      buffer_size = 1024000

      @file.rewind

      while @file.tell <= filesize
        @file.seek(-512, File::SEEK_CUR) if @file.tell > 0
        buffer = @file.read(buffer_size)
        if match = buffer.match(matcher)
          return match[0]
        end
      end

      ""
    end

  end
end
