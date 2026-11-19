<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  xmlns:isosts="http://www.iso.org/ns/isosts"
  exclude-result-prefixes="sc xs" version="2.0">

  <xsl:import href="identity.xsl"/>

  <xsl:template match="list[@list-type = 'dash']/@list-type" mode="bullet">
    <xsl:attribute name="{name()}" select="'bullet'"/>
    <xsl:attribute name="style-detail" select="'dash'"/>
  </xsl:template>
  
  <xsl:template match="*[self::list or self::def-list or self::non-normative-note or self::non-normative-example or self::disp-quote or self::disp-formula]
                        [not(parent::p)]
                        [preceding-sibling::*[not(self::list or self::def-list or self::non-normative-note or self::non-normative-example or self::disp-quote or self::disp-formula)][1][self::p]]" 
                mode="nest-lists">
    <xsl:param name="display" select="false()"/>
    
    <xsl:if test="$display">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="p[following-sibling::*[1]
                                             [self::list or self::def-list or self::non-normative-note or self::non-normative-example or self::disp-quote or self::disp-formula]]" 
                mode="nest-lists">
    <xsl:variable name="first-non-list" select="following-sibling::*[not(self::list or self::def-list or self::non-normative-note or self::non-normative-example or self::disp-quote or self::disp-formula)][1]"/>
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="#current"/>
      <xsl:apply-templates select="following-sibling::node()[. &lt;&lt; $first-non-list or empty($first-non-list)]" mode="#current">
        <xsl:with-param name="display" select="true()"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="list-item/p/@specific-use[matches(.,'^Listen(nummer|fortsetzung)')]" mode="remove-list-specific-use"/>
  
  <xsl:variable name="unordered-types" select="('bullet','dash','symbol')" as="xs:string*"/>
  <xsl:variable name="ordered-types" select="('alpha-lower','alpha-upper','lower-alpha','upper-alpha','roman-lower','lower-roman','upper-roman',
                                              'roman-upper','numeric','arabic','order')" 
                as="xs:string*"/>
  
  <xsl:function name="isosts:get-normalized-unordered-list-type" as="xs:string">
    <xsl:param name="list" as="element(list)"/>
    <xsl:sequence select="if ((count($list/ancestor::list) mod 2) = 0) then 'dash' else 'bullet'"/>
  </xsl:function>
  
  <xsl:function name="isosts:get-normalized-ordered-list-type" as="xs:string">
    <xsl:param name="list" as="element(list)"/>
    <xsl:variable name="ancestor-count" select="count($list/ancestor::list)" as="xs:integer"/>
    <xsl:choose>
      <xsl:when test="($ancestor-count mod 3) = 1">
        <xsl:sequence select="'arabic'"/>
      </xsl:when>
      <xsl:when test="($ancestor-count mod 3) = 2">
        <xsl:sequence select="'roman-lower'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="'alpha-lower'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="isosts:get-first-level-list-type" as="xs:string">
    <xsl:param name="list" as="element(list)"/>
    <xsl:variable name="first-level" select="$list/ancestor-or-self::list[not(ancestor::list)]"/>
    <xsl:sequence select="($first-level/@list-type,($first-level/descendant::list/@list-type)[1],'dash')[1]"/>
  </xsl:function>
  
  <xsl:template match="list[isosts:get-first-level-list-type(.)=($unordered-types,'simple')]
                           [@list-type ne isosts:get-normalized-unordered-list-type(.)]/@list-type" mode="normalize-lists">
    <xsl:attribute name="list-type" select="isosts:get-normalized-unordered-list-type(parent::list)"/>
  </xsl:template>
  
  <xsl:template match="list[isosts:get-first-level-list-type(.)=$ordered-types]
                           [@list-type ne isosts:get-normalized-ordered-list-type(.)]/@list-type" mode="normalize-lists">
    <xsl:attribute name="list-type" select="isosts:get-normalized-ordered-list-type(parent::list)"/>
  </xsl:template>
  
  <xsl:template match="list[not(@list-type)]" mode="normalize-lists">
    <xsl:copy>
      <xsl:attribute name="list-type" select="if (isosts:get-first-level-list-type(.)=$ordered-types) 
                                              then isosts:get-normalized-ordered-list-type(.) 
                                              else isosts:get-normalized-unordered-list-type(.)"/>
      <xsl:apply-templates select="@* | node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>