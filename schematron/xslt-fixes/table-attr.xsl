<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="sc xs isosts" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>
 
 <xsl:template match="@border[not(. castable as xs:nonNegativeInteger)]" mode="change_border_value">
   <xsl:attribute name="{name()}" 
     select=" if(. castable as xs:decimal and not(matches(., '^-')))
              then round(.)
              else '0'"/>
 </xsl:template>
  
  <xsl:template match="@colspan[not(. castable as xs:positiveInteger)]" mode="change_colspan_value">
   <xsl:attribute name="{name()}"
     select=" if(. castable as xs:decimal and not(matches(., '^-')))
              then round(.)
              else '1'"/>
 </xsl:template>
 
</xsl:stylesheet>
