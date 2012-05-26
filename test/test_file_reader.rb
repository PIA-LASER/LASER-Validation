$LOAD_PATH << File.dirname(__FILE__)

require 'rubygems'
require 'helper'

class TestInstanceManager < MiniTest::Unit::TestCase
  include Validator

  def setup
    @reader = FileReader.new(SEEK_FILE)
  end

  def test_seek
    [1000, 5000, 10000, 100000, 8000000].each do |number|
      read_start = Time.now
      matcher = /^#{number}(\s+\w+){4}$/
      result = @reader.seek(matcher)
      duration = Time.now - read_start
      puts "Reading #{number} took: #{duration}"
      assert_equal("#{number} asdf hjkl dododododo asasasasasasasasasasasa", result)
    end
  end

  def test_reverse
    [1000, 5000, 10000, 100000, 8000000].reverse.each do |number|
      read_start = Time.now
      matcher = /^#{number}(\s+\w+){4}$/
      result = @reader.seek(matcher)
      duration = Time.now - read_start
      assert_equal(result, "#{number} asdf hjkl dododododo asasasasasasasasasasasa")
    end
  end

end
