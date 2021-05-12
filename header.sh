#!/bin/bash

#  The next (currently unreleased) version of dCache
NEXT_RELEASE=7.2

#  Path within the filesystem corresponding to the web-server's root
WEB_ROOT="../.."

if [ `uname` = "SunOS" ]; then
    echo "
The script header.sh does not run on SunOS.
     Please login to dcache-infra03 to run the script!"
    exit 1
fi

while IFS='<>' read _ starttag value endtag; do
    case "$starttag" in
        version-prefix)       Version+=("$value");;
    esac
done < releases.xml

Version=(${Version[@]%-})
Version=(${Version[@]%.})


Version=("$NEXT_RELEASE" "${Version[@]}")

#echo Versionnumbers
#echo ${Version[@]}


length=${#Version[@]}

header_start="<a href=\"/manuals/releasenotes.shtml\">release notes</a>"
header_userguide_start=" | UserGuide: "
header_book_start=" | Book: "
header_end="| <a href=\"http://trac.dcache.org/trac.cgi/wiki\">Wiki</a>
   | <a href=\"/manuals/FAQ.shtml\">Q&amp;A</a>
   <img src=\"/images/black_bg.png\" width=\"100%\" height=\"1\" alt=\"black_bg\" border=\"0\" />"

#*****************************************************************************************
#   create file                                                                          *
#   $WEB_ROOT/template/frags/header-docs-overview.shtml                                  *
#                                                                                        *
#  This file needs to be changed for each new release.                                   *
#*****************************************************************************************

headeruserguideoverview=""
headerdocsoverview=""

book_type() { # $1 - dCache version, $2 dir prefix
    local bookPath="$WEB_ROOT/manuals/$2-$1"

    if [ -f $bookPath/index-fhs.shtml ]; then
        echo "DocBook"
    elif [ -d $bookPath ]; then
        echo "Markdown"
    else
        echo "Missing"
    fi
}

name_for_version() { # $1 - dCache version
    if [ "$1" = "$NEXT_RELEASE" ]; then
        echo "$1 (unreleased)"
    else
        echo "$1"
    fi
}


link_for_version() { # $1 - version, $2 dir prefix
    local bookPath="/manuals/$2-$1"
    local name=$(name_for_version $1)

    case "$(book_type "$1" "$2")" in
        DocBook)
            echo "<a href=\"$bookPath/index-fhs.shtml\">$name</a>"
            ;;

        Markdown)
            echo "<a href=\"$bookPath\">$name</a>"
            ;;

        Missing)
            echo "$name"
            ;;
    esac
}

for ((i=$length; i>0; i--));
do
    thisVersion=${Version[i-1]}
    book_html="$(link_for_version "$thisVersion" Book)"
    guide_html="$(link_for_version "$thisVersion" UserGuide)"
    if [ $i -ne $length ]; then
        headerdocsoverview="$headerdocsoverview, $book_html"
	headeruserguideoverview="$headeruserguideoverview, $guide_html"
    else
        headerdocsoverview="$book_html"
	headeruserguideoverview="$guide_html"
    fi
done

echo "     create $WEB_ROOT/template/frags/header-docs-overview.shtml"
echo -ne "<div class=\"book-navi\">
   $header_start
   $header_userguide_start
   $headeruserguideoverview
   $header_book_start
   $headerdocsoverview
   $header_end
</div>" >$WEB_ROOT/template/frags/header-docs-overview.shtml




#********************************************************************************************
#    Create files:                                                                          *
#       $WEB_ROOT/template/frags/header-docs-VERSION-fhs.shtml                              *
#       $WEB_ROOT/template/frags/header-docs-VERSION-userguide.shtml                        *
#    These files need to be changed for each new release.                                   *
#********************************************************************************************

for ((j=$length; j>0; j--)); do
    header_book_version=""
    header_book_version_all_live=""
    header_userguide_version=""
    header_userguide_version_all_live=""
    for ((i=$length; i>0; i--)); do
        thisVersion="${Version[i-1]}"
        if [ $i -ne $length ]; then
            header_book_version="$header_book_version, "
            header_book_version_all_live="$header_book_version_all_live, "
            header_userguide_version="$header_userguide_version, "
            header_userguide_version_all_live="$header_userguide_version_all_live, "
        fi

	book_html="$(link_for_version "$thisVersion" Book)"
	userguide_html="$(link_for_version "$thisVersion" UserGuide)"
        if [ "$j" = "$i" ]; then
            header_book_version="$header_book_version<span class=\"activ\">$(name_for_version "$thisVersion")</span>"
            header_userguide_version="$header_userguide_version<span class=\"activ\">$(name_for_version "$thisVersion")</span>"
        else
            header_book_version="$header_book_version$book_html"
            header_userguide_version="$header_userguide_version$userguide_html"
        fi
	header_book_version_all_live="$header_book_version_all_live$book_html"
	header_userguide_version_all_live="$header_userguide_version_all_live$userguide_html"
     done

     outerVersion="${Version[j-1]}"
     compat_path=$WEB_ROOT/template/frags/header-docs-$outerVersion.shtml
     book_path=$WEB_ROOT/template/frags/header-docs-book-$outerVersion.shtml
     userguide_path=$WEB_ROOT/template/frags/header-docs-userguide-$outerVersion.shtml

     ## REVISIT remove compat path once all Book versions are updated
     ## to include the header-docs-book-<version> template.
     cat >$compat_path <<EOF
<div class="book-navi">
$header_start
$header_userguide_start
$header_userguide_version_all_live
$header_book_start
$header_book_version
$header_end
</div>
EOF
     cat >$book_path <<EOF
<div class="book-navi">
$header_start
$header_userguide_start
$header_userguide_version_all_live
$header_book_start
$header_book_version
$header_end
</div>
EOF
     cat >$userguide_path <<EOF
<div class="book-navi">
$header_start
$header_userguide_start
$header_userguide_version
$header_book_start
$header_book_version_all_live
$header_end
</div>
EOF
done

#******************************************************************************************
# create files                                                                            *
#    $WEB_ROOT/template/frags/header-book-VERSION-fhs.shtml                               *
# for DocBook versions of The Book                                                        *
#******************************************************************************************

for ((i=0; i<$length-1; i++)); do
    thisVersion=${Version[i]}

    if [ $(book_type "$thisVersion" Book) = "DocBook" ]; then
        cat >$WEB_ROOT/template/frags/header-book-$thisVersion-fhs.shtml <<EOF
<div class="book-type">
   Web:
   <a href="/manuals/Book-${Version[i]}/index-fhs.shtml">Multi-page</a>,
   <a href="/manuals/Book-${Version[i]}/Book-fhs.shtml">Single page</a>
   | PDF: <a href="/manuals/Book-${Version[i]}/Book-fhs-a4.pdf">A4-size</a>,
   <a href="/manuals/Book-${Version[i]}/Book-fhs-letter.pdf">Letter-size</a>
   | eBook: <a href="/manuals/Book-${Version[i]}/Book-fhs.epub">epub</a>
   <img src="/images/black_bg.png" width="100%" height="1" alt="black_bg" border="0" />
</div>
EOF

    fi

done


#********************************************************************************************
# Create files:                                                                             *
#     $WEB_ROOT/template/l3-docs-book-VERSION-fhs-header.shtml                              *
# or                                                                                        *
#     $WEB_ROOT/template/l3-docs-book-VERSION-header.shtml                                  *
#********************************************************************************************

for ((i=$length-1; i>0; i--)); do
    thisVersion=${Version[i-1]}

    case $(book_type "$thisVersion" Book) in
        DocBook)
            cat >$WEB_ROOT/template/l3-docs-book-$thisVersion-fhs-header.shtml << EOF
<!--#include virtual="/template/frags/header-beginning.shtml" -->
<!--#include virtual="/template/frags/header-docs-$thisVersion-fhs.shtml" -->
<!--#include virtual="/template/frags/header-book-$thisVersion-fhs.shtml" -->
<!--#include virtual="/template/frags/header-end.shtml" -->
EOF
            ;;

        Markdown)
            cat >$WEB_ROOT/template/l3-docs-book-$thisVersion-header.shtml << EOF
<!--#include virtual="/template/frags/header-beginning.shtml" -->
<!--#include virtual="/template/frags/header-docs-$thisVersion.shtml" -->
<!--#include virtual="/template/frags/header-book-$thisVersion.shtml" -->
<!--#include virtual="/template/frags/header-end.shtml" -->
EOF
            ;;
    esac
done

exit 0
