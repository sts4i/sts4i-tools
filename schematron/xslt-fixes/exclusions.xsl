<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:isosts="http://www.iso.org/ns/isosts"
  xmlns:sbf="http://transpect.io/schematron-batch-fix"
  xmlns:tbx="urn:iso:std:iso:30042:ed-1"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="sbf isosts xs" version="3.0">

  <xsl:import href="identity.xsl"/>

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

</xsl:stylesheet>