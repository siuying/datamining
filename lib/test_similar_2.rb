require 'dm/similar'
require 'yaml'

data = YAML.load(File.open("../config/data.yml"))
metric = Dm::Similar::Pearson.new
puts metric.distance(data, "Lisa Rose", "Gene Seymour")
