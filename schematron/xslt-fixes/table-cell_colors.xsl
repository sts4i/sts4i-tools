<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  exclude-result-prefixes="sc xs" version="2.0">

  <xsl:import href="identity.xsl"/>

  <xsl:template match="*[self::td or self::th][@style[matches(.,'background-color')]]" mode="table-cell_colors">
    <xsl:variable name="style" as="xs:string+">
      <xsl:for-each select="tokenize(@style,'\s*;\s*')">
        <xsl:choose>
          <xsl:when test="matches(.,'background-color')">
            <xsl:sequence select="string-join((tokenize(.,'\s*:\s*')[1],sc:color2hex(tokenize(.,'\s*:\s*')[2])),':')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:attribute name="style" select="string-join($style,';')"/>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:function name="sc:color2hex" as="xs:string">
    <xsl:param name="color-text" as="xs:string"/>
    <xsl:variable name="color-hex" as="xs:string">
      <xsl:choose>
        <xsl:when test="matches($color-text,'^\s*aqua\s*$')">#00FFFF</xsl:when>
        <xsl:when test="matches($color-text,'^\s*black\s*$')">#000000</xsl:when>
        <xsl:when test="matches($color-text,'^\s*blue\s*$')">#0000FF</xsl:when>
        <xsl:when test="matches($color-text,'^\s*fuchsia\s*$')">#FF00FF</xsl:when>
        <xsl:when test="matches($color-text,'^\s*gray\s*$')">#808080</xsl:when>
        <xsl:when test="matches($color-text,'^\s*green\s*$')">#008000</xsl:when>
        <xsl:when test="matches($color-text,'^\s*lime\s*$')">#00FF00</xsl:when>
        <xsl:when test="matches($color-text,'^\s*maroon\s*$')">#800000</xsl:when>
        <xsl:when test="matches($color-text,'^\s*navy\s*$')">#000080</xsl:when>
        <xsl:when test="matches($color-text,'^\s*olive\s*$')">#808000</xsl:when>
        <xsl:when test="matches($color-text,'^\s*purple\s*$')">#800080</xsl:when>
        <xsl:when test="matches($color-text,'^\s*red\s*$')">#FF0000</xsl:when>
        <xsl:when test="matches($color-text,'^\s*silver\s*$')">#C0C0C0</xsl:when>
        <xsl:when test="matches($color-text,'^\s*teal\s*$')">#008080</xsl:when>
        <xsl:when test="matches($color-text,'^\s*white\s*$')">#FFFFFF</xsl:when>
        <xsl:when test="matches($color-text,'^\s*yellow\s*$')">#FFFF00</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$color-text"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:sequence select="$color-hex"/>
  </xsl:function>
  
  </xsl:stylesheet>