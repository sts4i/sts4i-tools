<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:sc="http://transpect.io/schematron-config"
  exclude-result-prefixes="sc xs isosts" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>
  
  <xsl:template match="*[namespace-uri() = 'http://www.w3.org/1998/Math/MathML']
                        [not(starts-with(name(), 'mml:'))]" 
                mode="prefix">
    <xsl:element name="mml:{local-name()}">
      <xsl:apply-templates select="@*, node()" mode="#current"/>
    </xsl:element>
  </xsl:template>
  
  <!-- mroot without index to msqrt -->
  <xsl:template match="mml:mroot[count(*)=1][not(text()[normalize-space()])]" mode="mroot-to-msqrt">
    <mml:msqrt>
      <xsl:apply-templates select="@* | node()" mode="#current"/>
    </mml:msqrt>
  </xsl:template>

</xsl:stylesheet>