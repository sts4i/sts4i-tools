<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xsl:output
    doctype-public="-//NISO//DTD NISO STS Interchange Tag Set (NISO STS) DTD with MathML 3.0 v0.2 20170331//EN"
    doctype-system="NISO-STS-interchange-1-mathml3.dtd"/>

  <xsl:key name="by-id" match="*[@id]" use="@id"/>

  <xsl:key name="by-rid" match="*[@rid]" use="@rid"/>

  <xsl:template match="node()|@*" mode="#all">
   <xsl:copy>
     <xsl:apply-templates select="@*|node()" mode="#current"/>
   </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>