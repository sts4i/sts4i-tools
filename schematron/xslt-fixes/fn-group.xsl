<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs" version="2.0">

  <xsl:import href="identity.xsl"/>

  <xsl:template match="fn-group" mode="ungroup-fn"/>

  <xsl:template match="xref[@ref-type = 'fn'][. is (key('by-rid', @rid))[1]]" mode="ungroup-fn"> 
    <xsl:apply-templates select="key('by-id', @rid)" mode="#current"/>
  </xsl:template>
  
  <xsl:template match="table-wrap-foot[every $c in * satisfies $c/self::fn-group]" mode="ungroup-fn"/>
  </xsl:stylesheet>