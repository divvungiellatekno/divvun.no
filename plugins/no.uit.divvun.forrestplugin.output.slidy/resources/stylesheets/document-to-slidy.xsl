<?xml version="1.0"?>
<!--
  Copyright 2002-2004 The Apache Software Foundation

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<!--
A prototype Docbook-to-Forrest stylesheet.
Volunteers are needed to improve this!

Support for the range of Docbook tags is very patchy. If you need real
Docbook support, then use Norm Walsh's stylesheets - see Forrest FAQ.

Credit: original from the jakarta-avalon project

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template match="document">
      <!--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">-->
      
      <html xmlns="http://www.w3.org/1999/xhtml">
        <xsl:apply-templates/>
      </html>
    </xsl:template>
    
  <xsl:template match="header">
    <head>
      <title><xsl:value-of select="title"/></title>
      <meta name="version" content="Apache Forrest HTML Slidy Plugin 0.1, based on W3C Slidy2" />
      <meta name="copyright" content="Copyright &#169; 2012 University of Tromsø" />
      <meta name="duration" content="60" />
      <link rel="stylesheet" type="text/css" media="screen, projection, print" href="slidy.css" />
      <link rel="stylesheet" type="text/css" media="screen, projection, print" href="w3c-blue.css" />
      <script src="slidy.js" type="text/javascript" charset="utf-8"></script>
    </head>  
  </xsl:template>
  
  <xsl:template match="body">
    <body>
      <div class="background"> 
        <img id="head-icon" alt="graphic with four colored squares" src="icon-blue.png" /> 
        <img id="head-logo" alt="Logo" src="logo-white.png" />
      </div>
      <xsl:apply-templates/>
    </body>
  </xsl:template>
  
  <!-- Cover slide-->
  <xsl:template match="body/section[1]">
    <div class="slide cover title">
      <!-- hidden style graphics to ensure they are saved with other content -->
       <img class="hidden" src="bullet.png" alt="" />
       <img class="hidden" src="fold.gif" alt="" />
       <img class="hidden" src="unfold.gif" alt="" />
       <img class="hidden" src="fold-dim.gif" alt="" />
       <img class="hidden" src="nofold-dim.gif" alt="" />
       <img class="hidden" src="unfold-dim.gif" alt="" />
       <img class="hidden" src="bullet-fold.gif" alt="" />
       <img class="hidden" src="bullet-unfold.gif" alt="" />
       <img class="hidden" src="bullet-fold-dim.gif" alt="" />
       <img class="hidden" src="bullet-nofold-dim.gif" alt="" />
       <img class="hidden" src="bullet-unfold-dim.gif" alt="" />
       <img class="cover"  src="logo-white.png" alt="Cover page image" />
      <br clear="all" />
      <h1><xsl:value-of select="title"/></h1>
      <xsl:for-each select="//document/header/authors/person">
        <p><b><xsl:value-of select="@name"/></b> - <xsl:value-of select="@email"/></p>
      </xsl:for-each>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- Regular top level section slide: -->
  <xsl:template match="body/section[position() != 1]">
    <div class="slide">
      <h4><xsl:value-of select="//body/section[1]/title"/></h4>
      <h1><xsl:value-of select="title"/></h1>
      <xsl:apply-templates select="*[name() != 'section']"/>
    </div>
    <xsl:apply-templates select="section"/>
  </xsl:template>

  <!-- Second level section slide: -->
  <xsl:template match="body/section/section">
    <div class="slide">
      <h4><xsl:value-of select="//body/section[1]/title"/></h4>
      <h2><xsl:value-of select="../title"/></h2>
      <h1><xsl:value-of select="title"/></h1>
      <xsl:apply-templates select="*[name() != 'section']"/>
    </div>
    <xsl:apply-templates select="section"/>
  </xsl:template>

  <!-- Third level section slide: -->
  <xsl:template match="body/section/section/section">
    <div class="slide">
      <h4><xsl:value-of select="//body/section[1]/title"/></h4>
      <h3><xsl:value-of select="../../title"/></h3>
      <h2><xsl:value-of select="../title"/></h2>
      <h1><xsl:value-of select="title"/></h1>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- Ordered lists are displayed incrementally (as unordered lists): -->
  <xsl:template match="ol">
    <ul class="incremental">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
    
  <!-- Paragraphs coming after incrementally displayed lists should themselves
       be displayed incrementally instead of when the slide is opened: -->
  <xsl:template match="p[preceding-sibling::ol]">
    <p class="incremental">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
    
  <!-- Ordered lists are displayed incrementally (as unordered lists): -->
  <xsl:template match="table">
    <div class="hbox">
      <table>
        <xsl:apply-templates/>
      </table>
    </div>
  </xsl:template>

  <!-- Ordered lists are displayed incrementally (as unordered lists): -->
  <xsl:template match="source">
      <pre>
        <xsl:apply-templates/>
      </pre>
  </xsl:template>

  <!-- Since every URL in the Slidy plugin is "moved" down into the slidy/
       sub-URL, we have to move one step up to get the correct path for regular
       images:    -->
  <xsl:template match="img">
    <img src="{concat('../',@src)}" alt="@alt"/>
  </xsl:template>
    
  <xsl:template match="@*|*|text()|processing-instruction()|comment()">
    <xsl:copy>
      <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
