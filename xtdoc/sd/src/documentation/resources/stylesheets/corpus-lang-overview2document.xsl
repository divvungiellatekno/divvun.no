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
          <xsl:apply-templates select="./language[@xml:lang = $overviewlang]"/>
      </body>
    </document>
  </xsl:template>

  <xsl:template match="summary/language[@xml:lang = $overviewlang]">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="genre">
    <xsl:variable name="genrename" select="@name"/>
    <section>
      <title>
        <xsl:value-of select="@name"/> —
        <xsl:value-of select="/summary/count/total/language[@xml:lang = $overviewlang]/genre[@name = $genrename]/@count"/>
        files
      </title>
      <table>
        <tr>
          <th>Title</th>
          <th>No of sections</th>
          <th>No of paragraphs</th>
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
      <td><xsl:value-of select="title"/></td>
      <td><xsl:value-of select="size/sectioncount"/></td>
      <td><xsl:value-of select="size/pcount"/></td>
      <td><xsl:value-of select="filename"/></td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
