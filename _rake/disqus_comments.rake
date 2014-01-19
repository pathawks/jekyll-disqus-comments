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
			warn "Comments feed not found: #{post_id}"
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
							if comment['author']['name'] == 'Pat Hawks'
								entry['author']['url']   = 'http://pathawks.com/'
								entry['author']['email'] = 'pat@pathawks.com'
								entry['author']['image'] = 'http://0.gravatar.com/avatar/6838471f21e47341fbf89ed969d4529f?s=72'
								entry['author']['name']  = 'Pat Hawks'
							elsif comment['author']['name'] == 'pathawks.com'
								entry['author']['url']   = 'http://pathawks.com/'
								entry['author']['email'] = 'pat@pathawks.com'
								entry['author']['image'] = 'http://0.gravatar.com/avatar/6838471f21e47341fbf89ed969d4529f?s=72'
								entry['author']['name']  = 'Pat Hawks'
							elsif comment['author']['name'] == 'chad cook'
								entry['author']['url']   = 'https://www.facebook.com/chadgcook'
								entry['author']['email'] = 'chadgcook@facebook.com'
								entry['author']['image'] = 'https://graph.facebook.com/chadgcook/picture?width=72&height=72'
								entry['author']['name']  = 'Chad Cook'
							elsif comment['author']['name'] == 'chad'
								entry['author']['url']   = 'https://www.facebook.com/chadgcook'
								entry['author']['email'] = 'chadgcook@facebook.com'
								entry['author']['image'] = 'https://graph.facebook.com/chadgcook/picture?width=72&height=72'
								entry['author']['name']  = 'Chad Cook'
							elsif comment['author']['name'] == 'Christine'
								entry['author']['url']   = 'http://www.christinehawks.com/'
								entry['author']['email'] = 'christinejwarner@gmail.com'
								entry['author']['image'] = 'https://1.gravatar.com/avatar/096890a70b50ddd7ca11427042c5eb2c?s=72'
								entry['author']['name']  = 'Christine'
							elsif comment['author']['name'] == 'Christine Warner'
								entry['author']['url']   = 'http://www.christinehawks.com/'
								entry['author']['email'] = 'christinejwarner@gmail.com'
								entry['author']['image'] = 'https://1.gravatar.com/avatar/096890a70b50ddd7ca11427042c5eb2c?s=72'
								entry['author']['name']  = 'Christine'
							elsif comment['author']['name'] == 'Ben Hawks'
								entry['author']['url']   = 'https://www.facebook.com/ben.hawks.52'
								entry['author']['email'] = 'bjhnow@gmail.com'
								entry['author']['image'] = 'https://graph.facebook.com/ben.hawks.52/picture?width=72&height=72'
								entry['author']['name']  = 'Ben Hawks'
							elsif comment['author']['name'] == 'Katie'
								entry['author']['url']   = 'https://www.facebook.com/katie.hawks.92'
								entry['author']['email'] = 'katie.hawks.92@facebook.com'
								entry['author']['image'] = 'https://graph.facebook.com/katie.hawks.92/picture?width=72&height=72'
								entry['author']['name']  = 'Katie'
							elsif comment['author']['name'] == 'mroepke'
								entry['author']['url']   = 'http://thoughtsinthestillness.wordpress.com/'
								entry['author']['email'] = 'mac.roepke@facebook.com'
								entry['author']['image'] = 'http://1.gravatar.com/avatar/10f027627c39afe25a67dae37c8e509c?s=72'
								entry['author']['name']  = 'mcropekey'
							elsif comment['author']['name'] == 'exploringtheinfiniteabyss'
								entry['author']['url']   = 'http://thoughtsinthestillness.wordpress.com/'
								entry['author']['email'] = 'mac.roepke@facebook.com'
								entry['author']['image'] = 'http://1.gravatar.com/avatar/10f027627c39afe25a67dae37c8e509c?s=72'
								entry['author']['name']  = 'mcropekey'
							elsif comment['author']['name'] == 'louisgray'
								entry['author']['url']   = 'http://blog.louisgray.com/'
								entry['author']['email'] = 'louisgray@gmail.com'
								entry['author']['image'] = 'https://lh4.googleusercontent.com/-Zd0y5djZBSQ/AAAAAAAAAAI/AAAAAAAAwTQ/N7hoHuVtu3g/s72-c/photo.jpg'
								entry['author']['name']  = 'Louis Gray'
							elsif comment['author']['name'] == 'louisgray'
								entry['author']['url']   = 'https://www.facebook.com/katie.hawks.92'
								entry['author']['email'] = 'katie.hawks.92@facebook.com'
								entry['author']['image'] = 'https://graph.facebook.com/katie.hawks.92/picture?width=72&height=72'
								entry['author']['name']  = 'Katie'
							elsif comment['author']['name'] == 'MG Siegler'
								entry['author']['url']   = 'http://parislemon.com/'
								entry['author']['email'] = 'noreply@blogger.com'
								entry['author']['image'] = 'http://0.gravatar.com/avatar/710187cd963df0f92d11ddb31e6ae3db?size=72'
								entry['author']['name']  = 'MG Siegler'
							elsif comment['author']['name'] == 'Med Student Wife'
								entry['author']['url']   = 'http://imawhitecoatwife.blogspot.com/'
								entry['author']['email'] = 'noreply@blogger.com'
								entry['author']['image'] = 'http://3.bp.blogspot.com/-xa4tSkiReOQ/UAM2lYcgngI/AAAAAAAAAAo/0cqSnSL58DA/s220/headshot.jpg'
								entry['author']['name']  = 'Med Student Wife'
							else
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
