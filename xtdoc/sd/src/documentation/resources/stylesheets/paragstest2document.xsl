<?xml version="1.0" encoding="UTF-8"?>
<!--+
    | Transforms corpus summary documents to Forrest documents
    +-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


  <xsl:template match="/">
    <document>
      <header>
        <title>Parallelisation of Corpus Files — Test results</title>
      </header>
      <body>
        <xsl:apply-templates select="paragstesting"/>
      </body>
    </document>
  </xsl:template>

  <xsl:template match="paragstesting">
    <table>
      <caption>Real parallelisation compared to exepcted result - # of failed sentence pairs / # of all sentence pairs</caption>
      <tr>
        <th>Test date⇓ \ Gold-standard files⇒</th>
        <xsl:for-each select="testrun/file">
          <th><xsl:value-of select="@name"/></th>
        </xsl:for-each>
        <th>Totals:</th>
      </tr>
      <xsl:apply-templates select="testrun"/>
    </table>
  </xsl:template>

  <xsl:template match="testrun">
    <tr>
      <td><strong><xsl:value-of select="@datetime"/></strong></td>
      <xsl:apply-templates select="file"/>
    <td><strong>
        <xsl:value-of select="sum(file/@diffpairs)"/> /
        <xsl:value-of select="sum(file/@gspairs)"/> =
        <xsl:value-of select="round((1 - (sum(file/@diffpairs) div
                              sum(file/@gspairs))) * 10000) div 100"/> %</strong>
    </td>
    </tr>
  </xsl:template>

  <xsl:template match="file">
    <td>
        <xsl:value-of select="@diffpairs"/> /
        <xsl:value-of select="@gspairs"/> =
        <xsl:value-of select="round((1 - (@diffpairs div @gspairs)) * 10000) div 100"/>
        %
    </td>
  </xsl:template>

</xsl:stylesheet>