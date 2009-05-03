module Dm
  module Similar
    class Similarity
      def top_matches(data, person, n = 5, metric = Pearson.new)
        raise StandardError.new("n must be positive integer") if n < 1

        others = data.keys - [person]
        scores = others.collect do |other|
          [metric.distance(data, person, other), other] 
        end

        # sort and reverse the array
        scores.sort!
        scores.reverse!

        # return n best matches record
        scores[0..n-1]
      end
    end
  end
end