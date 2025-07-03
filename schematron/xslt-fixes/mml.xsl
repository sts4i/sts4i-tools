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
  
  <xsl:variable name="wrapper-element-names" select="('msup', 
    'msub', 
    'msubsup', 
    'mfrac', 
    'mroot', 
    'mmultiscripts', 
    'mover', 
    'munder', 
    'munderover')" as="xs:string+"/>
  
  <!-- remove empty mtext or mtable -->
  <xsl:template match="*[local-name()=('mtext','mtable')]
                        [not(* or text()[normalize-space()])]
                        [not(parent::*/local-name() = $wrapper-element-names)] | 
                       *:mtable[not(*:mtr)][not(parent::*/local-name() = $wrapper-element-names) or count(*)=1]" mode="empty-math-elements">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*:mtable[@*]/*:mtable" mode="empty-math-elements">
    <xsl:copy>
      <xsl:apply-templates select="parent::*:mtable/@* | @* | node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>