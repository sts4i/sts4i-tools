<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xml:lang="en"
  xmlns:isosts="http://www.iso.org/ns/isosts" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sc="http://transpect.io/schematron-config"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  xmlns:tr= "http://transpect.io">
  
  <!-- Copyright 2017–2019 ISO and contributors

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License. -->
  
  <!-- Set the allow-foreign parameter to 'true' when invoking the default ISO Schematron
    implementation -->
  
  <xsl:import href="http://transpect.io/xslt-util/num/xsl/num.xsl"/>
  
  <ns uri="http://www.iso.org/ns/isosts" prefix="isosts"/>
  <ns prefix="tr" uri="http://transpect.io"/>
  
  <let name="legend-content-type" value="'fig-index'"/>
  <xsl:include href="http://niso-sts.org/sts4i-tools/schematron/NISOSTS_lib.xsl"/>  

  <pattern id="NISOSTS_lib_figure_keys">
    <title>Checks whether a key (a.k.a. legend) is part of the regular fig content, rather than in the caption</title>
    <p>There is no optimal or canonical way to place keys to figures yet.</p>
    <rule id="key_location" context="fig/*[not(name() = ('label', 'caption'))]">
      <report test="(p | self::p) = isosts:i18n-strings('key-heading', .)" role="warning" id="NISOSTS_lib_figure_keys_r1" 
        diagnostics="NISOSTS_lib_figure_keys_r1_de">
        Shouldn’t this p be a title (of a key)?
      </report>
      <report test="(title | caption/title) = isosts:i18n-strings('key-heading', .)" role="warning" id="NISOSTS_lib_figure_keys_r2">
        Put the figure key (a.k.a. legend) in the caption, either as a 
        table-wrap[@content-type='<value-of select="$legend-content-type"/>'] or as a 
        def-list[@list-type='<value-of select="$legend-content-type"/>']. 
        For validity reasons, it must be wrapped in a paragraph.
      </report>
    </rule>
  </pattern>
  
  <pattern id="NISOSTS_lib_subfigs_in_array">
    <title></title>
    <rule id="NISOSTS_lib_rule01" context="fig[array|table-wrap]">
      <report test="exists((array|table-wrap)//tr//graphic)" role="warning" id="NISOSTS_lib_rule01_r1">
        For subfigure arrangements use an outside tabular construction with the subfigures in the cells.
      </report>
    </rule>
  </pattern>
  
  
  <pattern id="NISOSTS_lib_ref-list_title_pattern">
    <rule id="ref-list_title" context="ref-list[parent::app|parent::sec]">
      <report role="warning" test="title" id="ref-list_title_r1"
        >ref-list with title found. Please move title to the surrounding sec or app.</report>
    </rule>
    <rule id="NISOSTS_lib_ref-list_title_back" context="ref-list[parent::back]">
      <report role="warning" test="title" id="NISOSTS_lib_ref-list_title_back_r1">ref-list with title found. 
        Please move the ref-list to an app and attach the title to the app.</report>
    </rule>
  </pattern>
  

  <pattern id="NISOSTS_lib_std-meta_pattern">
    <rule id="std-meta" context="standard/front/iso-meta | standard/front/reg-meta | standard/front/nat-meta">
      <report role="warning" test="true()" id="std-meta_r1"><name/> is deprecated in NISO STS. Please replace it with std-meta.</report>
    </rule>
  </pattern>
  
  <pattern id="NISOSTS_iso-like-ids">
    <rule id="NISOSTS_iso-like-ids_1" context="sec[label[text()]] | app[label[text()]]">
      <let name="annex-name" value="isosts:i18n-strings('annex-name', label)"/>
      <let name="strip-adornments" value="replace(label, concat('^(', $annex-name, ')[\s\p{Zs}]+'), '')"/>
      <assert test="@id = string-join(('sec', $strip-adornments), '_')" role="warning" id="NISOSTS_iso-like-ids_1_1" 
        diagnostics="NISOSTS_iso-like-ids_1_1_de">A section or appendix id must be 'sec_' + label (modulo 
      text such as 'Annex ').</assert>
    </rule>
  </pattern>

  <pattern id="NISOSTS_fn-in-fn-group">
    <rule id="NISOSTS_fn-in-fn-group_1" context="fn">
      <assert test="exists(ancestor::fn-group)" id="NISOSTS_fn-in-fn-group_2" role="warning"> All fn must be grouped in
        fn-groups.
      <sc:xsl-fix href="xslt-fixes/fn-group.xsl" mode="group-fn"/>
      </assert>
    </rule>
  </pattern>

  <pattern  id="NISOSTS_fn-not-in-fn-group" sc:alternative-for="NISOSTS_fn-in-fn-group">
    <rule id="NISOSTS_fn-not-in-fn-group_1" context="fn">
      <report test="exists(ancestor::fn-group)" id="NISOSTS_fn-not-in-fn-group_2" role="warning">Fn in fn-group found. 
        Fn must not be grouped in fn-groups. </report>
    </rule>
  </pattern>
  
  
  <pattern id="NISOSTS_fn-in-metadata">
    <rule  id="NISOSTS_fn-in-metadata_1" context="fn[ancestor::std-meta|ancestor::std-doc-meta|ancestor::iso-meta|ancestor::reg-meta|ancestor::nat-meta]">
      <report test="true()" id="NISOSTS_fn-in-metadata_1_r1">Fn are not allowed in metadata elements.</report>
    </rule>
  </pattern>
  
  <pattern id="NISOSTS_fn-without-xref">
    <rule id="NISOSTS_fn-without-xref_1" context="fn[ancestor::*[self::table-wrap or self::table]][not(@id = ancestor::*[self::table-wrap or self::table]//descendant::xref/@rid)]">
      <report test="true()" role="error" id="NISOSTS_fn-without-xref_1_r1" 
        diagnostics="NISOSTS_fn-without-xref_1_de">Table-fn without referencing xref found. All table-fn must be referenced.</report>    </rule>
  </pattern>
  
  
  <pattern id="NISOSTS_table-cell-paras">
    <rule id="NISOSTS_table-cell-paras_mixed-p" context="td[p] | th[p]">
      <report test="text()[normalize-space()] | *[name() = $inline-element-names]" id="NISOSTS_table-cell-paras_mixed-p_r1"
        role="error" diagnostics="NISOSTS_table-cell-paras_mixed-p_de">Table cells must
      not contain both paragraphs and inline elements or text.
      <sc:xsl-fix href="xslt-fixes/table-paras.xsl" mode="fix-table-paras"/>
      </report>
    </rule>
  </pattern>

  <pattern id="NISOSTS_bold-in-titles">
    <rule id="NISOSTS_bold-tags-in-title" context="title">
      <report test="bold[normalize-space()]" role="warning" diagnostics="NISOSTS_bold-tags-in-title_de"
        id="NISOSTS_bold-tags-in-title_r1">Titles usually are rendered in bold. Additional bold tags may lead to extra bold fonts.</report>
    </rule>
  </pattern>
  
  <pattern id="NISOSTS_listitem-labels">
    <rule id="NISOSTS_listitems-labels_mixed_rule" context="list[list-item[label[normalize-space()]]]">
      <report test="list-item[not(label)]" id="NISOSTS_listitems-labels_mixed" role="warning" 
        diagnostics="NISOSTS_listitems-labels_mixed_de"
        >Not all list-items contain label elements. Maybe paragraphs should be moved to the preceding list-item.</report>
    </rule>
  </pattern>
  
  <pattern id="NISOSTS_listtype">
    <rule id="NISOSTS_plausible-listtype_roman" context="list[@list-type = ('roman-lower', 'roman-upper', 'lower-roman', 'upper-roman')]">
      <report test="list-item/label[not(tr:roman-to-int(replace(., '[().]', '')))]" 
        role="error" diagnostics="NISOSTS_plausible-listtype_de" id="NISOSTS_plausible-listtype_roman_r1"
        >list-type must match label values. Found list-type="<xsl:value-of select="@list-type"/>" with label(s) 
        "<xsl:value-of select="string-join(list-item/label[not(tr:roman-to-int(replace(., '[().]', '')))], ' ')"/>".</report>
    </rule>
    <rule id="NISOSTS_plausible-listtype_alpha" context="list[@list-type = ('alpha-lower', 'alpha-upper', 'lower-alpha', 'upper-alpha')]">
      <report test="list-item/label[not(tr:letters-to-number(replace(., '[().]', '')))]" 
        role="error" diagnostics="NISOSTS_plausible-listtype_de" id="NISOSTS_plausible-listtype_alpha_r1"
        >list-type must match label values. Found list-type="<xsl:value-of select="@list-type"/>" with label(s) 
        "<xsl:value-of select="string-join(list-item/label[not(tr:letters-to-number(replace(., '[().]', '')))], ' ')"/>".</report>
    </rule>
  </pattern>
  
  <pattern id="NISOSTS_xrefs">
    <rule id="NISOSTS_xref_rendering-infos" context="xref">
      <report test="  preceding-sibling::node()[1]/self::sup[matches(., '^\s?\[$')] 
                    | following-sibling::node()[1]/self::sup[matches(., '^(\]|\))\s?$')]" 
              role="warning" diagnostics="NISOSTS_xref_rendering-infos_de" id="NISOSTS_xref_rendering-infos_r1"
        >Improper tagging of rendering information for element 'xref'.</report>
    </rule>
  </pattern>
  
  <pattern id="n12_table-cell_colors">
    <rule id="NISOSTS_table-cell_colors_1" context="*[self::td or self::th][matches(@style,'background-color')]">
      <report id="NISOSTS_table-cell_colors_2" test="not(matches(tokenize(tokenize(@style,'\s*;\s*')[matches(.,'background-color')],'\s*:\s*')[2],'^#[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]\s*$','i'))"
        role="warning" diagnostics="NISOSTS_table-cell_colors_2_de">Background-color must be represented by a hex code
        <sc:xsl-fix href="xslt-fixes/table-cell_colors.xsl" mode="table-cell_colors"/>
      </report>
    </rule>
  </pattern>
  
  <pattern id="lang">
    <rule id="content-language" context="content-language">
      <assert test="matches(., '^\p{Ll}{2}$')" role="warning" id="content-language-iso639-1">content-language 
        must contain a 2-letter lower-case ISO 639-1 language code. Current value: '<value-of select="."/>'</assert>
    </rule>
    <rule id="language-available" context="front | adoption-front | body | back">
      <assert test="isosts:lang(.)" role="warning" id="body-language-available">The content language cannot be determined.</assert>
    </rule>
  </pattern>
  
  <pattern id="app-norm-inform">
    <!-- https://gitlab.com/DIN-XML/STS/-/issues/28 -->
    <rule id="app_has_correct_values" context="app">
      <report role="warning" id="app_no_content-type" test="not(@content-type)"><name/> has no content-type.</report>
      <report role="error" id="app_wrong_content-type" test="@content-type/not(.='norm-annex' or .='inform-annex')">The 
        content-type of an app has to be either "norm-annex" or "inform-annex".
        <sc:xsl-fix href="xslt-fixes/app-type.xsl" mode="content-type"/>
      </report>
      <report role="warning" id="app_no_annex-type" test="not(annex-type)"><name/> has no annex-type.</report>
    </rule>
    <rule id="annex-type-normative-text-available" context="annex-type[parent::app/@content-type = 'norm-annex']">
      <assert role="warning" id="annex-type-text-available1" 
        test="exists(isosts:i18n-strings('annex-type-normative', .))">No normative annex type available for 
        language '<value-of select="isosts:lang(.)"/>'.
      </assert>
    </rule>
    <rule id="annex-type-normative-text" context="annex-type[parent::app/@content-type = 'norm-annex']">
      <let name="expected" value="concat('(', isosts:i18n-strings('annex-type-normative', .), ')')"/>
      <assert role="warning" id="annex-type-text-a1" 
        test=". = $expected"><name/> should be '<value-of select="$expected"/>'.
        <sc:xsl-fix href="xslt-fixes/app-type.xsl" mode="annex-type"/>
      </assert>
    </rule>
    <rule id="annex-type-inform-text-available" context="annex-type[parent::app/@content-type = 'inform-annex']">
      <assert role="warning" id="annex-type-text-available2" 
        test="exists(isosts:i18n-strings('annex-type-informative', .))">No informative annex type available for 
        language '<value-of select="isosts:lang(.)"/>'.
      </assert>
    </rule>
    <rule id="annex-type-inform-text" context="annex-type[parent::app/@content-type = 'inform-annex']">
      <let name="expected" value="concat('(', isosts:i18n-strings('annex-type-informative', .), ')')"/>
      <assert role="warning" id="annex-type-text-a2" 
        test=". = $expected"><name/> should be '<value-of select="$expected"/>'.
        <sc:xsl-fix href="xslt-fixes/app-type.xsl" mode="annex-type"/>
      </assert>
    </rule>
  </pattern>
  
  <pattern id="index-navpointer">
    <rule id="index-navpointer-1" context="index-entry">
      <assert role="warning" test="exists(.//nav-pointer)" id="index-navpointer-2">index-entry should contain an element nav-pointer</assert>      
    </rule>
  </pattern>
  
  <pattern id="math-without-mml">
    <rule id="math-without-mml-1" context="*[namespace-uri() = 'http://www.w3.org/1998/Math/MathML']">
      <assert test="starts-with(name(), 'mml:')" id="math-without-mml-2">MathML elements must have an 'mml' namespace prefix
      <sc:xsl-fix href="xslt-fixes/mml.xsl" mode="prefix"/>
      </assert>
    </rule>
  </pattern>
  
  <pattern id="exclusions" abstract="true">
    <rule context="$context">
      <let name="tokenized" value="tokenize('$exclude', '\s+', 's')[normalize-space()]"/>
      <report test="exists(descendant::*[if ($tokenized = '*') then true() 
                                         else 
                                         name() = $tokenized])">In context <value-of select="'$context'"/>,
      the following elements are prohibited: <value-of select="string-join($tokenized, ', ')"/>.</report>
    </rule>
  </pattern>
  
  <pattern id="exclusion-non-norm" is-a="exclusions">
    <param name="context" value="non-normative-note | non-normative-example"/>
    <param name="exclude" value="non-normative-note non-normative-example"/>
  </pattern>
  
  <pattern id="exclusion-ref" is-a="exclusions">
    <param name="context" value="xref | ext-link | std"/>
    <param name="exclude" value="bold italic underlined ext-link std fn def-item xref roman sans-serif monospace"/>
  </pattern>
  
  <pattern id="exclusion-block" is-a="exclusions">
    <param name="context" value="boxed-text | fig | supplementary-material[graphic] | table-wrap"/>
    <param name="exclude" value="boxed-text fig-group fig supplementary-material table-wrap preformat"/>
  </pattern>
  
  <pattern id="exclusion-fig-group" is-a="exclusions">
    <param name="context" value="fig-group"/>
    <param name="exclude" value="boxed-text fig-group supplementary-material table-wrap preformat"/>
  </pattern>
  
  <pattern id="exclusion-preformat" is-a="exclusions">
    <param name="context" value="preformat"/>
    <param name="exclude" value=" * "/>
  </pattern>

  <diagnostics>
    <diagnostic id="NISOSTS_lib_figure_keys_r1_de" xml:lang="de">Sollte dieser Absatz kein Titel (einer Legende) sein?</diagnostic>
    <diagnostic id="NISOSTS_iso-like-ids_1_1_de" xml:lang="de">Eine sec- oder app-ID muss wie folgt gebildet werden:
    'sec_' + der Inhalt von label (ohne Text wie z.B. 'Anhang ').</diagnostic>
    <diagnostic id="NISOSTS_table-cell-paras_mixed-p_de" xml:lang="de">Tabellenzellen dürfen nicht sowohl Absätze als 
      auch Inline-Elemente oder Text enthalten.</diagnostic>
    <diagnostic id="NISOSTS_bold-tags-in-title_de" xml:lang="de">Titel werden in der Regel fett dargestellt. 
      Zusätzliche bold-Elemente können zu einer extrafetten Darstellung führen.</diagnostic>
    <diagnostic id="NISOSTS_listitems-labels_mixed_de" xml:lang="de">Nicht alle Listenelemente verfügen über ein label-Element. 
      Möglicherweise handelt es sich dabei um Folgeabsätze des vorhergehenden Listenelementes.</diagnostic>
    <diagnostic id="NISOSTS_plausible-listtype_de" xml:lang="de">Listentyp und Inhalte der label-Elemente müssen 
      zusammenpassen.</diagnostic>
    <diagnostic id="NISOSTS_xref_rendering-infos_de" xml:lang="de">Darstellungsrelevantes Tagging sollte innerhalb des 
      xref-Elementes stehen.</diagnostic>
    <diagnostic id="NISOSTS_fn-without-xref_1_de" xml:lang="de">Tabellenfußnote ohne entsprechende Referenz gefunden. Tabellenfußnoten müssen immer referenziert werden.</diagnostic>
    <diagnostic id="NISOSTS_table-cell_colors_2_de">Background-color muss als Hex-code ausgezeichnet sein.</diagnostic>
  </diagnostics>
  
</schema>
