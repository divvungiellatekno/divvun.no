<?xml version="1.0"?>
<!--
site-to-xhtml.xsl is the final stage in HTML page production.  It merges HTML from
document-to-html.xsl, tab-to-menu.xsl and book-to-menu.xsl, and adds the site header,
footer, searchbar, css etc.  As input, it takes XML of the form:

<site>
  <div class="menu">
    ...
  </div>
  <div class="tab">
    ...
  </div>
  <div class="content">
    ...
  </div>
</site>

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1" exclude-result-prefixes="i18n">
    <xsl:import href="lm://transform.skin.common.html.site-to-xhtml"/>

    <!-- Overall site template -->
    <xsl:template match="site">
        <xsl:comment>html lang="en" xml:lang="en"</xsl:comment>
        <html>
            <xsl:comment>HTML-head</xsl:comment>
            <head>
                <xsl:comment>generator meta</xsl:comment>
                <xsl:comment>Add some Forrest-specific metadata</xsl:comment>
                <xsl:call-template name="html-meta"/>
                <xsl:comment>Add any metadata from the documents</xsl:comment>
                <xsl:call-template name="meta-data"/>
                <meta charset="utf-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <xsl:comment>title</xsl:comment>
                <title>
                    <xsl:value-of select="div[@id='content']/h1"/>
                    <xsl:if test="count($config/motd/motd-option) &gt; 0">
                        <xsl:for-each select="$config/motd/motd-option">
                            <xsl:choose>
                                <xsl:when test="@starts-with='true'">
                                    <xsl:if test="starts-with($path, @pattern)">
                                        <xsl:if test="normalize-space(motd-title) != ''">
                                            <xsl:text> (</xsl:text>
                                            <xsl:value-of select="motd-title"/>
                                            <xsl:text>)</xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="contains($path, @pattern)">
                                        <xsl:if test="normalize-space(motd-title) != ''">
                                            <xsl:text> (</xsl:text>
                                            <xsl:value-of select="motd-title"/>
                                            <xsl:text>)</xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:if>
                </title>
                <xsl:comment>stylesheets</xsl:comment>
                <link rel="stylesheet" href="{$root}skin/basic.css" type="text/css"/>
                <link rel="stylesheet" href="{$root}skin/screen.css" type="text/css" media="screen" />
                <link rel="stylesheet" href="{$root}skin/print.css" type="text/css" media="print" />
                <link rel="stylesheet" href="{$root}skin/profile.css" type="text/css" />
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous" />
                <xsl:comment>Javascripts</xsl:comment>
                <script type="text/javascript" language="javascript" src="{$root}skin/getBlank.js"></script>
                <script type="text/javascript" language="javascript" src="{$root}skin/getMenu.js"></script>
                <script type="text/javascript" language="javascript" src="{$root}skin/fontsize.js"></script>
                <xsl:comment>favicon</xsl:comment>
                <xsl:if test="//skinconfig/favicon-url">
                    <link rel="shortcut icon">
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat($root,//skinconfig/favicon-url)"/>
                        </xsl:attribute>
                    </link>
                </xsl:if>
            </head>
            <xsl:comment>HTML-body</xsl:comment>
            <body>
                <xsl:call-template name="carry-body-attribs"/>
                <script type="text/javascript">ndeSetTextSize();</script>
                <xsl:comment> +Site structure
+++++++++++++++++++++++++++
+=========================+
|       topstrip          |
+=========================+
|                         |
|       centerstrip       |
|                         |
|                         |
+=========================+
|       bottomstrip       |
+=========================+
+++++++++++++++++++++++++++
                </xsl:comment>
                <xsl:comment>topstrip with logos and search box</xsl:comment>
                <div id="top">
                    <xsl:comment>breadcrumbs org location</xsl:comment>
                    <!--<xsl:if test="not ($config/trail/@location)">
                        <xsl:comment>breadtrail</xsl:comment>
                        <div class="breadtrail">
                            <xsl:call-template name="breadcrumbs"/>
                        </div>
                    </xsl:if>-->
                    <xsl:comment>header</xsl:comment>
                    <div class="header col-sm-12">
                        <xsl:comment>start Tabs</xsl:comment>
                        <nav class="navbar navbar-expand-lg navbar-light bg-light">
                            <xsl:comment>start Project Logo</xsl:comment>
                            <xsl:variable name="xtest">
                                <xsl:choose>
                                    <xsl:when test="$config/group-url and $config/search and not($config/search/@box-location = 'alt')">
                                        <xsl:text>true</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>false</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:if test="$xtest='false'" >
                                <xsl:attribute name="class">
                                    <xsl:text>projectlogoA1</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:call-template name="renderlogo">
                                <xsl:with-param name="name" select="$config/project-name"/>
                                <xsl:with-param name="url"  select="$config/project-url"/>
                                <xsl:with-param name="logo" select="$config/project-logo"/>
                                <xsl:with-param name="root" select="$root"/>
                                <xsl:with-param name="description" select="$config/project-description"/>
                                <xsl:with-param name="height" select="$config/project-logo-height"/>
                                <xsl:with-param name="width"  select="$config/project-logo-width"/>
                                <xsl:with-param name="aclass" select="'navbar-brand'"/>
                            </xsl:call-template>

                            <xsl:comment>end Project Logo</xsl:comment>

                            <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
                                <span class="navbar-toggler-icon"></span>
                            </button>


                            <div class="collapse navbar-collapse" id="navbarNavDropdown">
                                <ul class="navbar-nav">
                                    <xsl:apply-templates select="div[@id='tabs']/li"/>
                                </ul>
                            </div>

                            <!-- Search form -->
                            <script>
                                //GOOGLE SEARCH
                                function Gsitesearch(curobj, domainroot){
                                curobj.q.value="site:"+domainroot+" "+curobj.qfront.value
                                }
                            </script>
                            <form class="form-inline" action="http://www.google.com/search" method="get" onSubmit="Gsitesearch(this, '{$config/search/@domain}')">
                                <input name="q" type="hidden" />
                                <input name="qfront" class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search" />
                                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
                            </form>
                        </nav>
                        <xsl:comment>end Tabs</xsl:comment>
                    </div>
                </div>
                <xsl:comment>centerstrip with menu and mainarea</xsl:comment>
                <div id="main" class="container-fluid">
<!--                    <div id="publishedStrip">
                        <xsl:call-template name="last-published"/>
                    </div>-->
                    <xsl:comment>breadtrail</xsl:comment>
                    <!--<div class="breadtrail">
                        <xsl:choose>
                            <xsl:when test="$config/trail/@location='alt'">
                                <xsl:call-template name="breadcrumbs"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:comment>*NO* breadtrail</xsl:comment>
                                    &#160;
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>-->
                    <div class="row">
                        <xsl:comment>start Menu, mainarea</xsl:comment>
                        <xsl:if test="div[@id='menu']/ul">
                            <xsl:call-template name="menu"/>
                        </xsl:if>
                        <xsl:comment>start content</xsl:comment>
                        <div id="article" class="col-md-9">
                            <xsl:apply-templates select="div[@id='content']"/>
                        </div>
                        <xsl:comment>end content</xsl:comment>
                        <div class="clearboth">&#160;</div>
                    </div>
                </div>
                <xsl:comment>bottomstrip with footer</xsl:comment>
                <div class="row container-fluid">
                    <div id="footer" class="col-sm-12">
                        <xsl:comment>start bottomstrip</xsl:comment>
                        <div class="lastmodified">
                            <xsl:call-template name="last-published"/>
                        </div>
                        <xsl:if test="$filename = 'index.html'">
                            <div id="logos" >
                                <xsl:if test="$config/disable-compliance-links/@align">
                                    <xsl:attribute name="style">text-align: <xsl:value-of select="$config/disable-compliance-links/@align"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:comment>W3C logos style="text-align: center;"</xsl:comment>
                                <xsl:call-template name="compliancy-logos"/>
                                <xsl:if test="$filename = 'index.html' and $config/credits">
                                    <xsl:for-each select="$config/credits/credit[not(@role='pdf')]">
                                        <xsl:if test="not(@box-location = 'alt') and not(@box-location = 'alt2')">
                                            <xsl:variable name="name" select="name"/>
                                            <xsl:variable name="url" select="url"/>
                                            <xsl:variable name="image" select="image"/>
                                            <xsl:variable name="width" select="width"/>
                                            <xsl:variable name="height" select="height"/><a href="{$url}">
                                                <img alt="{$name} - logo" title="{$name}" border="0">
                                                    <xsl:attribute name="src">
                                                        <xsl:if test="not(starts-with($image, 'http://'))">
                                                            <xsl:value-of select="$root"/>
                                                        </xsl:if>
                                                        <xsl:value-of select="$image"/>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="style">
                                                        <xsl:if test="$width">width:
                                                            <xsl:value-of select="$width"/>px;
                                                        </xsl:if>
                                                        <xsl:if test="$height">height:
                                                            <xsl:value-of select="$height"/>px;
                                                        </xsl:if>
                                                    </xsl:attribute>
                                                </img>
                                            </a>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                            </div>
                        </xsl:if>
                        <xsl:comment>end bottomstrip</xsl:comment>
                    </div>
                </div>
                <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
                <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
            </body>
        </html>
    </xsl:template>

    <xsl:template name="last-published">
        <script type="text/javascript"><![CDATA[<!-- document.write("]]><i18n:text >Last Published:</i18n:text><![CDATA[ " + document.lastModified);
    //  -->]]></script>
    </xsl:template>

    <!-- headings -->
    <xsl:template match="div[@class = 'skinconf-heading-1']">
        <xsl:choose>
            <xsl:when test="//skinconfig/headings/@type='underlined'">
                <h2 class="underlined_10">
                    <xsl:apply-templates select="(h1/title/*|h1/title/text())"/>
                </h2>
            </xsl:when>
            <xsl:when test="//skinconfig/headings/@type='boxed'">
                <h2 class="boxed">
                    <xsl:apply-templates select="(h1/title/*|h1/title/text())"/>
                </h2>
            </xsl:when>
            <xsl:otherwise>
                <h2 class="h3">
                    <xsl:apply-templates select="(h1/title/*|h1/title/text())"/>
                </h2>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="div[@class = 'skinconf-heading-2']">
        <xsl:choose>
            <xsl:when test="//skinconfig/headings/@type='underlined'">
                <h3 class="underlined_5">
                    <xsl:apply-templates select="(h2/title/*|h2/title/text())"/>
                </h3>
            </xsl:when>
            <xsl:when test="//skinconfig/headings/@type='boxed'">
                <h3 class="boxed">
                    <xsl:apply-templates select="(h2/title/*|h2/title/text())"/>
                </h3>
            </xsl:when>
            <xsl:otherwise>
                <h3 class="h4">
                    <xsl:apply-templates select="(h2/title/*|h2/title/text())"/>
                </h3>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Add links to any standards-compliance logos -->
    <xsl:template name="compliancy-logos">
        <xsl:if test="$filename = 'index.html' and $config/disable-compliance-links = 'false'">
            <a href="http://validator.w3.org/check/referer">
                <img class="logoImage" src="{$skin-img-dir}/valid-html401.png" alt="Valid HTML 4.01!" title="Valid HTML 4.01!" style="height: 31px; width: 88px;" />
            </a>
            <a href="http://jigsaw.w3.org/css-validator/check/referer">
                <img class="logoImage" src="{$skin-img-dir}/vcss.png" alt="Valid CSS!" title="Valid CSS!" style="height: 31px; width: 88px;"/>
            </a>
        </xsl:if>
    </xsl:template>

    <xsl:template name="menu">
        <xsl:comment>start Menu</xsl:comment>
        <div id="menu" class="col-sm-3">
            <ul class="sidebar bg-light">
                <xsl:comment>menu - inner</xsl:comment>
                <xsl:for-each select = "div[@id='menu']/ul/li">
                    <xsl:call-template name = "innermenuli" >
                        <xsl:with-param name="id" select="concat('1_', position())"/>
                    </xsl:call-template>
                </xsl:for-each>
            </ul>
            <xsl:comment>start group logo</xsl:comment>
            <xsl:if test="$config/group-url">
                <hr/>
                <div class="group-logo">
                    <xsl:call-template name="renderlogo">
                        <xsl:with-param name="name" select="$config/group-name"/>
                        <xsl:with-param name="url" select="$config/group-url"/>
                        <xsl:with-param name="logo" select="$config/group-logo"/>
                        <xsl:with-param name="root" select="$root"/>
                        <xsl:with-param name="description" select="$config/group-description"/>
                        <xsl:with-param name="height" select="150"/>
                    </xsl:call-template>
                </div>
            </xsl:if>
            <xsl:if test="$config/host-url">
                <div class="host-logo">
                    <xsl:call-template name="renderlogo">
                         <xsl:with-param name="name" select="$config/host-name"/>
                         <xsl:with-param name="url" select="$config/host-url"/>
                         <xsl:with-param name="logo" select="$config/host-logo"/>
                         <xsl:with-param name="root" select="$root"/>

                        <xsl:with-param name="description" select="$config/group-description"/>
                        <xsl:with-param name="height" select="50"/>
                    </xsl:call-template>
                </div>
            </xsl:if>
            <xsl:if test="not($config/disable-copyright-footer = 'true')">
                <div class="copyright">
                    Copyright &#169;
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$config/year"/>
                    <xsl:call-template name="current-year">
                        <xsl:with-param name="copyrightyear" select="$config/year"/>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                    <xsl:choose>
                        <xsl:when test="$config/copyright-link">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$config/copyright-link"/>
                                </xsl:attribute>
                                <xsl:value-of select="$config/vendor"/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$config/vendor"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="$config/trademark-statement">
                        <br />
                        <xsl:value-of select="$config/trademark-statement"/>
                    </xsl:if>
                </div>
                <div class="feedback">
                    <xsl:if test="$config/feedback">
                        <xsl:call-template name="feedback"/>
                    </xsl:if>
                </div>
            </xsl:if>
            <xsl:comment>end group logo</xsl:comment>
            <xsl:comment>credits in alternative location</xsl:comment>
            <div id="credit">
                <xsl:if test="$filename = 'index.html' and $config/credits and ($config/credits/credit/@box-location = 'alt')">
                <hr />
                <xsl:for-each select="$config/credits/credit[not(@role='pdf')]">
                    <xsl:if test="@box-location = 'alt'">
                        <xsl:variable name="name" select="name"/>
                        <xsl:variable name="url" select="url"/>
                        <xsl:variable name="image" select="image"/>
                        <xsl:variable name="width" select="width"/>
                        <xsl:variable name="height" select="height"/>
                            <a href="{$url}">
                                <img alt="{$name} - logo" title="{$name}" border="0">
                                    <xsl:attribute name="src">
                                        <xsl:if test="not(starts-with($image, 'http://'))">
                                            <xsl:value-of select="$root"/>
                                        </xsl:if>
                                        <xsl:value-of select="$image"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="style">
                                        <xsl:if test="$width">width: <xsl:value-of select="$width"/>px;</xsl:if>
                                        <xsl:if test="$height">height: <xsl:value-of select="$height"/>px;</xsl:if>
                                    </xsl:attribute>
                                </img>
                            </a>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                <xsl:comment>Message of the day</xsl:comment>
                <xsl:if test="count($config/motd/motd-option) &gt; 0">
                    <xsl:for-each select="$config/motd/motd-option">
                        <xsl:choose>
                            <xsl:when test="@starts-with='true'">
                                <xsl:if test="starts-with($path, @pattern)">
                                    <xsl:if test="motd-page/@location='alt' or motd-page/@location='both'">
                                        <hr />
                                        <xsl:value-of select="motd-page"/>
                                        <xsl:if test="motd-page-url">
                                            <xsl:text> (</xsl:text>
                                            <a>
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="motd-page-url"/>
                                                </xsl:attribute>
                                                <xsl:text>More</xsl:text>
                                            </a>
                                            <xsl:text>)</xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="contains($path, @pattern)">
                                    <xsl:if test="motd-page/@location='alt' or motd-page/@location='both'">
                                        <hr />
                                        <xsl:value-of select="motd-page"/>
                                        <xsl:if test="motd-page-url">
                                            <xsl:text> (</xsl:text>
                                            <a>
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="motd-page-url"/>
                                                </xsl:attribute>
                                                <xsl:text>More</xsl:text>
                                            </a>
                                            <xsl:text>)</xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:if>
            </div>
            <div id="roundbottom">
            </div>
            <xsl:comment>credits in alternative location #2</xsl:comment>
            <xsl:comment>alternative credits</xsl:comment>
            <div id="credit2">
                <xsl:if test="$config/credits and ($config/credits/credit/@box-location = 'alt2')">
                    <xsl:for-each select="$config/credits/credit[not(@role='pdf')]">
                        <xsl:if test="@box-location = 'alt2'">
                            <xsl:variable name="name" select="name"/>
                            <xsl:variable name="url" select="url"/>
                            <xsl:variable name="image" select="image"/>
                            <xsl:variable name="width" select="width"/>
                            <xsl:variable name="height" select="height"/>
                            <a href="{$url}">
                                <img alt="{$name} - logo" title="{$name}" border="0">
                                    <xsl:attribute name="src">
                                        <xsl:if test="not(starts-with($image, 'http://'))">
                                            <xsl:value-of select="$root"/>
                                        </xsl:if>
                                        <xsl:value-of select="$image"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="style">
                                        <xsl:if test="$width">width: <xsl:value-of select="$width"/>px;</xsl:if>
                                        <xsl:if test="$height">height: <xsl:value-of select="$height"/>px;</xsl:if>
                                    </xsl:attribute>
                                </img>
                            </a>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
            </div>
        </div>
        <xsl:comment>end Menu</xsl:comment>
    </xsl:template>

    <xsl:template name="innermenuli">
        <xsl:param name="id"/>
        <xsl:variable name="tagid">
            <xsl:choose>
                <xsl:when test="descendant-or-self::node()/li/div/@class='current'">
                    <xsl:value-of select="concat('menu_selected_',$id)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('menu_',concat(font,$id))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="whichGroup">
            <xsl:choose>
                <xsl:when test="descendant-or-self::node()/li/div/@class='current'"></xsl:when>
                <xsl:otherwise>collapse</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <div class="accordion-group" id="{$tagid}Title">
            <div class="accordion accordion-default">
                <div class="accordion-heading">
                    <h4 class="accordion-title">
                        <a data-toggle="collapse" data-parent="#{$tagid}Title" href="#{$tagid}">
                            <xsl:value-of select="h1"/>
                        </a>
                    </h4>
                </div>
            </div>
        </div>
        <ul>
            <div class="{$whichGroup}" id="{$tagid}">
                <div>
                    <xsl:for-each select= "ul/li">
                        <xsl:choose>
                            <xsl:when test="a">
                                <li class="menuitem"><a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="a/@href"/>
                                    </xsl:attribute>
                                    <xsl:if test="a/@title!=''">
                                        <xsl:attribute name="title">
                                            <xsl:value-of select="a/@title"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of select="a"/></a>
                                </li>
                            </xsl:when>
                            <xsl:when test="div/@class='current'">
                                <li class="menupage">
                                    <div class="menupagetitle">
                                        <xsl:value-of select="div" />
                                    </div>
                                    <xsl:if test="$config/toc/@max-depth > 0 and contains($minitoc-location,'menu') and count(//tocitems/tocitem) >= $config/toc/@min-sections">
                                        <div class="menupageitemgroup">
                                            <xsl:for-each select = "//tocitems/tocitem">
                                                <div class="menupageitem">
                                                    <xsl:choose>
                                                        <xsl:when test="string-length(@title)>15"><a href="{@href}" title="{@title}">
                                                            <xsl:value-of select="substring(@title,0,20)" />...</a>
                                                        </xsl:when>
                                                        <xsl:otherwise><a href="{@href}">
                                                            <xsl:value-of select="@title" /></a>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </xsl:if>
                                </li>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name = "innermenuli">
                                    <xsl:with-param name="id" select="concat($id, '_', position())"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </div>
            </div>
        </ul>
    </xsl:template>

    <!-- Generates the PDF link -->
    <xsl:template match="div[@id='skinconf-pdflink']">
        <xsl:if test="not($config/disable-pdf-link) or $disable-pdf-link = 'false'">
            <div class="pdflink" title="Portable Document Format">
                <a href="{$filename-noext}.pdf" class="dida">
                    <img class="skin" src="{$skin-img-dir}/pdfdoc.gif" alt="PDF -icon" />
                    <br/>
                    PDF
                </a>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="div[@id='skinconf-xmllink']">
        <xsl:if test="not($config/disable-xml-link) or $disable-xml-link = 'false'">
            <div class="xmllink" title="raw XML">
                <a href="{$filename-noext}.xml" class="dida">
                    <img class="skin" src="{$skin-img-dir}/xmldoc.gif" alt="XML - icon" />
                    <br/>
                    XML
                </a>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="div[@id='skinconf-txtlink']">
        <xsl:if test="not($config/disable-txt-link) or $disable-txt-link = 'false'">
            <div class="podlink" title="Plain Text Documentation">
                <a href="{$filename-noext}.txt" class="dida">
                    <img class="skin" src="{$skin-img-dir}/txtdoc.png" alt="TXT - icon" />
                    <br/>
                    TXT
                </a>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="div[@id='skinconf-podlink']">
        <xsl:if test="not($config/disable-pod-link) or $disable-pod-link = 'false'">
            <div class="podlink" title="Plain Old Documentation">
                <a href="{$filename-noext}.pod" class="dida">
                    <img class="skin" src="{$skin-img-dir}/poddoc.png" alt="POD - icon" />
                    <br/>
                    POD
                </a>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="div[@id='skinconf-printlink']">
        <xsl:if test="not($config/disable-print-link) or $disable-print-link = 'false'">
            <script type="text/javascript" language="Javascript">
    function printit() {
        if (window.print) {
            window.focus();
            window.print();
        }
    }
            </script>
            <script type="text/javascript" language="Javascript">
    var NS = (navigator.appName == "Netscape");
    var VERSION = parseInt(navigator.appVersion);
    if (VERSION > 3) {
        document.write('<div class="printlink" title="Print this Page">');
        document.write('  <a href="javascript:printit()" class="dida">');
        document.write('    <img class="skin" src="{$skin-img-dir}/printer.gif" alt="print - icon" />');
        document.write('    <br />');
        document.write('  PRINT</a>');
        document.write('</div>');
    }
            </script>
        </xsl:if>
    </xsl:template>

    <xsl:template match="div[@id='disable-font-script']">
        <xsl:if test="$disable-font-script = 'false'">
            <div class="trail">
                <i18n:text >Font size:</i18n:text>&#160;
                <input type="button" onclick="ndeSetTextSize('reset'); return false;" title="Reset text"   class="resetfont"   value="Reset" i18n:attr="value title"/>&#160;
                <input type="button" onclick="ndeSetTextSize('decr');  return false;" title="Shrink text"  class="smallerfont" value="-a"    i18n:attr="value title"/>&#160;
                <input type="button" onclick="ndeSetTextSize('incr');  return false;" title="Enlarge text" class="biggerfont"  value="+a"    i18n:attr="value title"/>
            </div>
        </xsl:if>
    </xsl:template>

    <!-- Message of the day -->
    <xsl:template match="div[@id='motd-page']">
        <xsl:if test="$config/motd">
            <xsl:for-each select="$config/motd/motd-option">
                <xsl:choose>
                    <xsl:when test="@starts-with='true'">
                        <xsl:if test="starts-with($path, @pattern)">
                            <xsl:if test="motd-page/@location='page' or motd-page/@location='both'">
                                <div id="motd-area">
                                    <xsl:value-of select="motd-page"/>
                                    <xsl:if test="motd-page-url">
                                        <xsl:text> (</xsl:text>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="motd-page-url"/>
                                            </xsl:attribute>
                                            <xsl:text>More</xsl:text>
                                        </a>
                                        <xsl:text>)</xsl:text>
                                    </xsl:if>
                                </div>
                            </xsl:if>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="contains($path, @pattern)">
                            <xsl:if test="motd-page/@location='page' or motd-page/@location='both'">
                                <div id="motd-area">
                                    <xsl:value-of select="motd-page"/>
                                    <xsl:if test="motd-page-url">
                                        <xsl:text> (</xsl:text>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="motd-page-url"/>
                                            </xsl:attribute>
                                            <xsl:text>More</xsl:text>
                                        </a>
                                        <xsl:text>)</xsl:text>
                                    </xsl:if>
                                </div>
                            </xsl:if>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <xsl:template match="div[@id='skinconf-toc-page']">
        <xsl:comment>Table of Contents ToC</xsl:comment>
        <xsl:if test="$config/toc">
            <xsl:if test="contains($minitoc-location,'page')">
                <xsl:if test="(count(//tocitems/tocitem) >= $config/toc/@min-sections) or (//tocitems/@force = 'true')">
                    <div id="minitoc-area">
                        <xsl:call-template name="minitoc">
                            <xsl:with-param name="tocroot" select="//tocitems"/>
                        </xsl:call-template>
                    </div>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
