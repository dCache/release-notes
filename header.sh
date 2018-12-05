#!/bin/bash

#  The next (currently unreleased) version of dCache
NEXT_RELEASE=5.0

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

header_start="<a href=\"/manuals/releasenotes.shtml\">release notes</a>
   | Book: "
header_end="| <a href=\"http://trac.dcache.org/trac.cgi/wiki\">Wiki</a>
   | <a href=\"/manuals/FAQ.shtml\">Q&amp;A</a>
   <img src=\"/images/black_bg.png\" width=\"100%\" height=\"1\" alt=\"black_bg\" border=\"0\" />"

#*****************************************************************************************
#   create file                                                                          *
#   $WEB_ROOT/template/frags/header-docs-overview.shtml                                  *
#                                                                                        *
#  This file needs to be changed for each new release.                                   *
#*****************************************************************************************

headerdocsoverview=""

book_type() { # $1 - dCache version
    local bookPath="$WEB_ROOT/manuals/Book-$1"

    if [ -f $bookPath/index-fhs.shtml ]; then
        echo "DocBook"
    elif [ -d $bookPath ]; then
        echo "Markdown"
    else
        echo "Missing"
    fi
}

link_for_version() { # $1 - version
    local bookPath="/manuals/Book-$1"
    local name

    if [ "$1" = "$NEXT_RELEASE" ]; then
        name="$1 (unreleased)"
    else
        name="$1"
    fi

    case $(book_type "$1") in
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
    html="$(link_for_version ${Version[i-1]})"
    if [ $i -ne $length ]; then
        headerdocsoverview="$headerdocsoverview, $html"
    else
        headerdocsoverview="$html"
    fi
done

echo "     create $WEB_ROOT/template/frags/header-docs-overview.shtml"
echo -ne "<div class=\"book-navi\">
   $header_start
   $headerdocsoverview
   $header_end
</div>" >$WEB_ROOT/template/frags/header-docs-overview.shtml




#********************************************************************************************
#    Create files:                                                                          *
#       $WEB_ROOT/template/frags/header-docs-VERSION-fhs.shtml                              *
#    These files need to be changed for each new release.                                   *
#********************************************************************************************

headerdocsversion=""
for ((j=$length; j>0; j--)); do
    for ((i=$length; i>0; i--)); do
        thisVersion="${Version[i-1]}"
        if [ $i -ne $length ]; then
            headerdocsversion="$headerdocsversion, "
        fi

        if [ "$j" = "$i" ]; then
            headerdocsversion="$headerdocsversion<span class=\"activ\">${Version[i-1]}</span>"

        else
            headerdocsversion="$headerdocsversion$(link_for_version "${Version[i-1]}")"
        fi
     done

     echo "     create $WEB_ROOT/template/frags/header-docs-${Version[j-1]}-fhs.shtml"
    echo -ne "<div class=\"book-navi\">
           $header_start
           $headerdocsversion
           $header_end
</div>" >$WEB_ROOT/template/frags/header-docs-${Version[j-1]}-fhs.shtml


   headerdocsversion=""
   done

#******************************************************************************************
# create files                                                                            *
#    $WEB_ROOT/template/frags/header-book-VERSION-fhs.shtml                               *
# for DocBook versions of The Book                                                        *
#******************************************************************************************

for ((i=0; i<$length-1; i++)); do
    thisVersion=${Version[i]}

    if [ $(book_type "$thisVersion") = "DocBook" ]; then
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

    case $(book_type "$thisVersion") in
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
