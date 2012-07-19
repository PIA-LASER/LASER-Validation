$LOAD_PATH << File.dirname(__FILE__)

require 'validator/file_reader'
require 'validator/file_enumerator'

module Validator

  class ValidationRunner

    def initialize(options)
      @recommendations = FileEnumerator.new(options[:recommendations])
      @category_reader = FileReader.new(options[:categories])
      @samples = FileReader.new(options[:samples])
      @validations = { }
      @threshold = options[:threshold].to_f
    end

    def validate
      load_user_prefs
      puts overall_precision

      sorted_user_precision
    end

    private

    def load_user_prefs
	index = 0
      @recommendations.each do |line|
	puts index
	index += 1
        add_user_pref(line)
		
      end
    end

    def overall_precision
      valid = 0
      invalid = 0
      @validations.each do |user, val|
        valid += val[:valid].length.to_f
        invalid += val[:invalid].length.to_f
      end

      valid / (valid + invalid)
    end

    def sorted_user_precision
      vals = @validations.keys.map do |userID|
        valid = 0
        invalid = 0
        val = @validations[userID]
        valid += val[:valid].length.to_f
        invalid += val[:invalid].length.to_f
        { :userID => userID, :precision => valid / (valid + invalid) }
      end

      vals.sort { |a, b| a[:precision] <=> b[:precision] }
    end

    def add_user_pref(line)
      userID, itemID, preference = line.split(",").map { |el| el.strip }

      if preference.to_f < @threshold
        #puts "had: " + preference
        return
      end

      @validations[userID] ||= { :valid => [], :invalid => [] }

      categories = lookup_categories(itemID)
      categories.each do |categoryID|
        if lookup_category_pref(userID, categoryID) > 0
          @validations[userID][:valid] << itemID
        else
          @validations[userID][:invalid] << itemID
        end
      end
  
      if userID == "0" 
        puts @validations[userID].inspect
      end
    end

    def lookup_categories(itemID)
      category_line = @category_reader.seek(/^\s*#{itemID}.*/)

      split_line = category_line.split(/\s/)
      category_amount = split_line.length - 1
      categories = split_line.last(category_amount).map { |el| el.strip }
    end

    def lookup_category_pref(userID, categoryID)
      categoryID = categoryID.to_i
      category_line = @samples.seek(/^\s*#{userID},.*/)

      category_line.split(",").map { |el| el.to_f }[categoryID + 1]
    end

  end

end
