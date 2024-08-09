<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="sc xs isosts" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>
  
<xsl:template match="@rid
  [key('by-id', .)/self::target[parent::label]]" 
  mode="change_rid">
  <xsl:attribute name="{name()}">
    <xsl:value-of select="key('by-id', .)/../../@id"/>
  </xsl:attribute>
</xsl:template>
  
  <xsl:template match="label
  [key('by-rid', target/@id)]" 
  mode="change_rid">
  <xsl:copy>
    <xsl:apply-templates select="@*, node() except (target[key('by-rid', @id)], target[matches(@id, 'end$')])" mode="#current"/> 
  </xsl:copy>
</xsl:template>
</xsl:stylesheet>
