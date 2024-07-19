<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="sc xs isosts" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>
  
 
 <xsl:template match="table-wrap[matches(caption/title, 'Symbole')]
      [count(table/col) = 2]/descendant::p/disp-formula" 
      mode="disp-formula_to_inline-formula">
    <inline-formula>
     <xsl:apply-templates select="@*, node()" mode="#current"/>
    </inline-formula>
 </xsl:template>
</xsl:stylesheet>
