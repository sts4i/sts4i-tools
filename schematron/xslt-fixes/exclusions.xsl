<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:isosts="http://www.iso.org/ns/isosts"
  xmlns:sbf="http://transpect.io/schematron-batch-fix"
  xmlns:tbx="urn:iso:std:iso:30042:ed-1"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="sbf isosts xs" version="3.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>

  <xsl:mode name="extract-trailing-inclusions"/>

  <xsl:template match="non-normative-note[non-normative-example]
                                         [every $example in non-normative-example satisfies
                                          (isosts:is-tail-example($example))]"
                mode="extract-trailing-inclusions">
    <xsl:copy>
      <xsl:apply-templates select="@*, node() except non-normative-example" mode="#current"/>
    </xsl:copy>
    <xsl:apply-templates select="non-normative-example" mode="#current"/>
  </xsl:template>

  <xsl:function name="isosts:is-tail-example" as="xs:boolean">
    <xsl:param name="example" as="element(non-normative-example)"/>
    <xsl:sequence select="empty(
                            $example/following-sibling::*[not(name() = 'non-normative-example')]
                                                         [normalize-space()]
                          )"/>
  </xsl:function>
  
  <xsl:function name="isosts:is-content-to-exclude" as="xs:boolean">
    <xsl:param name="n" as="node()"/>
    <xsl:param name="context" as="node()*"/>
    <xsl:sequence select="exists($n[self::bold|
                            self::italic|
                            self::underline|
                            self::ext-link|
                            self::std|
                            self::fn|
                            self::def-item|
                            self::xref|
                            self::roman|
                            self::sans-serif|
                            self::monospace])
                            and count(distinct-values($context[empty(self::std-id)]/local-name())) = 1
                            and (if (exists($context[empty(self::std-id)]/@*)) 
                                then (count(distinct-values($context[empty(self::std-id)]/@*/local-name())) = 1
                                  and count(distinct-values($context[empty(self::std-id)]/@*)) = 1)
                                else true())
                            and empty($context/self::text()[normalize-space()])"/>
  </xsl:function>
  
  <xsl:template name="move-single-element-inside-out">
    <xsl:param name="children" as="node()*"/>
    <xsl:param name="container" as="element()"/>
    <xsl:choose>
      <xsl:when test="exists($children/self::*[isosts:is-content-to-exclude(., $children)])">
        <xsl:element name="{$children/self::*[empty(self::std-id)][1]/local-name()}">
          <xsl:call-template name="move-single-element-inside-out">
            <xsl:with-param name="children" select="$children[empty(self::std-id)]/self::*/node()|$children/self::std-id"/>
            <xsl:with-param name="container" select="$container"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{$container/local-name()}">
          <xsl:apply-templates select="$container/@*, $children" mode="#current"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="std[*[isosts:is-content-to-exclude(., ../node())]]|
                       xref[*[isosts:is-content-to-exclude(., ../node())]]|
                       ext-link[*[isosts:is-content-to-exclude(., ../node())]]
                     " mode="extract-trailing-inclusions">
  <!-- only excludes or wrap unwanted elements around std if all content/formats give the same information.
       eg. only wrap bold from inside to the outside if every content is styled bold -->
    <xsl:choose>
      <xsl:when test="parent::*/name()=$element-parent-map(*[1]/name())">
        <xsl:call-template name="move-single-element-inside-out">
          <xsl:with-param name="children" select="node()"/>
          <xsl:with-param name="container" select="."/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>