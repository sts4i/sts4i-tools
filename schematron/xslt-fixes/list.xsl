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

</xsl:stylesheet>