require 'delicious_feed_reader'

module Dm
  module Similar
    class DeliciousRec
      attr_accessor :users
      attr_reader :all_items
      
      def initialize
        @delicious = DeliciousFeedReader.new
        @users = {}
        @all_items = {}
      end

      # initialize a user database, with top 5 links on a popular tag
      def init_user(tag, count=5)
        @users = {}
        @delicious.get_popular(tag)[0,count].each do |bookmark|
           @delicious.get_url(bookmark["u"]).each do |url|
             @users[url["user"]] = {}
           end
        end
        @users
      end

      def fill_items
        @all_items = {}

        # find links posted by all users
        @users.keys.each do |user|
          posts = []

          # download user posts, retry up to 3 times (in case of API block us)
          (1..3).each do
            begin
              posts = @delicious.get_user(user)
              break
            rescue StandardError => e
              # try again after 4 seconds
              sleep(4)
            end
          end

          # parse tags
          posts.each do |post|
            url = post["u"]
            @users[user] ||= {}
            @users[user][url] = 1.0
            @all_items[url] = 1
          end         
        end


        # fill missing items with 0
        @users.each do |user, items|
          @all_items.keys.each do |url|
            unless items[url]
              items ||= {}
              items[url] = 0.0
            end
          end
        end        
      end
    end
  end
end