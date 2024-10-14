<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="3.0"
  xmlns:html="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="#all"
  >
 <xsl:output method="xml" indent="no"/>
<xsl:mode on-no-match="shallow-skip"/>
  <xsl:template match="html:html">
    <xsl:choose>
      <xsl:when test="descendant::html:p[@class='ok']">
        <ok/>
      </xsl:when>
      <xsl:otherwise>
        <log>
        <xsl:apply-templates/>
        </log>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="html:div[@class='content']">
    <xsl:for-each-group select="descendant::html:summary[html:span]" group-by="html:span[1]">
       <xsl:sort select="index-of(('info', 'warning', 'error', 'fatal'), current-grouping-key())"/>
        <xsl:element name="{current-grouping-key()}">
          <xsl:attribute name="amount" select="sum(current-group()/html:span[2])"/>
          <xsl:variable name="fixed-num" select="current-group()/number(replace(html:span[3], '[^\d]', ''))"/>
          <xsl:attribute name="fixed" select="sum($fixed-num)"/>
        </xsl:element>
    </xsl:for-each-group>
  </xsl:template>
  
</xsl:stylesheet>