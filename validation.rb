#!/usr/bin/env ruby

$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')

require 'optparse'
require 'validator'

options = {}

OptionParser.new do |opts|
  opts.banner = 'Usage: -r [recommendations_file] -s [samples_file]'

  opts.on('-r', '--recommendations RECOMMENDATIONS', 'The recommendations file') do |rec_file|
    options[:recommendations_file] = rec_file
  end

  opts.on('-s', '--samples SAMPLES', 'The samples file') do |samples_file|
    options[:samples_file] = samples_file
  end

  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end.parse!

puts options.inspect
