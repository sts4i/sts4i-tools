<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  exclude-result-prefixes="sc xs" version="2.0">

  <xsl:import href="identity.xsl"/>

  <xsl:template match="*[name() = ('th', 'td')]
                        [p]
                        [text()[normalize-space()] | *[name() = $inline-element-names]]"
    mode="fix-table-paras">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:for-each-group select="node()" group-adjacent="exists(self::p)">
        <xsl:choose>
          <xsl:when test="current-grouping-key()">
            <xsl:apply-templates select="current-group()" mode="#current"/>
          </xsl:when>
          <xsl:otherwise>
            <p>
              <xsl:apply-templates select="current-group()" mode="#current"/>
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>