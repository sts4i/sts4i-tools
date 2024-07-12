<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isosts="http://www.iso.org/ns/isosts"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tr="http://transpect.io" xmlns:tbx="urn:iso:std:iso:30042:ed-1"
  version="3.0" exclude-result-prefixes="xs isosts">

  <xsl:param name="fail-on-error" select="'yes'"/>

  <xsl:variable name="inline-element-names" select="('bold', 'italic', 'named-content', 'styled-content')"
    as="xs:string+"/>

  <xsl:key name="by-id" match="*[@id]" use="@id"/>
  <xsl:key name="by-rid" match="*[@rid]" use="@rid"/>
  
<xsl:variable name="doc-lang" select="isosts:doc-lang(/)"/>

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
          <isosts:translation xml:lang="en">Annex|Appendix</isosts:translation>
          <isosts:translation xml:lang="de">Anhang</isosts:translation>
          <isosts:translation xml:lang="fr">Annexe</isosts:translation>
          <isosts:translation xml:lang="nl">Aanhang</isosts:translation>
          <isosts:translation xml:lang="ru">Приложение</isosts:translation>
        </isosts:string>
        <isosts:string name="clause-name">
          <isosts:translation xml:lang="en">Clause</isosts:translation>
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
          <!--AFNOR Text is english, but value of @xml:lang is "fr"-->
          <isosts:translation xml:lang="fr">où|where</isosts:translation>
          <isosts:translation xml:lang="nl">waarin</isosts:translation>
        </isosts:string>
        <isosts:string name="note-label">
          <isosts:translation xml:lang="en">NOTE</isosts:translation>
          <isosts:translation xml:lang="de">ANMERKUNG</isosts:translation>
          <isosts:translation xml:lang="fr">NOTE</isosts:translation>
          <isosts:translation xml:lang="nl">OPMERKING</isosts:translation>
          <isosts:translation xml:lang="ru">ПРИМЕЧАНИЕ</isosts:translation>
        </isosts:string>
        <isosts:string name="dimension-heading">
          <isosts:translation xml:lang="de">Maße</isosts:translation>
        </isosts:string>
      </isosts:i18n>
    </xsl:document>
  </xsl:variable>

  <xsl:variable name="space_regEx" select="'[\s\p{Zs}&#x200B;&#x2060;]+'"/>

  <xsl:variable name="table_label_regEx" select="concat('^\s*(Table(au)?|Таблица|Tabel(le)?)', $space_regEx)"/>

  <xsl:variable name="annex_label_regEx" select="concat('^\s*(Annexe?|Приложение|Aa?nhang)', $space_regEx)"/>

  <xsl:variable name="figur_label_regEx" select="concat('^\s*(Figure|Bild|Figuur|Рисунок)', $space_regEx)"/>


  <xsl:key name="i18n" match="isosts:string/isosts:translation" use="string-join((../@name, @xml:lang), '__')"/>

  <xsl:function name="isosts:lang" as="xs:string?">
    <xsl:param name="context" as="element(*)"/>
    <xsl:variable name="content-language" as="element(content-language)?"
      select="
        $context/ancestor-or-self::*[name() = ('standard', 'adoption')]
        [(front | adoption-front)/*[ends-with(name(), '-meta')]/content-language]
        [1]
        /(front | adoption-front)/*[ends-with(name(), '-meta')]/content-language"/>
     <xsl:variable name="doc-ident_language" as="element(language)?"
      select="
        $context/ancestor-or-self::*[name() = ('standard', 'adoption')]
        [(front | adoption-front)/*[ends-with(name(), '-meta')]/doc-ident/language]
        [1]
        /(front | adoption-front)/*[ends-with(name(), '-meta')]/doc-ident/language"/>
    <xsl:variable name="xml-lang" select="$context/ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
    <xsl:sequence select="(string($xml-lang)[normalize-space()], string($content-language)[normalize-space()], string($doc-ident_language)[normalize-space()])[1]"/>
  </xsl:function>

  <xsl:function name="isosts:i18n-strings" as="xs:string*">
    <xsl:param name="i18n-string-name" as="xs:string"/>
    <xsl:param name="context" as="element(*)"/>
    <xsl:sequence select="key('i18n', string-join(($i18n-string-name, isosts:lang($context)), '__'), $i18n-strings)"/>
  </xsl:function>
  
  <xsl:function name="isosts:i18n-strings-no-lang" as="xs:string*">
    <xsl:param name="i18n-string-name" as="xs:string"/>
    <xsl:sequence select="key('i18n', string-join(($i18n-string-name, $doc-lang), '__'), $i18n-strings)"/>
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
    <xsl:sequence
      select="exists($tw/caption/title[lower-case(isosts:i18n-strings('key-heading', .)) = lower-case(normalize-space(.))])"
    />
  </xsl:function>

  <xsl:function name="isosts:numbering-type" as="xs:string">
    <xsl:param name="marker" as="xs:string*"/>
    <xsl:choose>
      <xsl:when test="matches($marker, '^[A-Z]$')">
        <xsl:sequence select="'upper-alpha'"/>
      </xsl:when>
      <xsl:when test="matches($marker, '^[a-z]$')">
        <xsl:sequence select="'lower-alpha'"/>
      </xsl:when>
      <!-- <xsl:when test="matches($marker,'')">
            <xsl:sequence select="'upper-roman'"></xsl:sequence>
          </xsl:when>
          <xsl:when test="matches($marker, '')">
            <xsl:sequence select="'lower-roman'"></xsl:sequence>
          </xsl:when> -->
      <xsl:when test="matches($marker, '^\d+$')">
        <xsl:sequence select="'arabic'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="'lower-alpha'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="isosts:illegal" as="xs:string+">
    <xsl:param name="context" as="element(*)"/>
    <xsl:sequence>
      <xsl:text>Found illegal element:</xsl:text>
      <xsl:value-of select="name($context)"/>
      <xsl:text>at:</xsl:text>
      <xsl:value-of select="path($context)"/>
      <xsl:text>&#x2002;&#x007c;&#x2002;</xsl:text>
    </xsl:sequence>
  </xsl:function>

  <xsl:function name="isosts:label-to-regex">
    <xsl:param name="context" as="element(label)"/>
    <xsl:sequence select="$context => replace('[()\[\]{}]', '') => replace('\.', '\\.')"/>
  </xsl:function>



  <xsl:variable name="de_words"
    select="'der', 'das', 'oder', 'und', 'einführung', 'einleitung', 'vorwort', 'anhang', 'anwendungsbereich', 'geltungsbereich', 'zweck', 'tabelle', 'bild'"/>
  <xsl:variable name="en_words"
    select="'and', 'of', 'or', 'the', 'to', 'preface', 'annex', 'scope', 'field of application', 'key', 'table'"/>
  <xsl:variable name="fr_words"
    select="'et', 'la', 'le', 'ou', 'où', 'avant-propos', 'préface', 'annexe', 'domaine', 'légende', 'tablau'"/>
   <xsl:variable name="nl_words" 
     select="'het', 'een', 'legenda', 'aanhang', 'informatief', 'waarin', 'opmerking', 'normatief', 'voorwoord', 'termen', 'zijn', 'tabel', 'figuur'"/>
  <xsl:variable name="ru_words" 
    select="'справочное', 'приложение', 'примечание', 'таблица', 'рисунок'"/>


  <xsl:function name="isosts:word-lang" as="xs:string">
    <xsl:param name="input" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$input = $de_words">
        <xsl:sequence select="'de'"/>
      </xsl:when>
      <xsl:when test="$input = $en_words">
        <xsl:sequence select="'en'"/>
      </xsl:when>
      <xsl:when test="$input = $fr_words">
        <xsl:sequence select="'fr'"/>
      </xsl:when>
       <xsl:when test="$input = $nl_words">
        <xsl:sequence select="'nl'"/>
      </xsl:when>
       <xsl:when test="$input = $ru_words">
        <xsl:sequence select="'ru'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>


  <xsl:mode name="doc-lang" on-no-match="text-only-copy"/>

  <xsl:template match="/" mode="doc-lang">
    <doc>
      <xsl:apply-templates mode="#current"/>
    </doc>
  </xsl:template>


  <xsl:template
    match="tbx:* | std-meta | nat-meta | iso-meta | reg-meta | code | preformat | inline-code | std | ext-link | disp-formula | inline-formula | def-item/term"
    mode="doc-lang">
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="p | label | td | th" mode="doc-lang">
    <xsl:text> </xsl:text>
    <xsl:next-match/>
    <xsl:text> </xsl:text>
  </xsl:template>
 

  <xsl:template name="doc-lang" as="xs:string?">
    <xsl:param name="doc-lang-root" as="node()"/>
    <xsl:variable name="prelim" as="element(doc)">
      <doc>
        <xsl:apply-templates select="$doc-lang-root" mode="doc-lang">
          <xsl:with-param name="tunnel-doc-lang-root" as="node()" tunnel="yes" select="$doc-lang-root"/>
        </xsl:apply-templates>
      </doc>
    </xsl:variable>
    <xsl:variable name="words" as="element(w)*">
      <xsl:for-each-group select="($prelim => tokenize()) ! lower-case(.)" group-by=".">
        <xsl:sort data-type="text" select="current-grouping-key()"/>
        <xsl:if test=". = ($de_words, $en_words, $fr_words, $nl_words, $ru_words)">
          <w c="{count(current-group())}" l="{isosts:word-lang(.)}">
            <xsl:value-of select="."/>
          </w>
        </xsl:if>
      </xsl:for-each-group>
    </xsl:variable>
    <xsl:variable name="sums" as="element(sum)*">
      <xsl:for-each-group select="$words" group-by="distinct-values(@l)">
        <sum l="{./@l}">
          <xsl:value-of select="sum(current-group()/@c)"/>
        </sum>
      </xsl:for-each-group>
    </xsl:variable>
    <xsl:variable name="total" as="xs:integer" select="xs:integer(sum($sums))"/>
    <xsl:variable name="percentages" as="element(percentage)+">
      <xsl:for-each select="$sums">
        <percentage l="{./@l}">
          <xsl:value-of select="xs:integer(. * 100 div $total)"/>
        </percentage>
      </xsl:for-each>
    </xsl:variable>
      <xsl:if test="max($percentages) gt 50">
        <xsl:value-of select="$percentages[. = max($percentages)]/@l"/>
      </xsl:if>
  </xsl:template>

  <xsl:template match="standard | adoption" mode="doc-lang">
    <xsl:param name="tunnel-doc-lang-root" as="node()" tunnel="yes"/>
    <xsl:if test="$tunnel-doc-lang-root is . or $tunnel-doc-lang-root is /">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>


  <xsl:function name="isosts:doc-lang" as="xs:string?">
    <xsl:param name="context" as="node()"/>
    <xsl:call-template name="doc-lang">
      <xsl:with-param name="doc-lang-root" select="$context"/>
    </xsl:call-template>
  </xsl:function>




</xsl:stylesheet>
