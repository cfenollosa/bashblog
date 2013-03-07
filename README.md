bashblog
========

A Bash script that handles blog posting.

Some would say it's a CMS, but I don't like that word. It's just a script that lets you write a blog post with your favorite editor, puts all the posts together into an index, and creates an RSS file and a list of posts.

I created it because I wanted a very, very simple way to post entries to a blog by using a public folder on my server, without any special requirements and dependencies.

You can read [the initial blog post](http://mmb.pcb.ub.es/~carlesfe/blog/creating-a-simple-blog-system-with-a-500-line-bash-script.html) for more information and as a demo, as my site has been 100% generated using bashblog.

Usage
-----

Download bb.sh into a public folder of yours and run it:

    ./bb.sh

This will show the available commands

**Before creating a blog post, edit `bb.sh` and modify the variables in the `global_variables()` function**

To create your first post, make sure `$EDITOR` is set, and then just do:

    ./bb.sh post

When you're done, access the public URL for that folder and you should see the index
file and a new page for that post!

Features
--------

- Simple creation and edition of the posts with your favorite text editor
- Post preview
- Save posts as drafts and resume later
- Transformation of every post to its own html page, using the title as the URL
- Generation of an index.html file with the latest 10 posts
- Generation of an RSS file! Blog's magic is the RSS file, isn't it...?
- Generation of a page with all posts, to solve the index.html pagination problem
- Rebuilding the index files without the need to create a new entry
- Google Analytics support
- Feedburner support
- Auto-generated CSS support
- Headers, footers, and in general everything that a well-structured html file has
- xhtml validation, CSS validation, RSS validation by the w3c
- Backup of the site every time you post
- Everything contained in a single 700-line bash script!
- A simple but nice and readable design, with nothing but the blog posts

Non features (not planned)
--------------------------

- Comments. Would need a CAPTCHA or another antispam mechanism. Comments are handled through twitter, with a Twitter button

Read the CHANGELOG section of the script header for more updates
