#!/usr/bin/env ruby

$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')

require 'optparse'
require 'validator'

options = {}

OptionParser.new do |opts|
  opts.banner = 'Usage: -r [recommendations_file] -s [samples_file] -c [categories_file]'

  opts.on('-r', '--recommendations RECOMMENDATIONS', 'The recommendations file') do |rec_file|
    options[:recommendations] = rec_file
  end

  opts.on('-s', '--samples SAMPLES', 'The samples file') do |samples_file|
    options[:samples] = samples_file
  end

  opts.on('-c', '--categories CATEGORIES', 'The categories file') do |categories_file|
    options[:categories] = categories_file
  end

  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end.parse!


validator = Validator::ValidationRunner.new(options)
puts validator.validate
