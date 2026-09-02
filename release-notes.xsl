<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes" encoding="utf-8"/>
  <xsl:param name="version"/>
  <xsl:param name="ribbon-url"/>

  <xsl:template match="/html/body">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
    <html lang="en">
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><xsl:value-of select="/html/head/title"/> - dCache.org</title>
        <link rel="stylesheet" href="/css/style.css"/>
        <link rel="stylesheet" href="/css/custom.css"/>
        <link rel="stylesheet" href="/documentation/css/dCacheBook-common.css"/>
        <link rel="stylesheet" href="/documentation/css/prism.css"/>
        <link rel="stylesheet" href="/documentation/css/dCacheBook-dcacheorg.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-fork-ribbon-css/0.2.2/gh-fork-ribbon.min.css"/>
        <script src="/lib/prism.js"/>
        <link rel="icon" href="/favicon.ico"/>
        <style>
          .book-navi { font-size:9pt; font-weight:bold; color:#003172; text-transform:uppercase;
            text-align:right; max-width:1080px; margin:0 auto; padding:8px 16px;
            border-bottom:2px solid #c00; background:#f5f5f5; line-height:1.8; }
          .book-navi a { color:#800; font-weight:bold; text-decoration:none; }
          .book-navi a:hover { text-decoration:underline; }
          .book-content { max-width:1080px; margin:0 auto; padding:24px 16px 48px; }
          .github-fork-ribbon { position:sticky !important; top:0 !important; float:right; z-index:1000; }
          .book-content dl { display:grid; grid-template-columns:max-content 1fr; row-gap:6px; column-gap:10px; }
          .book-content dl dt { margin-top:4px; font-style:normal; font-weight:normal; }
          .book-content dl dd { margin:0; }
          h5 { font-size:15px; font-style:italic; margin-top:20px; }
        </style>
      </head>
      <body>
        <!-- new site header -->
        <xsl:text disable-output-escaping="yes"><![CDATA[
<header class="header">
  <div class="container header__container">
    <div class="logo logo--mixed">
      <a class="logo__link" href="/" title="dCache.org" rel="home">
        <div class="logo__item logo__imagebox">
          <img class="logo__img" src="/img/dCache-logo.svg" alt="dCache logo">
        </div>
        <div class="logo__item logo__text">
          <div class="logo__title">dCache.org</div>
          <div class="logo__tagline">distributed storage for scientific data</div>
        </div>
      </a>
    </div>
    <nav class="menu">
      <button class="menu__btn" aria-haspopup="true" aria-expanded="false" tabindex="0">
        <span class="menu__btn-title" tabindex="-1">Menu</span>
      </button>
      <ul class="menu__list">
        <li class="menu__item"><a class="menu__link" href="/"><span class="menu__text">Main</span></a></li>
        <li class="menu__item"><a class="menu__link" href="/post/"><span class="menu__text">Posts</span></a></li>
        <li class="menu__item"><a class="menu__link" href="/downloads/"><span class="menu__text">Downloads</span></a></li>
        <li class="menu__item"><a class="menu__link" href="/release/"><span class="menu__text">Releases</span></a></li>
        <li class="menu__item menu__item--active"><a class="menu__link" href="/documentation/"><span class="menu__text">Documentation</span></a></li>
        <li class="menu__item"><a class="menu__link" href="/support/"><span class="menu__text">Support</span></a></li>
        <li class="menu__item"><a class="menu__link" href="/about/"><span class="menu__text">About Us</span></a></li>
        <li class="menu__item"><a class="menu__link" href="/development/"><span class="menu__text">Developer's Corner</span></a></li>
      </ul>
    </nav>
  </div>
</header>]]></xsl:text>
        <!-- ribbon -->
        <a class="github-fork-ribbon" data-ribbon="Edit me on GitHub" title="Edit me on GitHub">
          <xsl:attribute name="href"><xsl:value-of select="$ribbon-url"/></xsl:attribute>
          Edit me on GitHub
        </a>
        <!-- version nav injected by CI per version -->
        <div class="book-navi">
          <b>Release Notes:</b>
          <xsl:text disable-output-escaping="yes">VERSION_NAV_PLACEHOLDER</xsl:text>
        </div>
        <main class="main">
          <div class="book-content markdown-body">
            <xsl:apply-templates select="node()"/>
          </div>
        </main>
        <footer class="footer">
          <div class="container footer__container">
            <div class="footer__copyright">
              Copyright &#169; 2003&#8211;2026 <a href="mailto:support@dcache.org">dCache.org</a>
            </div>
          </div>
        </footer>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="dl">
    <xsl:copy>
      <xsl:attribute name="class">dl-horizontal</xsl:attribute>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="pre/code">
    <xsl:copy>
      <xsl:attribute name="class">prettyprint lang-xml</xsl:attribute>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>