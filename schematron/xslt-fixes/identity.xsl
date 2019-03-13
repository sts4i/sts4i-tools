<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- If you need to use different version of the DTD, you need to create new XSLT variants that import
    the XSLTs in question and replace the xsl:output instruction. In addition, you might need to provide
  the DTDs and appropriate catalog resolution (see xmlcatalog/catalog.xml). -->
  
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
  
  <xsl:variable name="inline-element-names" as="xs:string+" 
    select="('bold', 'italic', 'named-content', 'styled-content')"/>
  
</xsl:stylesheet>