<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:tr= "http://transpect.io"
  version="2.0" exclude-result-prefixes="xs isosts">
  
  <xsl:param name="fail-on-error" select="'yes'"/>
  
  <xsl:variable name="inline-element-names" select="('bold', 'italic', 'named-content', 'styled-content')" as="xs:string+"/>
  
  <xsl:key name="by-id" match="*[@id]" use="@id"/>
  <xsl:key name="by-rid" match="*[@rid]" use="@rid"/>
  
  <xsl:variable name="i18n-strings" as="document-node(element(isosts:i18n))">
    <xsl:document>
      <isosts:i18n xml:id="i18n">
        <isosts:string name="key-heading">
          <isosts:documentation>The heading of figure keys</isosts:documentation>
          <isosts:translation xml:lang="en">Key</isosts:translation>
          <isosts:translation xml:lang="de">Legende</isosts:translation>
          <isosts:translation xml:lang="fr">Légende</isosts:translation>
          <isosts:translation xml:lang="nl">Legenda</isosts:translation>
        </isosts:string>
        <isosts:string name="annex-name">
          <isosts:translation xml:lang="en">Annex</isosts:translation>
          <isosts:translation xml:lang="de">Anhang</isosts:translation>
          <isosts:translation xml:lang="fr">Annexe</isosts:translation>
          <isosts:translation xml:lang="nl">Aanhang</isosts:translation>
          <isosts:translation xml:lang="ru">Приложение</isosts:translation>
        </isosts:string>
        <isosts:string name="annex-type-informative">
          <isosts:translation xml:lang="en">informative</isosts:translation>
          <isosts:translation xml:lang="de">informativ</isosts:translation>
          <isosts:translation xml:lang="fr">informative</isosts:translation>
          <isosts:translation xml:lang="nl">informatief</isosts:translation>
          <isosts:translation xml:lang="ru">справочное</isosts:translation>
        </isosts:string>
        <isosts:string name="annex-type-normative">
          <isosts:translation xml:lang="en">normative</isosts:translation>
          <isosts:translation xml:lang="de">normativ</isosts:translation>
          <isosts:translation xml:lang="fr">normative</isosts:translation>
          <isosts:translation xml:lang="nl">normatief</isosts:translation>
        </isosts:string>
        <isosts:string name="where-heading">
          <isosts:translation xml:lang="en">where</isosts:translation>
          <isosts:translation xml:lang="de">Dabei ist</isosts:translation>
          <isosts:translation xml:lang="fr">où</isosts:translation>
          <isosts:translation xml:lang="nl">waarin</isosts:translation>
        </isosts:string>
      </isosts:i18n>    
    </xsl:document>
  </xsl:variable>
  
  <xsl:variable name="table_label_regEx" select="'^\s*(Table(au)?|Таблица|Tabel(le)?)[\s\p{Zs}]+'"/>
  
  <xsl:variable name="figur_label_regEx" select="'^\s*(Figure|Bild|Figuur|Рисунок)[\s\p{Zs}]+'"/>
  
  <xsl:key name="i18n" match="isosts:string/isosts:translation" use="string-join((../@name, @xml:lang), '__')"/>
  
  <xsl:function name="isosts:lang" as="xs:string?">
    <xsl:param name="context" as="element(*)"/>
    <xsl:variable name="content-language" as="element(content-language)?" 
      select="$context/ancestor-or-self::*[name() = ('standard', 'adoption')]
                                          [(front | adoption-front)/*[ends-with(name(), '-meta')]/content-language]
                                          [1]
                                           /(front | adoption-front)/*[ends-with(name(), '-meta')]/content-language"/>
    <xsl:variable name="xml-lang" select="$context/ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
    <xsl:sequence select="(string($xml-lang)[normalize-space()], string($content-language)[normalize-space()])[1]"/>
  </xsl:function>
  
  <xsl:function name="isosts:i18n-strings" as="xs:string*">
    <xsl:param name="i18n-string-name" as="xs:string"/>
    <xsl:param name="context" as="element(*)"/>
    <xsl:sequence select="key('i18n', string-join(($i18n-string-name, isosts:lang($context)), '__'), $i18n-strings)"/>
  </xsl:function>
  
  <xsl:function name="isosts:std-meta-type" as="xs:string">
    <xsl:param name="meta-elt" as="element(*)"/>
    <xsl:variable name="originator" select="$meta-elt/std-ident/originator/normalize-space()" as="xs:string?"/>
    <xsl:choose>
      <xsl:when test="$meta-elt/self::nat-meta">
        <xsl:sequence select="'national'"/>
      </xsl:when>
      <xsl:when test="$meta-elt/self::reg-meta">
        <xsl:sequence select="'regional'"/>
      </xsl:when>
      <xsl:when test="$meta-elt/self::iso-meta">
        <xsl:sequence select="'international'"/>
      </xsl:when>
      <xsl:when test="matches($originator, '^C?EN')">
        <xsl:sequence select="'regional'"/>
      </xsl:when>
      <xsl:when test="matches($originator, '(^ISO|IEC)')">
        <xsl:sequence select="'international'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="'national'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="isosts:index-of" as="xs:integer*">
    <xsl:param name="all" as="node()*"/>
    <xsl:param name="selected" as="node()*"/>
    <xsl:sequence select="index-of($all/generate-id(), $selected/generate-id())"/>
  </xsl:function>

  <xsl:variable name="dash-in-space-regex" as="xs:string" select="'[\p{Zs}\s]+\p{Pd}[\p{Zs}\s]+'"/>
  
  
  <xsl:function name="isosts:is-legend-table" as="xs:boolean">
    <xsl:param name="tw" as="element(table-wrap)"/>
        <xsl:sequence select="exists($tw/caption/title[lower-case(isosts:i18n-strings('key-heading', .)) = lower-case(normalize-space(.))])"/>
  </xsl:function>
  
  <xsl:function name="isosts:numbering-type" as="xs:string">
    <xsl:param name="marker" as="xs:string*"/>
        <xsl:choose>
          <xsl:when test="matches($marker, '^[A-Z]$')">
            <xsl:sequence select="'upper-alpha'"></xsl:sequence>
          </xsl:when>
          <xsl:when test="matches($marker, '^[a-z]$')">
            <xsl:sequence select="'lower-alpha'"></xsl:sequence>
          </xsl:when>
          <!-- <xsl:when test="matches($marker,'')">
            <xsl:sequence select="'upper-roman'"></xsl:sequence>
          </xsl:when>
          <xsl:when test="matches($marker, '')">
            <xsl:sequence select="'lower-roman'"></xsl:sequence>
          </xsl:when> -->
          <xsl:when test="matches($marker, '^\d+$')">
            <xsl:sequence select="'arabic'"></xsl:sequence>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="'lower-alpha'"></xsl:sequence>
          </xsl:otherwise>
        </xsl:choose>
  </xsl:function>
  
 
</xsl:stylesheet>