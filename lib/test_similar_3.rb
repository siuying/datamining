require 'dm/similar'
require 'yaml'

data = YAML.load(File.open("../config/data.yml"))
#metric = Dm::Similar::Pearson.new

similar = Dm::Similar::Similarity.new
puts similar.top_matches(data, "Toby", 3).inspect