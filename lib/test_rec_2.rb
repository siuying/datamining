require 'dm/similar'
require 'yaml'

data = YAML.load(File.open("../config/data.yml"))

data_r = Dm::Similar.transform_pref(data)

rec = Dm::Similar::Recommendation.new
puts rec.top_matches(data_r, "Superman Returns").inspect
puts rec.get_recommendation(data_r, "Just My Luck").inspect