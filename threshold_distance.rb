require "redis"

threshold = 0.0000000001

f = File.open("/Users/dominik/Desktop/maaaaan", "r")
recs = {}

f.each_line do|line|
  prefs = line.strip!.split(",")

  user_id = prefs[0].to_i
  item_id = prefs[1].to_i
  pref = prefs[2].to_f

  if(recs[user_id].nil?)
    recs[user_id] = {item_id => pref}
  else
    recs[user_id][item_id] = pref
  end
end


ARGV.each do |arg|
	threshold = arg.to_i
end



total = 0

recs.each_pair do |user_id, prefs|
	rec_bigger = []	
	rec_smaller = []

	prefs.each_pair do |item_id, pref|
		if pref > threshold
			rec_bigger << pref
		else
			rec_smaller << pref
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
puts total / recs.count.to_f
