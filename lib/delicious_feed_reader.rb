require 'open-uri'
require 'rubygems'
require 'json/ext'
require 'digest/md5'
require 'nokogiri'

# This is mainly for doing data crunching with delicious
# For example, determining who has similar links to you.
class DeliciousFeedReader

	DELICIOUS = "http://feeds.delicious.com/v2"

	# Pass in a tag to get the most popular links for that tag
	# Takes a string, returns a hash
	def get_popular(tag)
		get("popular/#{tag}")
	end

	# Pass in a url to get a list of the bookmarks for it
	# This is mainly for use with building a list of people
	# Takes a url as a string, returns a hash
	def get_url(url)
		url = url.is_a?(Hash) ? url['u'] : url
		get("url/#{Digest::MD5.hexdigest(url)}", "rss")
	end

	# Pass in a user name to get a list of their bookmarks
	# Takes a string, returns a hash
	def get_user(user)
		get(user)
	end

	private

	# Delicious JSON feeds don't include user name,
	# so we must allow the option of using xml/rss,
	# but prefer JSON since it's faster
	def get(path, format="json")
		url = "#{DELICIOUS}/#{format}/#{path}"
		response = interact_with_api(url)
		format == "json" ? JSON.parse(response) : delicious_xml(response)
	end

	def interact_with_api(url)
		tries = 3
		tries.times do
			begin
				STDERR.puts "Opening Delicious: #{url}"
				return open(url, 'User-agent' => 'ruby/delicious_rec.rb').read
				break
			rescue Exception => e
				puts "Delicious Error: #{e}.  Retrying: (#{url})"
				sleep(4)
			end
		end
		raise "Couldn't connect to Delicious server"
	end

	def delicious_xml(xml)
		doc = Nokogiri::XML(xml)

		(doc./"item").map do |item|
			hsh = fill_hash(item)
			hsh['user'] = extract_user(hsh['title'])
			hsh
		end
	end

	def fill_hash(item)
		['title', 'pubDate', 'link'].inject({}) do |hash, element|
			hash[element] = item.at(element).inner_html
			hash
		end
	end

	def extract_user(title)
	# hmmm... need to get the user...
		if (userdata = title.match(/\[from (.*)\]/).captures).any?
		  userdata.first
		end
	end

end