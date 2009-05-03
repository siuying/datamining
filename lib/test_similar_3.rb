require 'dm/similar'
require 'yaml'

data = YAML.load(File.open("../config/data.yml"))
#metric = Dm::Similar::Pearson.new

rec = Dm::Similar::Recommendation.new
puts rec.top_matches(data, "Toby", 3).inspect