require "redis"

threshold = 0

ARGV.each do |arg|
	threshold = arg.to_i
end

con = Redis.new(:host => "master", :db => 0)

users = con.keys('users.*')

users = users.map do |user|
	user.gsub("users.","")
end

total_filtered = 0
total_raw = 0

users.each do |id|
	rec = con.zrange("users."+id,0,-1, withscores: true)
	links = con.lrange("user."+id+".links",0,-1)	

	rec_filtered = []	

	rec.each do |pref|
		if pref[1].to_f > threshold
			rec_filtered << pref
		end	
	end	
	
	total_raw += (rec.count.to_f / links.count.to_f)
	total_filtered += (rec_filtered.count.to_f / links.count.to_f)
end

puts "Ratio of number of recommended items and already known items. (recommended/known). Averaged over all users."
puts "unfiltered: " + (total_raw / users.count).to_s
puts "filtered (threshold: " + threshold.to_s + "): " + (total_filtered / users.count).to_s
