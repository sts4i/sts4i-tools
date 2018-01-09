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
  
  <diagnostics>
    <diagnostic id="NISOSTS_lib_figure_keys_r1_de" xml:lang="de">Sollte dieser Absatz kein Titel (einer Legende) sein?</diagnostic>
  </diagnostics>
  
</schema>