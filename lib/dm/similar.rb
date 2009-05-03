module Dm
  module Similar
    # Distance Metric base class
    class MetricBase
      def distance(data, user1, user2)
      end

      def shared_items(data1, data2)
        # select items shared by both data set
        data1.select(){|key,val| data2[key] }.collect(){|key,val| key }
      end
    end

    # Implement Euclidean Distance
    class EuclideanDistance < MetricBase
      def distance(data, user1, user2)
        data1 = data[user1]
        data2 = data[user2]
        shared_keys = shared_items(data1, data2)

        # if no rating in commin, return 0
        return 0 if shared_keys.length == 0

        # Add up the squares of all the difference
        sum_of_squares = shared_keys.inject(0) do |sum, key|
          sum + (data1[key] - data2[key])**2
        end

        1.0 / (1.0 + Math.sqrt(sum_of_squares))
      end
    end

    # Implement Pearson Correlation Score
    class Pearson < MetricBase
      def distance(data, user1, user2)
        data1 = data[user1]
        data2 = data[user2]
        shared_keys = shared_items(data1, data2)

        # if no rating in commin, return 0
        len = shared_keys.length
        return 0 if len == 0

        # find the sum of preferences
        sum1 = shared_keys.inject(0){|sum, key| sum + data1[key] }
        sum2 = shared_keys.inject(0){|sum, key| sum + data2[key] }

        # sum up the squares
        sum1sq = shared_keys.inject(0){|sum, key| sum + data1[key]**2 }
        sum2sq = shared_keys.inject(0){|sum, key| sum + data2[key]**2 }

        # sum up the products
        pSum = shared_keys.inject(0){|sum, key| sum + (data1[key]*data2[key]) }


        # Calculate Pearson score
        num = pSum - (sum1*sum2/len)
        den = Math.sqrt((sum1sq - (sum1**2)/len) * (sum2sq - (sum2**2)/len))
        return 0 if den == 0

        num / den
      end
    end

    
  end
end