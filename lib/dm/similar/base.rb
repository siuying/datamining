module Dm
  module Similar
    def self.transform_pref(data)
      result = {}

      data.each do |person, items|
        items.each do |item, score|
          result[item] ||= {}
          result[item][person] = score
        end
      end

      result
    end
  end
end