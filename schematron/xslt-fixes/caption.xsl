<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="sc xs isosts" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>
  
 
 <xsl:template match="fig
   [preceding-sibling::*[1]/self::p [matches(., isosts:i18n-strings-no-lang('dimension-heading'))]]/caption" 
   mode="add_p_to_caption">
   <xsl:copy>
     <xsl:apply-templates select="@*, node()" mode="#current"/>
     <p>
       <xsl:attribute name="content-type" select="'units'"/>
       <xsl:apply-templates select="../preceding-sibling::* [1]" mode="add_p"/>
     </p>
   </xsl:copy>
 </xsl:template>
  
  
  <xsl:template match="p
     [matches(., isosts:i18n-strings-no-lang('dimension-heading'))]
     [following-sibling::*[1]/self::fig]" 
   mode="add_p_to_caption"/>

 
   
 
 
</xsl:stylesheet>
