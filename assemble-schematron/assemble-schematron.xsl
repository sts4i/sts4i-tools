<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xslout="bogo"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sbf="http://transpect.io/schematron-batch-fix"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  xmlns:tr="http://transpect.io"
  exclude-result-prefixes="tr xs"
  version="3.0">

  <!-- Invocation: saxon -s:importing_front-end_schema.sch -xsl:this.xsl
    The front end Schematron schema may contain sbf:alternative-for attributes that point
    to IDs of patterns. In addition, you may specifiy elements
  <sbf:pattern selected-alternative="[some-pattern-id]"/>
  within sch:externds in order to select an alternative pattern (by its id attribute) so 
  that patterns with @sbf:alternative-for that refer to this ID will be suppressed. -->

  <xsl:import href="http://transpect.io/xslt-util/xslt-based-catalog-resolver/xsl/resolve-uri-by-catalog.xsl"/>

  <xsl:template match="node() | @*" mode="resolve-extends filter">
    <xsl:copy>
      <xsl:apply-templates select="@*, node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:namespace-alias stylesheet-prefix="xslout" result-prefix="xsl"/>

  <xsl:template match="*[@sbf:product-version-regex]" mode="resolve-extends" priority="100">
    <xsl:variable name="use-it" as="xs:boolean" select="matches(system-property('xsl:product-version'), @sbf:product-version-regex)"/>
    <xsl:if test="$use-it">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="sch:report | sch:assert" mode="resolve-extends"
    xmlns="http://purl.oclc.org/dsdl/schematron">
    <xsl:param name="xsl-fixes-for" as="element(sbf:xsl-fix-for)*" tunnel="yes"/>
    <xsl:variable name="for-this" as="xs:boolean" select="($xsl-fixes-for ! tokenize(@rid)) = @id"/>
    <xsl:copy>
      <xsl:apply-templates select="@* | node() except sbf:xsl-fix[$for-this]" mode="#current"/>
      <xsl:if test="$for-this">
        <xsl:for-each select="$xsl-fixes-for[tokenize(@rid) = current()/@id]">
          <sbf:xsl-fix>
            <xsl:attribute name="xml:base" select="base-uri(.)"/>
            <xsl:copy-of select="@* except @rid"/>
          </sbf:xsl-fix>  
        </xsl:for-each>
      </xsl:if>
      <span class="srcpath"><xslout:value-of select="@srcpath"/></span>
<!--      <span class="attributes"><xslout:value-of select="string-join(@* ! string-join((name(.), .), '='), ' ')"/></span>
      <span class="name"><xslout:value-of select="name()"/></span>
      <span class="serialize"><xslout:copy-of select="."/></span>-->
      <span class="rule-base-uri"><xsl:value-of select="base-uri()"/></span>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match=" sch:report[not(@id)] | sch:assert[not(@id)]" mode="resolve-extends filter">
    <xsl:message terminate="yes">This element needs an ID: <xsl:copy-of select="."/></xsl:message>
  </xsl:template>
  
  <xsl:template match="/" mode="#default">
    <xsl:variable name="resolve-extends" as="document-node(element(sch:schema))">
      <xsl:document>
        <xsl:apply-templates mode="resolve-extends">
          <xsl:with-param name="selected-alternatives"></xsl:with-param>
        </xsl:apply-templates>
      </xsl:document>
    </xsl:variable>
    <xsl:apply-templates select="$resolve-extends" mode="filter"/>
  </xsl:template>
  
  <xsl:template match="sbf:extends" mode="resolve-extends">
    <xsl:param name="lets" as="element(sch:let)*" tunnel="yes"/>
    <xsl:param name="alternatives-for" as="attribute(sbf:alternative-for)*" select="()" tunnel="yes"/>
    <xsl:param name="xsl-fixes-for" as="element(sbf:xsl-fix-for)*" select="()" tunnel="yes"/>
    <xsl:param name="selected-alternatives" as="attribute(selected-alternative)*" select="()" tunnel="yes"/>
    <xsl:param name="dependencies" as="element(sbf:dependency)*" tunnel="yes"/>
    <xsl:apply-templates select="doc(@href)/sch:schema/node()" mode="#current">
      <xsl:with-param name="lets" select="($lets, ..//sch:let[not(ancestor::sch:pattern)])" tunnel="yes"/>
      <xsl:with-param name="alternatives-for" tunnel="yes" select="($alternatives-for, //@sbf:alternative-for)"/>
      <xsl:with-param name="xsl-fixes-for" tunnel="yes" select="($xsl-fixes-for, sbf:xsl-fix-for)"/>
      <xsl:with-param name="selected-alternatives" as="attribute(selected-alternative)*" tunnel="yes"
        select="($selected-alternatives, sbf:pattern/@selected-alternative)"/>
      <xsl:with-param name="dependencies" as="element(sbf:dependency)*" tunnel="yes"
        select="($dependencies, sbf:dependency)"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="sbf:xsl-fix" mode="resolve-extends">
    <xsl:param name="dependencies" as="element(sbf:dependency)*" tunnel="yes"/>
    <xsl:variable name="for-this" as="element(sbf:dependency)*" 
      select="$dependencies[@fix-for = current()/(ancestor::sch:report | ancestor::sch:assert)/@id]"/>
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:if test="exists($for-this)">
        <xsl:attribute name="depends-on" select="@depends-on, $for-this/@depends-on"/>
      </xsl:if>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- 
  Do include: if current ID is in tunneled $selected-alternatives
              or
              if current ID is in the selected alternatives specified in this customization’s extends
              or
              (
                if current ID is not in tunneled $alternatives-for
                and 
                current element has no alternative-for attribute
              )
  
  Do not include: if current ID is in tunneled $alternatives-for 
  
  -->
  
  
  <xsl:template match="sch:pattern[@id]" mode="resolve-extends" priority="2">
    <xsl:param name="alternatives-for" as="attribute(sbf:alternative-for)*" tunnel="yes"/>
    <xsl:param name="selected-alternatives" as="attribute(selected-alternative)*" select="()" tunnel="yes"/>
    <xsl:if test="@id = ('NISO_disp-formula_alt-graphic', 'disp-formula_alt-graphic')">
    <!--<xsl:message select="'aaaaaa ', @id = $alternatives-for/../@id, string-join($alternatives-for, ' '), '::', string(@id), '   ::::   ', string-join($selected-alternatives, ' ')"></xsl:message>-->  
    </xsl:if>
    <xsl:if test="(
                    ($selected-alternatives = @id)
                    or 
                    (ancestor::sch:schema/sbf:extends/sbf:pattern/@selected-alternative = @id)
                    or
                    (
                      not($alternatives-for[. = current()/@id]/../@id = $selected-alternatives)
                    )
                  )
                  and (if (@id = $alternatives-for/../@id)
                       then not(@id = ($selected-alternatives, ancestor::sch:schema/sbf:extends/sbf:pattern/@selected-alternative))
                       else true()
                      )
                  and (if (@sbf:alternative-for)
                       then @id = ($selected-alternatives, ancestor::sch:schema/sbf:extends/sbf:pattern/@selected-alternative)
                       else true()
                      )
                  (:and
                  not($alternatives-for = @id):)">
<!--<xsl:message select="'AAAAAAAAAAAA ', string(@id), ' :: ',string-join($selected-alternatives, ' ')"></xsl:message>-->
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="sch:schema[empty(sbf:extends)]/node()[1]" mode="resolve-extends">
    <xsl:param name="lets" as="element(sch:let)*" tunnel="yes"/>
    <xsl:for-each-group select="($lets, ..//sch:let[empty(ancestor::sch:pattern)])" group-by="@name">
      <xsl:sequence select="."/>
    </xsl:for-each-group>
  </xsl:template>
  
  
  <xsl:template match="sch:let[empty(ancestor::sch:pattern)]" mode="resolve-extends"/>

  <xsl:template match="sch:pattern[@id]" mode="resolve-extends_">
    <xsl:param name="alternatives-for" as="attribute(sbf:alternative-for)*" tunnel="yes"/>
    <xsl:param name="selected-alternatives" as="attribute(selected-alternative)*" select="()" tunnel="yes"/>
    <xsl:if test="not($alternatives-for = @id)">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="sch:pattern[@sbf:alternative-for]" mode="resolve-extends_">
    <xsl:param name="selected-alternatives" as="attribute(selected-alternative)*" select="()" tunnel="yes"/>
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
  
  <xsl:template match="*[local-name() = ('import', 'include')]
                        [namespace-uri() = 'http://www.w3.org/1999/XSL/Transform']
                        [empty(@use-when)]" mode="resolve-extends">
    <xsl:comment select="string-join((name(), @href, '&#xa;'), ' ')"/>
    <xsl:apply-templates select="doc(@href)/*/node()" mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*[local-name() = ('import', 'include')]
                        [namespace-uri() = 'http://www.w3.org/1999/XSL/Transform']
                        [@use-when]" mode="resolve-extends"/>
  
</xsl:stylesheet>