<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  exclude-result-prefixes="sc xs isosts" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="http://niso-sts.org/sts4i-tools/schematron/NISOSTS_lib.xsl"/>

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
  
  <xsl:template match="app[not(annex-type)]
    [@content-type = 'norm-annex']" mode="annex-type">
    <xsl:variable name="expected" select="concat('(', isosts:i18n-strings('annex-type-normative', .), ')')"/>
    <xsl:copy>
      <xsl:apply-templates select="@*, editing-instruction, sec-meta, label" mode="#current"/>
      <annex-type>
        <xsl:value-of select="$expected"/>
      </annex-type>
       <xsl:apply-templates select="node() except (editing-instruction, sec-meta, label)" mode="#current"/>
    </xsl:copy> 
  </xsl:template>
  
  <xsl:template match="app[not(annex-type)]
    [@content-type = 'inform-annex']" mode="annex-type">
    <xsl:variable name="expected" select="concat('(', isosts:i18n-strings('annex-type-informative', .), ')')"/>
    <xsl:copy>
       <xsl:apply-templates select="@*, editing-instruction, sec-meta, label" mode="#current"/>
      <annex-type>
        <xsl:value-of select="$expected"/>
      </annex-type>
       <xsl:apply-templates select="node() except (editing-instruction, sec-meta, label)" mode="#current"/>
    </xsl:copy> 
  </xsl:template>
  
  <xsl:template match="app[not(@content-type = ('inform-annex', 'norm-annex'))]
                          [contains(@content-type, 'inform')]/@content-type" 
                mode="content-type">
    <xsl:attribute name="{name()}" select="'inform-annex'"/>
  </xsl:template>
  
    <xsl:template match="app[not(@content-type = ('inform-annex', 'norm-annex'))]
                          [contains(@content-type, 'norm')]/@content-type" 
                mode="content-type">
    <xsl:attribute name="{name()}" select="'norm-annex'"/>
  </xsl:template>
  
  
  
  <xsl:template match="app[not(@content-type)]
                          [matches(annex-type, isosts:i18n-strings('annex-type-normative', .), 'i')]" 
                mode="content-type">
    <xsl:copy>
       <xsl:attribute name="content-type" select="'norm-annex'"/>
      <xsl:apply-templates select="@*, node()" mode="#current"/>
    </xsl:copy>
   
  </xsl:template>
  
  <xsl:template match="app[not(@content-type)]
                          [matches(annex-type, isosts:i18n-strings('annex-type-informative', .), 'i')]" 
                mode="content-type">
    <xsl:copy>
       <xsl:attribute name="content-type" select="'inform-annex'"/>
      <xsl:apply-templates select="@*, node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  
   <xsl:template match="app/label" mode="label">
     <xsl:copy>
   <xsl:value-of select="replace(., $annex_label_regEx, '')"/>
       </xsl:copy>
  </xsl:template>
  
  

</xsl:stylesheet>