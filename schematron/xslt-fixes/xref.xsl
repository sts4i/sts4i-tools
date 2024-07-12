<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="sc xs isosts" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>
  
 
 <xsl:template match="xref
      [exists(key('by-id', @rid)/self::fn[ancestor::table-wrap-foot])]
      [not(matches(@ref-type, 'table-fn'))]"
   mode="change_ref-type">
   <xsl:copy>
   <xsl:attribute name="ref-type">
     <xsl:value-of select="'table-fn'"/>
   </xsl:attribute>
   <xsl:apply-templates select="@* except @ref-type, node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
   
 <xsl:template match="xref
      [.='']
      [exists(key('by-id', @rid))]
      [exists(key('by-id', @rid)/label)]"
   mode="add_label">
   <xsl:copy>
   <xsl:apply-templates select="@*" mode="#current"/>
     <xsl:value-of select="key('by-id', @rid)/label"/>
    </xsl:copy>
  </xsl:template>

<xsl:template match="xref
  [@ref-type = 'table-fn']
  [not(@rid)]" 
  mode="add_rid">
  <xsl:copy>
    <xsl:attribute name="rid">
      <xsl:value-of select="following::table-wrap-foot/descendant::fn[matches(normalize-space(label), normalize-space(current()))]/@id"/>
    </xsl:attribute>
    <xsl:apply-templates select="@*, node()" mode="#current"/>
  </xsl:copy>
</xsl:template>
</xsl:stylesheet>