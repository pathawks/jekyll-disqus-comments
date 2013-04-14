# Jekyll Disqus comments
## Import comments from a Disqus blog into Jekyll

If you have migrated an posts from a Disqus blog to Jekyll,
this plugin will allow you to keep the comments from the old Disqus posts.

This plugin assumes that the Disqus blog has not been deactivated.
If it is unreachable via the Disqus API, this plugin will not be able to fetch comments.

This plugin will download the posts comments from Disqus and cache them in the `_comments/`
folder at the root of the Jekyll site. To refresh the comments, simply empty the `_comments/`
folder

### Installation

Copy the following files to your Jekyll site folder.

* `_rake/disqus_comments.rake`
* `_plugins/static_comments.rb`  (Not necessary if you're already using [jekyll-static-comments](https://github.com/mpalmer/jekyll-static-comments))
* `_includes/comments.html`
* `Rakefile` (Not necessary if you already have a Rakefile that loads `_rake/*`)

### Disqus API Key

To use the plugin, you will need to obtain a [Disqus API key](http://disqus.com/api/applications/) and add it to your `_config.yml`

Add the following lines to your `_config.yml`

    comments:
      disqus:
        short_name: YOUR-DISQUS-FORUM-SHORTNAME-HERE
        api_key:    YOUR-DISQUS-PUBLIC-KEY-HERE


### Importing Disqus Comments

Importing comments from Disqus is as simple as running `rake disquscomments`

### Template Setup

Copy the following line into your **Post** template where you would like comments to appear.

`{% include comments.html %}`

Alternatively, you could use `_includes/comments.html` as a guide to custom taylor the code to fit your site.

You will also need to add some CSS to style comments appropriately.

## License

Copyright &copy; 2013 Patrick Hawks and licensed under dual licensed under [The MIT License](http://opensource.org/licenses/MIT) and the [GNU General Public License, version 2 or later](http://opensource.org/licenses/gpl-2.0.php), except for the files noted below.

You don't have to do anything special to choose one license or the other and you don't have to notify anyone which license you are using.

***

`_plugins/static_comments.rb` from [jekyll-static-comments](https://github.com/mpalmer/jekyll-static-comments) and licensed under the [GNU General Public License, version 3](http://opensource.org/licenses/gpl-3.0.html)

***

`./Rakefile` from [jekyll-bootstrap](http://jekyllbootstrap.com/) and licensed under [The MIT License](http://opensource.org/licenses/MIT)

Copyright &copy; 2012 Jade Dominguez

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
