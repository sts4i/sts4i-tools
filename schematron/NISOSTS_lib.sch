<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xml:lang="en"
  xmlns:isosts="http://www.iso.org/ns/isosts" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
  
  <!-- Copyright 2017 ISO and contributors

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
  
  <ns uri="http://www.iso.org/ns/isosts" prefix="isosts"/>
  
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
          <isosts:documentation>The heading of figure keys</isosts:documentation>
          <isosts:translation xml:lang="en">Annex</isosts:translation>
          <isosts:translation xml:lang="de">Anhang</isosts:translation>
          <isosts:translation xml:lang="fr">Annexe</isosts:translation>
        </isosts:string>
      </isosts:i18n>    
    </xsl:document>
  </xsl:variable>
  
  <xsl:key name="i18n" match="isosts:string/isosts:translation" use="string-join((../@name, @xml:lang), '__')"/>
  
  <xsl:function name="isosts:lang" as="xs:string?">
    <xsl:param name="context" as="element(*)"/>
    <xsl:variable name="content-language" as="element(content-language)?" 
      select="$context/ancestor-or-self::*[name() = ('standard', 'adoption')]
                                          [(front | adoption-front)/*[ends-with(name(), '-meta')]/content-language][1]
                                           /(front | adoption-front)/*[ends-with(name(), '-meta')]/content-language"/>
    <xsl:variable name="xml-lang" select="$context/ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
    <xsl:sequence select="(string($xml-lang)[normalize-space()], string($content-language)[normalize-space()])[1]"/>
  </xsl:function>
  
  <xsl:function name="isosts:i18n-strings" as="xs:string*">
    <xsl:param name="i18n-string-name" as="xs:string"/>
    <xsl:param name="context" as="element(*)"/>
    <xsl:sequence select="key('i18n', string-join(($i18n-string-name, isosts:lang($context)), '__'), $i18n-strings)"/>
  </xsl:function>

  <pattern id="NISOSTS_lib_figure_keys">
    <title>Checks whether a key (a.k.a. legend) is part of the regular fig content, rather than in the caption</title>
    <p>There is no optimal or canonical way to place keys to figures yet.</p>
    <rule id="key_location" context="fig/*[not(name() = ('label', 'caption'))]">
      <report test="(p | self::p) = isosts:i18n-strings('key-heading', .)" role="warning" id="NISOSTS_lib_figure_keys_r1" 
        diagnostics="NISOSTS_lib_figure_keys_r1_de">
        Shouldn’t this p be a title (of a key)?
      </report>
      <report test="(title | caption/title) = isosts:i18n-strings('key-heading', .)" role="warning">
        Put the figure key (a.k.a. legend) in the caption, either as a table-wrap[@content-type='key'] or as a def-list[@list-type='key']. 
        For validity reasons, it must be wrapped in a paragraph.
      </report>
    </rule>
  </pattern>
  
  <pattern id="NISOSTS_lib_subfigs_in_array">
    <title></title>
    <rule id="NISOSTS_lib_rule01" context="fig[array|table-wrap]">
      <report test="exists((array|table-wrap)//tr//graphic)" role="warning">
        For subfigure arrangements use an outside tabular construction with the subfigures in the cells.
      </report>
    </rule>
  </pattern>
  
  
  <pattern id="NISOSTS_lib_ref-list_title_pattern">
    <rule id="ref-list_title" context="ref-list[parent::app|parent::sec]">
      <report role="warning" test="title">ref-list with title found. Please move title to the surrounding sec or app.</report>
    </rule>
    <rule id="NISOSTS_lib_ref-list_title_back" context="ref-list[parent::back]">
      <report role="warning" test="title">ref-list with title found. 
        Please move the ref-list to an app and attach the title to the app.</report>
    </rule>
  </pattern>
  

  <pattern id="NISOSTS_lib_std-meta_pattern">
    <rule id="std-meta" context="standard/front/iso-meta | standard/front/reg-meta | standard/front/nat-meta"> <!-- oder muss es front[parent::standard] lauten? -->
      <report role="warning" test="true()"><name/> is deprecated in NISO STS. Please replace it with std-meta.</report>
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
        fn-groups. </assert>

    </rule>
  </pattern>

  <pattern sc:alternative-id="NISOSTS_fn-in-fn-group">
    <rule id="NISOSTS_fn-in-fn-group_1" context="fn">
      <assert test="exists(ancestor::fn-group)" id="NISOSTS_fn-in-fn-group_2" role="warning"> All fn must be grouped in
        fn-groups. </assert>

    </rule>
  </pattern>

  <diagnostics>
    <diagnostic id="NISOSTS_lib_figure_keys_r1_de" xml:lang="de">Sollte dieser Absatz kein Titel (einer Legende) sein?</diagnostic>
    <diagnostic id="NISOSTS_iso-like-ids_1_1_de" xml:lang="de">Eine sec- oder app-ID muss wie folgt gebildet werden:
    'sec_' + der Inhalt von label (ohne Text wie z.B. 'Anhang ').</diagnostic>
  </diagnostics>
  
</schema>