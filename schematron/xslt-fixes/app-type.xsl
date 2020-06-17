<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  exclude-result-prefixes="sc xs isosts" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>

  <xsl:template match="annex-type[parent::app/@content-type = 'inform-annex']" mode="annex-type">
    <xsl:variable name="expected" select="concat('(', isosts:i18n-strings('annex-type-informative', .), ')')"/>
    <xsl:copy>
      <xsl:value-of select="$expected"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="annex-type[parent::app/@content-type = 'norm-annex']" mode="annex-type">
    <xsl:variable name="expected" select="concat('(', isosts:i18n-strings('annex-type-normative', .), ')')"/>
    <xsl:copy>
      <xsl:value-of select="$expected"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="app[not(@content-type = ('inform-annex', 'norm-annex'))]
                          [contains(@content-type, 'inform')]/@content-type" 
                mode="content-type">
    <xsl:attribute name="{name()}" select="'inform-annex'"/>
  </xsl:template>
  
  

</xsl:stylesheet>