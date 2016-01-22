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

header_195_1912="<a href=\"/manuals/releasenotes.shtml\">release notes</a>
   | Book:
   <a href=\"/manuals/Book-1.9.5\"> 1.9.5</a>,
   1.9.12 (<a href=\"/manuals/Book-1.9.12\">opt</a>, <a href=\"/manuals/Book-1.9.12/index-fhs.shtml\">FHS</a>),"   
headerend="| <a href=\"http://trac.dcache.org/trac.cgi/wiki\">Wiki</a>
   | <a href=\"/manuals/FAQ.shtml\">Q&amp;A</a>
   <img src=\"/images/black_bg.png\" width=\"100%\" height=\"1\" alt=\"black_bg\" border=\"0\" />"

#*****************************************************************************************
#   create file                                                                          *
#   ../../template/frags/header-docs-overview.shtml                                      *
#                                                                                        * 
#  This file needs to be changed for each new release.                                   * 
#*****************************************************************************************

headerdocsoverview=""

for ((i=$length-1; i>0; i--));
do
headerdocsoverview="$headerdocsoverview${Version[i-1]} (<a href=\"/manuals/Book-${Version[i-1]}/index-fhs.shtml\">FHS</a>),\n"

done

echo "     create ../../template/frags/header-docs-overview.shtml"
# delete the line <a href=\"/manuals/Book-1.9.5\">1.9.5</a>,
# when 1.9.5 should not be in header anymore
# delete the line 1.9.12 (<a href="/manuals/Book-1.9.12">opt</a>, <a href="/manuals/Book-1.9.12/index-fhs.shtml">FHS</a>),
# when 1.9.12 should not be in header anymore
echo -ne "<div class=\"book-navi\">
   $header_195_1912
   $headerdocsoverview
   $headerend
</div>" >../../template/frags/header-docs-overview.shtml



#*************************************************************************************************
#           delete this section when 1.9.5 should not be in header anymore                       *
#*************************************************************************************************
#
# create file
# ../../template/frags/header-docs-1.9.5.shtml
#This file needs to be changed for each new release.

headerdocsversion=""

     for ((i=$length-1; i>0; i--));  
     do
	       headerdocsversion="$headerdocsversion \n${Version[i-1]} (<a href=\"/manuals/Book-${Version[i-1]}/index-fhs.shtml\">FHS</a>),"

     done


     echo "     create ../../template/frags/header-docs-1.9.5.shtml"

	 echo -ne "<div class=\"book-navi\">
   <a href=\"/manuals/releasenotes.shtml\">release notes</a>
   | Book:
   <span class=\"activ\">1.9.5</span>,
   1.9.12 (<a href=\"/manuals/Book-1.9.12\">opt</a>, <a href=\"/manuals/Book-1.9.12/index-fhs.shtml\">FHS</a>),
           $headerdocsversion
           $headerend
</div>" >../../template/frags/header-docs-1.9.5.shtml


#
#*************************************************************************************************
#            delete the above section when 1.9.5 should not be in header anymore                 *
#*************************************************************************************************




#**************************************************************************************************
#           delete this section when 1.9.12 should not be in header anymore                       *
#**************************************************************************************************
#
# create file
# ../../template/frags/header-docs-1.9.12-opt.shtml
#This file needs to be changed for each new release.
#
headerdocsversion=""

     for ((i=$length-1; i>0; i--));  
       do
	       headerdocsversion="$headerdocsversion \n${Version[i-1]} (<a href=\"/manuals/Book-${Version[i-1]}/index-fhs.shtml\">FHS</a>),"

     done


     echo "     create ../../template/frags/header-docs-1.9.12-opt.shtml"

	 echo -ne "<div class=\"book-navi\">
   <a href=\"/manuals/releasenotes.shtml\">release notes</a>
   | Book:
   <a href=\"/manuals/Book-1.9.5\">1.9.5</a>,
           <span class=\"activ\">1.9.12</span> (<span class=\"activ\">opt</span>, <a href=\"/manuals/Book-1.9.12/index-fhs.shtml\">FHS</a>),
           $headerdocsversion
           $headerend
</div>" >../../template/frags/header-docs-1.9.12-opt.shtml


#
# create file
# ../../template/frags/header-docs-1.9.12-fhs.shtml
#This file needs to be changed for each new release.

headerdocsversion=""


     for ((i=$length-1; i>0; i--));  
       do
	       headerdocsversion="$headerdocsversion \n${Version[i-1]} (<a href=\"/manuals/Book-${Version[i-1]}/index-fhs.shtml\">FHS</a>),"

     done


     echo "     create ../../template/frags/header-docs-1.9.12-fhs.shtml"

	 echo -ne "<div class=\"book-navi\">
   <a href=\"/manuals/releasenotes.shtml\">release notes</a>
   | Book:
   <a href=\"/manuals/Book-1.9.5\">1.9.5</a>,
   <span class=\"activ\">1.9.12</span> (<a href=\"/manuals/Book-1.9.12\">opt</a>, <span class=\"activ\">FHS</span>),
           $headerdocsversion
           $headerend
</div>" >../../template/frags/header-docs-1.9.12-fhs.shtml


#*************************************************************************************************
#            delete the above section when 1.9.12 should not be in header anymore                 *
#*************************************************************************************************





#********************************************************************************************
#    Create files:                                                                          *
#       ../../template/frags/header-docs-${Version[i]}-fhs.shtml                            * 
#    These files need to be changed for each new release.                                   *
#********************************************************************************************

headerdocsversion=""
#   for ((j=$length; j>0; j--));  use when 1.9.12 should not be in header anymore
   for ((j=$length-1; j>0; j--));   # delete when 1.9.12 should not be in header anymore
     do
     for ((i=$length-1; i>0; i--));  
       do

       if [ "$j" = "$i" ];
	   then
	       headerdocsversion="$headerdocsversion<span class=\"activ\">${Version[i-1]}</span> <span class=\"activ\">(FHS)</span>,\n"

       else
	       headerdocsversion="$headerdocsversion${Version[i-1]} (<a href=\"/manuals/Book-${Version[i-1]}/index-fhs.shtml\">FHS</a>),\n"

       fi

     done

     echo "     create ../../template/frags/header-docs-${Version[j-1]}-fhs.shtml"
# delete the line <a href=\"/manuals/Book-1.9.5\">1.9.5</a>,
# when 1.9.5 should not be in header anymore
    echo -ne "<div class=\"book-navi\">
           $header_195_1912 
           $headerdocsversion
           $headerend
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