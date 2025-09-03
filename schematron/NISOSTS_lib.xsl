<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isosts="http://www.iso.org/ns/isosts"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tr="http://transpect.io" xmlns:tbx="urn:iso:std:iso:30042:ed-1"
  xmlns:file="http://expath.org/ns/file" 
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

  <xsl:variable name="image_file_extension_regEx" select="'\.(png|jpg|svg|tif|gif)$'"/>


  <xsl:key name="i18n" match="isosts:string/isosts:translation" use="string-join((../@name, @xml:lang), '__')"/>

  <xsl:function name="isosts:lang" as="xs:string?">
    <xsl:param name="context" as="element(*)"/>
    <xsl:variable name="content-language" as="element(content-language)*" select="
        $context/ancestor-or-self::*[name() = ('standard', 'adoption')]
        [(front | adoption-front)/*[ends-with(name(), '-meta')]/content-language]
        [1]
        /(front | adoption-front)/*[ends-with(name(), '-meta')]/content-language"/>
    <xsl:variable name="doc-ident_language" as="element(language)?" select="
        $context/ancestor-or-self::*[name() = ('standard', 'adoption')]
        [(front | adoption-front)/*[ends-with(name(), '-meta')]/doc-ident/language]
        [1]
        /(front | adoption-front)/*[ends-with(name(), '-meta')]/doc-ident/language"/>
    <xsl:variable name="xml-lang" select="$context/ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
    <xsl:sequence select="(string($xml-lang)[normalize-space()], string-join((distinct-values($content-language) ! string(.)), '_')[normalize-space()], string($doc-ident_language)[normalize-space()])[1]"/>
  </xsl:function>

  <xsl:function name="isosts:i18n-strings" as="xs:string+">
    <xsl:param name="i18n-string-name" as="xs:string"/>
    <xsl:param name="context" as="element(*)"/>
    <xsl:sequence select="if (key('i18n', string-join(($i18n-string-name, isosts:lang($context)), '__'), $i18n-strings))
                          then key('i18n', string-join(($i18n-string-name, isosts:lang($context)), '__'), $i18n-strings)
                          else 'n/a'"/>
  </xsl:function>

  <xsl:function name="isosts:i18n-strings-no-lang" as="xs:string+">
    <xsl:param name="i18n-string-name" as="xs:string"/>
    <xsl:sequence select="if (key('i18n', string-join(($i18n-string-name, $doc-lang), '__'), $i18n-strings))
                          then key('i18n', string-join(($i18n-string-name, $doc-lang), '__'), $i18n-strings)
                          else 'n/a'"/>
  </xsl:function>
  
  <xsl:function name="isosts:id-string-by-label" as="xs:string">
    <xsl:param name="node" as="element(*)"/>
    <xsl:variable name="possible-annex-name" select="(isosts:i18n-strings('annex-name', $node/label[text()]), $node/generate-id())[1]"/>
    <xsl:variable name="strip-adornments" select="replace(replace($node/label, concat('^(', $possible-annex-name, ')[\s\p{Zs}]+'), ''), '[^\p{L}\d]+', '_')"/>
    <xsl:sequence select="string-join(('sec', $strip-adornments), '_')"/>
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
  
  <xsl:function name="isosts:contains-legend-title">
    <xsl:param name="elt"/>
    <xsl:sequence select="
        $elt/descendant::p[1][lower-case(isosts:i18n-strings('key-heading', .)) = lower-case(normalize-space(.))
        or lower-case(isosts:i18n-strings-no-lang('key-heading')) = lower-case(normalize-space(.))]"/>
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
    select="'справочное', 'приложение', 'примечание', 'таблица', 'рисунок', 'эта', 'через', 'по', 'на', 'за', 'от'"/>


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
    <xsl:variable name="percentages" as="element(percentage)*">
      <xsl:for-each select="$sums">
        <percentage l="{./@l}">
          <xsl:value-of select="xs:integer(. * 100 div $total)"/>
        </percentage>
      </xsl:for-each>
    </xsl:variable>
    <xsl:if test="not(empty($percentages)) and max($percentages) gt 50">
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

  <xsl:function name="isosts:tbf-id" as="xs:string">
    <xsl:param name="context" as="element(table-wrap)"/>
    <xsl:variable name="sec" select="$context/ancestor::*[self::app | self::sec][1]"/>
    <xsl:variable name="this-sec-tbfs" select="$sec//table-wrap[empty(label)]
                                                               [ancestor::*[self::app | self::sec][1] is $sec]"/>
    <xsl:variable name="tbf-number" select="index-of(for $tw in $this-sec-tbfs return generate-id($tw), generate-id($context))"/>
    <xsl:sequence select="string-join(($sec/@id, 'tbf', $tbf-number), '-')"/>
  </xsl:function>

  <xsl:function name="isosts:basename-to-regex" as="xs:string">
    <xsl:param name="input" as="xs:string"/>
    <xsl:variable name="parenthesis" select="replace(replace($input, '\)', '\\)'), '\(', '\\(')"/>
    <xsl:sequence select="if (not(matches($input, '\.\d?[A-z].*')))
                          then concat('(^|/)', $parenthesis, '(\.\d?[A-z].*|$)')
                          else concat('(^|/)', $parenthesis, '$')"/>
  </xsl:function>

  <xsl:function name="isosts:letters-to-number" as="xs:integer">
    <!--wrapper for 1-parameter-call; default: type=1-->
    <xsl:param name="string" as="xs:string"/>
    <xsl:sequence select="isosts:letters-to-number($string, 1)"/>
  </xsl:function>

  <xsl:function name="isosts:letters-to-number" as="xs:integer">
    <!-- a, b, c, …, aa, ab, … to 1, 2, 3, …, 27, 28, …
      Maybe this function should also deal with a, b, c, …, aa, bb, cc, … -->
    <xsl:param name="string" as="xs:string"/>
    <xsl:param name="type"/>
    <!--possible values: 1: normal: a..z, aa, ab..az, ba, bb
                         2: double digits: a..z, aa, bb..zz-->
    <xsl:variable name="offset" as="xs:integer">
      <xsl:choose>
        <xsl:when test="matches($string, '^[a-z][a-z]*$')">
          <xsl:sequence select="96"/>
        </xsl:when>
        <xsl:when test="matches($string, '^[A-Z][A-Z]*$')">
          <xsl:sequence select="64"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="-1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$type = 2">
        <!-- length ordered letter groups aa,bb -->
        <xsl:choose>
          <xsl:when test="$offset = -1">
            <xsl:sequence select="0"/><!-- or throw an error? -->
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="nums" as="xs:integer+">
              <xsl:for-each select="string-to-codepoints($string)">
                <xsl:sequence select="."/>
              </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="length" as="xs:integer" select="count($nums)"/>
            <xsl:sequence select="xs:integer((sum($nums) div $length) + (26 * ($length - 1)) - $offset)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- lexicographic ordered letters aa,ab -->
        <xsl:choose>
          <xsl:when test="$offset = -1">
            <xsl:sequence select="0"/><!-- or throw an error? -->
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="nums" as="xs:integer+">
              <xsl:for-each select="reverse(string-to-codepoints($string))">
                <xsl:sequence select="(. - $offset) * isosts:pow(26, position() - 1)"/>
              </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="xs:integer(sum($nums))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="isosts:pow" as="xs:integer">
    <xsl:param name="base" as="xs:integer"/>
    <xsl:param name="power" as="xs:integer"/>
    <xsl:choose>
      <xsl:when test="$power eq 0">
        <xsl:sequence select="1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$base * isosts:pow($base, $power - 1)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="isosts:is-incrementing-alpha-sequence" as="xs:boolean">
    <xsl:param name="marks" as="xs:string*"/>
    <xsl:choose>
      <xsl:when test="count($marks) = 0">
        <xsl:sequence select="false()"/>
      </xsl:when>
      <xsl:when test="count($marks) = 1">
        <xsl:sequence select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="tmp" as="xs:boolean+">
          <xsl:for-each select="$marks[position() gt 1]">
            <xsl:variable name="pos" as="xs:integer" select="position()"/>
            <xsl:sequence select="isosts:letters-to-number(.) = isosts:letters-to-number($marks[position() = $pos]) + 1"/>
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="tmp2" as="xs:boolean+">
          <xsl:for-each select="$marks[position() gt 1]">
            <xsl:variable name="pos" as="xs:integer" select="position()"/>
            <xsl:sequence select="isosts:letters-to-number(., 2) = isosts:letters-to-number($marks[position() = $pos], 2) + 1"/>
          </xsl:for-each>
        </xsl:variable>
        <xsl:sequence select="every $b in $tmp satisfies $b or (every $b in $tmp2 satisfies $b)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="isosts:uni-chars">
    <xsl:param name="context" as="node()*"/>
    <xsl:sequence select="distinct-values(for $t in $context return string-to-codepoints($t))"/>
  </xsl:function>


  <xsl:function name="isosts:is-para-interruptor" as="xs:boolean">
    <xsl:param name="context" as="node()"/>
    <xsl:variable name="prelim" as="xs:boolean?">
      <xsl:apply-templates select="$context" mode="isosts:is-para-interruptor"/>
    </xsl:variable>
    <xsl:sequence select="($prelim, false())[1]"/>
  </xsl:function>
  
  <xsl:variable name="valid-para-interruptor-elements" 
                select="('ack', 'app', 'app-group', 'bio', 'body', 'boxed-text', 'disp-quote', 'glossary', 'index', 'index-div', 
                         'index-group', 'license-p', 'named-content', 'non-normative-example', 'non-normative-note', 'normative-example',
                         'normative-note', 'notes', 'p', 'ref-list', 'sec','styled-content', 'term-display', 'term-sec')"/>
  
  <xsl:variable name="element-parent-map" as="map(xs:string, xs:string*)">
    <xsl:map>
      <xsl:map-entry key="'array'" select="('alternatives', 'chem-struct', 'disp-formula', 'fig', 'legend', 'see', 'see-also', 'see-also-entry', 'see-entry', 'supplementary-material', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'term', 'th')" />
      <xsl:map-entry key="'boxed-text'" select="('tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote')" />
      <xsl:map-entry key="'def-list'" select="('chem-struct', 'def-list', 'fig', 'legend', 'list-item', 'supplementary-material', 'table-wrap', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'th')" />
      <xsl:map-entry key="'disp-formula'" select="('disp-formula-group', 'fig', 'see', 'see-also', 'see-also-entry', 'see-entry', 'supplementary-material', 'table-wrap', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'term', 'th')" />
      <xsl:map-entry key="'disp-formula-group'" select="('disp-formula-group', 'fig', 'see', 'see-also', 'see-also-entry', 'see-entry', 'supplementary-material', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'term', 'th')" />
      <xsl:map-entry key="'disp-quote'" select="('fig', 'supplementary-material', 'table-wrap', 'td', 'th')" />
      <xsl:map-entry key="'fig'" select="('fig-group', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'th')" />
      <xsl:map-entry key="'fig-group'" select="('tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'th')" />
      <xsl:map-entry key="'graphic'" select="('alternatives', 'array', 'chem-struct', 'chem-struct-wrap', 'disp-formula', 'fig', 'fig-group', 'see', 'see-also', 'see-also-entry', 'see-entry', 'sig', 'sig-block', 'supplementary-material', 'table-wrap', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'term', 'th')" />
      <xsl:map-entry key="'list'" select="('chem-struct', 'fig', 'legend', 'list-item', 'supplementary-material', 'table-wrap', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'th')" />
      <xsl:map-entry key="'non-normative-example'" select="('abstract', 'annotation', 'author-comment', 'caption', 'chem-struct-wrap', 'def', 'disp-formula', 'disp-formula-group', 'editing-instruction', 'fig', 'fn', 'list-item', 'notes-group', 'open-access', 'ref', 'speech', 'statement', 'supplementary-material', 'table-wrap', 'table-wrap-foot', 'table-wrap-group', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'th')" />
      <xsl:map-entry key="'non-normative-note'" select="('abstract', 'annotation', 'author-comment', 'caption', 'chem-struct-wrap', 'def', 'disp-formula', 'disp-formula-group', 'editing-instruction', 'fig', 'fn', 'legend', 'list-item', 'notes-group', 'open-access', 'ref', 'speech', 'statement', 'supplementary-material', 'table-wrap', 'table-wrap-foot', 'table-wrap-group', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'th')" />
      <xsl:map-entry key="'preformat'" select="('alternatives', 'chem-struct', 'chem-struct-wrap', 'disp-formula', 'fig', 'see', 'see-also', 'see-also-entry', 'see-entry', 'supplementary-material', 'table-wrap', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'term', 'th')" />
      <xsl:map-entry key="'supplementary-material'" select="('alternatives', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote')" />
      <xsl:map-entry key="'table-wrap'" select="('fig', 'legend', 'supplementary-material', 'table-wrap-group', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote')" />
      <xsl:map-entry key="'table-wrap-group'" select="('tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote')" />
      <xsl:map-entry key="'bold'" select="('addr-line', 'aff', 'alt-title', 'article-title', 'attrib', 'award-id', 'bold', 'chapter-title', 'chem-struct', 'code', 'collab', 'comment', 'compl', 'compound-kwd-part', 'compound-subject-part', 'copyright-statement', 'data-title', 'def-head', 'disp-formula', 'element-citation', 'ext-link', 'fixed-case', 'full', 'funding-source', 'gov', 'inline-code', 'inline-formula', 'inline-media', 'inline-supplementary-material', 'institution', 'intro', 'italic', 'kwd', 'label', 'license-p', 'main', 'meta-value', 'mixed-citation', 'monospace', 'named-content', 'nav-pointer', 'on-behalf-of', 'overline', 'p', 'part-title', 'preformat', 'price', 'pronunciation', 'publisher-loc', 'rb', 'related-article', 'related-object', 'related-term', 'role', 'roman', 'sans-serif', 'sc', 'see', 'see-also', 'see-also-entry', 'see-entry', 'series', 'sig', 'sig-block', 'source', 'std', 'strike', 'styled-content', 'sub', 'subject', 'subtitle', 'sup', 'supplement', 'target', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'term', 'term-display-string', 'term-head', 'term-source', 'textual-form', 'th', 'title', 'trans-source', 'trans-subtitle', 'trans-title', 'underline', 'verse-line', 'xref')" />
      <xsl:map-entry key="'italic'" select="('addr-line', 'aff', 'alt-title', 'article-title', 'attrib', 'award-id', 'bold', 'chapter-title', 'chem-struct', 'code', 'collab', 'comment', 'compl', 'compound-kwd-part', 'compound-subject-part', 'copyright-statement', 'data-title', 'def-head', 'disp-formula', 'element-citation', 'ext-link', 'fixed-case', 'full', 'funding-source', 'gov', 'inline-code', 'inline-formula', 'inline-media', 'inline-supplementary-material', 'institution', 'intro', 'italic', 'kwd', 'label', 'license-p', 'main', 'meta-value', 'mixed-citation', 'monospace', 'named-content', 'nav-pointer', 'on-behalf-of', 'overline', 'p', 'part-title', 'preformat', 'price', 'pronunciation', 'publisher-loc', 'rb', 'related-article', 'related-object', 'related-term', 'role', 'roman', 'sans-serif', 'sc', 'see', 'see-also', 'see-also-entry', 'see-entry', 'series', 'sig', 'sig-block', 'source', 'std', 'strike', 'styled-content', 'sub', 'subject', 'subtitle', 'sup', 'supplement', 'target', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'term', 'term-display-string', 'term-head', 'term-source', 'textual-form', 'th', 'title', 'trans-source', 'trans-subtitle', 'trans-title', 'underline', 'verse-line', 'xref')" />
      <xsl:map-entry key="'underline'" select="('addr-line', 'aff', 'alt-title', 'article-title', 'attrib', 'award-id', 'bold', 'chapter-title', 'chem-struct', 'code', 'collab', 'comment', 'compl', 'compound-kwd-part', 'compound-subject-part', 'copyright-statement', 'data-title', 'def-head', 'disp-formula', 'element-citation', 'ext-link', 'fixed-case', 'full', 'funding-source', 'gov', 'inline-code', 'inline-formula', 'inline-media', 'inline-supplementary-material', 'institution', 'intro', 'italic', 'kwd', 'label', 'license-p', 'main', 'meta-value', 'mixed-citation', 'monospace', 'named-content', 'nav-pointer', 'on-behalf-of', 'overline', 'p', 'part-title', 'preformat', 'price', 'publisher-loc', 'rb', 'related-article', 'related-object', 'related-term', 'role', 'roman', 'sans-serif', 'sc', 'see', 'see-also', 'see-also-entry', 'see-entry', 'series', 'sig', 'sig-block', 'source', 'std', 'strike', 'styled-content', 'sub', 'subject', 'subtitle', 'sup', 'supplement', 'target', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'term', 'term-display-string', 'term-head', 'term-source', 'textual-form', 'th', 'title', 'trans-source', 'trans-subtitle', 'trans-title', 'underline', 'verse-line', 'xref')" />
      <xsl:map-entry key="'ext-link'" select="('address', 'aff', 'alt-title', 'array', 'article-title', 'attrib', 'bold', 'chapter-title', 'chem-struct', 'chem-struct-wrap', 'code', 'collab', 'comment', 'compl', 'contrib', 'contrib-group', 'copyright-statement', 'data-title', 'def-head', 'disp-formula', 'disp-formula-group', 'element-citation', 'fig', 'fig-group', 'fixed-case', 'full', 'graphic', 'index-entry', 'inline-code', 'inline-media', 'inline-supplementary-material', 'intro', 'italic', 'license-p', 'main', 'media', 'meta-value', 'mixed-citation', 'monospace', 'named-content', 'overline', 'p', 'part-title', 'preformat', 'publisher-loc', 'related-article', 'related-object', 'roman', 'sans-serif', 'sc', 'see', 'see-also', 'see-also-entry', 'see-entry', 'source', 'std', 'std-org-loc', 'strike', 'styled-content', 'sub', 'subtitle', 'sup', 'supplementary-material', 'table-wrap', 'table-wrap-group', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'term', 'term-display-string', 'term-head', 'term-source', 'th', 'title', 'toc-div', 'toc-entry', 'trans-source', 'trans-subtitle', 'trans-title', 'underline')" />
      <xsl:map-entry key="'std'" select="('attrib', 'bold', 'code', 'compl', 'element-citation', 'fixed-case', 'full', 'intro', 'italic', 'license-p', 'main', 'mixed-citation', 'monospace', 'overline', 'p', 'preformat', 'ref', 'related-article', 'related-object', 'roman', 'sans-serif', 'sc', 'strike', 'sub', 'subtitle', 'sup', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'th', 'title', 'underline')" />
      <xsl:map-entry key="'fn'" select="('aff', 'alt-title', 'article-title', 'attrib', 'bold', 'chapter-title', 'chem-struct', 'code', 'collab', 'comment', 'compl', 'compound-kwd-part', 'def-head', 'element-citation', 'fig', 'fixed-case', 'fn-group', 'full', 'inline-code', 'intro', 'italic', 'label', 'license-p', 'main', 'meta-value', 'mixed-citation', 'monospace', 'named-content', 'on-behalf-of', 'overline', 'p', 'part-title', 'preformat', 'related-term', 'roman', 'sans-serif', 'sc', 'see', 'see-also', 'see-also-entry', 'see-entry', 'source', 'speaker', 'std', 'strike', 'styled-content', 'sub', 'subtitle', 'sup', 'supplementary-material', 'table-wrap-foot', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'term', 'term-display-string', 'term-head', 'th', 'title', 'trans-source', 'trans-subtitle', 'trans-title', 'underline', 'verse-line')" />
      <xsl:map-entry key="'def-item'" select="('def-list')" />
      <xsl:map-entry key="'xref'" select="('aff', 'alt-title', 'article-title', 'attrib', 'bold', 'chapter-title', 'chem-struct', 'code', 'collab', 'comment', 'compl', 'compound-kwd-part', 'contrib', 'contrib-group', 'def-head', 'element-citation', 'fixed-case', 'full', 'inline-code', 'intro', 'italic', 'label', 'license-p', 'main', 'meta-value', 'mixed-citation', 'monospace', 'named-content', 'on-behalf-of', 'overline', 'p', 'part-title', 'preformat', 'roman', 'sans-serif', 'sc', 'see', 'see-also', 'see-also-entry', 'see-entry', 'source', 'speaker', 'std', 'strike', 'styled-content', 'sub', 'subtitle', 'sup', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'term', 'term-display-string', 'term-head', 'th', 'title', 'trans-source', 'trans-subtitle', 'trans-title', 'underline', 'verse-line')" />
      <xsl:map-entry key="'roman'" select="('addr-line', 'aff', 'alt-title', 'article-title', 'attrib', 'award-id', 'bold', 'chapter-title', 'chem-struct', 'code', 'collab', 'comment', 'compl', 'compound-kwd-part', 'compound-subject-part', 'copyright-statement', 'data-title', 'def-head', 'disp-formula', 'element-citation', 'ext-link', 'fixed-case', 'full', 'funding-source', 'gov', 'inline-code', 'inline-formula', 'inline-media', 'inline-supplementary-material', 'institution', 'intro', 'italic', 'kwd', 'label', 'license-p', 'main', 'meta-value', 'mixed-citation', 'monospace', 'named-content', 'nav-pointer', 'on-behalf-of', 'overline', 'p', 'part-title', 'preformat', 'price', 'publisher-loc', 'rb', 'related-article', 'related-object', 'related-term', 'role', 'roman', 'sans-serif', 'sc', 'see', 'see-also', 'see-also-entry', 'see-entry', 'series', 'sig', 'sig-block', 'source', 'std', 'strike', 'styled-content', 'sub', 'subject', 'subtitle', 'sup', 'supplement', 'target', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'term', 'term-display-string', 'term-head', 'term-source', 'textual-form', 'th', 'title', 'trans-source', 'trans-subtitle', 'trans-title', 'underline', 'verse-line', 'xref')" />
      <xsl:map-entry key="'sans-serif'" select="('addr-line', 'aff', 'alt-title', 'article-title', 'attrib', 'award-id', 'bold', 'chapter-title', 'chem-struct', 'code', 'collab', 'comment', 'compl', 'compound-kwd-part', 'compound-subject-part', 'copyright-statement', 'data-title', 'def-head', 'disp-formula', 'element-citation', 'ext-link', 'fixed-case', 'full', 'funding-source', 'gov', 'inline-code', 'inline-formula', 'inline-media', 'inline-supplementary-material', 'institution', 'intro', 'italic', 'kwd', 'label', 'license-p', 'main', 'meta-value', 'mixed-citation', 'monospace', 'named-content', 'nav-pointer', 'on-behalf-of', 'overline', 'p', 'part-title', 'preformat', 'price', 'publisher-loc', 'rb', 'related-article', 'related-object', 'related-term', 'role', 'roman', 'sans-serif', 'sc', 'see', 'see-also', 'see-also-entry', 'see-entry', 'series', 'sig', 'sig-block', 'source', 'std', 'strike', 'styled-content', 'sub', 'subject', 'subtitle', 'sup', 'supplement', 'target', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'term', 'term-display-string', 'term-head', 'term-source', 'textual-form', 'th', 'title', 'trans-source', 'trans-subtitle', 'trans-title', 'underline', 'verse-line', 'xref')" />
      <xsl:map-entry key="'monospace'" select="('addr-line', 'aff', 'alt-title', 'article-title', 'attrib', 'award-id', 'bold', 'chapter-title', 'chem-struct', 'code', 'collab', 'comment', 'compl', 'compound-kwd-part', 'compound-subject-part', 'copyright-statement', 'data-title', 'def-head', 'disp-formula', 'element-citation', 'ext-link', 'fixed-case', 'full', 'funding-source', 'gov', 'inline-code', 'inline-formula', 'inline-media', 'inline-supplementary-material', 'institution', 'intro', 'italic', 'kwd', 'label', 'license-p', 'main', 'meta-value', 'mixed-citation', 'monospace', 'named-content', 'nav-pointer', 'on-behalf-of', 'overline', 'p', 'part-title', 'preformat', 'price', 'publisher-loc', 'rb', 'related-article', 'related-object', 'related-term', 'role', 'roman', 'sans-serif', 'sc', 'see', 'see-also', 'see-also-entry', 'see-entry', 'series', 'sig', 'sig-block', 'source', 'std', 'strike', 'styled-content', 'sub', 'subject', 'subtitle', 'sup', 'supplement', 'target', 'tbx:crossReference', 'tbx:definition', 'tbx:entailedTerm', 'tbx:example', 'tbx:externalCrossReference', 'tbx:note', 'tbx:pronunciation', 'tbx:see', 'tbx:source', 'tbx:term', 'tbx:usageNote', 'td', 'term', 'term-display-string', 'term-head', 'term-source', 'textual-form', 'th', 'title', 'trans-source', 'trans-subtitle', 'trans-title', 'underline', 'verse-line', 'xref')" />
    </xsl:map>
  </xsl:variable>

  <xsl:template match="array | boxed-text | def-list | disp-formula | disp-formula-group | disp-quote | fig | fig-group | graphic | list | 
                       non-normative-example | non-normative-note | preformat | supplementary-material | table-wrap | table-wrap-group"
                mode="isosts:is-para-interruptor" as="xs:boolean">
    <xsl:choose>
      <xsl:when test="parent::p">
        <xsl:sequence select="parent::p/parent::*/name()=($valid-para-interruptor-elements,$element-parent-map(name()))"/>
      </xsl:when>
      <xsl:when test="parent::td | parent::th">
        <xsl:sequence select="exists(../text()[normalize-space()])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="true()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="processing-instruction() | comment() | text()[not(normalize-space())]"
                mode="isosts:is-para-interruptor" as="xs:boolean?">
    <xsl:apply-templates select="preceding-sibling::node()[1]" mode="#current"/>
  </xsl:template>

  <xsl:template match="node()" mode="isosts:is-para-interruptor" as="xs:boolean" priority="-0.25">
    <xsl:sequence select="false()"/>
  </xsl:template>

</xsl:stylesheet>
