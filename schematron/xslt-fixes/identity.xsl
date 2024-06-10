<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="3.0">
  
  <!-- If you need to use different version of the DTD, you need to create new XSLT variants that import
    the XSLTs in question and replace the xsl:output instruction. In addition, you might need to provide
  the DTDs and appropriate catalog resolution (see xmlcatalog/catalog.xml). -->
  
  <xsl:output
    doctype-public="-//NISO//DTD NISO STS Interchange Tag Set (NISO STS) DTD with MathML 3.0 v1.2 20221031//EN"
    doctype-system="NISO-STS-interchange-1-mathml3.dtd"/>

  <xsl:key name="by-id" match="*[@id]" use="@id"/>

  <xsl:key name="by-rid" match="*[@rid]" use="@rid"/>
  
  <xsl:key name="by-srcpath" match="*[@srcpath]" use="@srcpath"/>

  <xsl:template match="/*" priority="1" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:call-template name="top-level-ns-decls"/>
      <xsl:apply-templates select="@* | node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="top-level-ns-decls">
    <xsl:namespace name="tbx">urn:iso:std:iso:30042:ed-1</xsl:namespace>
    <xsl:namespace name="mml">http://www.w3.org/1998/Math/MathML</xsl:namespace>
    <xsl:namespace name="xlink">http://www.w3.org/1999/xlink</xsl:namespace>
    <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
    <xsl:namespace name="ali">http://www.niso.org/schemas/ali/1.0/</xsl:namespace>
    <xsl:namespace name="xi">http://www.w3.org/2001/XInclude</xsl:namespace>
  </xsl:template>

  <xsl:template match="node()|@*" mode="#all">
   <xsl:copy copy-namespaces="no">
     <xsl:apply-templates select="@*|node()" mode="#current"/>
   </xsl:copy>
  </xsl:template>
  
  <xsl:variable name="inline-element-names" as="xs:string+" 
    select="('bold', 'italic', 'named-content', 'styled-content')"/>
  
</xsl:stylesheet>