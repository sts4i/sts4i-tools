<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="2.0" exclude-result-prefixes="xs isosts">
  
  <xsl:variable name="inline-element-names" select="('bold', 'italic', 'named-content', 'styled-content')" as="xs:string+"/>
  
  <xsl:variable name="i18n-strings" as="document-node(element(isosts:i18n))">
    <xsl:document>
      <isosts:i18n xml:id="i18n">
        <isosts:string name="key-heading">
          <isosts:documentation>The heading of figure keys</isosts:documentation>
          <isosts:translation xml:lang="en">Key</isosts:translation>
          <isosts:translation xml:lang="de">Legende</isosts:translation>
          <isosts:translation xml:lang="fr">Légende</isosts:translation>
        </isosts:string>
        <isosts:string name="annex-name">
          <isosts:translation xml:lang="en">Annex</isosts:translation>
          <isosts:translation xml:lang="de">Anhang</isosts:translation>
          <isosts:translation xml:lang="fr">Annexe</isosts:translation>
        </isosts:string>
        <isosts:string name="annex-type-informative">
          <isosts:translation xml:lang="en">informative</isosts:translation>
          <isosts:translation xml:lang="de">informativ</isosts:translation>
          <isosts:translation xml:lang="fr">informative</isosts:translation>
        </isosts:string>
        <isosts:string name="annex-type-normative">
          <isosts:translation xml:lang="en">normative</isosts:translation>
          <isosts:translation xml:lang="de">normativ</isosts:translation>
          <isosts:translation xml:lang="fr">normative</isosts:translation>
        </isosts:string>
      </isosts:i18n>    
    </xsl:document>
  </xsl:variable>
  
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

</xsl:stylesheet>