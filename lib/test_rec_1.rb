require 'dm/similar'
require 'yaml'

data = YAML.load(File.open("../config/data.yml"))

rec = Dm::Similar::Recommendation.new


puts "Pearson:   " + rec.get_recommendation(data, "Toby", Dm::Similar::Pearson.new).inspect
puts "Euclidean: " + rec.get_recommendation(data, "Toby", Dm::Similar::EuclideanDistance.new).inspect