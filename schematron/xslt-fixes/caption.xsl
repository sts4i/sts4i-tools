<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="sc xs isosts" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="http://niso-sts.org/sts4i-tools/schematron/NISOSTS_lib.xsl"/>
  
 
 <xsl:template match="fig
   [preceding-sibling::*[1]/self::p [matches(., isosts:i18n-strings-no-lang('dimension-heading'))]]/caption" 
   mode="add_p_to_caption">
   <xsl:copy>
     <xsl:apply-templates select="@*" mode="#current"/>
       <xsl:attribute name="content-type" select="'units'"/>
       <xsl:apply-templates select="node(), ../preceding-sibling::* [1]" mode="add_p"/>
   </xsl:copy>
 </xsl:template>
  
  <xsl:template match="fig
    [preceding-sibling::*[1]/self::p [matches(., isosts:i18n-strings-no-lang('dimension-heading'))]]/caption" 
    mode="add_dimension_p_to_caption">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:attribute name="content-type" select="'dimension'"/>
      <xsl:apply-templates select="node(), ../preceding-sibling::* [1]" mode="add_p"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="p
     [matches(., isosts:i18n-strings-no-lang('dimension-heading'))]
     [following-sibling::*[1]/self::fig]" 
     mode="add_p_to_caption add_dimension_p_to_caption"/>

  <xsl:template match="@content-type[.=('Units','units')]" mode="units-content-type">
    <xsl:attribute name="{name()}" select="'dimension'"/>
  </xsl:template>
  
  <xsl:template match="fig-group/fig/caption/p[@content-type='dimension']" mode="fig-group-dimension">
    <xsl:param name="display-fig-group-dimension" select="false()" as="xs:boolean"/>
    <xsl:if test="$display-fig-group-dimension">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template> 
  
  <xsl:template match="fig-group/caption" mode="fig-group-dimension">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="#current"/>
      <xsl:apply-templates select="parent::fig-group/fig/caption/p[@content-type='dimension']" mode="#current">
        <xsl:with-param name="display-fig-group-dimension" select="true()" as="xs:boolean"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="fig-group[not(caption)][fig/caption/p[@content-type='dimension']]" mode="fig-group-dimension">
    <xsl:copy>
      <xsl:apply-templates select="@* | label" mode="#current"/>
      <caption>
        <xsl:apply-templates select="fig/caption/p[@content-type='dimension']" mode="#current">
          <xsl:with-param name="display-fig-group-dimension" select="true()" as="xs:boolean"/>
        </xsl:apply-templates>
      </caption>
      <xsl:apply-templates select="node() except label" mode="#current"/>
    </xsl:copy>
  </xsl:template>
 
</xsl:stylesheet>
