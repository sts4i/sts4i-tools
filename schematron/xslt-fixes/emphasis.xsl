<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="sc xs isosts" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>
  
<xsl:variable name="emphasis" select="'bold|italic|monospace|underline|sans-serif'"/>
 <xsl:template match="xref[count(*) = 1][matches(name(*), $emphasis)]
      [not(text()[normalize-space(.)])]"
   mode="emphasize_xref">
   <xsl:element name="{name(*)}">
     <xsl:apply-templates select="*/@*" mode="#current"/>
     <xsl:copy copy-namespaces="no">
       <xsl:apply-templates select="@*, */node()" mode="#current"/>
     </xsl:copy>
   </xsl:element>
 </xsl:template>
   
 
 
</xsl:stylesheet>
