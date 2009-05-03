require 'dm/similar'

# Retrieve data from delicious, use to create delicious.yml 
del = Dm::Similar::DeliciousRec.new
del.init_user('ruby', 10)
del.users["siuying"] = {}
del.fill_items

f = File.open('../config/delicious.yml', 'w') do |out|
  YAML::dump(del, out)
end

# load data from yml directly, if above code is uncommented, this line should be commented
# del = YAML::load(File.open('../config/delicious.yml'))

rec = Dm::Similar::Recommendation.new

puts rec.top_matches(del.users, "siuying").inspect
puts rec.get_recommendation(del.users, "siuying").inspect