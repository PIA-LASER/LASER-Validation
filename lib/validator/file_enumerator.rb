
module Validator

  class FileEnumerator

    include Enumerable

    def initialize(path)
      raise ArgumentError, "Could not find file #{path}" unless File.exists?(path)
      @file = File.open(path)
    end

    def each(&blk)
      @file.each_line(&blk)
    end

  end
end

