#!/usr/bin/env bash

# BashBlog, a simple blog system written in a single bash script
# Author: Carles Fenollosa <carles.fenollosa@bsc.es>, 2011-2012


#########################################################################################
#
# README
#
#########################################################################################
#
# This is a very basic blog system
#
# Basically it asks the user to create a text file, then converts it into a .html file
# and then rebuilds the index.html and feed.rss.
#
# Comments are not supported.
#
# This script is standalone, it doesn't require any other file to run
#
# Files that this script generates:
#	- main.css (inherited from my web page) and blog.css (blog-specific stylesheet)
#	- one .html for each post
#	- index.html (regenerated each run)
# 	- feed.rss (regenerated each run)
#	- all_posts.html (regenerated each run)
# 	- it also generates temporal files, which are removed afterwards
#
# It generates valid html and rss files, so keep care to use valid xhtml when editing a post
#
# There are many loops which iterate on '*.html' so make sure that the only html files 
# on this folder are the blog entries and index.html and all_posts.html. Drafts must go
# into drafts/ and any other *.html file should be moved out of the way


#########################################################################################
#
# LICENSE
#
#########################################################################################
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


#########################################################################################
#
# CHANGELOG
#
#########################################################################################
#
# 1.5.1    Misc bugfixes and parameter checks
# 1.5      Durad Radojicic refactored some code and added flexibility and i18n
# 1.4.2    Now issues are handled at Github
# 1.4.1    Some code refactoring
# 1.4      Using twitter for comments, improved 'rebuild' command
# 1.3      'edit' command
# 1.2.2    Feedburner support
# 1.2.1    Fixed the timestamps bug
# 1.2      'list' command
# 1.1      Draft and preview support
# 1.0      Read http://is.gd/Bkdoru


#########################################################################################
#
# CODE
#
#########################################################################################
#
# As usual with bash scripts, scroll all the way to the bottom for the main routine
# All other functions are declared above main.


# Global variables
# It is recommended to perform a 'rebuild' after changing any of this in the code
global_variables() {
    # If you want to fork the project please contact me first, I wouldn't mind opening a git
    # or some shared code base and collaborate with other people.
    global_software_name="BashBlog"
    global_software_version="1.5.1"

    # Blog title
    global_title="My fancy blog"
    # The typical subtitle for each blog
    global_description="A blog about turtles and carrots"
    # The public base URL for this blog
    global_url="http://example.com/blog"

    # Your name
    global_author="John Smith"
    # You can use twitter or facebook or anything for global_author_url
    global_author_url="http://twitter.com/example" 
    # Your email
    global_email="john@smith.com"

    # CC by-nc-nd is a good starting point, you can change this to "&copy;" for Copyright
    global_license="CC by-nc-nd"

    # If you have a Google Analytics ID (UA-XXXXX), put it here.
    # If left empty (i.e. "") Analytics will be disabled
    global_analytics=""

    # Leave this empty (i.e. "") if you don't want to use feedburner, 
    # or change it to your own URL
    global_feedburner=""

    # Leave these empty if you don't want to use twitter for comments
    global_twitter="true"
    global_twitter_username="example"


    # Blog generated files
    # index page of blog (it is usually good to use "index.html" here)
    index_file="index.html"
    number_of_index_articles="8"
    # global archive
    archive_index="all_posts.html"
    # feed file (rss in this case)
    blog_feed="feed.rss"
    number_of_feed_articles="10"

    # Localization and i18n
    # "Comments?" (used in twitter link after every post)
    template_comments="Comments?"
    # "View more posts" (used on bottom of index page as link to archive)
    template_archive="View more posts"
    # "Back to the index page" (used on archive page, it is link to blog index)
    template_archive_index_page="Back to the index page"
    # "Subscribe" (used on bottom of index page, it is link to RSS feed)
    template_subscribe="Subscribe"
    # "Subscribe to this page..." (used as text for browser feed button that is embedded to html)
    template_subscribe_browser_button="Subscribe to this page..."
    # "Tweet" (used as twitter text button for posting to twitter)
    template_twitter_button="Tweet"
    # The locale to use for the dates displayed on screen (not for the timestamps)
    date_format="%B %d, %Y"
    date_locale="C"
}

# Prints the required google analytics code
google_analytics() {
    if [ "$global_analytics" == "" ]; then return; fi

    echo "<script type=\"text/javascript\">

    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', '"$global_analytics"']);
    _gaq.push(['_trackPageview']);

    (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();

</script>"
}

# Edit an existing, published .html file while keeping its original timestamp
# Please note that this function does not automatically republish anything, as
# it is usually called from 'main'.
#
# 'edit' is kind of an advanced function, as it leaves to the user the responsability
# of editing an html file
#
# $1 	the file to edit
edit() {
    timestamp="$(date -r $1 +'%Y%m%d%k%M')"
    $EDITOR "$1"
    touch -t $timestamp "$1"
}

# Adds the code needed by the twitter button
#
# $1 the post URL
twitter() {
    echo "<p id='twitter'>$template_comments &nbsp;"
    echo "<a href=\"https://twitter.com/share\" class=\"twitter-share-button\" data-text=\"&lt;Type your comment here but please leave the URL so that other people can follow the comments&gt;\" data-url=\"$1\""

    if [ "$global_twitter_username" != "" ]; then
        echo " data-via=\"$global_twitter_username\""
    fi

    echo ">$template_twitter_button</a>	<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=\"//platform.twitter.com/widgets.js\";fjs.parentNode.insertBefore(js,fjs);}}(document,\"script\",\"twitter-wjs\");</script>"
    echo "</p>"
}

# Adds all the bells and whistles to format the html page
# Every blog post is marked with a <!-- entry begin --> and <!-- entry end -->
# which is parsed afterwards in the other functions. There is also a marker
# <!-- text begin --> to determine just the beginning of the text body of the post
#
# $1     a file with the body of the content
# $2     the output file
# $3     "yes" if we want to generate the index.html,
#        "no" to insert new blog posts
# $4     title for the html header
# $5     original blog timestamp
create_html_page() {
    content="$1"
    filename="$2"
    index="$3"
    title="$4"
    timestamp="$5"

    # Create the actual blog post
    # html, head
    cat ".header.html" > "$filename"
    echo "<title>$title</title>" >> "$filename"
    google_analytics >> "$filename"
    echo "</head><body>" >> "$filename"
    # body divs
    echo '<div id="divbodyholder">' >> "$filename"
    echo '<div class="headerholder"><div class="header">' >> "$filename"
    # blog title
    echo '<div id="title">' >> "$filename"
    cat .title.html >> "$filename"
    echo '</div></div></div>' >> "$filename" # title, header, headerholder
    echo '<div id="divbody"><div class="content">' >> "$filename"

    file_url="$(sed 's/.rebuilt//g' <<< $filename)" # Get the correct URL when rebuilding
    # one blog entry
    if [ "$index" == "no" ]; then
        echo '<!-- entry begin -->' >> "$filename" # marks the beginning of the whole post
        echo '<h3><a class="ablack" href="'$global_url/$file_url'">' >> "$filename"
        echo "$title" >> "$filename"
        echo '</a></h3>' >> "$filename"
        if [ "$timestamp" == "" ]; then
            echo '<div class="subtitle">'$(LC_ALL=date_locale date +"$date_format")' &mdash; ' >> "$filename"
        else
            echo '<div class="subtitle">'$(LC_ALL=date_locale date +"$date_format" --date="$timestamp") ' &mdash; ' >> "$filename"
        fi
        echo "$global_author</div>" >> "$filename"
        echo '<!-- text begin -->' >> "$filename" # This marks the text body, after the title, date...
    fi
    cat "$content" >> "$filename" # Actual content
    if [ "$index" == "no" ]; then
        echo '<!-- text end -->' >> "$filename"

        if [ "$global_twitter" == "true" ]; then
            twitter "$global_url/$file_url" >> "$filename"
        fi

        echo '<!-- entry end -->' >> "$filename" # absolute end of the post
    fi

    echo '</div>' >> "$filename" # content
    # page footer
    cat .footer.html >> "$filename"
    # close divs
    echo '</div></div>' >> "$filename" # divbody and divbodyholder 
    echo '</body></html>' >> "$filename"
}

# Parse the plain text file into an html file
parse_file() {
    # Read for the title and check that the filename is ok
    title=""
    while read line; do
        if [ "$title" == "" ]; then
            title="$line"
            filename="$(echo $title | tr [:upper:] [:lower:])"
            filename="$(echo $filename | sed 's/\ /-/g')"
            filename="$(echo $filename | tr -dc '[:alnum:]-')" # html likes alphanumeric
            filename="$filename.html"
            content="$filename.tmp"

            # Check for duplicate file names
            while [ -f "$filename" ]; do
                suffix="$RANDOM"
                filename="$(echo $filename | sed 's/\.html/'$suffix'\.html/g')"
            done
        else
            echo "$line" >> "$content"
        fi
    done < "$TMPFILE"

    # Create the actual html page
    create_html_page "$content" "$filename" no "$title"
    rm "$content"
}

# Manages the creation of the text file and the parsing to html file
# also the drafts
write_entry() {
    if [ "$1" != "" ]; then
        TMPFILE="$1"
        if [ ! -f "$TMPFILE" ]; then
            echo "The file doesn't exist"
            delete_includes
            exit
        fi
    else
        TMPFILE=".entry-$RANDOM.html"
        echo "Title on this line" >> "$TMPFILE"
        echo "" >> "$TMPFILE"
        echo "<p>The rest of the text file is an <b>html</b> blog post. The process" >> "$TMPFILE"
        echo "will continue as soon as you exit your editor</p>" >> "$TMPFILE"
    fi
    chmod 600 "$TMPFILE"

    post_status="E"
    while [ "$post_status" != "p" ] && [ "$post_status" != "P" ]; do
        $EDITOR "$TMPFILE"
        parse_file "$TMPFILE" # this command sets $filename as the html processed file
        chmod 600 "$filename"

        echo -n "Preview? (Y/n) "
        read p
        if [ "$p" != "n" ] && [ "$p" != "N" ]; then
            chmod 644 "$filename"
            echo "Open $global_url/$filename in your browser"
        fi

        echo -n "[P]ost this entry, [E]dit again, [D]raft for later? (p/E/d) "
        read post_status
        if [ "$post_status" == "d" ] || [ "$post_status" == "D" ]; then
            mkdir -p "drafts/"
            chmod 700 "drafts/"

            title="$(head -n 1 $TMPFILE)"
            title="$(echo $title | tr [:upper:] [:lower:])"
            title="$(echo $title | sed 's/\ /-/g')"
            title="$(echo $title | tr -dc '[:alnum:]-')"
            draft="drafts/$title.html"
            while [ -f "$draft" ]; do draft="drafts/$title-$RANDOM.html"; done

            mv "$TMPFILE" "$draft"
            chmod 600 "$draft"
            rm "$filename"
            delete_includes
            echo "Saved your draft as '$draft'"
            exit
        fi
        if [ "$post_status" == "e" ] || [ "$post_status" == "E" ]; then
            rm "$filename" # Delete the html file as it will be generated again
        fi
    done

    rm "$TMPFILE"
    chmod 644 "$filename"
    echo "Posted $filename"
}

# Create an index page with all the posts
all_posts() {
    echo -n "Creating an index page with all the posts "
    contentfile="$archive_index.$RANDOM"
    while [ -f "$contentfile" ]; do
        contentfile="$archive_index.$RANDOM"
    done

    echo "<h3>All posts</h3>" >> "$contentfile"
    echo "<ul>" >> "$contentfile"
    for i in $(ls -t *.html); do
        if [ "$i" == "$index_file" ] || [ "$i" == "$archive_index" ]; then continue; fi
        echo -n "."
        # Title
        title="$(awk '/<h3><a class="ablack" href=".+">/, /<\/a><\/h3>/{if (!/<h3><a class="ablack" href=".+">/ && !/<\/a><\/h3>/) print}' $i)"
        echo -n '<li><a href="'$global_url/$i'">'$title'</a> &mdash;' >> "$contentfile"
        # Date
        date="$(LC_ALL=date_locale date -r "$i" +"$date_format")"
        echo " $date</li>" >> "$contentfile"
    done
    echo ""
    echo "</ul>" >> "$contentfile"
    echo '<div id="all_posts"><a href="'$global_url'">'$template_archive_index_page'</a></div>' >> "$contentfile"

    create_html_page "$contentfile" "$archive_index.tmp" yes "$global_title &mdash; All posts"
    mv "$archive_index.tmp" "$archive_index"
    chmod 644 "$archive_index"
    rm "$contentfile"
}

# Generate the index.html with the content of the latest posts
rebuild_index() {
    echo -n "Rebuilding the index "
    newindexfile="$index_file.$RANDOM"
    contentfile="$newindexfile.content"
    while [ -f "$newindexfile" ]; do 
        newindexfile="$index_file.$RANDOM"
        contentfile="$newindexfile.content"
    done

    # Create the content file
    n=0
    for i in $(ls -t *.html); do # sort by date, newest first
        if [ "$i" == "$index_file" ] || [ "$i" == "$archive_index" ]; then continue; fi
        if [ "$n" -ge "$number_of_index_articles" ]; then break; fi
        awk '/<!-- entry begin -->/, /<!-- entry end -->/' "$i" >> "$contentfile"
        echo -n "."
        n=$(( $n + 1 ))
    done

    if [ "$global_feedburner" == "" ]; then
        echo '<div id="all_posts"><a href="'$archive_index'">View more posts</a> &mdash; <a href="'$blog_feed'">'$template_subscribe'</a></div>' >> "$contentfile"
    else
        echo '<div id="all_posts"><a href="'$archive_index'">'$template_archive'</a> &mdash; <a href="'$global_feedburner'">Susbcribe</a></div>' >> "$contentfile"
    fi

    echo ""

    create_html_page "$contentfile" "$newindexfile" yes "$global_title"
    rm "$contentfile"
    mv "$newindexfile" "$index_file"
    chmod 644 "$index_file"
}

# Displays a list of the posts
list_posts() {
    lines=""
    n=1
    for i in $(ls -t *.html); do
        if [ "$i" == "$index_file" ] || [ "$i" == "$archive_index" ]; then continue; fi
        line="$n # $(awk '/<h3><a class="ablack" href=".+">/, /<\/a><\/h3>/{if (!/<h3><a class="ablack" href=".+">/ && !/<\/a><\/h3>/) print}' $i) # $(LC_ALL=date_locale date -r $i +"date_format")"
        lines="${lines}""$line""\n" # Weird stuff needed for the newlines
        n=$(( $n + 1 ))
    done 

    echo -e "$lines" | column -t -s "#"
}

# Generate the feed file
make_rss() {
    echo -n "Making RSS "

    rssfile="$blog_feed.$RANDOM"
    while [ -f "$rssfile" ]; do rssfile="$blog_feed.$RANDOM"; done

    echo '<?xml version="1.0" encoding="UTF-8" ?>' >> "$rssfile"
    echo '<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:dc="http://purl.org/dc/elements/1.1/">' >> "$rssfile"
    echo '<channel><title>'$global_title'</title><link>'$global_url'</link>' >> "$rssfile"
    echo '<description>'$global_description'</description><language>en</language>' >> "$rssfile"
    echo '<lastBuildDate>'$(date -R)'</lastBuildDate>' >> "$rssfile"
    echo '<pubDate>'$(date -R)'</pubDate>' >> "$rssfile"
    echo '<atom:link href="'$global_url/$blog_feed'" rel="self" type="application/rss+xml" />' >> "$rssfile"

    n=0
    for i in $(ls -t *.html); do
        if [ "$i" == "$index_file" ] || [ "$i" == "$archive_index" ]; then continue; fi
        if [ "$n" -ge "$number_of_feed_articles" ]; then break; fi # max 10 items
        echo -n "."
        echo '<item><title>' >> "$rssfile"
        echo "$(awk '/<h3><a class="ablack" href=".+">/, /<\/a><\/h3>/{if (!/<h3><a class="ablack" href=".+">/ && !/<\/a><\/h3>/) print}' $i)" >> "$rssfile"
        echo '</title><description><![CDATA[' >> "$rssfile"
        echo "$(awk '/<!-- text begin -->/, /<!-- entry end -->/{if (!/<!-- text begin -->/ && !/<!-- entry end -->/) print}' $i)" >> "$rssfile"

        echo "]]></description><link>$global_url/$i</link>" >> "$rssfile"
        echo "<guid>$global_url/$i</guid>" >> "$rssfile"
        echo "<dc:creator>$global_author</dc:creator>" >> "$rssfile"
        echo '<pubDate>'$(date -r "$i" -R)'</pubDate></item>' >> "$rssfile"

        n=$(( $n + 1 ))
    done

    echo '</channel></rss>' >> "$rssfile"
    echo ""

    mv "$rssfile" "$blog_feed"
    chmod 644 "$blog_feed"
}

# generate headers, footers, etc
create_includes() {
    echo '<h1 class="nomargin"><a class="ablack" href="'$global_url'">'$global_title'</a></h1>' > ".title.html"
    echo '<div id="description">'$global_description'</div>' >> ".title.html"

    echo '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">' > ".header.html"
    echo '<html xmlns="http://www.w3.org/1999/xhtml"><head>' >> ".header.html"
    echo '<meta http-equiv="Content-type" content="text/html;charset=UTF-8" />' >> ".header.html"
    echo '<link rel="stylesheet" href="main.css" type="text/css" />' >> ".header.html"
    echo '<link rel="stylesheet" href="blog.css" type="text/css" />' >> ".header.html"
    if [ "$global_feedburner" == "" ]; then
        echo '<link rel="alternate" type="application/rss+xml" title="'$template_subscribe_browser_button'" href="'$blog_feed'" />' >> ".header.html"
    else 
        echo '<link rel="alternate" type="application/rss+xml" title="'$template_subscribe_browser_button'" href="'$global_feedburner'" />' >> ".header.html"
    fi

    protected_mail="$(echo "$global_email" | sed 's/@/\&#64;/g' | sed 's/\./\&#46;/g')"
    echo '<div id="footer">'$global_license '<a href="'$global_author_url'">'$global_author'</a> &mdash; <a href="mailto:'$protected_mail'">'$protected_mail'</a></div>' >> ".footer.html"
}

# Delete the temporarily generated include files
delete_includes() {
    rm ".title.html" ".footer.html" ".header.html"
}

# Create the css file from scratch
create_css() {
    # To avoid overwriting manual changes. However it is recommended that
    # this function is modified if the user changes the blog.css file
    if [ ! -f "blog.css" ]; then 
        # blog.css directives will be loaded after main.css and thus will prevail
        echo '#title{font-size: x-large;}
        a.ablack{color:black !important;}
        li{margin-bottom:8px;}
        ul,ol{margin-left:24px;margin-right:24px;}
        #all_posts{margin-top:24px;text-align:center;}
        .subtitle{font-size:small;margin:12px 0px;}
        .content p{margin-left:24px;margin-right:24px;}
        h1{margin-bottom:12px !important;}
        #description{font-size:large;margin-bottom:12px;}
        h3{margin-top:42px;margin-bottom:8px;}
        h4{margin-left:24px;margin-right:24px;}
        #twitter{line-height:20px;vertical-align:top;text-align:right;font-style:italic;color:#333;margin-top:24px;font-size:14px;}' > blog.css
    fi

    # This is the CSS file from my main page. Any other person would need it to run the blog
    # so it's attached here for convenience.
    if [ "$(whoami)" == "carlesfe" ] && [ ! -f "main.css" ]; then
        ln -s "../style.css" "main.css" # XXX This is clearly machine-dependent, beware!
    elif [ ! -f "main.css" ]; then
        echo 'body{font-family:Georgia,"Times New Roman",Times,serif;margin:0;padding:0;background-color:#F3F3F3;}
        #divbodyholder{padding:5px;background-color:#DDD;width:874px;margin:24px auto;}
        #divbody{width:776px;border:solid 1px #ccc;background-color:#fff;padding:0px 48px 24px 48px;top:0;}
        .headerholder{background-color:#f9f9f9;border-top:solid 1px #ccc;border-left:solid 1px #ccc;border-right:solid 1px #ccc;}
        .header{width:800px;margin:0px auto;padding-top:24px;padding-bottom:8px;}
        .content{margin-bottom:45px;}
        .nomargin{margin:0;}
        .description{margin-top:10px;border-top:solid 1px #666;padding:10px 0;}
        h3{font-size:20pt;width:100%;font-weight:bold;margin-top:32px;margin-bottom:0;}
        .clear{clear:both;}
        #footer{padding-top:10px;border-top:solid 1px #666;color:#333333;text-align:center;font-size:small;font-family:"Courier New","Courier",monospace;}
        a{text-decoration:none;color:#003366 !important;}
        a:visited{text-decoration:none;color:#336699 !important;}
        blockquote{background-color:#f9f9f9;border-left:solid 4px #e9e9e9;margin-left:12px;padding:12px 12px 12px 24px;}
        blockquote img{margin:12px 0px;}
        blockquote iframe{margin:12px 0px;}' > main.css
    fi
}

# Regenerates all the single post entries, keeping the post content but modifying
# the title, html structure, etc
rebuild_all_entries() {
    echo -n "Rebuilding all entries "

    for i in *.html; do # no need to sort
        if [ "$i" == "$index_file" ] || [ "$i" == "$archive_index" ]; then continue; fi
        contentfile=".tmp.$RANDOM"
        while [ -f "$contentfile" ]; do contentfile=".tmp.$RANDOM"; done

        echo -n "."
        # Get the title and entry, and rebuild the html structure from scratch (divs, title, description...)
        title="$(awk '/<h3><a class="ablack" href=".+">/, /<\/a><\/h3>/{if (!/<h3><a class="ablack" href=".+">/ && !/<\/a><\/h3>/) print}' $i)"
        awk '/<!-- text begin -->/, /<!-- text end -->/{if (!/<!-- text begin -->/ && !/<!-- text end -->/) print}' "$i" >> "$contentfile"

        # Original post timestamp
        timestamp="$(date -R -r $i)"

        create_html_page "$contentfile" "$i.rebuilt" no "$title" "$timestamp"
        # keep the original timestamp!
        timestamp="$(date -r $i +'%Y%m%d%k%M')"
        mv "$i.rebuilt" "$i"
        chmod 644 "$i"
        touch -t $timestamp "$i"
        rm "$contentfile"
    done
    echo ""
}

# Displays the help
function usage() {
echo "$global_software_name v$global_software_version"
echo "Usage: $0 command [filename]"
echo ""
echo "Commands:"
echo "    post [filename]    insert a new blog post, or the FILENAME of a draft to continue editing it"
echo "    edit [filename]    edit an already published .html file. Never edit manually a published .html file,"
echo "                       always use this function as it keeps the original timestamp "
echo "                       and rebuilds whatever indices are needed"
echo "    rebuild            regenerates all the pages and posts, preserving the content of the entries"
echo "    reset              deletes blog-generated files. Use with a lot of caution and back up first!"
echo "    list               list all entries. Useful for debug"
echo ""
echo "For more information please open $0 in a code editor and read the header and comments"
}

# Delete all generated content, leaving only this script
reset() {
    echo "Are you sure you want to delete all blog entries? Please write \"Yes, I am!\" "
    read line
    if [ "$line" == "Yes, I am!" ]; then
        rm "*.html" "*.css" "*.rss"
        echo "Deleted all posts, stylesheets and feeds."
    else
        echo "Phew! You dodged a bullet there. Nothing was modified."
    fi
}

# Main function
# Encapsuled on its own function for readability purposes
#
# $1     command to run
# $2     file name of a draft to continue editing (optional)
do_main() {
    global_variables

    # Check for $EDITOR
    if [[ -z "$EDITOR" ]]; then
        echo "Please set your \$EDITOR environment variable"
        exit
    fi

    # Check for validity of argument
    if [ "$1" != "reset" ] && [ "$1" != "post" ] && [ "$1" != "rebuild" ] && [ "$1" != "list" ] && [ "$1" != "edit" ]; then 
        usage; exit; 
    fi

    if [ "$1" == "list" ]; then
        list_posts
        exit
    fi

    if [[ "$1" == "edit" ]]; then
        if [[ $# -lt 2 ]] || [[ ! -f "$2" ]]; then
            echo "Please enter a valid html file to edit"
            exit
        fi
    fi

    # Test for existing html files
    ls *.html &> /dev/null
    if [ $? -ne 0 ] && [ "$1" == "rebuild" ]; then
        echo "Can't find any html files, nothing to rebuild"
        exit
    fi

    # We're going to back up just in case
    tar cfz ".backup.tar.gz" *.html
    chmod 600 ".backup.tar.gz"

    if [ "$1" == "reset" ]; then
        reset
        exit
    fi

    create_includes
    create_css
    if [ "$1" == "post" ]; then write_entry "$2"; fi
    if [ "$1" == "rebuild" ]; then rebuild_all_entries; fi
    if [ "$1" == "edit" ]; then edit "$2"; fi
    rebuild_index
    all_posts
    make_rss
    delete_includes
}


#
# MAIN
# Do not change anything here. If you want to modify the code, edit do_main()
#
do_main $*
