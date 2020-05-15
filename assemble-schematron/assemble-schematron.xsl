<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sc="http://transpect.io/schematron-config"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  xmlns:tr="http://transpect.io"
  exclude-result-prefixes="tr"
  version="2.0">

  <!-- Invocation: saxon -s:importing_front-end_schema.sch -xsl:this.xsl
    The front end Schematron schema may contain sc:alternative-for attributes that point
    to IDs of patterns. In addition, you may specifiy elements
  <sc:pattern sc:selected-alternative="[some-pattern-id]"/>
  within sch:externds in order to select an alternative pattern (by its id attribute) so 
  that patterns with @sc:alternative-for that refer to this ID will be suppressed. -->

  <xsl:import href="http://transpect.io/xslt-util/xslt-based-catalog-resolver/xsl/resolve-uri-by-catalog.xsl"/>

  <xsl:template match="node() | @*" mode="resolve-extends filter">
    <xsl:copy>
      <xsl:apply-templates select="@*, node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match=" sch:report[not(@id)] | sch:assert[not(@id)]" mode="resolve-extends filter">
    <xsl:message terminate="yes">This element needs an ID: <xsl:copy-of select="."/></xsl:message>
  </xsl:template>
  
  <xsl:template match="/" mode="#default">
    <xsl:variable name="resolve-extends" as="document-node(element(sch:schema))">
      <xsl:document>
        <xsl:apply-templates mode="resolve-extends"/>
      </xsl:document>
    </xsl:variable>
    <xsl:apply-templates select="$resolve-extends" mode="filter"/>
  </xsl:template>
  
  <xsl:template match="sch:extends" mode="resolve-extends">
    <xsl:param name="lets" as="element(sch:let)*" tunnel="yes"/>
    <xsl:param name="alternatives-for" as="attribute(sc:alternative-for)*" select="()" tunnel="yes"/>
    <xsl:param name="selected-alternatives" as="attribute(sc:selected-alternative)*" select="()" tunnel="yes"/>
    <xsl:apply-templates select="doc(@href)/sch:schema/node()" mode="#current">
      <xsl:with-param name="lets" select="($lets, ..//sch:let[not(ancestor::sch:pattern)])" tunnel="yes"/>
      <xsl:with-param name="alternatives-for" tunnel="yes" select="($alternatives-for, //@sc:alternative-for)"/>
      <xsl:with-param name="selected-alternatives" as="attribute(sc:selected-alternative)*" tunnel="yes"
        select="($selected-alternatives, sc:pattern/@sc:selected-alternative)"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="sch:pattern[@id][@sc:alternative-for]" mode="resolve-extends" priority="2">
    <xsl:param name="alternatives-for" as="attribute(sc:alternative-for)*" tunnel="yes"/>
    <xsl:param name="selected-alternatives" as="attribute(sc:selected-alternative)*" select="()" tunnel="yes"/>
    <xsl:if test="not($alternatives-for = @id) and $selected-alternatives = @id">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="sch:schema[empty(sch:extends)]/node()[1]" mode="resolve-extends">
    <xsl:param name="lets" as="element(sch:let)*" tunnel="yes"/>
    <xsl:for-each-group select="($lets, ..//sch:let[empty(ancestor::sch:pattern)])" group-by="@name">
      <xsl:sequence select="."/>
    </xsl:for-each-group>
  </xsl:template>
  
  
  <xsl:template match="sch:let[empty(ancestor::sch:pattern)]" mode="resolve-extends"/>

  <xsl:template match="sch:pattern[@id]" mode="resolve-extends">
    <xsl:param name="alternatives-for" as="attribute(sc:alternative-for)*" tunnel="yes"/>
    <xsl:param name="selected-alternatives" as="attribute(sc:selected-alternative)*" select="()" tunnel="yes"/>
    <xsl:if test="not($alternatives-for = @id)">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="sch:pattern[@sc:alternative-for]" mode="resolve-extends">
    <xsl:param name="selected-alternatives" as="attribute(sc:selected-alternative)*" select="()" tunnel="yes"/>
    <xsl:if test="$selected-alternatives = @id">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="sch:pattern/@id" mode="resolve-extends">
    <xsl:next-match/>
    <xsl:attribute name="xml:base" 
      select="tr:reverse-resolve-uri-by-catalog(
                base-uri(), 
                doc('http://this.transpect.io/xmlcatalog/catalog.xml')
              )"/>
  </xsl:template>
  
</xsl:stylesheet>