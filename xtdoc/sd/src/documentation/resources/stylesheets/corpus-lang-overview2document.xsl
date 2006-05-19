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

<!--+
    | Transforms corpus summary documents to Forrest documents
    +-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  version="1.0">

  <xsl:param name="overviewlang"/>

  <xsl:template match="summary">
    <document>
      <header>
        <title>Corpus Content —
          <i18n:text>
            <xsl:value-of select="$overviewlang"/>
          </i18n:text>:
          <xsl:value-of select="count/total/language[@xml:lang = $overviewlang]/@count"/>
          files
        </title>
      </header>
      <body>
        <xsl:choose>
          <xsl:when test="./language[@xml:lang = $overviewlang]">
          <xsl:apply-templates select="./language[@xml:lang = $overviewlang]"/>
          </xsl:when>
          <xsl:otherwise>
            <warning>No information found for
              <xsl:value-of select="$overviewlang"/>. Please report to divvun@samediggi.no.
            </warning>
          </xsl:otherwise>
        </xsl:choose>
      </body>
    </document>
  </xsl:template>

  <xsl:template match="summary/language[@xml:lang = $overviewlang]">
    <p>Below is a list of all corpus files for
    <xsl:value-of select="@xml:lang"/>,
    grouped according to genre. Some files might be invalid in one way or the other, these are
    <span class="nonvalid">colour marked</span>. Also files with a missing license declaration
    are marked <span class="nonvalid">with the same colour</span> (but only in the license field).</p>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="genre">
    <xsl:variable name="genrename" select="@name"/>
    <section>
      <title>
        <xsl:value-of select="@name"/> —
        <xsl:value-of select="count(file)"/>
        files
      </title>
      <table>
        <tr>
          <th>Title</th>
          <th>No of sections</th>
          <th>No of paragraphs</th>
          <th>No of words</th>
          <th>License</th>
          <th>Orig. lang.</th>
          <th>Filename</th>
        </tr>
        <xsl:apply-templates >
          <xsl:sort select="size/pcount" data-type="number" order="descending"/>
        </xsl:apply-templates >
      </table>
    </section>
  </xsl:template>

  <xsl:template match="file">
    <tr>
      <xsl:if test="nonvalid">
        <xsl:attribute name="class">nonvalid</xsl:attribute>
      </xsl:if>
      <td><xsl:value-of select="title"/></td>
      <td><xsl:value-of select="size/sectioncount"/></td>
      <td><xsl:value-of select="size/pcount"/></td>
      <td><xsl:value-of select="size/wordcount"/></td>
      <td>
        <xsl:choose>
          <xsl:when test="availability/free">
            free
          </xsl:when>
          <xsl:when test="availability/license">
            <b>Licensed</b>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">nonvalid</xsl:attribute>
            <i>not yet known</i>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="translated_from">
            <xsl:value-of select="translated_from/@xml:lang"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text> </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td><xsl:value-of select="filename"/></td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
