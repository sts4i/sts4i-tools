<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  exclude-result-prefixes="sc xs" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>

  <xsl:template match="fig[caption][table-wrap[@content-type = 'fig-index'][caption/title]]/caption" mode="legends">
    <xsl:next-match/>
    <xsl:apply-templates select="../table-wrap[@content-type = 'fig-index'][caption/title]" mode="create-legends"/>
  </xsl:template>
  
  <xsl:template match="fig[caption]/table-wrap[@content-type = 'fig-index'][caption/title]" mode="legends"/>
  
  <xsl:template match="fig[caption][table-wrap[@content-type = 'fig-index'][caption/title]]/fn-group" mode="legends"/>
  
  <xsl:template match="fig[caption]/table-wrap[@content-type = 'fig-index'][caption/title]" mode="create-legends">
    <legend>
      <xsl:apply-templates select="caption/title" mode="#current"/>
      <xsl:next-match>
        <xsl:with-param name="suppress" as="node()*" tunnel="yes" select="caption"/>
      </xsl:next-match>
      <xsl:apply-templates select="../fn-group" mode="#current"/>
    </legend>
  </xsl:template>
  
  <xsl:template match="fig[caption][table-wrap[@content-type = 'fig-index'][caption/title]]/fn-group" mode="create-legends">
    <def-list list-type="footnotes">
      <xsl:apply-templates select="fn" mode="#current"/>
    </def-list>
  </xsl:template>
  
  <xsl:template match="fn" mode="create-legends">
    <def-item>
      <term>
        <xsl:apply-templates select="label/node()" mode="#current"/>
      </term>
      <def>
        <xsl:apply-templates select="* except label" mode="#current"/>
      </def>
    </def-item>
  </xsl:template>
  
  <xsl:template match="fn/label/sup" mode="create-legends">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*" mode="legends create-legends">
    <xsl:param name="suppress" as="node()*" tunnel="yes"/>
    <xsl:if test="empty(. intersect $suppress)">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="fig[non-normative-note[@content-type = 'explanatory']]
                          /graphic[1]" mode="SN-legends">
    <legend>
      <xsl:apply-templates mode="#current"
        select="../non-normative-note[@content-type = 'explanatory']/(@* except @content-type, node())" />
    </legend>
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="fig[graphic]/non-normative-note[@content-type = 'explanatory']" mode="SN-legends"/>
  
  <xsl:template match="non-normative-note[@content-type = 'explanatory'][empty(title)]/label
                       | non-normative-note[@content-type = 'explanatory'][empty(title)][empty(label)][*[2]/self::def-list]/*[1][self::p]" mode="SN-legends">
    <title>
      <xsl:apply-templates mode="#current"/>
    </title>
  </xsl:template>
  
  <xsl:template mode="table-key" match="table-wrap[table-wrap-foot[fn[1][lower-case(isosts:i18n-strings('key-heading', .))=lower-case(normalize-space(.))]]]/caption">
    <xsl:next-match/>
    <legend>
      <xsl:apply-templates select="../table-wrap-foot/fn[empty(label)][1]" mode="table-key-to-legend"/>
      <def-list>
        <xsl:apply-templates select="../table-wrap-foot/fn[empty(label)][position() gt 1]" mode="table-key-to-legend"/>
      </def-list>
    </legend>
  </xsl:template>
  <xsl:template match="fn[1]" mode="table-key-to-legend">
    <title>
      <xsl:value-of select="normalize-space(.)"/>
    </title>
  </xsl:template>
  
  <xsl:template match="fn/p[1]" mode="table-key-to-legend">
    <xsl:variable name="first-text-node" select="text()[1]"/>
    <def-item>
      <term>
        <xsl:sequence select="node()[$first-text-node >> .]"/>
      </term>
      <def>
        <p>
          <xsl:value-of select="replace($first-text-node, '^\s+', '')"/>
          <xsl:sequence select="node()[. >> $first-text-node]"/>
        </p>
        <xsl:apply-templates select="../*[position() gt 1]" mode="#current"/>
      </def>
    </def-item>
  </xsl:template>
   <xsl:template mode="table-key" match="table-wrap-foot/fn[empty(label)]"/>
  
   <xsl:template match="fn" mode="table-key-to-legend">
     <xsl:apply-templates select="p[1]" mode="#current"/>
  </xsl:template>
  
</xsl:stylesheet>