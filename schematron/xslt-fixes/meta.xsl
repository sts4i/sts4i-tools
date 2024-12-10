<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  exclude-result-prefixes="sc xs isosts" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>
  
  
    <xsl:template match="std-meta[custom-meta-group]
                               [following-sibling::sec[@sec-type='titlepage'][empty(label/node())]]/custom-meta-group"
                mode="meta-note">
    <meta-note content-type="standard.text">
      <xsl:apply-templates select="../following-sibling::sec[@sec-type='titlepage']/node()" mode="#current"/>
    </meta-note>
    <xsl:next-match></xsl:next-match>
  </xsl:template>
  
  <xsl:template match="std-meta[not(custom-meta-group)]
                               [following-sibling::sec[@sec-type='titlepage'][empty(label/node())]]"
                mode="meta-note">
      <xsl:copy copy-namespaces="no">
          <xsl:apply-templates mode="#current"/>
         <meta-note content-type="standard.text">
      <xsl:apply-templates select="following-sibling::sec[@sec-type='titlepage']/node()" mode="#current"/>
    </meta-note>
      </xsl:copy>
  </xsl:template>  

  <xsl:template match="sec[@sec-type='titlepage'][empty(label/node())]
                          [preceding-sibling::std-meta]"
                mode="meta-note"/>
  
  <xsl:template match="sec[@sec-type='titlepage'][empty(label/node())]
                          [preceding-sibling::std-meta]/label"
                mode="meta-note"/>
  

  <xsl:template match="(front | adoption-front)/*[ends-with(name(), '-meta')][empty(std-ref)]
                                                 [std-ident//std-id[@std-id-type = ('dated', 'undated')]]" mode="std-ref-from-std-id">
    <xsl:variable name="up-to" as="element(*)" select="(*[self::std-ident | self::std-org | self::content-language])[last()]"/>
    <xsl:copy>
      <xsl:copy-of select="@*, node()[$up-to >> .], $up-to"/>
      <xsl:apply-templates select="std-ident//std-id[@std-id-type = ('dated', 'undated')]" mode="#current"/>
      <xsl:copy-of select="node()[. >> $up-to]"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="std-id" mode="std-ref-from-std-id">
    <std-ref type="{@std-id-type}">
      <xsl:value-of select="."/>
    </std-ref>
  </xsl:template>
</xsl:stylesheet>