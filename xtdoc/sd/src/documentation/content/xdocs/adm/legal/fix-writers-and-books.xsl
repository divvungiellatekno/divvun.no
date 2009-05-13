<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY content SYSTEM 'include_content.xml'>
<!ENTITY meta SYSTEM 'include_meta.xml'>
<!ENTITY settings SYSTEM 'include_settings.xml'>
<!ENTITY styles SYSTEM 'include_styles.xml'>
<!ENTITY manifest SYSTEM 'include_manifest.xml'>
]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                >

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
	<xsl:variable name="newline">
<xsl:text>
</xsl:text>
	</xsl:variable>

        <xsl:template match="@*|node()">
          <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
          </xsl:copy>
        </xsl:template>

	<xsl:template match="/document/body/section[1]/table/tr" >
		<tr><xsl:for-each select="td">
			
				<xsl:if test="position() = 1">
					<td id="title">
						<xsl:value-of select="."/>
					</td>
				</xsl:if>
				<xsl:if test="position() = 2">
					<td id="isbn">
					<xsl:value-of select="."/>
					</td>
				</xsl:if>
				<xsl:if test="position() = 3">
					<td id="publisher">
					<xsl:value-of select="."/>
					</td>
				</xsl:if>
				<xsl:if test="position() = 4">
					<td id="writer">
					<xsl:value-of select="."/>
					</td>
				</xsl:if>
				<xsl:if test="position() = 5">
					<td id="translator">
					<xsl:value-of select="."/>
					</td>
				</xsl:if>
				<xsl:if test="position() = 6">
					<td id="language">
					<xsl:value-of select="."/>
					</td>
				</xsl:if>
				<xsl:if test="position() = 7">
					<td id="contact">
					<xsl:value-of select="."/>
					</td>
				</xsl:if>
				<xsl:if test="position() = 8">
					<td id="sent_contract">
					<xsl:value-of select="."/>
					</td>
				</xsl:if>
				<xsl:if test="position() = 9">
					<td id="sign_writ">
					<xsl:value-of select="."/>
					</td>
				</xsl:if>
				<xsl:if test="position() = 10">
					<td id="sign_trans">
					<xsl:value-of select="."/>
					</td>
				</xsl:if>
				<xsl:if test="position() = 11">
					<td id="sign_publisher">
					<xsl:value-of select="."/>
					</td>
				</xsl:if>
				<xsl:if test="position() = 12">
					<td id="sign_samiparl">
					<xsl:value-of select="."/>
					</td>
				</xsl:if>
				<xsl:if test="position() = 13">
					<td id="arch_numb">
					<xsl:value-of select="."/>
					</td>
				</xsl:if>
				<xsl:if test="position() = 14">
					<td id="text_added_to_corp">
					<xsl:value-of select="."/>
					</td>
				</xsl:if>
			
		</xsl:for-each></tr>
	</xsl:template>

</xsl:stylesheet>
