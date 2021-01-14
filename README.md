bashblog
========

A single Bash script to create blogs. 

I created it because I wanted a very, very simple way to post entries to a blog by using a public folder on my server, without any special requirements and dependencies. Works on GNU/Linux, OSX and BSD.

*How simple? Just type `./bb.sh post` and start writing your blogpost.*

[![asciinema](https://asciinema.org/a/4nr44km9ipow4s7u2w2eabeik.png)](https://asciinema.org/a/4nr44km9ipow4s7u2w2eabeik)

You can see a sample here: [read the initial blog post](https://web.archive.org/web/20130520204024/http://mmb.pcb.ub.es/~carlesfe/blog/creating-a-simple-blog-system-with-a-500-line-bash-script.html). That page was 100% generated using bashblog, no additional tweaking.

[![demo](https://raw.githubusercontent.com/cfenollosa/bashblog/gh-pages/images/demo_thumb.png)](https://raw.githubusercontent.com/cfenollosa/bashblog/gh-pages/images/demo.png)

Check out [other bashblog users](https://www.google.com/search?q=%22Generated+with+bashblog,+a+single+bash+script+to+easily+create+blogs+like+this+one%22)


Usage
-----

Download the code and copy bb.sh into a public folder (for example, `$HOME/public_html/blog`) and run

    ./bb.sh

This will show the available commands. If the file is not executable, type `chmod +x bb.sh` and retry.

**Before creating your first post, you may want to configure the blog settings (title, author, etc).
Read the Configuration section below for more information**

To create your first post, just run:

    ./bb.sh post
    
It will try to use Markdown, if installed. To force HTML:

    ./bb.sh post -html
    
The script will handle the rest.

When you're done, access the public URL for that folder  (e.g. `http://server.com/~username/blog`) 
and you should see the index file and a new page for that post!


Features
--------

- Ultra simple usage: Just type a post with your favorite editor and the script does the rest. No templating.
- No installation required. Download `bb.sh` and start blogging.
- Zero dependencies. It runs just on base utils (`date`, `basename`, `grep`, `sed`, `head`, etc)
- GNU/Linux, BSD and OSX compatible out of the box, no need for GNU `coreutils` on a Mac.
  It does some magic to autodetect which command switches it needs to run depending on your system.
- All content is static. You only need shell access to a machine with a public web folder.
  *Tip: advanced users could mount a remote public folder via `ftpfs` and run this script locally*
- Allows drafts, includes a simple but clean stylesheet, generates the RSS file automatically.
- Support for tags/categories
- Support for Markdown, Disqus comments, Twitter, Feedburner, Google Analytics.
- The project is still maintained as of 2016. Bugs are fixed, and new features are considered (see "Contributing")
- Everything stored in a single ~1k lines bash script, how cool is that?! ;) 


Configuration
-------------

Configuration is not required for a test drive, but if you plan on running your blog with bashblog, you will
want to change the default titles, author names, etc, to match your own.

There are two ways to configure the blog strings:

- Edit `bb.sh` and modify the variables in the `global_variables()` function
- Create a `.config` file with your configuration values -- useful if you don't want to touch the script and be able to update it regularly with git

The software will load the values in the script first, then overwrite them with the values in the `.config` file.
This means that you don't need to define all variables in the config file, only those which you need to override
from the defaults.

The format of the `.config` file is just one `variablename="value"` per line, just like in the `global_variables()`
function. **Please remember:** quote the values, do not declare a variable with the dollar sign, do not use 
spaces around the equal sign.

bashblog uses the `$EDITOR` environment value to open the text editor.


Detailed features
-----------------

- A simple but nice and readable design, with nothing but the blog posts
- **NEW on 2.0** Markdown support via a third-party library.  
  The easiest method is to download
  Gruber's [Markdown.pl](http://daringfireball.net/projects/markdown/)
- Post preview
- Save posts as drafts and resume editing later
- HTML page for each post, using its title as the URL
- Configurable number of posts on the front page
- Automatic generation of an RSS file, feedburner support
- Additional page containing an index of all posts
- Automatically generates pages for each tag
- Rebuild all files while keeping the original data
- Comments delegated to Twitter, with additional Disqus support
- An option for cookieless Twitter sharing, to comply with the 
[EU cookie law](https://github.com/cfenollosa/eu-cookie-law)
- Google Analytics code support
- Contains its own CSS so that everything is reasonably styled by default
- Headers, footers, and in general everything that a well-structured html file needs
- Support to add extra content on top of every page (e.g. banners, images, etc)
- xhtml validation, CSS validation, RSS validation by the w3c
- Automatic backup of the site every time you post (stored as `.backup.tar.gz`)

Read the Changelog section for more updates or [check out the news on my blog](http://cfenollosa.com/blog/tag_bashblog.html)


Contributing
------------

Bashblog started at 500 SLOC and it now has hit the 1000 SLOC barrier. 
If we want to keep the code minimal and understandable, we need to make the difficult effort to restrain ourselves 
from adding too many features.

All bugfixes are welcome, but brand new features need to be strongly justified to get into the main tree. 
Every new request will be honestly and civilly discussed on the comments. 
As a guideline, pull requests should:

- Fix a use case for some people (e.g. internationalization)
- Add a use case which is arguably very common (e.g. disqus integration for comments)
- Be very small when possible (a couple lines of code)
- Don't require a significant rewrite of the code (Don't break `create_html_file()` or `write_entry()`, etc)
- It must work on Linux, BSD and Mac. Beware of using GNU coreutils with non-POSIX flags (i.e. `date` or `grep`)
- Follow the UNIX philosophy: do one thing and do it well, rely on third party software for external features, etc
- **Always** keep backwards compatibility when using the default configuration


Changelog
---------

- 2.9      Added `body_begin_file_index`
- 2.8      Bugfixes<br/>
           Slavic language support thanks to Tomasz Jadowski<br/>
           Removed the now defunct Twitter JSON API share count<br/>
           Support for static, not managed by bashblog html files<br/>
- 2.7      Store post date on a comment in the html file (#96).<br/>
           On rebuild, the post date will be synchronised between comment date and file date, with precedence for comment date.
- 2.6      Support for multiple authors, use a different `.config` for each one
- 2.5      Massive code cleanup by Martijn Dekker<br/>
           'tags' command<br/>
           The word 'posts' in the tag list (both website and command) now has a singular form, check out `template_tags_posts_singular`
- 2.4      Added Twitter summaries metadata for posts (#36)
- 2.3.3    Removed big comment header.<br/>
           Added option to display tags for cut articles on index pages (#61)<br/>
           Cleaned up "all posts" page (#57)
- 2.3.2    Option to use topsy instead of twitter for references
- 2.3.1    Cookieless Twitter option
- 2.3      Intelligent tag rebuilding and Markdown by default
- 2.2      Flexible post title -> filename conversion
- 2.1      Support for tags/categories.<br/>
           'delete' command
- 2.0.3    Support for other analytics code, via external file
- 2.0.2    Fixed bug when $body_begin_file was empty.<br/>
           Added extra line in the footer linking to the github project
- 2.0.1    Allow personalized header/footer files
- 2.0      Added Markdown support.<br/>
           Fully support BSD date
- 1.6.4    Fixed bug in localized dates
- 1.6.3    Now supporting BSD date
- 1.6.2    Simplified some functions and variables to avoid duplicated information
- 1.6.1    'date' fix when hours are 1 digit.
- 1.6.0    Disqus comments. External configuration file. Check of 'date' command version.
- 1.5.1    Misc bugfixes and parameter checks
- 1.5      Đurađ Radojičić (djura-san) refactored some code and added flexibility and i18n
- 1.4.2    Now issues are handled at Github
- 1.4.1    Some code refactoring
- 1.4      Using twitter for comments, improved 'rebuild' command
- 1.3      'edit' command
- 1.2.2    Feedburner support
- 1.2.1    Fixed the timestamps bug
- 1.2      'list' command
- 1.1      Draft and preview support
- 1.0      Read http://is.gd/Bkdoru


License
-------

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
