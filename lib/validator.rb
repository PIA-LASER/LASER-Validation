$LOAD_PATH << File.dirname(__FILE__)

require 'validator/file_reader'
require 'validator/file_enumerator'

module Validator

  class ValidationRunner

    def initialize(options)
      @recommendations = FileEnumerator.new(options[:recommendations])
      @category_reader = FileReader.new(options[:categories])
      @samples = FileReader.new(options[:samples])
    end

    def validate
      @recommendations.each do |line|
        userID, itemID, preference = line.split(",").map { |el| el.strip }
        categories = lookup_categories(itemID)
        cat_prefs = categories.map do |categoryID|
          { :id => categoryID, :pref => lookup_category_pref(userID, categoryID) }
        end

        puts "User: #{userID} item: #{itemID} pref: #{preference} categories: #{cat_prefs.inspect}"
      end
    end

    private

    def lookup_categories(itemID)
      @category_reader.seek(/^\s*#{itemID}/).split(",").map { |el| el.strip }
    end

    def lookup_category_pref(userID, categoryID)
      @samples.seek(/^\s*#{userID}/).split(",").map { |el| el.strip }[categoryID]
    end

  end

end
