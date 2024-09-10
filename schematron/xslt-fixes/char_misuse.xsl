<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:isosts="http://www.iso.org/ns/isosts" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:sc="http://transpect.io/schematron-config"
      xmlns:mml="http://www.w3.org/1998/Math/MathML"
      exclude-result-prefixes="sc xs isosts" version="2.0">
      
      <xsl:import href="http://niso-sts.org/sts4i-tools/schematron/xslt-fixes/identity.xsl"/>
      <xsl:import href="http://niso-sts.org/sts4i-tools/schematron/NISOSTS_lib.xsl"/>
    
    
      <xsl:template match="text()[matches(.,'&#414;')]" mode="LATINSMALLLETTERNWITHLONGRIGHTLEG"><xsl:value-of select="replace(., '&#414;', '&#951;')"/></xsl:template>
    
      <xsl:template match="text()[matches(.,'&#8413;')]" mode="COMBININGENCLOSINGCIRCLE"><xsl:value-of select="replace(., '&#8413;', '&#9675;')"/></xsl:template>
    
      <xsl:template match="text()[matches(.,'&#8407;')]" mode="COMBININGRIGHTARROWABOVE"><xsl:value-of select="replace(., '&#8407;', '&#8594;')"/></xsl:template>
    
      <xsl:template match="text()[matches(.,'&#8414;')]" mode="COMBININGENCLOSINGSQUARE"><xsl:value-of select="replace(., '&#8414;', '&#9633;')"/></xsl:template>
    
      <xsl:template match="text()[matches(.,'&#8404;')]" mode="COMBININGANTICLOCKWISEARROWABOVE"><xsl:value-of select="replace(., '&#8404;', '&#10554;')"/></xsl:template>
</xsl:stylesheet>