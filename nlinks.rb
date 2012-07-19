require "redis"

threshold = 0

f = File.open("", "r")
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
f.close

f = File.open("", "r")
links = {}

f.each_line do|line|
  line = line.strip!.split(",")

  user_id = line[0].to_i
  item_id = line[1].to_i
  pref = line[2].to_f

  if(links[user_id].nil?)
    links[user_id] = {item_id => pref}
  else
    links[user_id][item_id] = pref
  end
end
f.close

ARGV.each do |arg|
	threshold = arg.to_i
end

total_filtered = 0
total_raw = 0

recs.each_pair do |user_id, pref|
  recommendation_count = recs[user_id].count
  link_count = links[user_id].count

	rec_filtered = []	

  pref.each_pair do |item_id, pref_val|
    if pref_val > threshold
      rec_filtered << pref_val
    end
  end
	
	total_raw += (recommendation_count.to_f / link_count.to_f)
	total_filtered += (rec_filtered.count.to_f / link_count.to_f)
end

puts "Ratio of number of recommended items and already known items. (recommended/known). Averaged over all users."
puts "unfiltered: " + (total_raw / links.count).to_s
puts "filtered (threshold: " + threshold.to_s + "): " + (total_filtered / links.count).to_s
