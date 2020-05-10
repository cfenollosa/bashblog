#!/usr/bin/env bash

# BashBlog, a simple blog system written in a single bash script
# (C) Carlos Fenollosa <carlos.fenollosa@gmail.com>, 2011-2016 and contributors
# https://github.com/carlesfe/bashblog/contributors
# Check out README.md for more details

# Global variables
# It is recommended to perform a 'rebuild' after changing any of this in the code

# Config file. Any settings "key=value" written there will override the
# global_variables defaults. Useful to avoid editing bb.sh and having to deal
# with merges in VCS
global_config=".config"

# This function will load all the variables defined here. They might be overridden
# by the 'global_config' file contents
global_variables() {
    global_software_name="BashBlog"
    global_software_version="2.9"

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

    # If you have a Google Analytics ID (UA-XXXXX) and wish to use the standard
    # embedding code, put it on global_analytics
    # If you have custom analytics code (i.e. non-google) or want to use the Universal
    # code, leave global_analytics empty and specify a global_analytics_file
    global_analytics=""
    global_analytics_file=""

    # Leave this empty (i.e. "") if you don't want to use feedburner, 
    # or change it to your own URL
    global_feedburner=""

    # Change this to your username if you want to use twitter for comments
    global_twitter_username=""
    # Set this to false for a Twitter button with share count. The cookieless version
    # is just a link.
    global_twitter_cookieless="true"
    # Default search page, where tweets more than a week old are hidden
    global_twitter_search="twitter"

    # Change this to your disqus username to use disqus for comments
    global_disqus_username=""


    # Blog generated files
    # index page of blog (it is usually good to use "index.html" here)
    index_file="index.html"
    number_of_index_articles="8"
    # global archive
    archive_index="all_posts.html"
    tags_index="all_tags.html"

    # Non blogpost files. Bashblog will ignore these. Useful for static pages and custom content
    # Add them as a bash array, e.g. non_blogpost_files=("news.html" "test.html")
    non_blogpost_files=()

    # feed file (rss in this case)
    blog_feed="feed.rss"
    number_of_feed_articles="10"
    # "cut" blog entry when putting it to index page. Leave blank for full articles in front page
    # i.e. include only up to first '<hr>', or '----' in markdown
    cut_do="cut"
    # When cutting, cut also tags? If "no", tags will appear in index page for cut articles
    cut_tags="yes"
    # Regexp matching the HTML line where to do the cut
    # note that slash is regexp separator so you need to prepend it with backslash
    cut_line='<hr ?\/?>'
    # save markdown file when posting with "bb post -m". Leave blank to discard it.
    save_markdown="yes"
    # prefix for tags/categories files
    # please make sure that no other html file starts with this prefix
    prefix_tags="tag_"
    # personalized header and footer (only if you know what you're doing)
    # DO NOT name them .header.html, .footer.html or they will be overwritten
    # leave blank to generate them, recommended
    header_file=""
    footer_file=""
    # extra content to add just after we open the <body> tag
    # and before the actual blog content
    body_begin_file=""
    # extra content to add just before we close </body>
    body_end_file=""
    # extra content to ONLY on the index page AFTER `body_begin_file` contents
    # and before the actual content
    body_begin_file_index=""
    # CSS files to include on every page, f.ex. css_include=('main.css' 'blog.css')
    # leave empty to use generated
    css_include=()
    # HTML files to exclude from index, f.ex. post_exclude=('imprint.html 'aboutme.html')
    html_exclude=()

    # Localization and i18n
    # "Comments?" (used in twitter link after every post)
    template_comments="Comments?"
    # "Read more..." (link under cut article on index page)
    template_read_more="Read more..."
    # "View more posts" (used on bottom of index page as link to archive)
    template_archive="View more posts"
    # "All posts" (title of archive page)
    template_archive_title="All posts"
    # "All tags"
    template_tags_title="All tags"
    # "posts" (on "All tags" page, text at the end of each tag line, like "2. Music - 15 posts")
    template_tags_posts="posts"
    template_tags_posts_2_4="posts"  # Some slavic languages use a different plural form for 2-4 items
    template_tags_posts_singular="post"
    # "Posts tagged" (text on a title of a page with index of one tag, like "My Blog - Posts tagged "Music"")
    template_tag_title="Posts tagged"
    # "Tags:" (beginning of line in HTML file with list of all tags for this article)
    template_tags_line_header="Tags:"
    # "Back to the index page" (used on archive page, it is link to blog index)
    template_archive_index_page="Back to the index page"
    # "Subscribe" (used on bottom of index page, it is link to RSS feed)
    template_subscribe="Subscribe"
    # "Subscribe to this page..." (used as text for browser feed button that is embedded to html)
    template_subscribe_browser_button="Subscribe to this page..."
    # "Tweet" (used as twitter text button for posting to twitter)
    template_twitter_button="Tweet"
    template_twitter_comment="&lt;Type your comment here but please leave the URL so that other people can follow the comments&gt;"
    
    # The locale to use for the dates displayed on screen
    date_format="%B %d, %Y"
    date_locale="C"
    date_inpost="bashblog_timestamp"
    # Don't change these dates
    date_format_full="%a, %d %b %Y %H:%M:%S %z"
    date_format_timestamp="%Y%m%d%H%M.%S"
    date_allposts_header="%B %Y"

    # Perform the post title -> filename conversion
    # Experts only. You may need to tune the locales too
    # Leave empty for no conversion, which is not recommended
    # This default filter respects backwards compatibility
    convert_filename="iconv -f utf-8 -t ascii//translit | sed 's/^-*//' | tr [:upper:] [:lower:] | tr ' ' '-' | tr -dc '[:alnum:]-'"

    # URL where you can view the post while it's being edited
    # same as global_url by default
    # You can change it to path on your computer, if you write posts locally
    # before copying them to the server
    preview_url=""

    # Markdown location. Trying to autodetect by default.
    # The invocation must support the signature 'markdown_bin in.md > out.html'
    [[ -f Markdown.pl ]] && markdown_bin=./Markdown.pl || markdown_bin=$(which Markdown.pl 2>/dev/null || which markdown 2>/dev/null)
}

# Check for the validity of some variables
# DO NOT EDIT THIS FUNCTION unless you know what you're doing
global_variables_check() {
    [[ $header_file == .header.html ]] &&
        echo "Please check your configuration. '.header.html' is not a valid value for the setting 'header_file'" &&
        exit
    [[ $footer_file == .footer.html ]] &&
        echo "Please check your configuration. '.footer.html' is not a valid value for the setting 'footer_file'" &&
        exit
}


# Test if the markdown script is working correctly
test_markdown() {
    [[ -n $markdown_bin ]] &&
        (
        [[ $("$markdown_bin" <<< $'line 1\n\nline 2') == $'<p>line 1</p>\n\n<p>line 2</p>' ]] ||
        [[ $("$markdown_bin" <<< $'line 1\n\nline 2') == $'<p>line 1</p>\n<p>line 2</p>' ]]
        )
}


# Parse a Markdown file into HTML and return the generated file
markdown() {
    out=${1%.md}.html
    while [[ -f $out ]]; do out=${out%.html}.$RANDOM.html; done
    $markdown_bin "$1" > "$out"
    echo "$out"
}


# Prints the required google analytics code
google_analytics() {
    [[ -z $global_analytics && -z $global_analytics_file ]]  && return

    if [[ -z $global_analytics_file ]]; then
        echo "<script type=\"text/javascript\">

        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', '${global_analytics}']);
        _gaq.push(['_trackPageview']);

        (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();

        </script>"
    else
        cat "$global_analytics_file"
    fi
}

# Prints the required code for disqus comments
disqus_body() {
    [[ -z $global_disqus_username ]] && return

    echo '<div id="disqus_thread"></div>
            <script type="text/javascript">
            /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
               var disqus_shortname = '"'$global_disqus_username'"'; // required: replace example with your forum shortname

            /* * * DONT EDIT BELOW THIS LINE * * */
            (function() {
            var dsq = document.createElement("script"); dsq.type = "text/javascript"; dsq.async = true;
            dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js";
            (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(dsq);
            })();
            </script>
            <noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
            <a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>'
}

# Prints the required code for disqus in the footer
disqus_footer() {
    [[ -z $global_disqus_username ]] && return
    echo '<script type="text/javascript">
        /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
        var disqus_shortname = '"'$global_disqus_username'"'; // required: replace example with your forum shortname

        /* * * DONT EDIT BELOW THIS LINE * * */
        (function () {
        var s = document.createElement("script"); s.async = true;
        s.type = "text/javascript";
        s.src = "//" + disqus_shortname + ".disqus.com/count.js";
        (document.getElementsByTagName("HEAD")[0] || document.getElementsByTagName("BODY")[0]).appendChild(s);
    }());
    </script>'
}

# Reads HTML file from stdin, prints its content to stdout
# $1    where to start ("text" or "entry")
# $2    where to stop ("text" or "entry")
# $3    "cut" to remove text from <hr /> to <!-- text end -->
#       note that this does not remove <hr /> line itself,
#       so you can see if text was cut or not
get_html_file_content() {
    awk "/<!-- $1 begin -->/, /<!-- $2 end -->/{
        if (!/<!-- $1 begin -->/ && !/<!-- $2 end -->/) print
        if (\"$3\" == \"cut\" && /$cut_line/){
            if (\"$2\" == \"text\") exit # no need to read further
            while (getline > 0 && !/<!-- text end -->/) {
                if (\"$cut_tags\" == \"no\" && /^<p>$template_tags_line_header/ ) print 
            }
        }
    }"
}

# Edit an existing, published .html file while keeping its original timestamp
# Please note that this function does not automatically republish anything, as
# it is usually called from 'main'.
#
# Note that it edits HTML file, even if you wrote the post as markdown originally
# Note that if you edit title then filename might also change
#
# $1 	the file to edit
# $2	(optional) edit mode:
#	"keep" to keep old filename
#	"full" to edit full HTML, and not only text part (keeps old filename)
#	leave empty for default behavior (edit only text part and change name)
edit() {
    [[ ! -f "${1%%.*}.html" ]] && echo "Can't edit post "${1%%.*}.html", did you mean to use \"bb.sh post <draft_file>\"?" && exit -1
    # Original post timestamp
    edit_timestamp=$(LC_ALL=C date -r "${1%%.*}.html" +"$date_format_full" )
    touch_timestamp=$(LC_ALL=C date -r "${1%%.*}.html" +"$date_format_timestamp")
    tags_before=$(tags_in_post "${1%%.*}.html")
    if [[ $2 == full ]]; then
        $EDITOR "$1"
        filename=$1
    else
        if [[ ${1##*.} == md ]]; then
            test_markdown
            if (($? != 0)); then
                echo "Markdown is not working, please edit HTML file directly."
                exit
            fi
            # editing markdown file
            $EDITOR "$1"
            TMPFILE=$(markdown "$1")
            filename=${1%%.*}.html
        else
            # Create the content file
            TMPFILE=$(basename "$1").$RANDOM.html
            # Title
            get_post_title "$1" > "$TMPFILE"
            # Post text with plaintext tags
            get_html_file_content 'text' 'text' <"$1" | sed "/^<p>$template_tags_line_header/s|<a href='$prefix_tags\([^']*\).html'>\\1</a>|\\1|g" >> "$TMPFILE"
            $EDITOR "$TMPFILE"
            filename=$1
        fi
        rm "$filename"
        if [[ $2 == keep ]]; then
            parse_file "$TMPFILE" "$edit_timestamp" "$filename"
        else
            parse_file "$TMPFILE" "$edit_timestamp" # this command sets $filename as the html processed file
            [[ ${1##*.} == md ]] && mv "$1" "${filename%%.*}.md" 2>/dev/null
        fi
        rm "$TMPFILE"
    fi
    touch -t "$touch_timestamp" "$filename"
    touch -t "$touch_timestamp" "$1"
    chmod 644 "$filename"
    echo "Posted $filename"
    tags_after=$(tags_in_post "$filename")
    relevant_tags=$(echo "$tags_before $tags_after" | tr ',' ' ' | tr ' ' '\n' | sort -u | tr '\n' ' ')
    if [[ ! -z $relevant_tags ]]; then
        relevant_posts="$(posts_with_tags $relevant_tags) $filename"
        rebuild_tags "$relevant_posts" "$relevant_tags"
    fi
}

# Create a Twitter summary (twitter "card") for the post
#
# $1 the post file
# $2 the title
twitter_card() {
    [[ -z $global_twitter_username ]] && return
    
    echo "<meta name='twitter:card' content='summary' />"
    echo "<meta name='twitter:site' content='@$global_twitter_username' />"
    echo "<meta name='twitter:title' content='$2' />" # Twitter truncates at 70 char
    description=$(grep -v "^<p>$template_tags_line_header" "$1" | sed -e 's/<[^>]*>//g' | tr '\n' ' ' | sed "s/\"/'/g" | head -c 250) 
    echo "<meta name='twitter:description' content=\"$description\" />"
    image=$(sed -n '2,$ d; s/.*<img.*src="\([^"]*\)".*/\1/p' "$1") # First image is fine
    [[ -z $image ]] && return
    [[ $image =~ ^https?:// ]] || image=$global_url/$image # Check that URL is absolute
    echo "<meta name='twitter:image' content='$image' />"
}

# Adds the code needed by the twitter button
#
# $1 the post URL
twitter() {
    [[ -z $global_twitter_username ]] && return

    if [[ -z $global_disqus_username ]]; then
        if [[ $global_twitter_cookieless == true ]]; then 
            id=$RANDOM

            search_engine="https://twitter.com/search?q="

            echo "<p id='twitter'><a href='http://twitter.com/intent/tweet?url=$1&text=$template_twitter_comment&via=$global_twitter_username'>$template_comments $template_twitter_button</a> "
            echo "<a href='$search_engine""$1'><span id='count-$id'></span></a>&nbsp;</p>"
            return;
        else 
            echo "<p id='twitter'>$template_comments&nbsp;"; 
        fi
    else
        echo "<p id='twitter'><a href=\"$1#disqus_thread\">$template_comments</a> &nbsp;"
    fi  

    echo "<a href=\"https://twitter.com/share\" class=\"twitter-share-button\" data-text=\"$template_twitter_comment\" data-url=\"$1\""
    echo " data-via=\"$global_twitter_username\""
    echo ">$template_twitter_button</a>	<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=\"//platform.twitter.com/widgets.js\";fjs.parentNode.insertBefore(js,fjs);}}(document,\"script\",\"twitter-wjs\");</script>"
    echo "</p>"
}

# Check if the file is a 'boilerplate' (i.e. not a post)
# The return values are designed to be used like this inside a loop:
# is_boilerplate_file <file> && continue
#
# $1 the file
#
# Return 0 (bash return value 'true') if the input file is an index, feed, etc
# or 1 (bash return value 'false') if it is a blogpost
is_boilerplate_file() {
    name=${1#./}
    # First check against user-defined non-blogpost pages
    for item in "${non_blogpost_files[@]}"; do
        [[ "$name" == "$item" ]] && return 0
    done

    case $name in
    ( "$index_file" | "$archive_index" | "$tags_index" | "$footer_file" | "$header_file" | "$global_analytics_file" | "$prefix_tags"* )
        return 0 ;;
    ( * ) # Check for excluded
        for excl in "${html_exclude[@]}"; do
            [[ $name == "$excl" ]] && return 0
        done
        return 1 ;;
    esac
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
# $6     post author
create_html_page() {
    content=$1
    filename=$2
    index=$3
    title=$4
    timestamp=$5
    author=$6

    # Create the actual blog post
    # html, head
    {
        cat ".header.html"
        echo "<title>$title</title>"
        google_analytics
        twitter_card "$content" "$title"
        echo "</head><body>"
        # stuff to add before the actual body content
        [[ -n $body_begin_file ]] && cat "$body_begin_file"
        [[ $filename = $index_file* ]] && [[ -n $body_begin_file_index ]] && cat "$body_begin_file_index"
        # body divs
        echo '<div id="divbodyholder">'
        echo '<div class="headerholder"><div class="header">'
        # blog title
        echo '<div id="title">'
        cat .title.html
        echo '</div></div></div>' # title, header, headerholder
        echo '<div id="divbody"><div class="content">'

        file_url=${filename#./}
        file_url=${file_url%.rebuilt} # Get the correct URL when rebuilding
        # one blog entry
        if [[ $index == no ]]; then
            echo '<!-- entry begin -->' # marks the beginning of the whole post
            echo "<h3><a class=\"ablack\" href=\"$file_url\">"
            # remove possible <p>'s on the title because of markdown conversion
            title=${title//<p>/}
            title=${title//<\/p>/}
            echo "$title"
            echo '</a></h3>'
            if [[ -z $timestamp ]]; then
                echo "<!-- $date_inpost: #$(LC_ALL=$date_locale date +"$date_format_timestamp")# -->"
            else
                echo "<!-- $date_inpost: #$(LC_ALL=$date_locale date +"$date_format_timestamp" --date="$timestamp")# -->"
            fi
            if [[ -z $timestamp ]]; then
                echo -n "<div class=\"subtitle\">$(LC_ALL=$date_locale date +"$date_format")"
            else
                echo -n "<div class=\"subtitle\">$(LC_ALL=$date_locale date +"$date_format" --date="$timestamp")"
            fi
            [[ -n $author ]] && echo -e " &mdash; \n$author"
            echo "</div>"
            echo '<!-- text begin -->' # This marks the text body, after the title, date...
        fi
        cat "$content" # Actual content
        if [[ $index == no ]]; then
            echo -e '\n<!-- text end -->'

            twitter "$global_url/$file_url"

            echo '<!-- entry end -->' # absolute end of the post
        fi

        echo '</div>' # content

        # Add disqus commments except for index and all_posts pages
        [[ $index == no ]] && disqus_body

        # page footer
        cat .footer.html
        # close divs
        echo '</div></div>' # divbody and divbodyholder 
        disqus_footer
        [[ -n $body_end_file ]] && cat "$body_end_file"
        echo '</body></html>'
    } > "$filename"
}

# Parse the plain text file into an html file
#
# $1    source file name
# $2    (optional) timestamp for the file
# $3    (optional) destination file name
# note that although timestamp is optional, something must be provided at its
# place if destination file name is provided, i.e:
# parse_file source.txt "" destination.html
parse_file() {
    # Read for the title and check that the filename is ok
    title=""
    while IFS='' read -r line; do
        if [[ -z $title ]]; then
            # remove extra <p> and </p> added by markdown
            title=$(echo "$line" | sed 's/<\/*p>//g')
            if [[ -n $3 ]]; then
                filename=$3
            else
                filename=$title
                [[ -n $convert_filename ]] &&
                    filename=$(echo "$title" | eval "$convert_filename")
                [[ -n $filename ]] || 
                    filename=$RANDOM # don't allow empty filenames

                filename=$filename.html

                # Check for duplicate file names
                while [[ -f $filename ]]; do
                    filename=${filename%.html}$RANDOM.html
                done
            fi
            content=$filename.tmp
        # Parse possible tags
        elif [[ $line == "<p>$template_tags_line_header"* ]]; then
            tags=$(echo "$line" | cut -d ":" -f 2- | sed -e 's/<\/p>//g' -e 's/^ *//' -e 's/ *$//' -e 's/, /,/g')
            IFS=, read -r -a array <<< "$tags"

            echo -n "<p>$template_tags_line_header " >> "$content"
            for item in "${array[@]}"; do
                echo -n "<a href='$prefix_tags$item.html'>$item</a>, "
            done | sed 's/, $/<\/p>/g' >> "$content"
        else
            echo "$line" >> "$content"
        fi
    done < "$1"

    # Create the actual html page
    create_html_page "$content" "$filename" no "$title" "$2" "$global_author"
    rm "$content"
}

# Manages the creation of the text file and the parsing to html file
# also the drafts
write_entry() {
    test_markdown && fmt=md || fmt=html
    f=$2
    [[ $2 == -html ]] && fmt=html && f=$3

    if [[ -n $f ]]; then
        TMPFILE=$f
        if [[ ! -f $TMPFILE ]]; then
            echo "The file doesn't exist"
            delete_includes
            exit
        fi
        # guess format from TMPFILE
        extension=${TMPFILE##*.}
        [[ $extension == md || $extension == html ]] && fmt=$extension
        # but let user override it (`bb.sh post -html file.md`)
        [[ $2 == -html ]] && fmt=html
        # Test if Markdown is working before re-posting a .md file
        if [[ $extension == md ]]; then
            test_markdown
            if (($? != 0)); then
                echo "Markdown is not working, please edit HTML file directly."
                exit
            fi
        fi
    else
        TMPFILE=.entry-$RANDOM.$fmt
        echo -e "Title on this line\n" >> "$TMPFILE"

        [[ $fmt == html ]] && cat << EOF >> "$TMPFILE"
<p>The rest of the text file is an <b>html</b> blog post. The process will continue as soon
as you exit your editor.</p>

<p>$template_tags_line_header keep-this-tag-format, tags-are-optional, example</p>
EOF
        [[ $fmt == md ]] && cat << EOF >> "$TMPFILE"
The rest of the text file is a **Markdown** blog post. The process will continue
as soon as you exit your editor.

$template_tags_line_header keep-this-tag-format, tags-are-optional, beware-with-underscores-in-markdown, example
EOF
    fi
    chmod 600 "$TMPFILE"

    post_status="E"
    filename=""
    while [[ $post_status != "p" && $post_status != "P" ]]; do
        [[ -n $filename ]] && rm "$filename" # Delete the generated html file, if any
        $EDITOR "$TMPFILE"
        if [[ $fmt == md ]]; then
            html_from_md=$(markdown "$TMPFILE")
            parse_file "$html_from_md"
            rm "$html_from_md"
        else
            parse_file "$TMPFILE" # this command sets $filename as the html processed file
        fi

        chmod 644 "$filename"
        [[ -n $preview_url ]] || preview_url=$global_url
        echo "To preview the entry, open $preview_url/$filename in your browser"

        echo -n "[P]ost this entry, [E]dit again, [D]raft for later? (p/E/d) "
        read -r post_status
        if [[ $post_status == d || $post_status == D ]]; then
            mkdir -p "drafts/"
            chmod 700 "drafts/"

            title=$(head -n 1 $TMPFILE)
            [[ -n $convert_filename ]] && title=$(echo "$title" | eval "$convert_filename")
            [[ -n $title ]] || title=$RANDOM

            draft=drafts/$title.$fmt
            mv "$TMPFILE" "$draft"
            chmod 600 "$draft"
            rm "$filename"
            delete_includes
            echo "Saved your draft as '$draft'"
            exit
        fi
    done

    if [[ $fmt == md && -n $save_markdown ]]; then
        mv "$TMPFILE" "${filename%%.*}.md"
    else
        rm "$TMPFILE"
    fi
    chmod 644 "$filename"
    echo "Posted $filename"
    relevant_tags=$(tags_in_post $filename)
    if [[ -n $relevant_tags ]]; then
        relevant_posts="$(posts_with_tags $relevant_tags) $filename"
        rebuild_tags "$relevant_posts" "$relevant_tags"
    fi
}

# Create an index page with all the posts
all_posts() {
    echo -n "Creating an index page with all the posts "
    contentfile=$archive_index.$RANDOM
    while [[ -f $contentfile ]]; do
        contentfile=$archive_index.$RANDOM
    done

    {
        echo "<h3>$template_archive_title</h3>"
        prev_month=""
        while IFS='' read -r i; do
            is_boilerplate_file "$i" && continue
            echo -n "." 1>&3
            # Month headers
            month=$(LC_ALL=$date_locale date -r "$i" +"$date_allposts_header")
            if [[ $month != "$prev_month" ]]; then
                [[ -n $prev_month ]] && echo "</ul>"  # Don't close ul before first header
                echo "<h4 class='allposts_header'>$month</h4>"
                echo "<ul>"
                prev_month=$month
            fi
            # Title
            title=$(get_post_title "$i")
            echo -n "<li><a href=\"$i\">$title</a> &mdash;"
            # Date
            date=$(LC_ALL=$date_locale date -r "$i" +"$date_format")
            echo " $date</li>"
        done < <(ls -t ./*.html)
        echo "" 1>&3
        echo "</ul>"
        echo "<div id=\"all_posts\"><a href=\"./$index_file\">$template_archive_index_page</a></div>"
    } 3>&1 >"$contentfile"

    create_html_page "$contentfile" "$archive_index.tmp" yes "$global_title &mdash; $template_archive_title" "$global_author"
    mv "$archive_index.tmp" "$archive_index"
    chmod 644 "$archive_index"
    rm "$contentfile"
}

# Create an index page with all the tags
all_tags() {
    echo -n "Creating an index page with all the tags "
    contentfile=$tags_index.$RANDOM
    while [[ -f $contentfile ]]; do
        contentfile=$tags_index.$RANDOM
    done

    {
        echo "<h3>$template_tags_title</h3>"
        echo "<ul>"
        for i in $prefix_tags*.html; do
            [[ -f "$i" ]] || break
            echo -n "." 1>&3
            nposts=$(grep -c "<\!-- text begin -->" "$i")
            tagname=${i#"$prefix_tags"}
            tagname=${tagname%.html}
            case $nposts in
                1) word=$template_tags_posts_singular;;
                2|3|4) word=$template_tags_posts_2_4;;
                *) word=$template_tags_posts;;
            esac
            echo "<li><a href=\"$i\">$tagname</a> &mdash; $nposts $word</li>"
        done
        echo "" 1>&3
        echo "</ul>"
        echo "<div id=\"all_posts\"><a href=\"./$index_file\">$template_archive_index_page</a></div>"
    } 3>&1 > "$contentfile"

    create_html_page "$contentfile" "$tags_index.tmp" yes "$global_title &mdash; $template_tags_title" "$global_author"
    mv "$tags_index.tmp" "$tags_index"
    chmod 644 "$tags_index"
    rm "$contentfile"
}

# Generate the index.html with the content of the latest posts
rebuild_index() {
    echo -n "Rebuilding the index "
    newindexfile=$index_file.$RANDOM
    contentfile=$newindexfile.content
    while [[ -f $newindexfile ]]; do 
        newindexfile=$index_file.$RANDOM
        contentfile=$newindexfile.content
    done

    # Create the content file
    {
        n=0
        while IFS='' read -r i; do
            is_boilerplate_file "$i" && continue;
            if ((n >= number_of_index_articles)); then break; fi
            if [[ -n $cut_do ]]; then
                get_html_file_content 'entry' 'entry' 'cut' <"$i" | awk "/$cut_line/ { print \"<p class=\\\"readmore\\\"><a href=\\\"$i\\\">$template_read_more</a></p>\" ; next } 1"
            else
                get_html_file_content 'entry' 'entry' <"$i"
            fi
            echo -n "." 1>&3
            n=$(( n + 1 ))
        done < <(ls -t ./*.html) # sort by date, newest first

        feed=$blog_feed
        if [[ -n $global_feedburner ]]; then feed=$global_feedburner; fi
        echo "<div id=\"all_posts\"><a href=\"$archive_index\">$template_archive</a> &mdash; <a href=\"$tags_index\">$template_tags_title</a> &mdash; <a href=\"$feed\">$template_subscribe</a></div>"
    } 3>&1 >"$contentfile"

    echo ""

    create_html_page "$contentfile" "$newindexfile" yes "$global_title" "$global_author"
    rm "$contentfile"
    mv "$newindexfile" "$index_file"
    chmod 644 "$index_file"
}

# Finds all tags referenced in one post.
# Accepts either filename as first argument, or post content at stdin
# Prints one line with space-separated tags to stdout
tags_in_post() {
    sed -n "/^<p>$template_tags_line_header/{s/^<p>$template_tags_line_header//;s/<[^>]*>//g;s/[ ,]\+/ /g;p;}" "$1" | tr ', ' ' '
}

# Finds all posts referenced in a number of tags.
# Arguments are tags
# Prints one line with space-separated tags to stdout
posts_with_tags() {
    (($# < 1)) && return
    set -- "${@/#/$prefix_tags}"
    set -- "${@/%/.html}"
    sed -n '/^<h3><a class="ablack" href="[^"]*">/{s/.*href="\([^"]*\)">.*/\1/;p;}' "$@" 2> /dev/null
}

# Rebuilds tag_*.html files
# if no arguments given, rebuilds all of them
# if arguments given, they should have this format:
# "FILE1 [FILE2 [...]]" "TAG1 [TAG2 [...]]"
# where FILEn are files with posts which should be used for rebuilding tags,
# and TAGn are names of tags which should be rebuilt.
# example:
# rebuild_tags "one_post.html another_article.html" "example-tag another-tag"
# mind the quotes!
rebuild_tags() {
    if (($# < 2)); then
        # will process all files and tags
        files=$(ls -t ./*.html)
        all_tags=yes
    else
        # will process only given files and tags
        files=$(printf '%s\n' $1 | sort -u)
        files=$(ls -t $files)
        tags=$2
    fi
    echo -n "Rebuilding tag pages "
    n=0
    if [[ -n $all_tags ]]; then
        rm ./"$prefix_tags"*.html &> /dev/null
    else
        for i in $tags; do
            rm "./$prefix_tags$i.html" &> /dev/null
        done
    fi
    # First we will process all files and create temporal tag files
    # with just the content of the posts
    tmpfile=tmp.$RANDOM
    while [[ -f $tmpfile ]]; do tmpfile=tmp.$RANDOM; done
    while IFS='' read -r i; do
        is_boilerplate_file "$i" && continue;
        echo -n "."
        if [[ -n $cut_do ]]; then
            get_html_file_content 'entry' 'entry' 'cut' <"$i" | awk "/$cut_line/ { print \"<p class=\\\"readmore\\\"><a href=\\\"$i\\\">$template_read_more</a></p>\" ; next } 1"
        else
            get_html_file_content 'entry' 'entry' <"$i"
        fi >"$tmpfile"
        for tag in $(tags_in_post "$i"); do
            if [[ -n $all_tags || " $tags " == *" $tag "* ]]; then
                cat "$tmpfile" >> "$prefix_tags$tag".tmp.html
            fi
        done
    done <<< "$files"
    rm "$tmpfile"
    # Now generate the tag files with headers, footers, etc
    while IFS='' read -r i; do
        tagname=${i#./"$prefix_tags"}
        tagname=${tagname%.tmp.html}
        create_html_page "$i" "$prefix_tags$tagname.html" yes "$global_title &mdash; $template_tag_title \"$tagname\"" "$global_author"
        rm "$i"
    done < <(ls -t ./"$prefix_tags"*.tmp.html 2>/dev/null)
    echo
}

# Return the post title
#
# $1 the html file
get_post_title() {
    awk '/<h3><a class="ablack" href=".+">/, /<\/a><\/h3>/{if (!/<h3><a class="ablack" href=".+">/ && !/<\/a><\/h3>/) print}' "$1"
}

# Return the post author
#
# $1 the html file
get_post_author() { 
    awk '/<div class="subtitle">.+/, /<!-- text begin -->/{if (!/<div class="subtitle">.+/ && !/<!-- text begin -->/) print}' "$1" | sed 's/<\/div>//g'
}

# Displays a list of the tags
#
# $2 if "-n", tags will be sorted by number of posts
list_tags() {
    if [[ $2 == -n ]]; then do_sort=1; else do_sort=0; fi

    ls ./$prefix_tags*.html &> /dev/null
    (($? != 0)) && echo "No posts yet. Use 'bb.sh post' to create one" && return

    lines=""
    for i in $prefix_tags*.html; do
        [[ -f "$i" ]] || break
        nposts=$(grep -c "<\!-- text begin -->" "$i")
        tagname=${i#"$prefix_tags"}
        tagname=${tagname#.html}
        ((nposts > 1)) && word=$template_tags_posts || word=$template_tags_posts_singular
        line="$tagname # $nposts # $word"
        lines+=$line\\n
    done

    if (( do_sort == 1 )); then
        echo -e "$lines" | column -t -s "#" | sort -nrk 2
    else
        echo -e "$lines" | column -t -s "#" 
    fi
}

# Displays a list of the posts
list_posts() {
    ls ./*.html &> /dev/null
    (($? != 0)) && echo "No posts yet. Use 'bb.sh post' to create one" && return

    lines=""
    n=1
    while IFS='' read -r i; do
        is_boilerplate_file "$i" && continue
        line="$n # $(get_post_title "$i") # $(LC_ALL=$date_locale date -r "$i" +"$date_format")"
        lines+=$line\\n
        n=$(( n + 1 ))
    done < <(ls -t ./*.html)

    echo -e "$lines" | column -t -s "#"
}

# Generate the feed file
make_rss() {
    echo -n "Making RSS "

    rssfile=$blog_feed.$RANDOM
    while [[ -f $rssfile ]]; do rssfile=$blog_feed.$RANDOM; done

    {
        pubdate=$(LC_ALL=C date +"$date_format_full")
        echo '<?xml version="1.0" encoding="UTF-8" ?>' 
        echo '<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:dc="http://purl.org/dc/elements/1.1/">' 
        echo "<channel><title>$global_title</title><link>$global_url/$index_file</link>"
        echo "<description>$global_description</description><language>en</language>"
        echo "<lastBuildDate>$pubdate</lastBuildDate>"
        echo "<pubDate>$pubdate</pubDate>"
        echo "<atom:link href=\"$global_url/$blog_feed\" rel=\"self\" type=\"application/rss+xml\" />"
    
        n=0
        while IFS='' read -r i; do
            is_boilerplate_file "$i" && continue
            ((n >= number_of_feed_articles)) && break # max 10 items
            echo -n "." 1>&3
            echo '<item><title>' 
            get_post_title "$i"
            echo '</title><description><![CDATA[' 
            get_html_file_content 'text' 'entry' $cut_do <"$i"
            echo "]]></description><link>$global_url/${i#./}</link>" 
            echo "<guid>$global_url/$i</guid>" 
            echo "<dc:creator>$(get_post_author "$i")</dc:creator>" 
            echo "<pubDate>$(LC_ALL=C date -r "$i" +"$date_format_full")</pubDate></item>"
    
            n=$(( n + 1 ))
        done < <(ls -t ./*.html)
    
        echo '</channel></rss>'
    } 3>&1 >"$rssfile"
    echo ""

    mv "$rssfile" "$blog_feed"
    chmod 644 "$blog_feed"
}

# generate headers, footers, etc
create_includes() {
    {
        echo "<h1 class=\"nomargin\"><a class=\"ablack\" href=\"$global_url/$index_file\">$global_title</a></h1>" 
        echo "<div id=\"description\">$global_description</div>"
    } > ".title.html"

    if [[ -f $header_file ]]; then cp "$header_file" .header.html
    else {
        echo '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'
        echo '<html xmlns="http://www.w3.org/1999/xhtml"><head>'
        echo '<meta http-equiv="Content-type" content="text/html;charset=UTF-8" />'
        echo '<meta name="viewport" content="width=device-width, initial-scale=1.0" />'
        printf '<link rel="stylesheet" href="%s" type="text/css" />\n' "${css_include[@]}"
        if [[ -z $global_feedburner ]]; then
            echo "<link rel=\"alternate\" type=\"application/rss+xml\" title=\"$template_subscribe_browser_button\" href=\"$blog_feed\" />"
        else 
            echo "<link rel=\"alternate\" type=\"application/rss+xml\" title=\"$template_subscribe_browser_button\" href=\"$global_feedburner\" />"
        fi
        } > ".header.html"
    fi

    if [[ -f $footer_file ]]; then cp "$footer_file" .footer.html
    else {
        protected_mail=${global_email//@/&#64;}
        protected_mail=${protected_mail//./&#46;}
        echo "<div id=\"footer\">$global_license <a href=\"$global_author_url\">$global_author</a> &mdash; <a href=\"mailto:$protected_mail\">$protected_mail</a><br/>"
        echo 'Generated with <a href="https://github.com/cfenollosa/bashblog">bashblog</a>, a single bash script to easily create blogs like this one</div>'
        } >> ".footer.html"
    fi
}

# Delete the temporarily generated include files
delete_includes() {
    rm ".title.html" ".footer.html" ".header.html"
}

# Create the css file from scratch
create_css() {
    # To avoid overwriting manual changes. However it is recommended that
    # this function is modified if the user changes the blog.css file
    (( ${#css_include[@]} > 0 )) && return || css_include=('main.css' 'blog.css')
    if [[ ! -f blog.css ]]; then 
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
        img{max-width:100%;}
        #twitter{line-height:20px;vertical-align:top;text-align:right;font-style:italic;color:#333;margin-top:24px;font-size:14px;}' > blog.css
    fi

    # If there is a style.css from the parent page (i.e. some landing page)
    # then use it. This directive is here for compatibility with my own
    # home page. Feel free to edit it out, though it doesn't hurt
    if [[ -f ../style.css ]] && [[ ! -f main.css ]]; then
        ln -s "../style.css" "main.css" 
    elif [[ ! -f main.css ]]; then
        echo 'body{font-family:Georgia,"Times New Roman",Times,serif;margin:0;padding:0;background-color:#F3F3F3;}
        #divbodyholder{padding:5px;background-color:#DDD;width:100%;max-width:874px;margin:24px auto;}
        #divbody{border:solid 1px #ccc;background-color:#fff;padding:0px 48px 24px 48px;top:0;}
        .headerholder{background-color:#f9f9f9;border-top:solid 1px #ccc;border-left:solid 1px #ccc;border-right:solid 1px #ccc;}
        .header{width:100%;max-width:800px;margin:0px auto;padding-top:24px;padding-bottom:8px;}
        .content{margin-bottom:5%;}
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

    for i in ./*.html; do
        is_boilerplate_file "$i" && continue;
        contentfile=.tmp.$RANDOM
        while [[ -f $contentfile ]]; do contentfile=.tmp.$RANDOM; done

        echo -n "."
        # Get the title and entry, and rebuild the html structure from scratch (divs, title, description...)
        title=$(get_post_title "$i")

        get_html_file_content 'text' 'text' <"$i" >> "$contentfile"

        # Read timestamp from post, if present, and sync file timestamp
        timestamp=$(awk '/<!-- '$date_inpost': .+ -->/ { print }' "$i" | cut -d '#' -f 2)
        [[ -n $timestamp ]] && touch -t "$timestamp" "$i"
        # Read timestamp from file in correct format for 'create_html_page'
        timestamp=$(LC_ALL=C date -r "$i" +"$date_format_full")

        create_html_page "$contentfile" "$i.rebuilt" no "$title" "$timestamp" "$(get_post_author "$i")"
        # keep the original timestamp!
        timestamp=$(LC_ALL=C date -r "$i" +"$date_format_timestamp")
        mv "$i.rebuilt" "$i"
        chmod 644 "$i"
        touch -t "$timestamp" "$i"
        rm "$contentfile"
    done
    echo ""
}

# Displays the help
usage() {
    echo "$global_software_name v$global_software_version"
    echo "Usage: $0 command [filename]"
    echo ""
    echo "Commands:"
    echo "    post [-html] [filename] insert a new blog post, or the filename of a draft to continue editing it"
    echo "                            it tries to use markdown by default, and falls back to HTML if it's not available."
    echo "                            use '-html' to override it and edit the post as HTML even when markdown is available"
    echo "    edit [-n|-f] [filename] edit an already published .html or .md file. **NEVER** edit manually a published .html file,"
    echo "                            always use this function as it keeps internal data and rebuilds the blog"
    echo "                            use '-n' to give the file a new name, if title was changed"
    echo "                            use '-f' to edit full html file, instead of just text part (also preserves name)"
    echo "    delete [filename]       deletes the post and rebuilds the blog"
    echo "    rebuild                 regenerates all the pages and posts, preserving the content of the entries"
    echo "    reset                   deletes everything except this script. Use with a lot of caution and back up first!"
    echo "    list                    list all posts"
    echo "    tags [-n]               list all tags in alphabetical order"
    echo "                            use '-n' to sort list by number of posts"
    echo ""
    echo "For more information please open $0 in a code editor and read the header and comments"
}

# Delete all generated content, leaving only this script
reset() {
    echo "Are you sure you want to delete all blog entries? Please write \"Yes, I am!\" "
    read -r line
    if [[ $line == "Yes, I am!" ]]; then
        rm .*.html ./*.html ./*.css ./*.rss &> /dev/null
        echo
        echo "Deleted all posts, stylesheets and feeds."
        echo "Kept your old '.backup.tar.gz' just in case, please delete it manually if needed."
    else
        echo "Phew! You dodged a bullet there. Nothing was modified."
    fi
}

# Detects if GNU date is installed
date_version_detect() {
	date --version >/dev/null 2>&1
	if (($? != 0));  then
		# date utility is BSD. Test if gdate is installed 
		if gdate --version >/dev/null 2>&1 ; then
            date() {
                gdate "$@"
            }
		else
            # BSD date
            date() {
                if [[ $1 == -r ]]; then
                    # Fall back to using stat for 'date -r'
                    format=${3//+/}
                    stat -f "%Sm" -t "$format" "$2"
                elif [[ $2 == --date* ]]; then
                    # convert between dates using BSD date syntax
                    command date -j -f "$date_format_full" "${2#--date=}" "$1" 
                else
                    # acceptable format for BSD date
                    command date -j "$@"
                fi
            }
        fi
    fi    
}

# Main function
# Encapsulated on its own function for readability purposes
#
# $1     command to run
# $2     file name of a draft to continue editing (optional)
do_main() {
    # Detect if using BSD date or GNU date
    date_version_detect
    # Load default configuration, then override settings with the config file
    global_variables
    [[ -f $global_config ]] && source "$global_config" &> /dev/null 
    global_variables_check

    # Check for $EDITOR
    [[ -z $EDITOR ]] && 
        echo "Please set your \$EDITOR environment variable. For example, to use nano, add the line 'export EDITOR=nano' to your \$HOME/.bashrc file" && exit

    # Check for validity of argument
    [[ $1 != "reset" && $1 != "post" && $1 != "rebuild" && $1 != "list" && $1 != "edit" && $1 != "delete" && $1 != "tags" ]] && 
        usage && exit

    [[ $1 == list ]] &&
        list_posts && exit

    [[ $1 == tags ]] &&
        list_tags "$@" && exit

    if [[ $1 == edit ]]; then
        if (($# < 2)) || [[ ! -f ${!#} ]]; then
            echo "Please enter a valid .md or .html file to edit"
            exit
        fi
    fi

    # Test for existing html files
    if ls ./*.html &> /dev/null; then
        # We're going to back up just in case
        tar -c -z -f ".backup.tar.gz" -- *.html &&
            chmod 600 ".backup.tar.gz"
    elif [[ $1 == rebuild ]]; then
        echo "Can't find any html files, nothing to rebuild"
        exit
    fi

    # Keep first backup of this day containing yesterday's version of the blog
    [[ ! -f .yesterday.tar.gz || $(date -r .yesterday.tar.gz +'%d') != "$(date +'%d')" ]] &&
        cp .backup.tar.gz .yesterday.tar.gz &> /dev/null

    [[ $1 == reset ]] &&
        reset && exit

    create_css
    create_includes
    [[ $1 == post ]] && write_entry "$@"
    [[ $1 == rebuild ]] && rebuild_all_entries && rebuild_tags
    [[ $1 == delete ]] && rm "$2" &> /dev/null && rebuild_tags
    if [[ $1 == edit ]]; then
        if [[ $2 == -n ]]; then
            edit "$3"
        elif [[ $2 == -f ]]; then
            edit "$3" full
        else
            edit "$2" keep
        fi
    fi
    rebuild_index
    all_posts
    all_tags
    make_rss
    delete_includes
}


#
# MAIN
# Do not change anything here. If you want to modify the code, edit do_main()
#
do_main "$@"

# vim: set shiftwidth=4 tabstop=4 expandtab:
