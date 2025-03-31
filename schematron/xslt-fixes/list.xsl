<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  exclude-result-prefixes="sc xs" version="2.0">

  <xsl:import href="identity.xsl"/>

  <xsl:template match="list[@list-type = 'dash']/@list-type" mode="bullet">
    <xsl:attribute name="{name()}" select="'bullet'"/>
    <xsl:attribute name="style-detail" select="'dash'"/>
  </xsl:template>
  
  <xsl:template match="*[self::list or self::def-list or self::non-normative-note or self::non-normative-example or self::disp-quote or self::disp-formula]
                        [not(parent::p)]
                        [preceding-sibling::*[not(self::list or self::def-list or self::non-normative-note or self::non-normative-example or self::disp-quote or self::disp-formula)][1][self::p]]" 
                mode="nest-lists">
    <xsl:param name="display" select="false()"/>
    
    <xsl:if test="$display">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="p[following-sibling::*[1]
                                             [self::list or self::def-list or self::non-normative-note or self::non-normative-example or self::disp-quote or self::disp-formula]]" 
                mode="nest-lists">
    <xsl:variable name="first-non-list" select="following-sibling::*[not(self::list or self::def-list or self::non-normative-note or self::non-normative-example or self::disp-quote or self::disp-formula)][1]"/>
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="#current"/>
      <xsl:apply-templates select="following-sibling::node()[. &lt;&lt; $first-non-list or empty($first-non-list)]" mode="#current">
        <xsl:with-param name="display" select="true()"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>