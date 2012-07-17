require "redis"

threshold = 0.0000000001

ARGV.each do |arg|
	threshold = arg.to_i
end

con = Redis.new(:host => "master", :db => 0)

users = con.keys('users.*')

users = users.map do |user|
	user.gsub("users.","")
end

total = 0

users.each do |id|
	rec = con.zrange("users."+id,0,-1, withscores: true)

	rec_bigger = []	
	rec_smaller = []

	rec.each do |pref|
		if pref[1].to_f > threshold
			rec_bigger << pref[1].to_f
		else
			rec_smaller << pref[1].to_f
		end	
	end	
	
	sum_bigger = rec_bigger.inject(0){|sum,x| sum + x}
	sum_smaller = rec_smaller.inject(0){|sum, x| sum + x}
	
	avg_bigger = sum_bigger / rec_bigger.count.to_f
	avg_smaller = sum_smaller / rec_smaller.count.to_f

	distance = avg_bigger - avg_smaller
	total += distance
end

puts "Distance between filtered and kept recommendations."
puts total / users.count.to_f
