bashblog
========

A Bash script that handles blog posting.

Some would say it's a CMS, but I don't like that word. It's just a script that lets you write a blog post with your favorite editor, puts all the posts together into an index, and creates an RSS file and a list of posts.

I created it because I wanted a very, very simple way to post entries to a blog by using a public folder on my server, without any special requirements and dependencies.

You can read [the initial blog post](http://mmb.pcb.ub.es/~carlesfe/blog/creating-a-simple-blog-system-with-a-500-line-bash-script.html) for more information and as a demo, as my site has been 100% generated using bashblog.


Features
--------

- Everything stored in a single 700-line bash script! Just download and start writing.
- GNU/Linux, BSD and OSX compatible out of the box (no need for GNU `coreutils` on a Mac)
- Simple creation and edition of the posts with your favorite text editor
- Support for Markdown, Disqus comments, Twitter, RSS, Feedburner, Google Analytics


Usage
-----

You will need SSH access to a server which allows its users to run shell scripts. More advanced users could
mount a server folder via `ftpfs` and run this script locally, however, it can be quite slow.

Copy bb.sh into a public folder of yours (for example, `public_html/blog`) and run it:

    ./bb.sh

This will show the available commands. If the file is not executable, you can either `chmod +x bb.sh`
or run it with `bash bb.sh`

**Before creating your first post, you may want to configure the blog settings (title, author name, etc).
Read the Configuration section below for more information**

To create your first post, just run:

    ./bb.sh post

When you're done, access the public URL for that folder and you should see the index
file and a new page for that post!


Configuration
-------------

Configuration is not required for a test drive, but if you plan on running your blog with bashblog, you will
want to change the default titles, author names, etc, to match your own.

There are two ways to configure the blog strings:

- Edit `bb.sh` and modify the variables in the `global_variables()` function
- Create a `.config` file with your configuration values (useful if you don't want to touch the script). You can find
  the `global_variables()` function on the script 

The software will load the values in the script first, then overwrite them with the values in the `.config` file.
This means that you don't need to define all variables in the config file, only those which you need to override
from the defaults.

Please note that bashblog uses the `$EDITOR` environment value to open the text editor.


Detailed features
-----------------

- A simple but nice and readable design, with nothing but the blog posts
- **NEW on 2.0** Markdown support via a third-party library (e.g. 
  [Markdown.pl](http://daringfireball.net/projects/markdown/)). Use
  it via `./bb.sh post -m`. The third party library must support an invokation
  like `markdown_bin in.html > out.md` as the code calls it that way.
- Post preview
- Save posts as drafts and resume editing later
- HTML page for each post, using its title as the URL
- Configurable number of posts on the front page
- Automatic generation of an RSS file, feedburner support
- Additional page containing an index of all posts
- Rebuild all files while keeping the original data
- Comments delegated to Twitter, with additional Disqus support
- Google Analytics code support
- Contains its own CSS so that everything is reasonably styled by default
- Headers, footers, and in general everything that a well-structured html file needs
- xhtml validation, CSS validation, RSS validation by the w3c
- Backup of the site every time you post

Read the CHANGELOG section of the script header for more updates

Future ideas
------------

This software is still maintained, however, it can be considered more or less finished. 
It has been used by many people and no bugs have been found, but if you happen to find one,
please report it.
