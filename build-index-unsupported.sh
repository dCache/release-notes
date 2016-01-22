#!/bin/sh

cd `dirname $0`
xsltproc build-index.xsl releases.xml > index.shtml
chmod 664 index.shtml 2>/dev/null

#  Rebuild the RSS feeds
rm -f rss-*.xml
xsltproc rss.xsl releases.xml
#  and the EMI feed
#../update-rss.sh
