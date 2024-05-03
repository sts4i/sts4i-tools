<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="sc xs isosts" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>
  
 
 
  <xsl:template match="disp-formula[mml:math][graphic]" mode="formula-alternatives">
     <xsl:copy>
        <xsl:apply-templates select="@* , node() except(mml:math | graphic)" mode="#current"/>
      <alternatives>
          <xsl:apply-templates select="(mml:math | graphic)" mode="#current"/>
      </alternatives>
       </xsl:copy>
   </xsl:template>
  
 

  <xsl:template match="table-wrap[table][graphic]" mode="table-alternatives">
    <xsl:copy>
        <xsl:apply-templates select="@* , node() except(table | graphic)" mode="#current"/>
      <alternatives>
          <xsl:apply-templates select="(table | graphic)" mode="#current"/>
      </alternatives>
       </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
