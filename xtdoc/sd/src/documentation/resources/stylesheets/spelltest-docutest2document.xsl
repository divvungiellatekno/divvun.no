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
    <xsl:param name="nrflaggedwords"
     select="count(../results/word[status='SplErr'])"/>
    <xsl:param name="nrflaggedwordsprcnt"
     select="round(($nrflaggedwords div $nrwords) * 10000) div 100"/>
    <xsl:param name="nracceptwords"
     select="count(../results/word[status='SplCor'])"/>
    <xsl:param name="truepositive"
     select="count(../results/word[status='SplErr' and ./expected])"/>
    <xsl:param name="falsepositive"
     select="count(../results/word[status='SplErr' and not(./expected)])"/>
    <xsl:param name="nrrealerr" select="count(../results/word[expected])"/>
    <xsl:param name="truenegative"
     select="count(../results/word[status='SplCor' and not(./expected)])"/>
    <xsl:param name="falsenegative"
     select="count(../results/word[status='SplCor' and ./expected])"/>
    <xsl:param name="nrrealcorr" select="count(../results/word[not(expected)])"/>
    <xsl:param name="precision" select="$truepositive div ($truepositive + $falsepositive)"/>
    <xsl:param name="recall" select="$truepositive div ($truepositive + $falsenegative)"/>
    <xsl:param name="accuracy" select="($truepositive+$truenegative) div $nrwords"/>
    <xsl:param name="corrected"
     select="count(../results/word[status='SplErr'][expected][position > 0])"/>
    <xsl:param name="topthree"
     select="count(../results/word[status='SplErr'][position > 0]
                                  [position &lt;= $toplimit])"/>
    <xsl:param name="nocorrsugg"
     select="count(../results/word[status='SplErr']
                                  [expected]
                                  [suggestions/@count > 0]
                                  [position = 0])"/>
    <xsl:param name="nosugg"
     select="count(../results/word[status='SplErr'][expected]
                                  [suggestions/@count = 0])"/>
    <xsl:param name="editdist1"
     select="count(../results/word[expected]
                                  [edit_dist = 1])"/>
    <xsl:param name="editdist2"
     select="count(../results/word[expected]
                                  [edit_dist = 2])"/>
    <xsl:param name="editdist3"
     select="count(../results/word[expected]
                                  [edit_dist > 2])"/>
    <section>
      <title>Overview</title>
      <section>
        <title>Technical data</title>
        <p>Language tested: <code><xsl:value-of select="$testlang"/></code></p>
        <p>Document tested: <xsl:value-of select="document"/></p>
        <p>Speller tool:
          <xsl:choose>
            <xsl:when test="tool/@type = 'PLX'">
            Polderland command line tool
            </xsl:when>
            <xsl:when test="tool/@type = 'AS'">
            AppleScript driving the speller in MS Word
            </xsl:when>
            <xsl:otherwise>Unknown</xsl:otherwise>
          </xsl:choose>
        </p>
        <p>Speller lexicon version:
          <xsl:choose>
            <xsl:when test="tool/@version = ''">Unknown</xsl:when>
            <xsl:otherwise><xsl:value-of select="tool/@version"/></xsl:otherwise>
          </xsl:choose>
        </p>
        <p>Test Date:
        <xsl:value-of select="date"/></p>
      </section>
      <section>
        <title>Result summary</title>
        <p>Number of input words:
        <strong><xsl:value-of select="$nrwords"/></strong></p>
        <table>
          <caption>Precision and Recall</caption>
          <tr>
            <td colspan="2" rowspan="2"/>
            <th colspan="2">Speller view</th>
          </tr>
          <tr>
            <td>Speller Positive<br/>
              (number of flagged words):<br/>
              <strong><xsl:value-of select="$nrflaggedwords"/></strong></td>
            <td>Speller Negative<br/>
              (number of accepted words):<br/>
              <strong><xsl:value-of select="$nracceptwords"/></strong></td>
          </tr>
          <tr>
            <th rowspan="2">Reality</th>
            <td>Number of real errors:<br/>
              <strong><xsl:value-of select="$nrrealerr"/></strong></td>
            <td>Number of true positives<br/>
              (detected real errors):<br/>
              <strong><xsl:value-of select="$truepositive"/></strong></td>
            <td>Number of false negatives<br/>
              (unflagged spelling errors):<br/>
              <strong><xsl:value-of select="$falsenegative"/></strong></td>
          </tr>
          <tr>
            <td>Number of real correct words:<br/>
              <strong><xsl:value-of select="$nrrealcorr"/></strong></td>
            <td>Number of false positives<br/>
              (incorrectly flagged words):<br/>
              <strong><xsl:value-of select="$falsepositive"/></strong></td>
            <td>Number of true negatives<br/>
              (unflagged correct words):<br/>
              <strong><xsl:value-of select="$truenegative"/></strong></td>
          </tr>
        </table>

        <dl>
          <dt>Precision (tp/(tp+fp)):</dt>
            <dd><xsl:value-of select="round($precision * 10000) div 100"/> %</dd>
          <dt>Recall (tp/(tp+fn)):</dt>
            <dd><xsl:value-of select="round($recall * 10000) div 100"/> %</dd>
          <dt>Accuracy ((tp+tn)/words):</dt>
            <dd><xsl:value-of select="round($accuracy * 10000) div 100"/> %</dd>
        </dl>

        <section>
          <title>Suggestion statistics</title>
          <ul>
          <li>Number of spelling errors with <span class="correct">correct
            suggestion</span>:
          <xsl:value-of select="$corrected"/></li>
          <li>Number of spelling errors with <span class="correct">correct
           suggestion</span> in top <xsl:value-of select="$toplimit"/>:
          <xsl:value-of select="$topthree"/></li>
          <li>Number of spelling errors with only wrong suggestions:
          <xsl:value-of select="$nocorrsugg - $nosugg"/></li>
          <li>Number of spelling errors with no suggestions at all:
          <xsl:value-of select="$nosugg"/></li>
          </ul>
        </section>

        <section>
          <title>Spelling error statistics</title>
          <ul>
          <li>Number of spelling errors :
          <xsl:value-of select="$nrrealerr"/></li>
          <li>Number of simple spelling errors :
          <xsl:value-of select="$editdist1"/></li>
          <li>Number of spelling errors with editing distance 2:
          <xsl:value-of select="$editdist2"/></li>
          <li>Number of spelling errors with editing distance 3 or more:
          <xsl:value-of select="$editdist3"/></li>
          </ul>
        </section>
      </section>
    </section>
  </xsl:template>

  <xsl:template match="results">
    <section>
      <title>True positives (<xsl:value-of select="count(word[status='SplErr'][expected])"/>)
        </title>
      <section>
        <title>Spelling errors with correct suggestions (<xsl:value-of
                select="count(word[status='SplErr']
                                  [expected]
                                  [suggestions/@count > 0]
                                  [position > 0])"/>)</title>
        <table>
          <tr>
            <th>Input<br/>word</th>
            <th>Expected<br/>correction</th>
            <th>Editing<br/>distance</th>
            <th>Suggestions</th>
          </tr>
          <xsl:apply-templates select="word[status='SplErr']
                                           [expected]
                                           [suggestions/@count > 0]
                                           [position > 0]">
            <xsl:sort select="edit_dist" order="descending" data-type="number"/>
            <xsl:sort select="position" order="descending"/>
          </xsl:apply-templates >
        </table>
      </section>
      <xsl:if test="count(word[status='SplErr']
                              [expected]
                              [suggestions/@count > 0]
                              [position = 0]) > 0">
       <section>
          <title>Spelling errors with only incorrect suggestions (<xsl:value-of
                  select="count(word[status='SplErr']
                                    [expected]
                                    [suggestions/@count > 0]
                                    [position = 0])"/>)</title>
          <table>
            <tr>
              <th>Input<br/>word</th>
              <th>Expected<br/>correction</th>
              <th>Editing<br/>distance</th>
            </tr>
            <xsl:apply-templates select="word[status='SplErr']
                                             [expected]
                                             [suggestions/@count > 0]
                                             [position = 0]">
              <xsl:sort select="edit_dist" order="descending" data-type="number"/>
              <xsl:sort select="original" />
            </xsl:apply-templates >
          </table>
        </section>
      </xsl:if>
      <xsl:if test="count(word[status='SplErr']
                              [expected]
                              [suggestions/@count = 0]) > 0">
        <section>
          <title>Spelling errors without suggestions (<xsl:value-of
                  select="count(word[status='SplErr']
                                    [expected]
                                    [suggestions/@count = 0])"/>)</title>
          <table>
            <tr>
              <th>Input<br/>word</th>
              <th>Expected<br/>correction</th>
              <th>Editing<br/>distance</th>
            </tr>
            <xsl:apply-templates select="word[status='SplErr']
                                             [expected]
                                             [suggestions/@count = 0]">
              <xsl:sort select="edit_dist" order="descending" data-type="number"/>
              <xsl:sort select="original" />
            </xsl:apply-templates >
          </table>
        </section>
      </xsl:if>
    </section>

    <xsl:if test="count(word[status='SplErr'][not(expected)]) > 0">
      <section>
        <title>False positives (<xsl:value-of
              select="count(word[status='SplErr'][not(expected)])"/>)</title>
        <table>
          <tr>
            <th>Input<br/>word</th>
            <th>Suggestions</th>
          </tr>
          <xsl:apply-templates select="word[status='SplErr'][not(expected)]">
            <xsl:sort select="original" />
            <xsl:with-param name="type" select="'fp'"/>
          </xsl:apply-templates >
        </table>
      </section>
    </xsl:if>

    <xsl:if test="count(word[status='SplCor'][expected]) > 0">
      <section>
        <title>False negatives (<xsl:value-of
              select="count(word[status='SplCor'][expected])"/>)</title>
        <table>
          <tr>
            <th>Input<br/>word</th>
            <th>Expected<br/>correction</th>
            <th>Editing<br/>distance</th>
          </tr>
          <xsl:apply-templates select="word[status='SplCor'][expected]">
            <xsl:sort select="original" />
            <xsl:with-param name="type" select="'fp'"/>
          </xsl:apply-templates >
        </table>
      </section>
    </xsl:if>

    <section>
      <title>True negatives (<xsl:value-of
              select="count(word[status='SplCor'][not(expected)])"/>)</title>
      <p>The correctly accepted words are listed here for easy copy&amp;paste
         into Word to quick check regressions in new versions of the speller:
         No correctly spelled words accepted by an earlier speller should be
         rejected by later spellers. To check, just copy and paste these words
         to Word, and see if you get any red underlines. Duplicate words are not
         repeated, unless one is followed by some punctuation. The words are
         sorted according to Unicode character code.</p>
      <p>
        <xsl:apply-templates select="word[status='SplCor'][not(expected)]">
          <xsl:sort select="original" />
          <xsl:with-param name="type" select="'tn'"/>
        </xsl:apply-templates >
      </p>
    </section>
  </xsl:template>

  <xsl:template match="word">
    <xsl:param name="type"/>
    <xsl:choose>
      <xsl:when test="$type = 'tn'">
        <xsl:apply-templates select="original[not(. =
                     ../preceding-sibling::word/original)]"/>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <tr>
          <xsl:if test="@forced">
            <xsl:attribute name="class">
              <xsl:value-of select="'forced'"/>
            </xsl:attribute>
          </xsl:if>
          <td><xsl:value-of select="original"/></td>
          <xsl:if test="$type != 'fp'">
            <td><xsl:value-of select="expected"/></td>
            <td><xsl:value-of select="edit_dist"/></td>
          </xsl:if>
          <xsl:if test="suggestions/@count > 0">
            <td>
              <xsl:apply-templates select="suggestions"/>
            </td>
          </xsl:if>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
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
