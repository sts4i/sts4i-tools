<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="sc xs isosts" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>
  
 
 <xsl:template match="doc-ref" mode="fill_doc-ref">
   <xsl:copy copy-namespaces="no">
     <xsl:value-of select="../std-ref"/>
   </xsl:copy>
 </xsl:template>
  
  
  
 <xsl:template match="release-date" mode="fill_release-date">
   <xsl:copy copy-namespaces="no">
     <xsl:value-of select="../pub-date"/>
   </xsl:copy>
 </xsl:template>
   
 
 
</xsl:stylesheet>
