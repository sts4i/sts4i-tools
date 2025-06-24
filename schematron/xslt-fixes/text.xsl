<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="sc xs isosts" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>
  
 
 <xsl:template match="nat-meta/text()[normalize-space(.)]" mode="delete_text_in_nat-meta"/>
   
 <xsl:template match="p[not(child::node())][not(@*[not(name()='srcpath')])][following-sibling::*[not(self::label)] or preceding-sibling::*[not(self::label)]]" mode="delete-empty-p"/>
 
</xsl:stylesheet>
