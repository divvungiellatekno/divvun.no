<?xml version="1.0" encoding="UTF-8"?>
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
<!DOCTYPE xsl:stylesheet [
<!ENTITY content SYSTEM 'include_content.xml'>
<!ENTITY meta SYSTEM 'include_meta.xml'>
<!ENTITY settings SYSTEM 'include_settings.xml'>
<!ENTITY styles SYSTEM 'include_styles.xml'>
<!ENTITY manifest SYSTEM 'include_manifest.xml'>
]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:zip="http://apache.org/cocoon/zip-archive/1.0"
                xmlns:text="http://openoffice.org/2000/text"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
                xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
                xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
                xmlns:datetime="http://exslt.org/dates-and-times"
                exclude-result-prefixes="datetime">
    
    <!-- improves the readability of the resulting document
        when using xsltproc. Should probably be deleted for
        the final version -->
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    <xsl:template match="doc">
        <zip:archive>
            <zip:entry name="content.xml" serializer="xml">
                &content;
            </zip:entry>
            <zip:entry name="meta.xml" serializer="xml">
                &meta;
            </zip:entry>
            <zip:entry name="settings.xml" serializer="xml">
                &settings;
            </zip:entry>
            <zip:entry name="styles.xml" serializer="xml">
                &styles;
            </zip:entry>
            <zip:entry name="META-INF/manifest.xml" serializer="xml">
                &manifest;
            </zip:entry>
            <zip:entry name="mimetype" serializer="text">
                <text>application/vnd.oasis.opendocument.graphics</text>
            </zip:entry>
            <!--<zip:entry>
                <xsl:apply-templates select="//document[1]/body"/>
            </zip:entry>-->
<!--             <xsl:call-template name="createImageEntries"/> -->
        </zip:archive>
    </xsl:template>

    <!--
        Rearrange the contents of a our doc.
        Overrides many of the templates earlier declared, will
        have to be fixed.
    -->
    <xsl:template match="//document[1]/body">
        <xsl:for-each select="section">
            <xsl:variable name="sectionPosition" select="position()"/>
            <draw:frame>
                <draw:text-box>
                    <xsl:for-each select="//section[$sectionPosition]/title">
                        <text:h text:outline-level="2" text:is-list-header="true"><xsl:apply-templates/></text:h>
                    </xsl:for-each>
                    <xsl:for-each select="p">
                        <xsl:variable name="pPosition" select="position()" />
                        <xsl:for-each select="//section[$sectionPosition]/p[$pPosition]" >
                            <text:p text:style-name="P2"><xsl:apply-templates/></text:p>
                        </xsl:for-each>
                    </xsl:for-each>
                </draw:text-box>
            </draw:frame>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="header">
        <text:h text:outline-level="1" text:is-list-header="true"><xsl:value-of select="title"/></text:h>
        <text:h text:outline-level="3" text:is-list-header="true"><xsl:value-of select="subtitle"/></text:h>
        <text:p><xsl:value-of select="abstract"/></text:p>
    </xsl:template>

    <xsl:template match="body">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="section">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="title">
        <text:h text:outline-level="2" text:is-list-header="true"><xsl:value-of select="."/></text:h>
    </xsl:template>

    <xsl:template match="a|link">
        <text:a xlink:type="simple" xlink:href="{@href}"><xsl:value-of select="."/></text:a>
    </xsl:template>

    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="ol|ul">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <text:p text:style-name="P2"><xsl:apply-templates/></text:p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ul">
        <text:list>
            <xsl:apply-templates/>
        </text:list>
    </xsl:template>

    <xsl:template match="ol">
        <text:list text:style-name="L1">
            <xsl:apply-templates/>
        </text:list>
    </xsl:template>

    <xsl:template match="li">
        <text:list-item>
            <xsl:choose>
                <xsl:when test="p|note|warning|fixme">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <text:p>
                        <xsl:apply-templates/>
                    </text:p>
                </xsl:otherwise>
            </xsl:choose>
        </text:list-item>
    </xsl:template>

    <xsl:template match="sub">
        <text:span text:style-name="T1">
            <xsl:value-of select="."/>
        </text:span>
    </xsl:template>

    <xsl:template match="sup">
        <text:span text:style-name="T2">
            <xsl:value-of select="."/>
        </text:span>
    </xsl:template>

    <xsl:template match="em">
        <text:span text:style-name="Emphasis">
            <xsl:value-of select="."/>
        </text:span>
    </xsl:template>

    <xsl:template match="code">
        <text:span text:style-name="Source_20_Text">
            <xsl:value-of select="."/>
        </text:span>
    </xsl:template>

    <xsl:template match="source">
        <text:p text:style-name="Standard">
            <text:span text:style-name="Source_20_Text">
                <xsl:value-of select="."/>
            </text:span>
        </text:p>
    </xsl:template>

    <xsl:template match="strong">
        <text:span text:style-name="Strong_20_Text">
            <xsl:value-of select="."/>
        </text:span>
    </xsl:template>

    <xsl:template match="note | warning | fixme">
        <xsl:choose>
            <xsl:when test="@label">
                <xsl:value-of select="@label"/>
            </xsl:when>
            <xsl:when test="local-name() = 'note'">
                <text:p text:style-name="P6">
                    Note: <xsl:value-of select="."/>
                </text:p>
            </xsl:when>
            <xsl:when test="local-name() = 'warning'">
                <text:p text:style-name="P6">
                    Warning: <xsl:value-of select="."/>
                </text:p>
            </xsl:when>
            <xsl:otherwise>
                <text:p text:style-name="P6">
                    Fixme (<xsl:value-of select="@author"/>) <xsl:value-of select="."/>
                </text:p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="img|figure|icon">
        <draw:frame>
                <xsl:attribute name="draw:style-name">fr1</xsl:attribute>
                <xsl:attribute name="draw:name"><xsl:value-of select="@alt"/></xsl:attribute>
                <xsl:attribute name="text:anchor-type">paragraph</xsl:attribute>
                <xsl:attribute name="draw:z-index">0</xsl:attribute>
                <!-- <xsl:attribute name="svg:y">0cm</xsl:attribute> -->
                <xsl:attribute name="svg:width"><xsl:value-of select="substring-before(@width, 'p') div 36"/>cm</xsl:attribute>
                <xsl:attribute name="svg:height"><xsl:value-of select="substring-before(@height, 'p') div 36"/>cm</xsl:attribute>
                <xsl:call-template name="drawImage"/>
        </draw:frame>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template name="drawImage">
        <draw:image>
            <xsl:attribute name="xlink:href">Pictures/<xsl:call-template name="fileName">
            <xsl:with-param name="path" select="@src"/>
            </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="xlink:type">simple</xsl:attribute>
            <xsl:attribute name="xlink:show">embed</xsl:attribute>
            <xsl:attribute name="xlink:actuate">onLoad</xsl:attribute>
        </draw:image>
    </xsl:template>

    <!-- Tables -->
    <xsl:template match="table">
        <xsl:param name="count" select="count(following-sibling::tr)"/>
        <table:table table:name="{//caption}">
            <table:table-column table:number-columns-repeated="3" />
            <!-- FIXME: That hard coded 3 needs to be replaced with a count of how <tr> there are
            need to test and apply the 'count' param above -->
            <xsl:apply-templates/>
        </table:table>
    </xsl:template>

    <xsl:template match="th">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="tr">
        <table:table-row>
            <xsl:apply-templates/>
        </table:table-row>
    </xsl:template>

    <xsl:template match="td">
        <table:table-cell>
            <text:p>
                <xsl:apply-templates/>
            </text:p>
        </table:table-cell>
    </xsl:template>
    <!-- /Tables -->

    <xsl:template name="createImageEntries">
        <xsl:for-each select="//img|//figure|//icon">
            <zip:entry>
                <xsl:attribute name="name">
                    Pictures/<xsl:call-template name="fileName">
                        <xsl:with-param name="path" select="@src"/>
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="src">
                    cocoon://<xsl:value-of select="@src"/>
                </xsl:attribute>
            </zip:entry>
        </xsl:for-each>
        <!-- Add default background image -->
        <zip:entry>
            <xsl:attribute name="name">Pictures/osswatch_background.png</xsl:attribute>
            <xsl:attribute name="src">resources/images/osswatch_background.png</xsl:attribute>
            <!-- FIXME: Would like to use project images dir, how to configure for that ? -->
        </zip:entry>
    </xsl:template>

    <!-- 'filename' template returns just file.txt from a path such
    as /foo/bar/baz/file.txt -->

    <xsl:template name="fileName">
        <xsl:param name="path" />
        <xsl:choose>
            <xsl:when test="contains($path,'\')">
                <xsl:call-template name="fileName">
                    <xsl:with-param name="path" select="substring-after($path,'\')" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($path,'/')">
                <xsl:call-template name="fileName">
                    <xsl:with-param name="path" select="substring-after($path,'/')" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$path" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
