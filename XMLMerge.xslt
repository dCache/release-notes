<?xml version="1.0" encoding="utf-8"?>
<!--+
    |  Code taken from:
    |
    |      http://blog.mastykarz.nl/how-to-do-it-rss-aggregation-merging-multiple-xml-files-using-xslt/
    +-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                extension-element-prefixes="exsl">
  <xsl:output method="xml" indent="yes"/>

  <!-- Limit number of items (0 => unlimited) -->
  <xsl:variable name="FeedsNumber" select="10"/>
	
  <xsl:variable name="Months" select="'Jan;Feb;Mar;Apr;May;Jun;Jul;Aug;Sep;Oct;Nov;Dec'"/>

  <xsl:variable name="Aggregation">
<!--    <xsl:copy-of select="document('1.9/rss-server-1.9.5-releases.xml')/rss/channel/item"/> -->
    <xsl:copy-of select="document('1.9/rss-server-1.9.12-releases.xml')/rss/channel/item"/>
    <xsl:copy-of select="document('1.9/rss-server-2.2-releases.xml')/rss/channel/item"/>

    <xsl:copy-of select="document('1.9/srm/rss-srm-client-releases.xml')/rss/channel/item"/>
  </xsl:variable>

  <xsl:variable name="RSS">
    <xsl:for-each select="exsl:node-set($Aggregation)/item">
      <!-- year -->
      <xsl:sort select="substring(pubDate, 13, 4)" order="descending" data-type="number"/>
      <!-- month -->
      <xsl:sort select="string-length(substring-before($Months, substring(pubDate, 9, 3)))"
		order="descending" data-type="number"/>
      <!-- day -->
      <xsl:sort select="substring(pubDate, 6, 2)" order="descending" data-type="number"/>
      <!-- hour -->
      <xsl:sort select="substring(pubDate, 18, 2)" order="descending" data-type="number"/>
      <!-- minute -->
      <xsl:sort select="substring(pubDate, 21, 2)" order="descending" data-type="number"/>
      <!-- second -->
      <xsl:sort select="substring(pubDate, 24, 2)" order="descending" data-type="number"/>
      <xsl:copy-of select="current()"/>
    </xsl:for-each>
  </xsl:variable>

  <xsl:template match="/">
    <rss version="2.0">
      <channel>
        <title>dCache releases</title>
        <link>http://www.dcache.org/downloads/1.9</link>

        <image>
          <url>http://www.dcache.org/images/dCache+rss.png</url>
          <title>dCache releases</title>
          <link>http://www.dcache.org/downloads/1.9</link>
        </image>

        <atom:link xmlns:atom="http://www.w3.org/2005/Atom" 
                   href="http://www.dcache.org/downloads/emi-releases.xml"
                   rel="self" type="application/rss+xml"/>

        <description>
            Releases of dCache server and the dCache SRM client.
        </description>

	<xsl:choose>
	  <xsl:when test="$FeedsNumber&gt;0">
	    <xsl:for-each select="exsl:node-set($RSS)/item">
	      <xsl:if test="position()&lt;=$FeedsNumber">
		<xsl:copy-of select="current()"/>
	      </xsl:if>
	    </xsl:for-each>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:copy-of select="$RSS"/>
	  </xsl:otherwise>
	</xsl:choose>
      </channel>
    </rss>
  </xsl:template>
</xsl:stylesheet>
