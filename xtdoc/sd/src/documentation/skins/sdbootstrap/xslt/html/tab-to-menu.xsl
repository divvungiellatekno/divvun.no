<?xml version="1.0"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<!--
This stylesheet generates 'tabs' at the top left of the screen.  Tabs are
visual indicators that a certain subsection of the URI space is being browsed.
For example, if we had tabs with paths:

Tab1:  ''
Tab2:  'community'
Tab3:  'community/howto'
Tab4:  'community/howto/form/index.html'

Then if the current path was 'community/howto/foo', Tab3 would be highlighted.
The rule is: the tab with the longest path that forms a prefix of the current
path is enabled.

The output of this stylesheet is HTML of the form:
    <div class="tab">
      ...
    </div>

which is then merged by site-to-xhtml.xsl

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="lm://transform.skin.common.html.tab-to-menu"/>
  <xsl:template match="tabs">
    <div id="tabs">
        <ul class="nav navbar-nav">
            <xsl:call-template name="base-tabs"/>
        </ul>
    </div>
    <!--- orig-versjon av nivå2-flikane: -->
    <!--div id="level2tabs">
        <ul class="nav navbar-nav">
            <xsl:call-template name="level2tabs"/>
        </ul>
    </div-->
    <xsl:if test="(tab/@id=$matching-id) or
                  (tab[@dir=$longest-dir]) or
                  (tab[@href=$longest-dir]) or
                  (tab[tab/@id=$matching-id])">
      <div id="level2tabs">
        <ul class="nav navbar-nav">
            <!-- @id should take the id of the mother tab as its value -->
            <xsl:attribute name="id">
              <!--xsl:value-of select="tab[@dir=$longest-dir]/@id"/-->
                <!-- The choose statement will in effect take the first id
                     of the second-level tabs of the current first-level tab
                     - probably not what we want. What is the purpose of the
                     @id of the ul? -->
                <xsl:choose>
                  <xsl:when test="tab/@id=$matching-id">
                    <xsl:value-of select="tab[@id=$matching-id]/@id"/>
                  </xsl:when>
                  <xsl:when test="tab/@dir=$longest-dir">
                    <xsl:value-of select="tab[@dir=$longest-dir]/tab/@id"/>
                  </xsl:when>
                  <xsl:when test="tab/@href=$longest-dir">
                    <xsl:value-of select="tab[@href=$longest-dir]/tab/@id"/>
                  </xsl:when>
                  <xsl:when test="tab/tab/@id=$matching-id">
                    <xsl:value-of select="tab[tab/@id=$matching-id]/tab/@id"/>
                  </xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <!-- DEBUG: -->
            <xsl:attribute name="test">
                  <xsl:value-of select="concat(
                        '€',@id,
                        '€',@dir,
                        '€',$matching-id,
                        '$',$longest-dir,
                        '£',$level2-longest-dir,
                        '•',tab[@id=$matching-id]/@id,
                        '-',tab[@dir=$longest-dir]/tab/@id,
                        '•',tab[@dir=$longest-dir]/@id,
                        '+',tab[@href=$longest-dir]/@id,
                        '•',tab[tab/@id=$matching-id]/@id)"/>
            </xsl:attribute>
        <xsl:call-template name="level2tabs"/>
        </ul>
      </div>
    </xsl:if>
  </xsl:template>
  <xsl:template name="pre-separator"></xsl:template>
  <xsl:template name="post-separator"></xsl:template>
  <xsl:template name="separator"></xsl:template>
  <xsl:template name="level2-separator"></xsl:template>
  <xsl:template name="selected">
    <li class="active dropdown"><xsl:call-template name="base-selected"/></li>
  </xsl:template>
  <xsl:template name="not-selected">
    <li class="dropdown"><xsl:call-template name="base-not-selected"/></li>
  </xsl:template>
  <xsl:template name="level2-not-selected">
    <li><xsl:call-template name="base-not-selected"/></li>
  </xsl:template>
  <xsl:template name="level2-selected">
    <li class="active"><xsl:call-template name="base-selected"/></li>
  </xsl:template>
</xsl:stylesheet>
