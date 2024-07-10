<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="sc xs isosts" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>
  
 
 <xsl:template match="(front | adoption-front)/*[ends-with(name(), '-meta')][not(content-language)]" mode="add_content-language">
   <xsl:copy>
   <xsl:variable name="before-content-language" as="element(*)*" select="title-wrap | proj-id | release-version | std-ident | std-org | std-org-group"/>
    <xsl:apply-templates select="@*, $before-content-language" mode="#current"/>
     <content-language>
        <xsl:value-of select="isosts:doc-lang(../..)"/>
     </content-language>
    <xsl:apply-templates select="node() except $before-content-language" mode="#current"/>
    </xsl:copy>
 </xsl:template>
 
</xsl:stylesheet>
