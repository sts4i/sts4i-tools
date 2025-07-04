<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  exclude-result-prefixes="sc xs" version="2.0">

  <xsl:import href="identity.xsl"/>

  <xsl:template match="*[count(label) gt 1][count(distinct-values(label))=1]/label" mode="multiple-labels">
    <xsl:if test="not(preceding-sibling::label)">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
