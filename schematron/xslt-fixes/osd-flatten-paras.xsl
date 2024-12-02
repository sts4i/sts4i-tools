<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config" xmlns:isosts="http://www.iso.org/ns/isosts"
  exclude-result-prefixes="sc xs isosts" version="3.0">

  <xsl:import href="identity.xsl"/>

  <xsl:include href="../NISOSTS_lib.xsl"/>

  <xsl:template match="(th|td)[some $n in node() satisfies isosts:is-para-interruptor($n)]
                              [text()[normalize-space(.)]]" 
    mode="split-paras">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:for-each-group select="node()" group-adjacent="isosts:is-para-interruptor(.)">
        <xsl:choose>
          <xsl:when test="current-grouping-key()">
            <xsl:apply-templates select="current-group()" mode="#current"/>
          </xsl:when>
          <xsl:otherwise>
            <p>
              <xsl:apply-templates select="current-group()" mode="#current"/>
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="p[some $n in node() satisfies isosts:is-para-interruptor($n)]" 
    mode="split-paras">
    <xsl:variable name="attr" select="@* except @id" as="attribute(*)*"/>
    <xsl:variable name="id" select="@id" as="attribute(id)?"/>
    <xsl:variable name="context" as="element(p)" select="."/>
    <xsl:for-each-group select="node()" group-adjacent="isosts:is-para-interruptor(.)">
      <xsl:choose>
        <xsl:when test="current-grouping-key()">
          <xsl:apply-templates select="current-group()" mode="#current"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy select="$context">
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
            <xsl:apply-templates select="$attr" mode="#current"/>
            <xsl:apply-templates select="current-group()" mode="#current"/>
          </xsl:copy>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

</xsl:stylesheet>
