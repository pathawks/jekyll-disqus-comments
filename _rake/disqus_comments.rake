require 'rubygems'
require 'net/https'
require 'uri'
require 'json'
require 'domainatrix'
require 'date'
require 'yaml/store'
require 'yaml'

require 'jekyll'

desc "Sync Disqus comments"
task :disquscomments do
	site = Jekyll.configuration({})

	unless site['comments'] and site['comments']['disqus'] and site['comments']['disqus']['api_key']
		raise 'Disqus API key missing from `_config.yml`'
	end

	commentsdirectory = '_comments/'
	jekyll_site = Jekyll::Site.new(site)

	jekyll_site.reset
	jekyll_site.read
	jekyll_site.generate
	
	if site['comments'] and site['comments']['disqus'] and site['comments']['disqus']['short_name']
		site_disqus_short_name = site['comments']['disqus']['short_name']
	end

	jekyll_site.posts.each do |post|
		if post.data['published'] == 'false' or post.data['comments'] == 'false'
			next
		end
	
		post_id   = post.id()
		post_date = post.date()
		post_file = commentsdirectory + post_date.strftime('%Y-%m-%d-') + post.slug()
		
		if (post.data['comments'].class == 'Array') and (post.data['comments']['disqus'].class == 'Array') and post.data['comments']['disqus']['short_name']
			post_disqus_short_name = post.data['comments']['disqus']['short_name']
		end
	
		unless post_disqus_short_name or site_disqus_short_name
			next
		end
	
		if post.data['comments'] and post.data['comments']['disqus'] and post.data['comments']['disqus']['short_name']
			ident = post.data['comments']['disqus']['postid']
		elsif post.data['blogger'] and post.data['blogger']['postid']
			ident = post.data['blogger']['postid']
		else
			ident = post_id
		end
	
		siteid  = post_disqus_short_name || site_disqus_short_name
		api_key = site['comments']['disqus']['api_key']
	
		uri = "http://disqus.com/api/3.0/threads/listPosts.json?forum=#{siteid}&thread:ident=#{ident}&api_key=#{api_key}&limit=100"
		url = URI.parse(uri)
		http = Net::HTTP.new(url.host, url.port)
		request = Net::HTTP::Get.new(url.request_uri)
		response = http.request(request)
	
		unless response.code == "200" then
			warn "\r\e[33mComments feed not found:\e[0m #{post_id}"
		end
	
		if response.code == "200" then
			json_rep = JSON.parse(response.body)
	
			if json_rep['response'] and json_rep['response'].length > 0 then
	
				comments = json_rep['response']
	
				comments.each do |comment|
					comments_date = DateTime.parse(comment['createdAt'])
					post_created  = comments_date.strftime('%Y-%m-%d %H:%M:%S %z')
					comments_date = comments_date.new_offset('+00:00')
					comments_file = comments_date.strftime('%Y-%m-%d-%H%M%S')

					unless File.exist?("#{post_file}_#{comments_file}.txt")

						entry = YAML::Store.new("#{post_file}_#{comments_file}.txt")
						entry.transaction do
							entry['id']                = 'comment-' + comment['id']
							entry['source']            = 'Disqus'
							entry['date']              = post_created
							entry['updated']           = post_created
							entry['post_id']           = post_id
							entry['author']            = Hash.new
							if true
								if comment['author']['url'] then
										entry['author']['url']   = comment['author']['url']
								end
								if comment['author']['email'] then
									entry['author']['email'] = comment['author']['email']
								else
									entry['author']['email'] = 'noreply@blogger.com'
								end
								if comment['author']['avatar']['permalink'] then
									entry['author']['image'] = comment['author']['avatar']['permalink']
								end
								entry['author']['name']    = comment['author']['name']
							end
							entry['content']           = comment['message'].to_str.gsub('<br>','<br />')
							entry['title']             = comment['message'].to_str.gsub('<br>','<br />')
						end
					end
				end
			end
		end
	end
end
