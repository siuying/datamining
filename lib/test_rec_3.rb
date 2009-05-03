require 'dm/similar'
require 'yaml'

data = YAML.load(File.open("../config/data.yml"))

rec = Dm::Similar::Recommendation.new

items = rec.calculate_similar_items(data, 10, Dm::Similar::EuclideanDistance.new)
#puts items["Lady in the Water"].inspect

rec_items = rec.get_recommended_items(data, items, "Toby")
puts rec_items.inspect


