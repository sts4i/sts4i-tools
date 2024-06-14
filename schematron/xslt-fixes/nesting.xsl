<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  exclude-result-prefixes="sc xs isosts" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>

  <xsl:template match="@std-meta-type" mode="correct-std-meta-type">
    <xsl:attribute name="{name()}" select="isosts:std-meta-type(..)"/>
  </xsl:template>

  <xsl:function name="isosts:meta-sortkey" as="xs:integer">
    <xsl:param name="meta" as="element(*)"/>
    <xsl:choose>
      <xsl:when test="isosts:std-meta-type($meta) = 'international'">
        <xsl:sequence select="1"/>
      </xsl:when>
      <xsl:when test="isosts:std-meta-type($meta) = 'regional'">
        <xsl:sequence select="2"/>
      </xsl:when>
      <xsl:when test="isosts:std-meta-type($meta) = 'national'">
        <xsl:sequence select="3"/>
      </xsl:when>
    </xsl:choose>
  </xsl:function>

  <xsl:template match="standard" mode="create-adoptions">
    <xsl:variable name="sorted-metas" as="element(sorted-metas)">
      <sorted-metas>
        <xsl:for-each-group select="front/*[ends-with(name(), '-meta')]" group-by="isosts:meta-sortkey(.)">
          <xsl:sort select="current-grouping-key()" order="descending"/>
          <metas sortkey="{current-grouping-key()}">
            <xsl:sequence select="current-group()"/>
          </metas>
        </xsl:for-each-group>
      </sorted-metas>  
    </xsl:variable>
    <xsl:apply-templates select="$sorted-metas/metas[1]" mode="#current">
      <xsl:with-param name="entire-standard" as="element(standard)" tunnel="yes" select="."/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="metas" mode="create-adoptions">
    <xsl:param name="entire-standard" as="element(standard)" tunnel="yes"/>
    <xsl:variable name="std-meta-type" as="xs:string" select="isosts:std-meta-type(*[1])"/>
    <xsl:choose>
      <xsl:when test="following-sibling::metas">
        <adoption>
          <xsl:if test="empty(preceding-sibling::metas)">
            <xsl:call-template name="top-level-atts-and-ns"/>
          </xsl:if>
          <adoption-front>
            <xsl:apply-templates select="*" mode="#current"/>
            <xsl:apply-templates select="$entire-standard/front/*[not(ends-with(name(), '-meta'))]
                                                                 [isosts:front-matter-origin-type(.) = $std-meta-type]" 
                                 mode="#current"/>
          </adoption-front>
          <xsl:apply-templates select="following-sibling::metas[1]" mode="#current"/>
        </adoption>
      </xsl:when>
      <xsl:otherwise>
        <standard>
          <xsl:if test="empty(preceding-sibling::metas)">
            <xsl:call-template name="top-level-atts-and-ns"/>
          </xsl:if>
          <front>
            <xsl:apply-templates select="*" mode="#current"/>
            <xsl:apply-templates select="$entire-standard/front/*[not(ends-with(name(), '-meta'))]
                                                                 [isosts:front-matter-origin-type(.) = $std-meta-type]" 
                                 mode="#current"/>
          </front>
          <xsl:apply-templates select="$entire-standard/(body | back)" mode="#current"/>
        </standard>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="top-level-atts-and-ns">
    <xsl:param name="entire-standard" as="element(standard)" tunnel="yes"/>
    <xsl:call-template name="top-level-ns-decls"/>
    <xsl:apply-templates select="$entire-standard/@*" mode="#current"/>
  </xsl:template>
  
  <xsl:function name="isosts:front-matter-origin-type" as="xs:string">
    <xsl:param name="elt" as="element(*)"/>
    <xsl:variable name="metas" as="element(*)+" select="$elt/../*[ends-with(name(), '-meta')]"/>
    <xsl:choose>
      <xsl:when test="count($metas) = 1">
        <xsl:sequence select="isosts:std-meta-type($metas)"/>
      </xsl:when>
      <xsl:when test="starts-with($elt/p[1] => normalize-space(), 'ISO (the International Organization for Standardization) is a worldwide federation of national standards bodies')">
        <xsl:sequence select="'international'"/>
      </xsl:when>
      <xsl:when test="matches($elt/title, 'europ', 'i')">
        <xsl:sequence select="'regional'"/>
      </xsl:when>
      <xsl:when test="contains($elt, 'CEN')">
        <xsl:sequence select="'regional'"/>
      </xsl:when>
      <xsl:when test="matches($elt/title, '(einleitung|introduction)', 'i')
                      and
                      exists($elt/preceding-sibling::*[not(ends-with(name(), '-meta'))])">
        <xsl:sequence select="isosts:front-matter-origin-type($elt/preceding-sibling::*[1])"/>
      </xsl:when>
      <xsl:when test="matches($elt/title, '(endorsement|anerkennung)', 'i')
                      and
                      exists($elt/preceding-sibling::*[not(ends-with(name(), '-meta'))])">
        <xsl:sequence select="isosts:front-matter-origin-type($elt/preceding-sibling::*[1])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="'national'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:template match="nat-meta | reg-mata | int-meta" mode="legacy-meta">
    <std-meta>
      <xsl:apply-templates select="@* | node()" mode="#current"/>
    </std-meta>
  </xsl:template>
  
  <xsl:template match="doc-ident" mode="legacy-meta">
    <std-ident>
      <xsl:apply-templates select="@* | node()" mode="#current"/>
    </std-ident>
  </xsl:template>
  
  <xsl:template match="nat-meta/@originator | reg-mata/@originator" mode="legacy-meta"/>
  
  <xsl:template match="doc-ident[sdo]" mode="remove_doc-ident"/>

</xsl:stylesheet>