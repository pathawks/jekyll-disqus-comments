# Jekyll Blogger comments
## Import comments from a Blogger blog into Jekyll

If you have migrated an posts from a Blogger blog to Jekyll,
this plugin will allow you to keep the comments from the old Blogger posts.

This plugin assumes that the Blogger blog has not been deactivated.
If it is unreachable via the Blogger API, this plugin will not be able to fetch comments.

This plugin will download the posts comments from Blogger and cache them in the `_comments/`
folder at the root of the Jekyll site. To refresh the comments, simply empty the `_comments/`
folder

### Installation

Copy the following files to your Jekyll site folder.

* `_plugins/static_comments.rb`
* `_layouts/comment_template.html`
* `_rake/blogger-comments.rake`
* `Rakefile` (Not necessary if you already have a Rakefile that loads `_rake/*`)

### Template Setup


### Post Setup

For each post you would like to add comments to, you will also need to add the following data to the posts YAML front matter.

    blogger:
        siteid: NUMERIC SITE ID
        postid: NUMERIC POST ID

For example:

    title: "Example Post"
    layout: "post"
    date: "2013-04-13 20:45:00"
    blogger:
        siteid: "8505008"
        postid: "109657544490721509"

If you used [blogger2jekyll](https://github.com/coolaj86/blogger2jekyll) to migrate your Blogger posts, this data will likely already be included for each post.

## License

`_plugins/static_comments.rb` and `_layouts/comment_template.html` from [jekyll-static-comments](https://github.com/mpalmer/jekyll-static-comments) and licensed under the [GNU General Public License, version 3](http://opensource.org/licenses/gpl-3.0.html)

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
