require 'dm/similar'
require 'yaml'

data = YAML.load(File.open("../config/data.yml"))

data_r = Dm::Similar.transform_pref(data)

puts data_r.inspect
