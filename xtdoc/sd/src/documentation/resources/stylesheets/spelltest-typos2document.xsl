<?xml version="1.0"?>
<!--+
    | Transforms corpus content documents to Forrest documents according
    | to the language parameter - only content for the given language is
    | returned.
    +-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  version="1.0">

  <xsl:param name="testlang"/>
  <xsl:param name="testtype"/>
  <xsl:param name="date"/>
  <xsl:param name="toplimit">5</xsl:param>

  <xsl:template match="spelltestresult">
    <document>
      <header>
        <title>Speller Test Results for:
          «<xsl:value-of select="header/document"/>»
        </title>
      </header>
      <body>
        <xsl:apply-templates />
      </body>
    </document>
  </xsl:template>

  <xsl:template match="header">
    <xsl:param name="nrwords" select="count(../results/word)"/>
    <xsl:param name="nrsplerr"
     select="count(../results/word[status='SplErr'])"/>
    <xsl:param name="nrsplerrprcnt"
     select="round(($nrsplerr div $nrwords) * 10000) div 100"/>
    <xsl:param name="corrected"
     select="count(../results/word[status='SplErr'][position > 0])"/>
    <xsl:param name="topthree"
     select="count(../results/word[status='SplErr'][position > 0][position &lt;= $toplimit])"/>
    <xsl:param name="nocorrsugg"
     select="count(../results/word[status='SplErr'][position = 0])"/>
    <xsl:param name="nosugg"
     select="count(../results/word[status='SplErr'][suggestions/@count = 0])"/>
    <section>
      <title>Overview</title>
      <section>
        <title>Technical data</title>
        <p>Language tested:
        <code><xsl:value-of select="$testlang"/></code></p>
        <p>Document tested:
        <xsl:value-of select="document"/></p>
        <p>Speller tool:
          <xsl:choose>
            <xsl:when test="tool/@type = 'PLX'">
            Polderland command line tool
            </xsl:when>
            <xsl:when test="tool/@type = 'AS'">
            AppleScript driving the speller in MS Word
            </xsl:when>
            <xsl:otherwise>
              Unknown
            </xsl:otherwise>
          </xsl:choose>
        </p>
        <p>Speller lexicon version:
          <xsl:choose>
            <xsl:when test="tool/@version = ''">
            Unknown
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="tool/@version"/>
            </xsl:otherwise>
          </xsl:choose>
        </p>
        <p>Test Date:
        <xsl:value-of select="date"/></p>
      </section>
      <section>
        <title>Result summary</title>
        <p>Number of input words:
        <xsl:value-of select="$nrwords"/></p>
        <p>Number of detected spelling errors:
        <xsl:value-of select="$nrsplerr"/> (<xsl:value-of select="$nrsplerrprcnt"/> %)</p>
        <p>Number of undetected spelling errors:
        <xsl:value-of select="$nrwords - $nrsplerr"/> (<xsl:value-of select="100 - $nrsplerrprcnt"/> %)</p>
        <p>Number of spelling errors with <span class="correct">correct
          suggestion</span>:
        <xsl:value-of select="$corrected"/></p>
        <p>Number of spelling errors with <span class="correct">correct
         suggestion</span> in top <xsl:value-of select="$toplimit"/>:
        <xsl:value-of select="$topthree"/></p>
        <p>Number of spelling errors with only wrong suggestions:
        <xsl:value-of select="$nocorrsugg - $nosugg"/></p>
        <p>Number of spelling errors with no suggestions at all:
        <xsl:value-of select="$nosugg"/></p>
      </section>
    </section>
  </xsl:template>

  <xsl:template match="results">
    <section>
      <title>Spelling errors with correct suggestions</title>
      <table>
        <tr>
          <th>Input<br/>word</th>
          <th>Expected<br/>correction</th>
          <th>Editing<br/>distance</th>
          <th>Suggestions</th>
        </tr>
        <xsl:apply-templates select="word[status='SplErr'][suggestions/@count > 0][position > 0]">
          <xsl:sort select="edit_dist" order="descending" data-type="number"/>
          <xsl:sort select="position" order="descending"/>
        </xsl:apply-templates >
      </table>
    </section>
    <section>
      <title>Spelling errors with only incorrect suggestions</title>
      <table>
        <tr>
          <th>Input<br/>word</th>
          <th>Expected<br/>correction</th>
          <th>Editing<br/>distance</th>
        </tr>
        <xsl:apply-templates select="word[status='SplErr'][suggestions/@count > 0][position = 0]">
          <xsl:sort select="edit_dist" order="descending" data-type="number"/>
          <xsl:sort select="original" />
        </xsl:apply-templates >
      </table>
    </section>
    <section>
      <title>Spelling errors without suggestions</title>
      <table>
        <tr>
          <th>Input<br/>word</th>
          <th>Expected<br/>correction</th>
          <th>Editing<br/>distance</th>
        </tr>
        <xsl:apply-templates select="word[status='SplErr'][suggestions/@count = 0]">
          <xsl:sort select="edit_dist" order="descending" data-type="number"/>
          <xsl:sort select="original" />
        </xsl:apply-templates >
      </table>
    </section>
    <section>
      <title>Speller considers the input correct</title>
      <table>
        <tr>
          <th>Input<br/>word</th>
          <th>Expected<br/>correction</th>
          <th>Editing<br/>distance</th>
        </tr>
        <xsl:apply-templates select="word[status='SplCor']">
          <xsl:sort select="edit_dist" order="descending" data-type="number"/>
          <!--xsl:sort select="position" order="ascending"/-->
        </xsl:apply-templates >
      </table>
    </section>
  </xsl:template>

  <xsl:template match="word">
    <tr>
      <xsl:if test="@forced">
        <xsl:attribute name="class">
          <xsl:value-of select="'forced'"/>
        </xsl:attribute>
      </xsl:if>
      <td><xsl:value-of select="original"/></td>
      <td><xsl:value-of select="expected"/></td>
      <td><xsl:value-of select="edit_dist"/></td>
      <xsl:if test="suggestions/@count > 0">
        <td>
          <xsl:apply-templates select="suggestions"/>
        </td>
      </xsl:if>
    </tr>
  </xsl:template>

  <xsl:template match="suggestions">
    <ol>
      <xsl:apply-templates />
    </ol>
  </xsl:template>

  <xsl:template match="suggestion">
    <li>
      <xsl:if test="@expected">
        <xsl:attribute name="class">
          <xsl:value-of select="'correct'"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates />
    </li>
  </xsl:template>

</xsl:stylesheet>
