require 'rubygems'
require 'net/https'
require 'uri'
require 'json'
require 'domainatrix'
require 'date'
require 'yaml/store'
require 'yaml'

require 'jekyll'

desc "Sync Blogger comments"
task :bloggercomments do
	site              = Jekyll.configuration({})
	commentsdirectory = '_comments/'
	jekyll_site       = Jekyll::Site.new(site)

	jekyll_site.reset
	jekyll_site.read
	jekyll_site.generate

	jekyll_site.posts.each do |post|
		if post.data['published'] == 'false' or post.data['comments'] == 'false'
			next
		end
	
		post_id   = post.id()
		post_date = post.date()
		post_file = commentsdirectory + post_date.strftime('%Y-%m-%d-') + post.slug()
	
		link  = '##'
	
		unless post.data['blogger'] and ( post.data['blogger']['siteid'] or site['blogger']['siteid'] )
			next
		end
		blogger_siteid = post.data['blogger']['siteid'] || site['blogger']['siteid']
	
		unless post.data['blogger'] and post.data['blogger']['postid'] and blogger_siteid
			next
		end
	
		uri = "http://www.blogger.com/feeds/#{blogger_siteid}/#{post.data['blogger']['postid']}/comments/default/?alt=json"
		url = URI.parse(uri)
		http = Net::HTTP.new(url.host, url.port)
		request = Net::HTTP::Get.new(url.request_uri)
		response = http.request(request)
	
		unless response.code == "200" then
			warn "Comments feed not found: #{post_id}"
		end
	
		if response.code == "200" then
			json_rep = JSON.parse(response.body)
	
			if json_rep['feed'] and json_rep['feed']['entry'] and json_rep['feed']['entry'].length > 0 then
	
				comments = json_rep['feed']['entry'].reverse
	
				comments.each do |comment|
					author  = comment['author'][0].clone
					comments_date = DateTime.parse(comment['published']['$t'])
					comments_file = comments_date.strftime('%Y-%m-%d-%H%M%S')
	
					entry = YAML::Store.new("#{post_file}_#{comments_file}.txt")
					entry.transaction do
						entry['id'] = "c"+comment['id']['$t'].gsub(/tag\:blogger\.com\,1999\:blog\-\d+\.post\-/,'')
						entry['author']            = Hash.new
						if author['uri'] then
							entry['author']['url']   = comment['author'][0]['uri']['$t']
						end
						if comment['author'][0]['email'] then
							entry['author']['email'] = comment['author'][0]['email']['$t']
						else
							entry['author']['email'] = 'noreply@blogger.com'
						end
						if author['gd$image']['src'] then
							entry['author']['image'] = comment['author'][0]['gd$image']['src']
						end
						entry['author']['name']    = comment['author'][0]['name']['$t']
						entry['content']           = comment['content']['$t']
						entry['title']             = comment['title']['$t']
						entry['date']              = DateTime.parse(comment['published']['$t'])
						entry['updated']           = DateTime.parse(comment['updated']['$t'])
						entry['post_id']           = post_id
						entry['source']            = 'Blogger'
					end
				end
			end
		end
	end
end