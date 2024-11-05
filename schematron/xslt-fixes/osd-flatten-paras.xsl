<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config" xmlns:isosts="http://www.iso.org/ns/isosts"
  exclude-result-prefixes="sc xs isosts" version="3.0">

  <xsl:import href="identity.xsl"/>

  
  <xsl:function name="isosts:para-interruptor" as="xs:boolean">
    <xsl:param name="context" as="node()"/>
    <xsl:sequence select="exists($context/(self::array | self::boxed-text | self::def-list | self::disp-formula | self::disp-formula-group | 
      self::disp-quote | self::fig | self::fig-group | self::list | self::non-normative-example | self::non-normative-note | self::supplementary-material | 
      self::table-wrap | self::table-wrap-group))"/>    
  </xsl:function>


  <xsl:template match="(th|td)[some $n in node() satisfies isosts:para-interruptor($n)]
    [text() ! normalize-space(.) != '']" 
    mode="split-paras">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
    <xsl:for-each-group select="node()" group-adjacent="isosts:para-interruptor(.)">
      <xsl:choose>
        <xsl:when test="current-grouping-key()">
          <xsl:copy-of select="current-group()"/>
        </xsl:when>
        <xsl:otherwise>
          <p>
            <xsl:copy-of select="current-group()"/>
          </p>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="p[some $n in node() satisfies isosts:para-interruptor($n)]" 
    mode="split-paras">
    <xsl:variable name="attr" select="@* except @id" as="attribute(*)*"/>
    <xsl:variable name="id" select="@id" as="attribute(id)?"/>
    <xsl:for-each-group select="node()[normalize-space(.) != '']" group-adjacent="isosts:para-interruptor(.)">
      <xsl:choose>
        <xsl:when test="current-grouping-key()">
          <xsl:copy-of select="current-group()"/>
        </xsl:when>
        <xsl:otherwise>
          <p>
            <xsl:if test="exists($id)">
              <xsl:choose>
                <xsl:when test="position() = 1">
                  <xsl:attribute name="id" select="$id"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="id" select="generate-id()"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:for-each select="$attr">
              <xsl:attribute name="{name()}" select="."/>
            </xsl:for-each>
            <xsl:copy-of select="current-group()"/>
          </p>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>


</xsl:stylesheet>
