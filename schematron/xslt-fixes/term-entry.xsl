<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  xmlns:tbx="urn:iso:std:iso:30042:ed-1"
  exclude-result-prefixes="sc xs" version="2.0">

  <xsl:import href="identity.xsl"/>

  <xsl:variable name="term-sec-parent-names" select="('abstract','ack','app','back','bio','body','boxed-text','notes','sec','term-sec')"/>

  <xsl:template match="*[tbx:termEntry[not(parent::term-sec)]][parent::*/name()=$term-sec-parent-names][matches(name(),'sec')]" 
                mode="term-entry-in-sec">
    <term-sec>
      <xsl:apply-templates select="@*, node()" mode="#current"/>
    </term-sec>
  </xsl:template>

</xsl:stylesheet>
