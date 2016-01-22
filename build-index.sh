#!/bin/sh

cd `dirname $0`
basedir=$(pwd)

#  Rebuild the index page
/usr/bin/xsltproc build-index.xsl releases.xml > index.shtml
xsltproc build-srm-index.xsl srm-releases.xml > srm/index.shtml
chmod 664 index.shtml 2>/dev/null

#  Rebuild unsupported index page
xsltproc build-index.xsl unsupported/releases.xml > unsupported/index.shtml
chmod 664 unsupported/index.shtml >/dev/null

#  Rebuild the RSS feeds
rm -f rss-*.xml
xsltproc rss.xsl releases.xml
xsltproc srm-rss.xsl srm-releases.xml

#  Rebuild the unsupported RSS feed
rm -f unsupported/rss-*.xml
cd unsupported
xsltproc rss.xsl releases.xml
cd "$basedir"

#  and the EMI feed
../update-rss.sh

#  Rebuild timeline diagram
rm timeline/Build-from-SVN/svn-tags.xml
make -C timeline/Build-from-SVN
make -C timeline

echo "   Rebuild the files /template/frags/header-docs-*"
echo "   Create /template/frags/header-book-* if it does not exist"
echo "   Create /template/l3-docs-book-* if it does not exist"
./header.sh

