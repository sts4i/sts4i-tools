<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--  Purpose: Convert ISOSTS XML to XHTML 1.1 standalone document -->
<!--  $LastChangedRevision: 48666 $                                -->
<!--  $LastChangedDate: 2013-10-16 18:19:35 +0200 (Wed, 16 Oct 2013) $                                           -->
<!--                                                               -->
<!-- ============================================================= -->
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xlink="http://www.w3.org/1999/xlink" 
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:tbx="urn:iso:std:iso:30042:ed-1" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:loc="http://www.iso.org/ns/localization"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:functx="http://www.functx.com"
  xmlns="http://www.w3.org/1999/xhtml" 
  exclude-result-prefixes="xlink mml tbx isosts loc xhtml xs">

  <xsl:import href="isosts2html.xsl"/>
  <xsl:output method="xhtml" indent="no" encoding="UTF-8" version="1.0" doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"/>


  <xsl:param name="css">http://www.iso.org/schema/isosts/resources/isosts.css</xsl:param>
  <xsl:param name="img-src">relative</xsl:param>

  <xsl:template match="/" priority="1">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="/standard">
    <xsl:variable name="doc-lang" select="/standard/front/iso-meta/content-language"/>
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>          
          <xsl:value-of select="/standard/front/iso-meta/doc-ref"/>, <xsl:value-of select="/standard/front/iso-meta/title-wrap[@xml:lang=$doc-lang]/full"/>
        </title>
        <link rel="stylesheet" type="text/css" href="{$css}"/>
      </head>
      <body>
        <div class="sts-standard">
          <h1><xsl:value-of select="/standard/front/iso-meta/doc-ref"/></h1>
          <h2 style="font-style: italic"><xsl:value-of select="/standard/front/iso-meta/title-wrap[@xml:lang=$doc-lang]/full"/></h2>
          <xsl:apply-templates/>
          <xsl:call-template name="footnotes"/>
          <xsl:call-template name="copyright">
            <xsl:with-param name="metadata" select="front/iso-meta"/>
          </xsl:call-template>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="assign-src">
    <xsl:if test="@xlink:href">
      <xsl:attribute name="src">
        <xsl:choose>
          <xsl:when test="$img-src='o-drive'">
            <xsl:choose>
              <xsl:when test="self::graphic and processing-instruction(isoimg-id)">
                <xsl:variable name="isoimg-id" select="processing-instruction(isoimg-id)"/>
                <xsl:value-of select="concat('file:///O:/Draw/Png/', substring($isoimg-id, 1, 4), '/', functx:substring-before-last($isoimg-id, '.'), '.PNG')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat($imgPath, $resPrefix, @xlink:href, '.png')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($imgPath, $resPrefix, @xlink:href, '.png')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="$img-src='o-drive'">
        <xsl:attribute name="style">width: 50%; height:50%;</xsl:attribute>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="assign-math-src">
      <xsl:attribute name="src">
        <xsl:choose>
          <xsl:when test="$img-src='o-drive'">            
              <xsl:variable name="proj-id" select="//iso-meta/doc-ident/proj-id"/>
              <xsl:variable name="padded-proj-id" select="concat(substring('000000', 1, 6 - string-length($proj-id)), $proj-id)"/>
              <xsl:variable name="release-version" select="//iso-meta/doc-ident/release-version"/>
              <xsl:variable name="language" select="//iso-meta/content-language[1]"/>
              <xsl:value-of
                select="concat('file:///O:/Draw/Graphics/', 
                substring($padded-proj-id, 1, 3), '/', 
                $padded-proj-id, '/', 
                $release-version, '/',
                $language, '/',
                @id, '.png')"
              />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($imgPath, $resPrefix, @id, '.png')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
  </xsl:template>
  
  <!-- 
    Helper functions 
  -->
  <xsl:function name="functx:escape-for-regex" as="xs:string" 
    xmlns:functx="http://www.functx.com" >
    <xsl:param name="arg" as="xs:string?"/> 
    
    <xsl:sequence select=" 
      replace($arg,
      '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
      "/>
    
  </xsl:function>
  <xsl:function name="functx:substring-before-last" as="xs:string" 
    xmlns:functx="http://www.functx.com" >
    <xsl:param name="arg" as="xs:string?"/> 
    <xsl:param name="delim" as="xs:string"/> 
    
    <xsl:sequence select=" 
      if (matches($arg, functx:escape-for-regex($delim)))
      then replace($arg,
      concat('^(.*)', functx:escape-for-regex($delim),'.*'),
      '$1')
      else ''
      "/>
    
  </xsl:function>
</xsl:stylesheet>
