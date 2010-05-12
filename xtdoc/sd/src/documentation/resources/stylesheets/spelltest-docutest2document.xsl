<?xml version="1.0"?>
<!--+
    | Transforms corpus content documents to Forrest documents according
    | to the language parameter - only content for the given language is
    | returned.
    +-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  exclude-result-prefixes="i18n"
  version="1.0">

  <xsl:param name="testlang"/>
  <xsl:param name="testtype"/>
  <xsl:param name="toplimit">3</xsl:param>
  <xsl:param name="bugurl">http://giellatekno.uit.no/bugzilla/show_bug.cgi?id=</xsl:param>

  <xsl:key name="bugid" match="word" use="./bug"/>

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
    <xsl:param name="TokErrSpellErr"
     select="count(../results/word[status='TokErr' and ./expected])"/>
    <xsl:param name="TokErrSpellCor"
     select="count(../results/word[status='TokErr' and not(./expected)])"/>
    <xsl:param name="nrrealcorr" select="count(../results/word[not(expected)])"/>
    <xsl:param name="precision" select="$truepositive div ($truepositive + $falsepositive)"/>
    <xsl:param name="recall" select="$truepositive div ($truepositive + $falsenegative)"/>
    <xsl:param name="accuracy" select="($truepositive+$truenegative) div
                            ($nrflaggedwords + $nracceptwords)"/>

    <!-- Classification of spelling errors according to suggestions: -->
    <xsl:param name="topthree"
     select="count(../results/word[status='SplErr']
                                  [position > 0]
                                  [position &lt;= $toplimit])"/>
    <xsl:param name="NotTopThree"
     select="count(../results/word[status='SplErr']
                                  [expected]
                                  [position > $toplimit])"/>
    <xsl:param name="nocorrsugg"
     select="count(../results/word[status='SplErr']
                                  [expected]
                                  [suggestions/@count > 0]
                                  [position = 0])"/>
    <xsl:param name="nosugg"
     select="count(../results/word[status='SplErr'][expected]
                                  [suggestions/@count = 0])"/>

    <!-- Classification of spelling errors according to editing distance: -->
    <xsl:param name="editdist1"
     select="count(../results/word[expected]
                                  [edit_dist = 1])"/>
    <xsl:param name="editdist2"
     select="count(../results/word[expected]
                                  [edit_dist = 2])"/>
    <xsl:param name="editdist3"
     select="count(../results/word[expected]
                                  [edit_dist > 2])"/>
    <xsl:param name="errorinput"
     select="count(../results/word[status='Error']
                                  [expected])"/>

    <!-- The X product of suggestions and spelling errors above: -->
    <xsl:param name="NotTopThreeSimple"
     select="count(../results/word[status='SplErr']
                                  [expected]
                                  [position > $toplimit]
                                  [edit_dist = 1])"/>
    <xsl:param name="NotTopThreeEdit2"
     select="count(../results/word[status='SplErr']
                                  [expected]
                                  [position > $toplimit]
                                  [edit_dist = 2])"/>
    <xsl:param name="NotTopThreeEdit3"
     select="count(../results/word[status='SplErr']
                                  [expected]
                                  [position > $toplimit]
                                  [edit_dist > 2])"/>

    <xsl:param name="topthreeSimple"
     select="count(../results/word[status='SplErr']
                                  [position > 0]
                                  [position &lt;= $toplimit]
                                  [edit_dist = 1])"/>
    <xsl:param name="topthreeEdit2"
     select="count(../results/word[status='SplErr']
                                  [position > 0]
                                  [position &lt;= $toplimit]
                                  [edit_dist = 2])"/>
    <xsl:param name="topthreeEdit3"
     select="count(../results/word[status='SplErr']
                                  [position > 0]
                                  [position &lt;= $toplimit]
                                  [edit_dist > 2])"/>

    <xsl:param name="nocorrsuggSimple"
     select="count(../results/word[status='SplErr']
                                  [expected]
                                  [suggestions/@count > 0]
                                  [position = 0]
                                  [edit_dist = 1])"/>
    <xsl:param name="nocorrsuggEdit2"
     select="count(../results/word[status='SplErr']
                                  [expected]
                                  [suggestions/@count > 0]
                                  [position = 0]
                                  [edit_dist = 2])"/>
    <xsl:param name="nocorrsuggEdit3"
     select="count(../results/word[status='SplErr']
                                  [expected]
                                  [suggestions/@count > 0]
                                  [position = 0]
                                  [edit_dist > 2])"/>
    <xsl:param name="nosuggSimple"
     select="count(../results/word[status='SplErr']
                                  [expected]
                                  [suggestions/@count = 0]
                                  [edit_dist = 1])"/>
    <xsl:param name="nosuggEdit2"
     select="count(../results/word[status='SplErr']
                                  [expected]
                                  [suggestions/@count = 0]
                                  [edit_dist = 2])"/>
    <xsl:param name="nosuggEdit3"
     select="count(../results/word[status='SplErr']
                                  [expected]
                                  [suggestions/@count = 0]
                                  [edit_dist > 2])"/>
    <xsl:param name="falsenegSimple"
     select="count(../results/word[status='SplCor' and ./expected]
                                  [edit_dist = 1])"/>
    <xsl:param name="falsenegEdit2"
     select="count(../results/word[status='SplCor' and ./expected]
                                  [edit_dist = 2])"/>
    <xsl:param name="falsenegEdit3"
     select="count(../results/word[status='SplCor' and ./expected]
                                  [edit_dist > 2])"/>

    <section>
      <title>Overview</title>
      <section>
        <title>Technical data</title>
        <p>Language tested:
          <strong><xsl:value-of select="$testlang"/></strong>
        </p>
        <p>Document tested: 
          <strong><xsl:value-of select="document"/></strong>
        </p>
        <p>Speller tool:
          <xsl:choose>
            <xsl:when test="tool/@type = 'pl'">
              <strong>Polderland command line tool</strong>
            </xsl:when>
            <xsl:when test="tool/@type = 'mw'">
              <strong>AppleScript driving MS Word</strong>
            </xsl:when>
            <xsl:when test="tool/@type = 'hu'">
              <strong>Hunspell, command line version</strong>
            </xsl:when>
            <xsl:otherwise>Unknown</xsl:otherwise>
          </xsl:choose>
        </p>
        <p>Speller tool version:
          <xsl:choose>
            <xsl:when test="tool/@toolversion = ''">Unknown</xsl:when>
            <xsl:otherwise>
              <strong><xsl:value-of select="tool/@toolversion"/></strong>
            </xsl:otherwise>
          </xsl:choose>
        </p>
        <p>Speller lexicon version:
          <xsl:choose>
            <xsl:when test="tool/@version = ''">Unknown</xsl:when>
            <xsl:otherwise>
              <strong><xsl:value-of select="tool/@lexversion"/></strong>
            </xsl:otherwise>
          </xsl:choose>
        </p>
        <p>Test Date:
          <strong><xsl:value-of select="date"/></strong></p>
        <p>Test Type:
          <xsl:choose>
            <xsl:when test="$testtype = 'regression' or
                            $testtype = 'typos' or
                            $testtype = 'wordtype' or
                            $testtype = 'baseform' ">
              <strong><xsl:value-of select="$testtype"/></strong>
            </xsl:when>
            <xsl:otherwise>
              <strong>correct-corpus</strong>
            </xsl:otherwise>
          </xsl:choose>
        </p>
      </section>
      <section>
        <title>Result summary</title>
        <p>Nº of input words:
        <strong><xsl:value-of select="$nrwords"/></strong></p>
        <p>Nº of spelling errors:
        <strong><xsl:value-of select="$nrrealerr"/></strong> (<xsl:value-of
                select="round(($nrrealerr div $nrwords) * 10000) div 100"/> % of all words)</p>

        <table>
          <caption>Precision and Recall</caption>
          <tr>
            <td colspan="2" rowspan="2"/>
            <th colspan="2">Speller view</th>
            <th>Wrong tokenisation</th>
          </tr>
          <tr>
            <td>Speller Positive<br/>
              (Nº of flagged words):<br/>
              <strong><xsl:value-of select="$nrflaggedwords"/></strong></td>
            <td>Speller Negative<br/>
              (Nº of accepted words):<br/>
              <strong><xsl:value-of select="$nracceptwords"/></strong></td>
            <th>All tokenisation<br/>
              errors:<br/>
              <strong><xsl:value-of select="$TokErrSpellErr + $TokErrSpellCor"/></strong></th>
          </tr>
          <tr>
            <th rowspan="2">Reality</th>
            <td>Nº of real errors:<br/>
              <strong><xsl:value-of select="$nrrealerr"/></strong></td>
            <td>Nº of true positives<br/>
              (detected real errors):<br/>
              <strong><xsl:value-of select="$truepositive"/></strong></td>
            <td>Nº of false negatives<br/>
              (unflagged spelling errors):<br/>
              <strong><xsl:value-of select="$falsenegative"/></strong></td>
            <td>Nº of errouneously<br/>
              tokenized spelling errors:<br/>
              <strong><xsl:value-of select="$TokErrSpellErr"/></strong></td>
          </tr>
          <tr>
            <td>Nº of real correct words:<br/>
              <strong><xsl:value-of select="$nrrealcorr"/></strong></td>
            <td>Nº of false positives<br/>
              (incorrectly flagged words):<br/>
              <strong><xsl:value-of select="$falsepositive"/></strong></td>
            <td>Nº of true negatives<br/>
              (unflagged correct words):<br/>
              <strong><xsl:value-of select="$truenegative"/></strong></td>
            <td>Nº of errouneously<br/>
              tokenized correct words:<br/>
              <strong><xsl:value-of select="$TokErrSpellCor"/></strong></td>
          </tr>
        </table>

        <xsl:if test="count(../results/word[status='Error'][expected]) > 0">
          <p><strong><xsl:value-of select="$errorinput"/> input word(s)</strong>
          was/were discarded because the speller (or MS Word) could not deal with them
          properly. The calculation of Precision, Recall and Accuracy below does
          <strong>NOT</strong> include this/these word(s).</p>
        </xsl:if>

        <dl>
          <dt>Precision (tp/(tp+fp)):</dt>
            <dd><xsl:value-of select="round($precision * 10000) div 100"/> %</dd>
          <dt>Recall (tp/(tp+fn)):</dt>
            <dd><xsl:value-of select="round($recall * 10000) div 100"/> %</dd>
          <dt>Accuracy ((tp+tn)/words):</dt>
            <dd><xsl:value-of select="round($accuracy * 10000) div 100"/> %</dd>
        </dl>

        <table>
          <caption>Suggestion &amp; Spelling error statistics</caption>
          <tr>
            <td colspan="2" rowspan="2"> </td>
            <th colspan="3">Spelling errors: <xsl:value-of select="$nrrealerr"/></th>
          </tr>
          <tr>
            <th>Simple errors<br/>
                (edit dist. 1):</th>
            <th>Errors with edit<br/>
                distance 2:</th>
            <th>Errors with edit<br/>
                distance ≥3:</th>
          </tr>
          <tr>
            <th colspan="2">Suggestion statistics for true positives (tp =
                <xsl:value-of select="$truepositive"/> = 100%):</th>
            <td><xsl:value-of select="$editdist1"/>
                (<xsl:value-of select="round(($editdist1 div $nrrealerr) * 10000) div 100"/> %)</td>
            <td><xsl:value-of select="$editdist2"/>
                (<xsl:value-of select="round(($editdist2 div $nrrealerr) * 10000) div 100"/> %)</td>
            <td><xsl:value-of select="$editdist3"/>
                (<xsl:value-of select="round(($editdist3 div $nrrealerr) * 10000) div 100"/> %)</td>
          </tr>
          <tr>
            <td>Nº of detected spelling errors with <span class="correct">correct
                suggestion</span> in top <xsl:value-of select="$toplimit"/>:</td>
            <td><xsl:value-of select="$topthree"/>
                (<xsl:value-of select="round(($topthree div $truepositive) * 10000) div 100"/> %)</td>
            <td><xsl:value-of select="$topthreeSimple"/></td>
            <td><xsl:value-of select="$topthreeEdit2"/></td>
            <td><xsl:value-of select="$topthreeEdit3"/></td>
          </tr>
          <tr>
            <td>Nº of detected spelling errors with <span class="correct">correct
                suggestion</span> <em>below</em> top <xsl:value-of select="$toplimit"/>:</td>
            <td><xsl:value-of select="$NotTopThree"/>
                (<xsl:value-of select="round(($NotTopThree div $truepositive) * 10000) div 100"/> %)</td>
            <td><xsl:value-of select="$NotTopThreeSimple"/></td>
            <td><xsl:value-of select="$NotTopThreeEdit2"/></td>
            <td><xsl:value-of select="$NotTopThreeEdit3"/></td>
          </tr>
          <tr>
            <td>Nº of detected spelling errors with only wrong suggestions:</td>
            <td><xsl:value-of select="$nocorrsugg "/>
                (<xsl:value-of select="round(($nocorrsugg div $truepositive) * 10000) div 100"/> %)</td>
            <td><xsl:value-of select="$nocorrsuggSimple"/></td>
            <td><xsl:value-of select="$nocorrsuggEdit2"/></td>
            <td><xsl:value-of select="$nocorrsuggEdit3"/></td>
          </tr>
          <tr>
            <td>Nº of detected spelling errors with no suggestions at all:</td>
            <td><xsl:value-of select="$nosugg"/>
                (<xsl:value-of select="round(($nosugg div $truepositive) * 10000) div 100"/> %)</td>
            <td><xsl:value-of select="$nosuggSimple"/></td>
            <td><xsl:value-of select="$nosuggEdit2"/></td>
            <td><xsl:value-of select="$nosuggEdit3"/></td>
          </tr>
          <tr>
            <td>Undetected spelling errors:</td>
            <td><xsl:value-of select="$falsenegative"/></td>
            <td><xsl:value-of select="$falsenegSimple"/></td>
            <td><xsl:value-of select="$falsenegEdit2"/></td>
            <td><xsl:value-of select="$falsenegEdit3"/></td>
          </tr>
        </table>

        <p/>

      </section>
    </section>
  </xsl:template>

  <xsl:template match="results">
    <xsl:if test="count(word[status='SplErr'][expected]) > 0">
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
            <xsl:if test="$testtype = 'regression'">
              <th>Bug ID</th>
              <th>Comment</th>
            </xsl:if>
            <xsl:if test="not($testtype = 'regression') and ./word/comment">
              <th>Comment</th>
            </xsl:if>
          </tr>
          <xsl:apply-templates select="word[status='SplErr']
                                           [expected]
                                           [suggestions/@count > 0]
                                           [position > 0]">
            <xsl:sort select="bug" data-type="number"/>
            <xsl:sort select="edit_dist" order="descending" data-type="number"/>
            <xsl:sort select="position" order="descending" data-type="number"/>
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
              <th>Suggestions</th>
              <xsl:if test="$testtype = 'regression'">
                <th>Bug ID</th>
                <th>Comment</th>
              </xsl:if>
              <xsl:if test="not($testtype = 'regression') and ./word/comment">
                <th>Comment</th>
              </xsl:if>
            </tr>
            <xsl:apply-templates select="word[status='SplErr']
                                             [expected]
                                             [suggestions/@count > 0]
                                             [position = 0]">
              <xsl:sort select="bug" data-type="number"/>
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
              <xsl:if test="$testtype = 'regression'">
                <th>Bug ID</th>
                <th>Comment</th>
              </xsl:if>
              <xsl:if test="not($testtype = 'regression') and ./word/comment">
                <th>Comment</th>
              </xsl:if>
            </tr>
            <xsl:apply-templates select="word[status='SplErr']
                                             [expected]
                                             [suggestions/@count = 0]">
              <xsl:sort select="bug" data-type="number"/>
              <xsl:sort select="edit_dist" order="descending" data-type="number"/>
              <xsl:sort select="original" />
            </xsl:apply-templates >
          </table>
        </section>
      </xsl:if>
    </section>
    </xsl:if>

    <xsl:if test="count(word[status='SplErr'][not(expected)]) > 0">
      <section>
        <title>False positives (<xsl:value-of
              select="count(word[status='SplErr'][not(expected)])"/>)</title>
        <xsl:if test="count(word[status='SplErr']
                                [not(expected)]
                                [suggestions/@count > 0]) > 0">
          <section>
            <title>False positives with suggestions (<xsl:value-of
                  select="count(word[status='SplErr']
                                    [not(expected)]
                                    [suggestions/@count > 0])"/>)</title>
            <table>
              <tr>
                <th>Input<br/>word</th>
                <th>Suggestions</th>
                <xsl:if test="$testtype = 'regression'">
                  <th>Bug ID</th>
                  <th>Comment</th>
                </xsl:if>
              </tr>
              <xsl:apply-templates select="word[status='SplErr']
                                               [not(expected)]
                                               [suggestions/@count > 0]">
                <xsl:sort select="bug" data-type="number"/>
                <xsl:sort select="original" />
                <xsl:with-param name="type" select="'fp'"/>
              </xsl:apply-templates >
            </table>
          </section>
        </xsl:if>
        <xsl:if test="count(word[status='SplErr']
                                [not(expected)]
                                [suggestions/@count = 0]) > 0">
          <section>
            <title>False positives without suggestions (<xsl:value-of
                  select="count(word[status='SplErr']
                                    [not(expected)]
                                    [suggestions/@count = 0])"/>)</title>
            <p>
              <xsl:apply-templates select="word[status='SplErr']
                                               [not(expected)]
                                               [suggestions/@count = 0]">
                <xsl:sort select="bug" data-type="number"/>
                <xsl:sort select="original" order="descending" />
                <xsl:with-param name="type" select="'fpnosugg'"/>
              </xsl:apply-templates >
            </p>
          </section>
        </xsl:if>
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
            <xsl:if test="$testtype = 'regression'">
              <th>Bug ID</th>
              <th>Comment</th>
            </xsl:if>
          </tr>
          <xsl:apply-templates select="word[status='SplCor'][expected]">
            <xsl:sort select="bug" data-type="number"/>
            <xsl:sort select="edit_dist" order="descending" data-type="number"/>
            <xsl:sort select="original" />
            <xsl:with-param name="type" select="'fn'"/>
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
         reverse sorted according to Unicode character code.</p>
      <p id="truenegatives">
        <xsl:apply-templates select="word[status='SplCor'][not(expected)]">
          <xsl:sort select="original" order="descending" />
          <xsl:with-param name="type" select="'tn'"/>
        </xsl:apply-templates >
      </p>
    </section>

    <xsl:if test="count(word[status='Error'][expected]) > 0">
      <section>
        <title>Disregarded by speller (<xsl:value-of
              select="count(word[status='Error'][expected])"/>)</title>
      <p>When using AppleScript and Microsoft Word to run the speller tests,
      there are some words that are impossible to spell check. This is due to
      a "feature" of MS Word's implementation of AppleScript - hyphens, colons
      and full stops are not recognised as part of the string to be checked,
      and the words are instead split in two (or more) at each non-letter,
      and each part is spell-checked alone. This of course leads to meaningless
      speller output. They are therefore not considered, but are listed here
      for reference. <strong>This only happens when using AppleScript.</strong>
      In normal, interactive use, such words are correctly dealt with by the
      speller/Word.</p>
        <table>
          <tr>
            <th>Input<br/>word</th>
            <th>Expected<br/>correction</th>
            <th>Editing<br/>distance</th>
            <xsl:if test="$testtype = 'regression'">
              <th>Bug ID</th>
              <th>Comment</th>
            </xsl:if>
          </tr>
          <xsl:apply-templates select="word[status='Error'][expected]">
            <xsl:sort select="bug" data-type="number"/>
            <xsl:sort select="edit_dist" order="descending" data-type="number"/>
            <xsl:sort select="original" />
          </xsl:apply-templates >
        </table>
      </section>
    </xsl:if>

    <xsl:if test="count(word[status='TokErr']) > 0">
    <section>
      <title>Tokenization Errors
            (<xsl:value-of select="count(word[status='TokErr'])"/>)</title>
        <xsl:if test="count(word[status='TokErr'][expected]) > 0">
          <section>
            <title>Tokenization Errors of Misspellings
            (<xsl:value-of select="count(word[status='TokErr'][expected])"/>)</title>
            <table>
              <tr>
                <th>Input<br/>word</th>
                <th>Expected<br/>correction</th>
                <th>Editing<br/>distance</th>
                <th>Speller<br/>Tokens</th>
              </tr>
              <xsl:apply-templates select="word[status='TokErr'][expected]">
                <xsl:sort select="edit_dist" order="descending" data-type="number"/>
                <xsl:sort select="original" />
                <xsl:with-param name="type" select="'toSpErr'"/>
              </xsl:apply-templates >
            </table>
          </section>
        </xsl:if>
        <xsl:if test="count(word[status='TokErr'][not(expected)]) > 0">
          <section>
            <title>Tokenization Errors of Correct Words
            (<xsl:value-of select="count(word[status='TokErr'][not(expected)])"/>)</title>
            <table>
              <tr>
                <th>Input<br/>word</th>
                <th>Speller<br/>Tokens</th>
              </tr>
              <xsl:apply-templates select="word[status='TokErr'][not(expected)]">
                <xsl:sort select="edit_dist" order="descending" data-type="number"/>
                <xsl:sort select="original" />
                <xsl:with-param name="type" select="'toSpCor'"/>
              </xsl:apply-templates >
            </table>
          </section>
        </xsl:if>
      </section>
    </xsl:if>

    <xsl:if test="$testtype = 'regression'">
      <section>
        <title>Grouped by bug #</title>
        <xsl:for-each select="word[generate-id(.)=generate-id(key('bugid',bug))]/bug">
          <xsl:sort select="." data-type="number"/> <!-- . = word/bug -->
          <p/>
          <table>
            <caption>
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="concat($bugurl,.)"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
              </a>
            </caption>
            <tr>
              <th>Input<br/>word</th>
              <th>Expected<br/>correction</th>
              <th width="4em">Editing<br/>distance</th>
              <th width="25%">Suggestions</th>
              <th>Comment</th>
            </tr>
            <xsl:for-each select="key('bugid', .)">
              <tr>
                <xsl:if test="(not(expected) and status = 'SplErr') or
                              (expected and status = 'SplCor')">
                  <xsl:attribute name="class">
                    <xsl:value-of select="'broken'"/>
                  </xsl:attribute>
                </xsl:if>
                <td><xsl:value-of select="original"/></td>
                <td><xsl:value-of select="expected"/></td>
                <td><xsl:value-of select="edit_dist"/></td>
                <td><xsl:apply-templates select="suggestions"/></td>
                <td><xsl:value-of select="comment"/></td>
              </tr>
            </xsl:for-each>
          </table>
        </xsl:for-each>
      </section>
    </xsl:if>

    <xsl:if test="$testtype = 'wordtype'">
      <section>
        <title>All test data</title>
          <table>
            <tr>
              <th>Input<br/>word</th>
              <th>Expected<br/>correction</th>
              <th>Editing<br/>distance</th>
              <th>Suggestions</th>
              <th>Comment</th>
            </tr>
            <xsl:apply-templates select="word">
              <xsl:sort select="comment"/>
              <xsl:sort select="original"/>
              <xsl:with-param name="type" select="'wordtype'"/>
            </xsl:apply-templates >
          </table>
        </section>
    </xsl:if>

    <xsl:if test="$testtype = 'regression' and
                  count(word[not(bug)]) > 0">
      <section>
        <title>Testpairs not in bugs</title>
          <table>
            <tr>
              <th>Input<br/>word</th>
              <th>Expected<br/>correction</th>
              <th width="4em">Editing<br/>distance</th>
              <th width="25%">Suggestions</th>
              <th>Comment</th>
            </tr>
            <xsl:apply-templates select="word[not(bug)]">
                <xsl:with-param name="type" select="'nobug'"/>
              <xsl:sort select="comment"/>
              <xsl:sort select="original" />
              <!--tr>
                <td><xsl:value-of select="original"/></td>
                <td><xsl:value-of select="expected"/></td>
                <td><xsl:value-of select="edit_dist"/></td>
                <td><xsl:apply-templates select="suggestions"/></td>
                <td><xsl:value-of select="comment"/></td>
              </tr-->
            </xsl:apply-templates>
          </table>
      </section>
    </xsl:if>

  </xsl:template>

  <xsl:template match="word">
    <xsl:param name="type"/>
    <xsl:choose>
      <xsl:when test="$type = 'tn'">
        <xsl:apply-templates select="original[not(. =
                     ../preceding-sibling::word/original)]"/>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="$type = 'fpnosugg'">
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
          <xsl:if test="((not(expected) and status = 'SplErr') or
                         (expected and status = 'SplCor')       )
                        and
                        ( $type = 'nobug' or
                          $type = 'wordtype' ) ">
            <xsl:attribute name="class">
              <xsl:value-of select="'broken'"/>
            </xsl:attribute>
          </xsl:if>
          <td><xsl:value-of select="original"/></td>
          <xsl:if test="$type != 'fp' and $type != 'toSpCor'">
            <td><xsl:value-of select="expected"/></td>
            <td><xsl:value-of select="edit_dist"/></td>
          </xsl:if>
          <xsl:if test="suggestions/@count > 0 or
                        $testtype = 'wordtype' or
                        ($testtype = 'regression' and
                         $type != 'fn' and
                         suggestions/@count > 0 )">
                         <!-- One more test here - now it skips no-bugged cases without suggs., instead 
                              the cell should be empty. -->
            <td>
              <xsl:apply-templates select="suggestions"/>
            </td>
          </xsl:if>
          <xsl:if test="$type = 'toSpErr' or
                        $type = 'toSpCor'">
            <td>
              <xsl:apply-templates select="tokens"/>
            </td>
          </xsl:if>
          <xsl:if test="$testtype = 'regression' or $testtype = 'wordtype' or ./comment">
            <xsl:if test="$type != 'nobug' and $testtype = 'regression'">
              <td>
                <a>
                  <xsl:attribute name="href">
                    <xsl:value-of select="concat($bugurl,bug)"/>
                  </xsl:attribute>
                <xsl:apply-templates select="bug"/>
                </a>
              </td>
            </xsl:if>
            <td>
              <xsl:apply-templates select="comment"/>
            </td>
          </xsl:if>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="suggestions|tokens">
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
      <xsl:if test="@penscore">
        <span class="score">
          (<xsl:value-of select="@penscore"/>)
        </span>
      </xsl:if>
      <xsl:apply-templates />
    </li>
  </xsl:template>

  <xsl:template match="token">
    <li>
      <xsl:apply-templates />
    </li>
  </xsl:template>

</xsl:stylesheet>
