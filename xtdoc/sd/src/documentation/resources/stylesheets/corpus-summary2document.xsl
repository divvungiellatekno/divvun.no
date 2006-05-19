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

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


  <xsl:template match="count">
    <document>
      <header>
        <title>Corpus Files — Overview</title>
      </header>
      <body>
        <table>
          <caption>Corpus files per language and in all</caption>
          <xsl:apply-templates select="language"/>
          <tr><td colspan="2"> </td></tr>
          <tr>
            <th>Total number of corpus files:</th>
            <th><xsl:value-of select="total/@count"/></th>
          </tr>
        </table>
      </body>
    </document>
  </xsl:template>

  <xsl:template match="language">
      <td colspan="2"><strong><xsl:value-of select="@xml:lang"/>
      files:</strong></td>
    <xsl:apply-templates select="genre"/>
    <tr>
      <th>Total number of
      <xsl:value-of select="@xml:lang"/>
      files:</th>
      <th><xsl:value-of select="@count"/></th>
    </tr>
  </xsl:template>

  <xsl:template match="genre">
    <tr>
      <td><xsl:value-of select="@name"/></td>
      <td><xsl:value-of select="@count"/></td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
