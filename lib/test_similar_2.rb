require 'dm/similar'
require 'yaml'

data = YAML.load(File.open("../config/data.yml"))
d1 = data["Lisa Rose"]
d2 = data["Gene Seymour"]

eucli = Dm::Similar::Pearson.new

puts eucli.distance(d1, d2)