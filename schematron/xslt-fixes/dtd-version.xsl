<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  exclude-result-prefixes="sc xs" version="2.0">

  <xsl:import href="identity.xsl"/>

  <xsl:param name="target-niso-version" as="xs:string" select="'1.0'"/>

  <xsl:template match="/*[empty(@dtd-version)]" mode="dtd-version">
    <xsl:copy>
      <xsl:attribute name="dtd-version" select="$target-niso-version"/>
      <xsl:copy-of select="@*, node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="/*/@dtd-version[not(. = $target-niso-version)]" mode="dtd-version">
    <xsl:attribute name="dtd-version" select="$target-niso-version"/>
  </xsl:template>

</xsl:stylesheet>