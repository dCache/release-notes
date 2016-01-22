<?xml version="1.0"?>

<!DOCTYPE stylesheet [

<!-- Page location, without trailing '/' -->
<!ENTITY base-uri     "http://www.dcache.org/downloads/1.9" >

<!-- Arbirary URI prefix for building GUID -->
<!ENTITY guid-prefix  "http://www.dcache.org/" >

<!-- Location of the feed image -->
<!ENTITY rss-icon-uri "http://www.dcache.org/images/dCache+rss.png" >

<!-- Name of all releases feed -->
<!ENTITY all-feeds-filename "rss-all-releases.xml">
]>


<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:date="http://exslt.org/dates-and-times"
		xmlns:exsl="http://exslt.org/common"
		extension-element-prefixes="date exsl">

  <xsl:output method="xml"
	      cdata-section-elements="description"/>

  <xsl:template match="/">
    <xsl:call-template name="build-all-releases-feed"/>
    <xsl:call-template name="build-each-series-feed"/>
  </xsl:template>


  <xsl:template name="build-all-releases-feed">
    <exsl:document href="&all-feeds-filename;">
      <xsl:apply-templates select="/" mode="emit-rss-contents"/>
    </exsl:document>
  </xsl:template>


  <xsl:template name="build-each-series-feed">
    <xsl:apply-templates select="download-page/series" mode="emit-feed"/>
  </xsl:template>


  <xsl:template match="series" mode="emit-feed">
    <exsl:document href="{concat('rss-',@id,'-releases.xml')}">
      <xsl:apply-templates select="/" mode="emit-rss-contents">
	<xsl:with-param name="id" select="@id"/>
      </xsl:apply-templates>
    </exsl:document>
  </xsl:template>


  <xsl:template match="download-page" mode="emit-rss-contents">
    <xsl:param name="id"/>

    <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
      <channel>

	<xsl:choose>
	  <xsl:when test="$id">
	    <xsl:variable name="title-text"
			  select="concat('dCache ', series[@id=$id]/title)"/>
	    <xsl:variable name="link-url" select="concat('&base-uri;/index.shtml#',$id)"/>

	    <image>
	      <url>&rss-icon-uri;</url>
	      <title><xsl:value-of select="$title-text"/></title>
	      <link><xsl:value-of select="$link-url"/></link>
	    </image>

	    <title><xsl:value-of select="$title-text"/></title>
	    <link><xsl:value-of select="$link-url"/></link>
	    <atom:link href="{concat('&base-uri;/rss-',$id,'-releases.xml')}"
		       rel="self" type="application/rss+xml" />

	    <description>
	      <xsl:apply-templates select="series[@id=$id]/description/*" mode="emit.as.html"/>
	    </description>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:variable name="title-text" select="'dCache releases'"/>

	    <image>
	      <url>&rss-icon-uri;</url>
	      <title><xsl:value-of select="$title-text"/></title>
	      <link>&base-uri;</link>
	    </image>

	    <title><xsl:value-of select="$title-text"/></title>
	    <link>&base-uri;</link>
	    <atom:link href="&base-uri;/&all-feeds-filename;"
		       rel="self" type="application/rss+xml" />

	    <description>
	      Aggregation of release news for all dCache software on
	      &lt;a href="&base-uri;">this page&lt;/a>.
	    </description>
	  </xsl:otherwise>
	</xsl:choose>

	<language>en</language>

	<lastBuildDate><xsl:call-template name="rfc822-date"/></lastBuildDate>

	<xsl:choose>
	  <xsl:when test="$id">
	    <xsl:apply-templates select="series[@id=$id]/releases/release"
				 mode="emit-rss-contents">
	      <!-- sort by year -->
	      <xsl:sort select="substring-after(substring-after(date, '.'), '.')"
			order="descending"
			data-type="number"/>
	      <!-- sort by month -->
	      <xsl:sort select="substring-before(substring-after(date, '.'), '.')"
			order="descending"
			data-type="number"/>
	      <!-- sort by day -->
	      <xsl:sort select="substring-before(date, '.')"
			order="descending"
			data-type="number"/>
	    </xsl:apply-templates>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:apply-templates select="series/releases/release"
				 mode="emit-rss-contents">
	      <!-- sort by year -->
	      <xsl:sort select="substring-after(substring-after(date, '.'), '.')"
			order="descending"
			data-type="number"/>
	      <!-- sort by month -->
	      <xsl:sort select="substring-before(substring-after(date, '.'), '.')"
			order="descending"
			data-type="number"/>
	      <!-- sort by day -->
	      <xsl:sort select="substring-before(date, '.')"
			order="descending"
			data-type="number"/>
	    </xsl:apply-templates>
	  </xsl:otherwise>
	</xsl:choose>
      </channel>
    </rss>
  </xsl:template>



  <xsl:template match="release" mode="emit-rss-contents">
    <xsl:variable name="version" select="concat(../version-prefix,@version,@pack-version)"/>

    <xsl:variable name="name">
      <xsl:call-template name="expand-version">
        <xsl:with-param name="string" select="../name"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="notes-filename">
      <xsl:call-template name="get-notes-filename"/>
    </xsl:variable>

    <xsl:variable name="notes-url"
		  select="concat('&base-uri;/', $notes-filename,'#',@version)"/>

    <xsl:variable name="release-anchor-url"
		  select="concat('&base-uri;/index.shtml#',../version-prefix, @version)"/>
		  
    <item>
      <link><xsl:value-of select="$release-anchor-url"/></link>

      <guid>&guid-prefix;<xsl:value-of
      select="concat('downloads/1.9/index.shtml#',../version-prefix,@version)"/></guid>   
      
      
      <title>Release of <xsl:value-of select="$name"/></title>

      <pubDate>
	<xsl:call-template name="rfc822-date">
	  <xsl:with-param name="date">
	    <xsl:call-template name="emit-iso-time"/>
	  </xsl:with-param>
	</xsl:call-template>
      </pubDate>

      <description>
	Announcing the release of <xsl:value-of select="$name"/>.
	This software release is available for download as
	<xsl:apply-templates select="package"
	mode="packages.list-as-hot-links"/>.
	&lt;br>
	&lt;br>
	For more information about this release, please read the &lt;a
	href="<xsl:value-of select="$notes-url"/>">release
	notes&lt;/a> or visit the
	&lt;a
	href="<xsl:value-of select="'&base-uri;'"/>">download page&lt;/a>.
	
	&lt;hr>
	The &lt;a href="http://www.dcache.org">dCache.org&lt;/a> team.
      </description>
    </item>
  </xsl:template>

  <xsl:template match="package" mode="packages.list-as-hot-links">
    <xsl:text>&lt;a href="</xsl:text>
    <xsl:call-template name="build-download-url"/>"><xsl:value-of select="@name"/>
    <xsl:text>&lt;/a></xsl:text>

    <xsl:choose>
      <xsl:when test="count(following-sibling::package) > 1">
	<xsl:text>, </xsl:text>
      </xsl:when>
      <xsl:when test="count(following-sibling::package) = 1">
	<xsl:text> and </xsl:text>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="build-download-url">
    <xsl:call-template name="expand-pack-version">
      <xsl:with-param name="string"
		      select="concat('&base-uri;/',../../download-url-prefix,download-url)"/>
      <xsl:with-param name="version" select="../@version"/>
      <xsl:with-param name="version-prefix" select="../../version-prefix"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="expand-version">
    <xsl:param name="string"/>
    <xsl:param name="version" select="@version"/>
    <xsl:param name="version-prefix" select="../version-prefix"/>

    <xsl:choose>
      <xsl:when test="contains($string,'VERSION')">
        <xsl:value-of select="concat(substring-before($string,'VERSION'),
			      $version-prefix, $version,
			      substring-after($string, 'VERSION'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="expand-pack-version">
    <xsl:param name="string"/>
    <xsl:param name="version" select="@version"/>
    <xsl:param name="version-prefix" select="../version-prefix"/>

    <xsl:choose>
      <xsl:when test="contains($string,'VERSION')">
        <xsl:value-of select="concat(substring-before($string,'VERSION'),
			      $version-prefix, $version,../@pack-version,
			      substring-after($string, 'VERSION'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
  
  

  <xsl:template name="get-notes-filename">
    <xsl:call-template name="expand-version">
      <xsl:with-param name="string">
	<xsl:choose>
	  <xsl:when test="count(package/notes-url) = 1">
	    <xsl:value-of select="package/notes-url"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="../notes-url"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="emit-iso-time">
    <xsl:variable name="day" select="substring-before(date,'.')"/>
    <xsl:variable name="month" select="substring-before(substring-after(date,'.'),'.')"/>
    <xsl:variable name="year" select="substring-after(substring-after(date,'.'),'.')"/>
    <xsl:value-of select="concat($year, '-', $month, '-', $day, 'T12:00:00')"/>
  </xsl:template>



  <xsl:template name="rfc822-date">
    <xsl:param name="date" select="date:date-time()"/>

    <xsl:variable name="isodate" select="date:date-time()"/>

    <xsl:value-of select="concat(date:day-abbreviation($date), ', ',
  format-number(date:day-in-month($date), '00'), ' ',
  date:month-abbreviation($date), ' ', date:year($date), ' ',
  format-number(date:hour-in-day($date), '00'), ':',
  format-number(date:minute-in-hour($date), '00'), ':',
  format-number(date:second-in-minute($date), '00'), ' ',
  substring($isodate,string-length($isodate)-5,3),
  substring($isodate,string-length($isodate)-1))"/>
  </xsl:template>


  <xsl:template match="*" mode="emit.as.html">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:apply-templates select="attribute::*" mode="emit.html.attributes"/>
    <xsl:text>></xsl:text>

    <xsl:apply-templates select="*|text()" mode="emit.as.html"/>

    <xsl:text>&lt;/</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>></xsl:text>
  </xsl:template>


  <xsl:template match="@*" mode="emit.html.attributes">
    <xsl:text> </xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>="</xsl:text>
    <xsl:choose>
      <xsl:when test="starts-with(., 'http://')">
	<xsl:value-of select="."/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="concat('&base-uri;/', .)"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>"</xsl:text>
  </xsl:template>

</xsl:stylesheet>
