<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  exclude-result-prefixes="sc xs" version="2.0">

  <xsl:import href="identity.xsl"/>

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

</xsl:stylesheet>