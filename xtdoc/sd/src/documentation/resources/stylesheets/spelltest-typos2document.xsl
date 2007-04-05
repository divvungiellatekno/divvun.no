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
  <xsl:param name="date"/>

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
    <xsl:param name="nrforced"
     select="count(../results/word[@forced])"/>
    <xsl:param name="corrected"
     select="count(../results/word[status='SplErr'][position > 0])"/>
    <xsl:param name="topthree"
     select="count(../results/word[status='SplErr'][position > 0][position &lt; 4])"/>
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
        <xsl:value-of select="$nrsplerr"/></p>
        <p>Of those,
          <xsl:value-of select="$nrforced"/> where
        <span class="forced">forced</span>*).</p>
        <p>Number of undetected spelling errors:
        <xsl:value-of select="$nrwords - $nrsplerr"/></p>
        <p>Number of spelling errors with <span class="correct">correct
          suggestion</span>:
        <xsl:value-of select="$corrected"/></p>
        <p>Number of spelling errors with <span class="correct">correct
         suggestion</span> in top three:
        <xsl:value-of select="$topthree"/></p>
        <p>Number of spelling errors with only wrong suggestions:
        <xsl:value-of select="$nocorrsugg - $nosugg"/></p>
        <p>Number of spelling errors with no suggestions at all:
        <xsl:value-of select="$nosugg"/></p>
        <note><strong>*) Forced:</strong> The Polderland command line speller
              will by default ignore input words starting with a non-alphabetic
              character. Thus, words starting with e.g. numbers or hyphens are
              ignored, giving the impression that they are correct input. Such
              words can be forced to be treated as spelling errors, but then
              <strong>all</strong> such words are considered spelling errors.
              That will be correct in the case of typos-type input, but not
              necessarily for other types of input data, which means the results
              can be somewhat schewed in those cases. Normally, the number of
              forced spelling errors will be very low, and won't have a big
              impact on the results anyway, but please check the forced cases.
              Forced spelling errors are marked with a <span class="forced">yellow background</span> in the table below.
        </note>
      </section>
    </section>
  </xsl:template>

  <xsl:template match="results">
    <section>
      <title>Spelling errors with correct suggestions</title>
      <table>
        <tr>
          <th>Input word</th>
          <th>Expected word</th>
          <th>Suggestions</th>
        </tr>
        <xsl:apply-templates select="word[status='SplErr'][suggestions/@count > 0][position > 0]">
          <xsl:sort select="position" order="ascending"/>
        </xsl:apply-templates >
      </table>
    </section>
    <section>
      <title>Spelling errors with only incorrect suggestions</title>
      <table>
        <tr>
          <th>Input word</th>
          <th>Expected word</th>
        </tr>
        <xsl:apply-templates select="word[status='SplErr'][suggestions/@count > 0][position = 0]">
          <xsl:sort select="original" />
        </xsl:apply-templates >
      </table>
    </section>
    <section>
      <title>Spelling errors without suggestions</title>
      <table>
        <tr>
          <th>Input word</th>
          <th>Expected word</th>
        </tr>
        <xsl:apply-templates select="word[status='SplErr'][suggestions/@count = 0]">
          <xsl:sort select="original" />
        </xsl:apply-templates >
      </table>
    </section>
    <section>
      <title>Speller considers the input correct</title>
      <table>
        <tr>
          <th>Input word</th>
          <th>Expected word</th>
        </tr>
        <xsl:apply-templates select="word[status='SplCor']">
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
