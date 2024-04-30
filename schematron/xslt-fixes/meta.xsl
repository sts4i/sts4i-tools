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
                mode="meta-note-titlepage">
    <meta-note content-type="standard.text">
      <xsl:apply-templates select="../following-sibling::sec[@sec-type='titlepage']/node()" mode="#current"/>
    </meta-note>
    <xsl:next-match></xsl:next-match>
  </xsl:template>
  
  <xsl:template match="std-meta[not(custom-meta-group)]
                               [following-sibling::sec[@sec-type='titlepage'][empty(label/node())]]"
                mode="meta-note-titlepage">
      <xsl:copy copy-namespaces="no">
          <xsl:apply-templates mode="#current"/>
         <meta-note content-type="standard.text">
      <xsl:apply-templates select="following-sibling::sec[@sec-type='titlepage']/node()" mode="#current"/>
    </meta-note>
      </xsl:copy>
  </xsl:template>  

  <xsl:template match="sec[@sec-type='titlepage'][empty(label/node())]
                          [preceding-sibling::std-meta]"
                mode="meta-note-titlepage"/>
  
  <xsl:template match="sec[@sec-type='titlepage'][empty(label/node())]
                          [preceding-sibling::std-meta]/label"
                mode="meta-note-titlepage"/>

</xsl:stylesheet>