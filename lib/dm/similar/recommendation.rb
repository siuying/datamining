module Dm
  module Similar
    class Recommendation
      # find others people that most similar to specified person
      def top_matches(data, key, n = 5, metric = Pearson.new)
        raise StandardError.new("n must be positive integer") if n < 1

        others = data.keys - [key]
        scores = others.collect do |other|
          [metric.distance(data, key, other), other]
        end

        # sort and reverse the array
        scores.sort!
        scores.reverse!

        # return n best matches record
        scores[0..n-1]
      end

      # get recommended items: items not rated and likely rate highly by this person  
      # based on similarity of this person to others and their rating
      def get_recommendation(data, key, metric = Pearson.new)
        totals = {}
        sim_sums = {}

        others = data.keys - [key]
        others.each do |other|
          sim = metric.distance(data, key, other)

          # only check others with similarity > 0
          if sim > 0
            data[other].each do |item, score|
              # only check item not rated by me
              if data[key][item].nil? or data[key][item] == 0
                totals[item] = 0 if totals[item].nil?
                sim_sums[item] = 0 if sim_sums[item].nil?

                totals[item] += score * sim
                sim_sums[item] += sim
              end
            end
          end
        end

        rankings = totals.collect do |item, score|
          [score/sim_sums[item], item] 
        end
        rankings.sort!
        rankings.reverse!
      end

      # calculate the item similarity scores for each items with each other items
      # used for item based filtering
      def calculate_similar_items(data, n=10, metric = Pearson.new)
        result = {}

        item_prefs = Dm::Similar::transform_pref(data)

        c = 0
        item_prefs.each do |item, similar|
          c += 1

          # print a counter for progress report (for large database)
          puts "#{c} / #{item_prefs.size}" if c%100 == 0

          # find score for similar item
          result[item] = top_matches(item_prefs, item, n, metric)
        end

        result
      end

      # recommended items base on item based filtering
      def get_recommended_items(data, item_sim, user)
        user_rating = data[user]
        scores = {}
        total_sim = {}

        user_rating.each do |item, rating|
          item_sim[item].each do |similarity, item2|
            if user_rating[item2].nil?
              # weighted sum of rating times similarity
              scores[item2] ||= 0
              scores[item2] += similarity*rating

              # sum of all similarities
              total_sim[item2] ||= 0
              total_sim[item2] += similarity
            end
          end
        end

        rankings = scores.collect do |item, score|
          [score/total_sim[item], item]
        end
        rankings.sort!
        rankings.reverse!       
      end
    end
  end
end