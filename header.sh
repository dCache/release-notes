#!/bin/bash


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


#echo Versionnumbers
#echo ${Version[@]}


length=${#Version[@]}
#echo "length of array = $length"
#echo ${Version[length-1]}

header_start="<a href=\"/manuals/releasenotes.shtml\">release notes</a>
   | Book: "
header_end="| <a href=\"http://trac.dcache.org/trac.cgi/wiki\">Wiki</a>
   | <a href=\"/manuals/FAQ.shtml\">Q&amp;A</a>
   <img src=\"/images/black_bg.png\" width=\"100%\" height=\"1\" alt=\"black_bg\" border=\"0\" />"

#*****************************************************************************************
#   create file                                                                          *
#   ../../template/frags/header-docs-overview.shtml                                      *
#                                                                                        * 
#  This file needs to be changed for each new release.                                   * 
#*****************************************************************************************

headerdocsoverview=""

for ((i=$length; i>0; i--));
do
    if [ $i -ne $length ]; then
	headerdocsoverview="$headerdocsoverview, "
    fi
    headerdocsoverview="$headerdocsoverview<a href=\"/manuals/Book-${Version[i-1]}/index-fhs.shtml\">${Version[i-1]}</a>"
done

echo "     create ../../template/frags/header-docs-overview.shtml"
echo -ne "<div class=\"book-navi\">
   $header_start
   $headerdocsoverview
   $header_end
</div>" >../../template/frags/header-docs-overview.shtml




#********************************************************************************************
#    Create files:                                                                          *
#       ../../template/frags/header-docs-${Version[i]}-fhs.shtml                            * 
#    These files need to be changed for each new release.                                   *
#********************************************************************************************

headerdocsversion=""
for ((j=$length; j>0; j--)); do
    for ((i=$length; i>0; i--)); do

	if [ $i -ne $length ]; then
	    headerdocsversion="$headerdocsversion, "
	fi

	if [ "$j" = "$i" ]; then
	    headerdocsversion="$headerdocsversion<span class=\"activ\">${Version[i-1]}</span>"

	else
	    headerdocsversion="$headerdocsversion<a href=\"/manuals/Book-${Version[i-1]}/index-fhs.shtml\">${Version[i-1]}</a>"
	fi
     done

     echo "     create ../../template/frags/header-docs-${Version[j-1]}-fhs.shtml"
    echo -ne "<div class=\"book-navi\">
           $header_start
           $headerdocsversion
           $header_end
</div>" >../../template/frags/header-docs-${Version[j-1]}-fhs.shtml


   headerdocsversion=""
   done

#******************************************************************************************
# create files                                                                            *
#    ../../template/frags/header-book-${Version[i]}-fhs.shtml                             *
# if they do not exist                                                                    *
#******************************************************************************************

# for ((i=0; i<$length; i++));  use when 1.9.12 should not be in header anymore
for ((i=0; i<$length-1; i++)); # delete when 1.9.12 should not be in header anymore

do

# does the file ../../template/frags/header-book-${Version[i]}-fhs.shtml exist?

file="../../template/frags/header-book-${Version[i]}-fhs.shtml"
if [ ! -e $file ];

then       

echo "     $file does not exist and will be generated"

# generate the file ../../template/frags/header-book-${Version[i]}-fhs.shtml
echo "     create $file"
echo -ne "<div class=\"book-type\">
   Web:
   <a href=\"/manuals/Book-${Version[i]}/index-fhs.shtml\">Multi-page</a>,
   <a href=\"/manuals/Book-${Version[i]}/Book-fhs.shtml\">Single page</a>
   | PDF: <a href=\"/manuals/Book-${Version[i]}/Book-fhs-a4.pdf\">A4-size</a>,
   <a href=\"/manuals/Book-${Version[i]}/Book-fhs-letter.pdf\">Letter-size</a>
   | eBook: <a href=\"/manuals/Book-${Version[i]}/Book-fhs.epub\">epub</a>
   <img src=\"/images/black_bg.png\" width=\"100%\" height=\"1\" alt=\"black_bg\" border=\"0\" />
</div>" >../../template/frags/header-book-${Version[i]}-fhs.shtml


else
echo "     $file exists and will not be generated"

fi

done


#********************************************************************************************
# Create files:                                                                             *
#     ../../template/l3-docs-book-${Version[i-1]}-fhs-header.shtml                          *
# if they do not exist                                                                      * 
#********************************************************************************************

# for ((i=$length; i>0; i--)); use when 1.9.12 should not be in header anymore
for ((i=$length-1; i>0; i--));  # delete when 1.9.12 should not be in header anymore
  do
     file="../../template/l3-docs-book-${Version[i-1]}-fhs-header.shtml"
     if [ ! -e $file ];

	 then

echo "     $file does not exist and will be generated"

# generate the file ../../template/l3-docs-book-${Version[i-1]}-fhs-header.shtml

echo "     create $file"
	 echo -ne "<!--#include virtual=\"/template/frags/header-beginning.shtml\" -->
<!--#include virtual=\"/template/frags/header-docs-${Version[i-1]}-fhs.shtml\" -->
<!--#include virtual=\"/template/frags/header-book-${Version[i-1]}-fhs.shtml\" -->
<!--#include virtual=\"/template/frags/header-end.shtml\" -->
 " >../../template/l3-docs-book-${Version[i-1]}-fhs-header.shtml

else
echo "     $file exists and will not be generated"
     fi
done

exit 0
