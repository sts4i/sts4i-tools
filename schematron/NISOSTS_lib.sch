<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xml:lang="en"
  xmlns:isosts="http://www.iso.org/ns/isosts" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sbf="http://transpect.io/schematron-batch-fix" xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xmlns:tr="http://transpect.io">

  <!-- Copyright 2017–2024 ISO and contributors

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

  <xsl:param name="target-niso-version"/>

  <ns uri="http://www.iso.org/ns/isosts" prefix="isosts"/>
  <ns prefix="tr" uri="http://transpect.io"/>
  <ns prefix="tbx" uri="urn:iso:std:iso:30042:ed-1"/>
  <ns prefix="c" uri="http://www.w3.org/ns/xproc-step"/>
  <ns uri="http://www.w3.org/1998/Math/MathML" prefix="mml"/>

  <let name="legend-content-type" value="'fig-index'"/>
  <xsl:include href="http://niso-sts.org/sts4i-tools/schematron/NISOSTS_lib.xsl"/>

  <pattern id="unexpected-namespace-uris">
    <let name="expected-ns-uris"
      value="
        ('urn:iso:std:iso:30042:ed-1', 'http://www.w3.org/1998/Math/MathML',
        'http://www.w3.org/1999/xlink', 'http://www.w3.org/XML/1998/namespace',
        'http://www.niso.org/schemas/ali/1.0/', 'http://www.w3.org/2001/XInclude',
        'http://www.w3.org/2001/XMLSchema-instance', 'http://www.w3.org/ns/xproc-step')"/>

    <let name="expected-ns-prefixes"
      value="
        ('ali', 'mml',
        'xi', 'xsi',
        'tbx',
        'xlink', 'xml')"/>

    <rule context="*[namespace::*]">
      <assert
        test="
          every $n in (namespace::* ! string(.))
            satisfies ($n = $expected-ns-uris or $n = ../namespace::* ! string(.))"
        id="unexpected-namespace-uris_a1">Unexpected namespace declaration in <name/>. Found: <value-of
          select="string-join(namespace::*[not(string(.) = $expected-ns-uris)] ! string-join((name(.), string(.)), ':'), ', ')"
        />
      </assert>

      <assert
        test="
          every $n in (namespace::* ! name(.))
            satisfies ($n = $expected-ns-prefixes or $n = ../namespace::* ! name(.))"
        id="unexpected-namespace-prefix">Unexpected prefix in namespace declaration in <name/>. Found: <value-of
          select="string-join(namespace::*[not(name(.) = $expected-ns-prefixes)] ! string-join((name(.), string(.)), ':'), ', ')"
        />
      </assert>

    </rule>


  </pattern>

  <pattern id="legacy-meta">
    <rule id="legacy-meta_rule1" context="nat-meta | reg-meta | iso-meta">
      <assert test="name() = 'std-meta'" id="legacy-meta_a1" role="error">Please use std-meta since <name/> will be
        deprecated in future NISO STS versions. <sbf:xsl-fix href="xslt-fixes/nesting.xsl" mode="legacy-meta"
          depends-on="deprecated_doc-ident_r1 text_in_nat-meta_r1"/>
      </assert>
    </rule>
  </pattern>

  <pattern id="NISOSTS_lib_figure_keys">
    <title>Checks whether a key (a.k.a. legend) is part of the regular fig content, rather than in the caption</title>
    <p>Prior to NISO STS 1.2, there was no optimal or canonical way to place keys to figures yet.</p>
    <rule id="SN-key_location" context="fig/non-normative-note[@content-type = 'explanatory']">
      <report test="true()" id="SN-key_location_r1">The legend needs to go into a NISO STS 1.2 legend element.
          <sbf:xsl-fix href="xslt-fixes/legend.xsl" mode="SN-legends"/></report>
    </rule>
    <rule id="NISOSTS_table-key-in-footnotes_rule1"
      context="table-wrap-foot[fn[1][lower-case(isosts:i18n-strings('key-heading', .)) = lower-case(normalize-space(.))]]">
      <report test="true()" role="error" id="NISOSTS_table-key-in-footnotes_r1"> Table key seems to be encoded in
        table-footnotes. <sbf:xsl-fix href="xslt-fixes/legend.xsl" mode="table-key"/>
      </report>
    </rule>
    <rule id="key_location" context="fig/*[not(name() = ('label', 'caption', 'legend'))]">
      <report test="(p | self::p) = isosts:i18n-strings('key-heading', .)" role="warning"
        id="NISOSTS_lib_figure_keys_r1" diagnostics="NISOSTS_lib_figure_keys_r1_de"> Shouldn’t this p be a title (of a
        key)? </report>
      <report
        test="
          (title | caption/title) = isosts:i18n-strings('key-heading', .)
          and (xs:decimal($target-niso-version) lt 1.2)"
        role="warning" id="NISOSTS_lib_figure_keys_r2"> Put the figure key (a.k.a. legend) in the caption, either as a
          table-wrap[@content-type='<value-of select="$legend-content-type"/>'] or as a def-list[@list-type='<value-of
          select="$legend-content-type"/>']. For validity reasons, it must be wrapped in a paragraph. </report>
      <report
        test="
          (title | caption/title) = isosts:i18n-strings('key-heading', .)
          and (xs:decimal($target-niso-version) ge 1.2)"
        role="warning" id="NISOSTS_lib_figure_keys_r3"> Put the figure key in a NISO STS 1.2 legend element. <sbf:xsl-fix
          href="xslt-fixes/legend.xsl" mode="legends"/>
      </report>
    </rule>
  </pattern>

  <pattern id="NISOSTS_lib_subfigs_in_array">
    <title/>
    <rule id="NISOSTS_lib_rule01" context="fig[array | table-wrap]">
      <report test="exists((array | table-wrap)//tr//graphic)" role="warning" id="NISOSTS_lib_rule01_r1"> For subfigure
        arrangements use 'fig-group' or an outside tabular construction with the subfigures in the cells. </report>
    </rule>
  </pattern>


  <pattern id="NISOSTS_lib_ref-list_title_pattern">
    <rule id="ref-list_title" context="ref-list[parent::app | parent::sec]">
      <report role="warning" test="title" id="ref-list_title_r1">ref-list with title found. Please move title to the
        surrounding sec or app.</report>
    </rule>
    <rule id="NISOSTS_lib_ref-list_title_back" context="ref-list[parent::back]">
      <report role="warning" test="title" id="NISOSTS_lib_ref-list_title_back_r1">ref-list with title found. Please move
        the ref-list to an app and attach the title to the app.</report>
    </rule>
  </pattern>

  <pattern id="NISOSTS_iso-like-ids">
    <rule id="NISOSTS_iso-like-ids_1" context="sec[label[text()]] | app[label[text()]]">
      <let name="annex-name" value="isosts:i18n-strings('annex-name', label)"/>
      <let name="strip-adornments" value="replace(label, concat('^(', $annex-name, ')[\s\p{Zs}]+'), '')"/>
      <assert test="@id = string-join(('sec', $strip-adornments), '_')" role="warning" id="NISOSTS_iso-like-ids_1_1"
        diagnostics="NISOSTS_iso-like-ids_1_1_de">A section or appendix id must be 'sec_' + label (modulo text such as
        'Annex ').</assert>
    </rule>
  </pattern>

  <pattern id="NISOSTS_fn-in-fn-group">
    <rule id="NISOSTS_fn-in-fn-group_1" context="fn">
      <assert test="exists(ancestor::fn-group)" id="NISOSTS_fn-in-fn-group_2" role="warning"> All fn must be grouped in
        fn-groups. <sbf:xsl-fix href="xslt-fixes/fn-group.xsl" mode="group-fn"
          depends-on="NISOSTS_table-key-in-footnotes_r1 continuation_footnotes_r1 duplicate_fn_marker_r1 AFNOR_remove_enrichments_r1"/>
      </assert>
    </rule>
  </pattern>

  <pattern id="NISOSTS_fn-not-in-fn-group" sbf:alternative-for="NISOSTS_fn-in-fn-group">
    <rule id="NISOSTS_fn-not-in-fn-group_1" context="fn">
      <report test="exists(ancestor::fn-group)" id="NISOSTS_fn-not-in-fn-group_2" role="warning">Fn in fn-group found.
        Fn must not be grouped in fn-groups. </report>
    </rule>
  </pattern>


  <pattern id="NISOSTS_fn-in-metadata">
    <rule id="NISOSTS_fn-in-metadata_1"
      context="fn[ancestor::std-meta | ancestor::std-doc-meta | ancestor::iso-meta | ancestor::reg-meta | ancestor::nat-meta]">
      <report test="true()" id="NISOSTS_fn-in-metadata_1_r1">Fn are not allowed in metadata elements.</report>
    </rule>
  </pattern>

  <pattern id="NISOSTS_fn-without-xref">
    <rule id="NISOSTS_fn-without-xref_1"
      context="fn[ancestor::*[self::table-wrap or self::table]][not(@id = ancestor::*[self::table-wrap or self::table]//descendant::xref/@rid)]">
      <report test="true()" role="error" id="NISOSTS_fn-without-xref_1_r1" diagnostics="NISOSTS_fn-without-xref_1_de"
        >Table-fn without referencing xref found. All table-fn must be referenced.</report>
    </rule>
  </pattern>

  <pattern id="NISOSTS_BSI_bookmark_error">
    <rule id="NISOSTS_BSI_bookmark_error_rule1" context="bold[sup[. = 'Error! Bookmark not defined.']]">
      <report test="true()" role="error" id="NISOSTS_BSI_bookmark_error_r1">This error message ('<value-of
          select="string(sup)"/>') is probably not part of the standard’s content.</report>
    </rule>
  </pattern>

  <pattern id="NISOSTS_table-cell-paras">
    <rule id="NISOSTS_table-cell-paras_mixed-p" context="td[p] | th[p]">
      <report test="text()[normalize-space()] | *[name() = $inline-element-names]"
        id="NISOSTS_table-cell-paras_mixed-p_r1" role="error" diagnostics="NISOSTS_table-cell-paras_mixed-p_de">Table
        cells must not contain both paragraphs and inline elements or text. <sbf:xsl-fix
          href="xslt-fixes/table-paras.xsl" mode="fix-table-paras"/>
      </report>
    </rule>
  </pattern>

  <pattern id="NISOSTS_normalize-space-label">
    <rule id="NISOSTS_normalize-space-label_rule1"
      context="
        label[text()][every $n in node()
          satisfies ($n/self::text())]" role="warning">
      <assert test="normalize-space(.) = string(.)" id="NISOSTS_normalize-space-label_a1">The label contains additional
        whitespace that might impede subsequent ID normalization, etc. <sbf:xsl-fix href="xslt-fixes/titles.xsl"
          mode="normalize-space-label"/>
      </assert>
    </rule>
  </pattern>

  <pattern id="NISOSTS_annex-type-in-bold-title">
    <rule id="NISOSTS_annex-type-in-bold-title_rule1" context="title[bold[normalize-space()]]">
      <report test="node()[1]/self::text()[normalize-space()]" role="warning" id="NISOSTS_annex-type-in-bold-title_r1"
        >There is probably an annex-type identifier string at the beginning of a title that has also bold tags. This
        should go into an annex-type element. <sbf:xsl-fix href="xslt-fixes/titles.xsl" mode="annex-type"/>
      </report>
    </rule>
  </pattern>

  <pattern id="NISOSTS_numbering-in-bold-title">
    <rule id="NISOSTS_numbering-in-bold-title_rule1" context="title[bold[normalize-space()]]">
      <report test="node()[1]/self::text()[normalize-space()]" role="warning" id="NISOSTS_numbering-in-bold-title_r1"
        >There is probably numbering at the beginning of a title that has also bold tags. Numbering should go into a
        label. <sbf:xsl-fix href="xslt-fixes/titles.xsl" mode="label" depends-on="NISOSTS_annex-type-in-bold-title_r1"/>
      </report>
    </rule>
  </pattern>

  <pattern id="NISOSTS_bold-in-titles">
    <rule id="NISOSTS_bold-tags-in-titles_rule1" context="title">
      <report test="bold[. = '(continued)']" role="warning" id="NISOSTS_bold-tags-in-title_r2">Continuation objects may
        be problematic for subsequent processing steps. For the time being, we avoid this warning by converting the bold
        element into a named-content element. <sbf:xsl-fix href="xslt-fixes/titles.xsl" mode="continuation"
          depends-on="NISOSTS_numbering-in-bold-title_r1"/>
      </report>

    </rule>
    <rule id="NISOSTS_bold-tags-in-title" context="title">
      <report test="bold[normalize-space()]" role="warning" diagnostics="NISOSTS_bold-tags-in-title_de"
        id="NISOSTS_bold-tags-in-title_r1">Titles are usually rendered in bold so bold tags are redundant. <sbf:xsl-fix
          href="xslt-fixes/titles.xsl" mode="bold-in-title" depends-on="NISOSTS_numbering-in-bold-title_r1"/>
      </report>
    </rule>
  </pattern>

  <pattern id="NISOSTS_listitem-labels">
    <rule id="NISOSTS_listitems-labels_mixed_rule" context="list[list-item[label[normalize-space()]]]">
      <report test="list-item[not(label)]" id="NISOSTS_listitems-labels_mixed" role="warning"
        diagnostics="NISOSTS_listitems-labels_mixed_de">Not all list-items contain label elements. Maybe paragraphs
        should be moved to the preceding list-item.</report>
    </rule>
  </pattern>

  <pattern id="NISOSTS_listtype">
    <rule id="NISOSTS_plausible-listtype_roman"
      context="list[@list-type = ('roman-lower', 'roman-upper', 'lower-roman', 'upper-roman')]">
      <report test="list-item/label[not(tr:roman-to-int(replace(., '[().]', '')))]" role="error"
        diagnostics="NISOSTS_plausible-listtype_de" id="NISOSTS_plausible-listtype_roman_r1">list-type must match label
        values. Found list-type="<xsl:value-of select="@list-type"/>" with label(s) "<xsl:value-of
          select="string-join(list-item/label[not(tr:roman-to-int(replace(., '[().]', '')))], ' ')"/>".</report>
    </rule>
    <rule id="NISOSTS_plausible-listtype_alpha"
      context="list[@list-type = ('alpha-lower', 'alpha-upper', 'lower-alpha', 'upper-alpha')]">
      <report test="list-item/label[not(tr:letters-to-number(replace(., '[().]', '')))]" role="error"
        diagnostics="NISOSTS_plausible-listtype_de" id="NISOSTS_plausible-listtype_alpha_r1">list-type must match label
        values. Found list-type="<xsl:value-of select="@list-type"/>" with label(s) "<xsl:value-of
          select="string-join(list-item/label[not(tr:letters-to-number(replace(., '[().]', '')))], ' ')"/>".</report>
    </rule>
    <rule id="NISOSTS_listtype_dash"
      context="
        list[@list-type = ('dash')]
        [xs:decimal($target-niso-version) gt 1.0]">
      <report test="list-item/label[not(tr:letters-to-number(replace(., '[().]', '')))]" role="warning"
        id="NISOSTS_listtype_dash_r1">The recommended list-type is 'bullet' instead of 'dash'. You can specify the
        detail in the style-detail attribute. <sbf:xsl-fix href="xslt-fixes/list.xsl" mode="bullet"/>
      </report>
    </rule>
  </pattern>

  <pattern id="NISOSTS_xrefs">
    <rule id="NISOSTS_xref_rendering-infos" context="xref">
      <report
        test="
          preceding-sibling::node()[1]/self::sup[matches(., '^\s?\[$')]
          | following-sibling::node()[1]/self::sup[matches(., '^(\]|\))\s?$')]"
        role="warning" diagnostics="NISOSTS_xref_rendering-infos_de" id="NISOSTS_xref_rendering-infos_r1">Improper
        tagging of rendering information for element 'xref'.</report>
    </rule>
  </pattern>

  <pattern id="n12_table-cell_colors">
    <rule id="NISOSTS_table-cell_colors_1" context="*[self::td or self::th][matches(@style, 'background-color')]">
      <report id="NISOSTS_table-cell_colors_2"
        test="not(matches(tokenize(tokenize(@style, '\s*;\s*')[matches(., 'background-color')], '\s*:\s*')[2], '^#[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]\s*$', 'i'))"
        role="warning" diagnostics="NISOSTS_table-cell_colors_2_de">Background-color must be represented by a hex code
          <sbf:xsl-fix href="xslt-fixes/table-cell_colors.xsl" mode="table-cell_colors"/>
      </report>
    </rule>
  </pattern>

  <pattern id="dtd-version">
    <rule id="NISOSTS_dtd-version_missing_rule" context="/*">
      <report id="NISOSTS_dtd-version_missing" test="empty(@dtd-version)" role="info">The dtd-version attribute on the
        top-level element is not specified. It is recommended to be set even when using XSD or RNG validation. It will
        be autocorrected to <xsl:value-of select="$target-niso-version"/>. <sbf:xsl-fix href="xslt-fixes/dtd-version.xsl"
          mode="dtd-version">
          <sbf:param name="target-niso-version"><xsl:value-of select="$target-niso-version"/></sbf:param>
        </sbf:xsl-fix>
      </report>
    </rule>
    <rule id="NISOSTS_dtd-version_different_rule" context="/*">
      <report id="NISOSTS_dtd-version_different" test="not(@dtd-version = $target-niso-version)" role="info">The
        dtd-version attribute on the top-level element is different from the target version. It will be autocorrected to
          <xsl:value-of select="$target-niso-version"/>
        <sbf:xsl-fix href="xslt-fixes/dtd-version.xsl" mode="dtd-version">
          <sbf:param name="target-niso-version"><xsl:value-of select="$target-niso-version"/></sbf:param>
        </sbf:xsl-fix></report>
    </rule>
  </pattern>

  <pattern id="lang">
    <rule id="content-language" context="content-language">
      <assert test="matches(., '^\p{Ll}{2}$')" role="warning" id="content-language-iso639-1">content-language must
        contain a 2-letter lower-case ISO 639-1 language code. Current value: '<value-of select="."/>'</assert>
    </rule>
    <rule id="language-available" context="front | adoption-front | body | back">
      <assert test="isosts:lang(.)" role="warning" id="body-language-available">The content language cannot be
        determined.</assert>
    </rule>
  </pattern>

  <pattern id="adoption-nesting">
    <rule id="adoption-nesting_rule1" context="standard/front[std-meta]">
      <let name="int" value="std-meta[isosts:std-meta-type(.) = 'international'][1]"/>
      <let name="reg" value="std-meta[isosts:std-meta-type(.) = 'regional'][1]"/>
      <let name="nat" value="std-meta[isosts:std-meta-type(.) = 'national'][1]"/>
      <report id="adoption-nesting_r1" role="error" test="count($int | $reg | $nat) gt 1">Use adoption nesting for
        adopted standards. <sbf:xsl-fix href="xslt-fixes/nesting.xsl" mode="create-adoptions"/>
      </report>
    </rule>
  </pattern>

  <pattern id="app-norm-inform">
    <!-- https://gitlab.com/DIN-XML/STS/-/issues/28 -->
    <rule id="app_has_correct_values" context="app">
      <report role="warning" id="app_no_content-type" test="not(@content-type)"><name/> has no content-type. <xsl:if
          test="empty(annex-type)"> If there were an annex-type we could infer the content-type attribute </xsl:if>
        <sbf:xsl-fix href="xslt-fixes/app-type.xsl" mode="content-type"/>
      </report>
      <report role="error" id="app_wrong_content-type"
        test="exists(@content-type) and not(@content-type = ('norm-annex', 'inform-annex', 'bibl'))">The content-type of
        an app has to be either "norm-annex", "inform-annex" or "bibl". <sbf:xsl-fix href="xslt-fixes/app-type.xsl"
          mode="content-type"/>
      </report>
      <report role="warning" id="app_no_annex-type" test="not(@content-type = 'bibl') and not(annex-type)"><name/> has
        no annex-type. CEN/CENELEC Internal Regulations Part 3: &#x201c;The annex heading shall be followed by the
        indication "(normative)" or "(informative)"&#x2026;&#x201d; </report>
    </rule>
    <rule id="annex-type-normative-text-available" context="annex-type[parent::app/@content-type = 'norm-annex']">
      <assert role="warning" id="annex-type-text-available1"
        test="exists(isosts:i18n-strings('annex-type-normative', .))">No normative annex type available for language
          '<value-of select="isosts:lang(.)"/>'. </assert>
    </rule>
    <rule id="annex-type-normative-text" context="annex-type[parent::app/@content-type = 'norm-annex']">
      <let name="expected" value="concat('(', isosts:i18n-strings('annex-type-normative', .), ')')"/>
      <assert role="warning" id="annex-type-text-a1" test=". = $expected"><name/> should be '<value-of
          select="$expected"/>'. <sbf:xsl-fix href="xslt-fixes/app-type.xsl" mode="annex-type"/>
      </assert>
    </rule>
    <rule id="annex-type-inform-text-available" context="annex-type[parent::app/@content-type = 'inform-annex']">
      <assert role="warning" id="annex-type-text-available2"
        test="exists(isosts:i18n-strings('annex-type-informative', .))">No informative annex type available for language
          '<value-of select="isosts:lang(.)"/>'. </assert>
    </rule>
    <rule id="annex-type-inform-text" context="annex-type[parent::app/@content-type = 'inform-annex']">
      <let name="expected" value="concat('(', isosts:i18n-strings('annex-type-informative', .), ')')"/>
      <assert role="warning" id="annex-type-text-a2" test=". = $expected"><name/> should be '<value-of
          select="$expected"/>'. <sbf:xsl-fix href="xslt-fixes/app-type.xsl" mode="annex-type"/>
      </assert>
    </rule>
  </pattern>

  <pattern id="ref-list2app">
    <!-- Note: Putting bibliographic references into an appendix deviates from the IEC/ISO Coding Guidelines. -->
    <rule context="back">
      <report id="ref-list-back2app" test="ref-list">The element ref-list must be moved to an app with content-type
        "bibl". <sbf:xsl-fix href="xslt-fixes/ref-list.xsl" mode="ref-list-in-back"/>
      </report>
      <report id="ref-list-app-group2app" test="app-group/ref-list">The element ref-list must be moved to an app with
        content-type "bibl". <sbf:xsl-fix href="xslt-fixes/ref-list.xsl" mode="ref-list-in-app"/>
      </report>
      <report id="app-content-type" test="app[not(@content-type = 'bibl')]/ref-list">The app containing the bibliography
        needs an attribute content-type with the value "bibl". <sbf:xsl-fix href="xslt-fixes/ref-list.xsl"
          mode="content-type-for-app"/>
      </report>
    </rule>
  </pattern>

  <pattern id="index-navpointer">
    <rule id="index-navpointer-1" context="index-entry">
      <assert role="warning" test="exists(.//nav-pointer)" id="index-navpointer-2">index-entry should contain an element
        nav-pointer</assert>
    </rule>
  </pattern>

  <pattern id="math-without-mml">
    <rule id="math-without-mml-1" context="*[namespace-uri() = 'http://www.w3.org/1998/Math/MathML']">
      <assert test="starts-with(name(), 'mml:')" id="math-without-mml-2">MathML elements must have an 'mml' namespace
        prefix <sbf:xsl-fix href="xslt-fixes/mml.xsl" mode="prefix"/>
      </assert>
    </rule>
  </pattern>

  <pattern id="exclusions" abstract="true">
    <rule context="$context">
      <let name="tokenized" value="tokenize('$exclude', '\s+', 's')[normalize-space()]"/>
      <let name="intermediatelegalizers" value="tokenize('$legalizing-intermediates', '\s+', 's')[normalize-space()]"/>
      <let name="ancestorlegalizers" value="tokenize('$legalizing-ancestors', '\s+', 's')[normalize-space()]"/>
      <report
        test="
          exists(descendant::*[if ($tokenized = '*') then
            true()
          else
            name() = $tokenized]
          [if ($intermediatelegalizers)
          then
            empty(ancestor::*[name() = $intermediatelegalizers]
            [exists(ancestor::* intersect current())])
          else
            true()]
          [if ($ancestorlegalizers)
          then
            empty(ancestor::*[name() = $ancestorlegalizers])
          else
            true()])"
        id="report-illegal-nesting">In context <value-of select="'$context'"/>, the following elements are prohibited:
          <value-of select="string-join($tokenized, ', ')"/>.</report>
    </rule>
  </pattern>

  <pattern id="exclusion-non-norm" is-a="exclusions">
    <param name="context" value="non-normative-note | non-normative-example"/>
    <param name="exclude" value="non-normative-note non-normative-example note"/>
  </pattern>

  <pattern id="exclusion-note" is-a="exclusions">
    <param name="context" value="note"/>
    <param name="exclude" value="non-normative-note non-normative-example note"/>
  </pattern>

  <pattern id="exclusion-ref" is-a="exclusions">
    <param name="context" value="xref | ext-link | std"/>
    <param name="exclude" value="bold italic underlined ext-link std fn def-item xref roman sans-serif monospace"/>
    <param name="legalizing-ancestors" value="ref"/>
  </pattern>

  <pattern id="exclusion-block" is-a="exclusions">
    <param name="context" value="boxed-text | fig | supplementary-material[graphic] | table-wrap"/>
    <param name="exclude" value="boxed-text fig-group fig supplementary-material table-wrap preformat"/>
    <param name="legalizing-intermediates" value="legend"/>
  </pattern>

  <pattern id="exclusion-fig-group" is-a="exclusions">
    <param name="context" value="fig-group"/>
    <param name="exclude" value="boxed-text fig-group supplementary-material table-wrap preformat"/>
    <param name="legalizing-intermediates" value="legend"/>
  </pattern>

  <pattern id="exclusion-preformat" is-a="exclusions">
    <param name="context" value="preformat"/>
    <param name="exclude" value=" * "/>
  </pattern>

  <pattern id="exclusion-code" is-a="exclusions">
    <param name="context" value="code"/>
    <param name="exclude" value=" * "/>
  </pattern>

  <pattern id="exclusion-fn" is-a="exclusions">
    <param name="context" value="fn"/>
    <param name="exclude" value="fn"/>
  </pattern>

  <pattern id="exclusion-disp-formula" is-a="exclusions">
    <param name="context" value="disp-formula"/>
    <param name="exclude" value="disp-formula"/>
  </pattern>

  <pattern id="exclusion-graphic" is-a="exclusions">
    <param name="context" value="graphic"/>
    <param name="exclude" value="graphic"/>
  </pattern>

  <pattern id="exclusion-disp-quot" is-a="exclusions">
    <param name="context" value="disp-quot"/>
    <param name="exclude" value="disp-quot"/>
  </pattern>

  <pattern id="exclusion-array" is-a="exclusions">
    <param name="context" value="array"/>
    <param name="exclude" value="array"/>
  </pattern>

  <pattern id="exclusion-ref-list" is-a="exclusions">
    <param name="context" value="ref-list"/>
    <param name="exclude" value="ref-list"/>
  </pattern>

  <pattern id="exclusion-def-item" is-a="exclusions">
    <param name="context" value="def-item"/>
    <param name="exclude" value="def-item"/>
  </pattern>

  <pattern id="exclusion-term-entry" is-a="exclusions">
    <param name="context" value="tbx:termEntry"/>
    <param name="exclude" value="tbx:termEntry"/>
  </pattern>

  <pattern id="entailedTerm">
    <rule id="xref-to-entailedTerm"
      context="
        xref[key('by-id', @rid)/self::term-sec]
        [count(italic) = 1]
        [normalize-space(italic[1]) = //tbx:term]
        [count(text()[matches(., '\(\d+\.\d+\)')]) = 1]">
      <let name="parenthesized-term-sec-number" value="replace(text(), '[\p{Zs}\s]+\((\d+\.\d+)\)', '$1', 's')"/>
      <report
        test="
          $parenthesized-term-sec-number = key('by-id', @rid)/self::term-sec/label
          and
          normalize-space(italic[1]) = key('by-id', @rid)/self::term-sec//tbx:term"
        id="xref-to-entailedTerm_r1" role="warning">The italic term should become a tbx:entailedTerm and only the number
        in parentheses should link to the term-sec. <sbf:xsl-fix href="xslt-fixes/entailedTerm.xsl"
          mode="SN-italic-entailedTerm"/>
      </report>
    </rule>
  </pattern>

  <pattern id="release-date">
    <rule id="release-date-empty"
      context="
        std-meta[empty(release-date)]
        [exists(std-ident/year)
        or
        contains(std-ref[@type = 'dated'], ':')]"
      role="warning">
      <report test="true()" id="release-date-empty-but-fallback-exists">release-date should be given <sbf:xsl-fix
          href="xslt-fixes/release-date.xsl" mode="infer"/>
      </report>
    </rule>
    <rule id="release-date-empty2" context="std-meta[empty(release-date)]" role="warning">
      <report test="true()" id="release-date-empty-no-fallback-exists">release-date should be given (no fallback
        available)</report>
    </rule>
  </pattern>

  <pattern id="term-sec-wrapper">
    <rule
      context="
        term-sec[not(normalize-space(label))]
        [not(normalize-space(tbx:termEntry))]
        [empty(@id)]
        [term-sec]"
      id="term-sec-wrapper_rule1">
      <report test="true()" id="term-sec-wrapper_r1" role="warning">This term-sec is a wrapper around others for no
        apparent reason. <sbf:xsl-fix href="xslt-fixes/entailedTerm.xsl" mode="unwrap-empty-term-sec"/>
      </report>
    </rule>
  </pattern>


  <pattern id="change_markup_in_specififc-use">
    <rule id="change_markup_in_specififc-use_rule1" context="*[@specific-use]">
      <report id="change_markup_in_specific-use_r1" role="error" test="@specific-use = ('insert', 'delete')"> Attribute
        specific-use with value <value-of select="@specific-use"/> found in Element <name/>
      </report>
    </rule>
  </pattern>

  <pattern id="main_in_title-wrap_empty">
    <rule id="main_in_title-wrap_empty_rule1"
      context="
        title-wrap[empty(main/node())]
        [empty(compl/node())]
        [empty(main-title-wrap | compl-title-wrap | intro | intro-title-wrap)]
        [matches(full, $dash-in-space-regex)]">
      <report id="main_in_title-wrap_empty_r1" role="warning" test="true()">
        <sbf:xsl-fix href="xslt-fixes/titles.xsl" mode="title-wrap-only-full"/> Element main in title-wrap is empty.
      </report>
    </rule>
    <rule id="main_in_title-wrap_empty_rule2"
      context="
        title-wrap[empty(main/node())]
        [empty(compl/node())]
        [not(main-title-wrap | compl-title-wrap | intro-title-wrap)]
        [not(matches(full, $dash-in-space-regex))]
        [not(empty(full/node()))]">
      <report id="main_in_title-wrap_empty_r2" role="warning" test="true()">
        <sbf:xsl-fix href="xslt-fixes/titles.xsl" mode="title-wrap-only-full"/> Element 'main' in 'title-wrap' was empty and was filled with the contents of 'full'.
      </report>
    </rule>
    <rule id="main_in_main-title-wrap_empty_rule1"
      context="
        main-title-wrap[main=''][matches(subtitle, $dash-in-space-regex)]
        ">
      <report id="main_in_main-title-wrap_empty_r1" role="warning" test="true()">
        <sbf:xsl-fix href="xslt-fixes/titles.xsl" mode="main-title-wrap-only-subtitle"/>
        Element 'main' in 'main-title-wrap' is empty
      </report>
    </rule>
  </pattern>


  <pattern id="sec-type_unintended_value">
    <rule id="sec-type_unintended_value_rule1" context="sec[@sec-type = 'titlepage']">
      <report id="sec-type_unintended_value_r1" role="warning" test="true()"> '<value-of select="@sec-type"/>' is not an
        intended value for the attribute 'sec-type'. <sbf:xsl-fix href="xslt-fixes/meta.xsl" mode="meta-note"/>
      </report>
    </rule>
  </pattern>

  <pattern id="legend_title_in_table-wrap">
    <rule id="legend_title_in_table-wrap_rule1"
      context="
        legend[*[1]/self::table-wrap/caption/title]
        [isosts:is-legend-table(table-wrap[1])]">
      <report id="legend_title_in_table-wrap_r1" role="error" test="true()"> Found 'legend' where 'title' is in
        'table-wrap/caption'. <sbf:xsl-fix href="xslt-fixes/legend.xsl" mode="table-wrap-title-to-legend"/>
      </report>
    </rule>
  </pattern>

  <pattern id="entailedTerm_in_named-content">
    <rule id="entailedTerm_in_named-content_rule1" context="named-content[@content-type = 'term']">
      <report id="entailedTerm_in_named-content_r1" test="true()"> '<name/>' with '@content-type="term"' found instead
        of Element 'entailedTerm' <sbf:xsl-fix href="xslt-fixes/entailedTerm.xsl"
          mode="named-content_content-type_term_to_entailedTerm"/>
      </report>
    </rule>
  </pattern>

  <pattern id="NISO_disp-formula_alt-graphic">
    <rule id="NISO_disp-formula_alt-graphic_rule1" context="disp-formula[mml:math]/graphic">
      <report role="warning" id="NISO_disp-formula_alt-graphic_r1" test="true()">This is probably an alternative
        representation. Both should be wrapped in an alternatives element. <sbf:xsl-fix
          href="xslt-fixes/alternatives.xsl" mode="formula-alternatives" depends-on="SN-key_location_r1"/>
      </report>
    </rule>
  </pattern>
  
   <pattern id="NISO_disp-formula_alt-inline-graphic">
    <rule id="NISO_disp-formula_alt-inline-graphic_rule1" context="disp-formula[mml:math]/inline-graphic">
      <report role="warning" id="NISO_disp-formula_alt-inline-graphic_r1" test="true()">This is probably an alternative
        representation. Both should be wrapped in an alternatives element. <sbf:xsl-fix
          href="xslt-fixes/alternatives.xsl" mode="formula-alternatives" depends-on="SN-key_location_r1"/>
      </report>
    </rule>
  </pattern>
  
  <pattern id="NISO_table-wrap_alt-graphic">
    <rule id="NISO_table-wrap_alt-graphic_rule1" context="table-wrap[table]/graphic">
      <report role="warning" id="NISO_table-wrap_alt-graphic_r1" test="true()">This is probably an alternative
        representation. Both should be wrapped in an alternatives element. <sbf:xsl-fix
          href="xslt-fixes/alternatives.xsl" mode="table-alternatives" depends-on="SN-key_location_r1"/>
      </report>
    </rule>
  </pattern>

  <pattern id="continuation_footnotes">
    <rule id="continuation_footnotes_rule1" context="table-wrap-foot | fn-group">
      <report test="fn[position() gt 1][empty(label)][preceding-sibling::fn[label]]" id="continuation_footnotes_r1">
        This footnote has no label. Is it a continuation footnote? </report>
    </rule>
  </pattern>

  <pattern id="legend_is_table">
    <rule id="legend_is_table_rule1"
      context="
        fig/table-wrap[@content-type = 'key'][empty(caption/title)]
        [(table/(thead | tbody)/tr[1])[1]/*[1] ! normalize-space(.) ! lower-case(.) = isosts:i18n-strings('key-heading', .) ! lower-case(.)]">
      <report test="true()" id="legend_is_table_r1"> table-wrap appears to be a legend with a title inside a td
          <sbf:xsl-fix href="xslt-fixes/legend.xsl" mode="legend_title_in_table"/>
      </report>
    </rule>
    <rule id="legend_is_table_rule2" context="fig/table-wrap[@content-type = 'key'][empty(caption/title)]">
      <report test="true()" id="legend_is_table_r2"> table-wrap appears to be a legend without a title <sbf:xsl-fix
          href="xslt-fixes/legend.xsl" mode="legend_title_in_table"/>
      </report>
    </rule>
  </pattern>

  <pattern id="disp-formula_in_p_with_table-wrap_legend">
    <rule id="disp-formula_in_p_with_table-wrap_legend_rule1"
      context="
        p[@style-type = 'indent']
        [following-sibling::*[1]/self::table-wrap[@content-type = 'formula-index']]">
      <report id="disp-formula_in_p_with_table-wrap_legend_r1" test="true()"> This seems to be a disp-formula with
        legend. Please mark it up accordingly. <sbf:xsl-fix href="xslt-fixes/legend.xsl"
          mode="disp-formula_with_legend_from_p"/>
      </report>
    </rule>
  </pattern>

  <pattern id="disp-formula_with_array_legend">
    <rule id="disp-formula_with_array_legend_rule1"
      context="
        array
        [preceding-sibling::*[1]/self::p[matches(., isosts:i18n-strings('where-heading', .), 'i')]][preceding-sibling::*[2]/self::disp-formula]">
      <report id="disp-formula_with_array_legend_r1" test="true()"> Put this '<name/>' into a 'legend' element inside
        the preceding 'disp-formula'. The 'title' schould be "<value-of select="preceding-sibling::*[1]"/>" and is found
        in the preceding 'p'. <sbf:xsl-fix href="xslt-fixes/legend.xsl" mode="disp-formula_add_legend_from_array"/>
      </report>
    </rule>
  </pattern>

  <pattern id="disp-formula_with_table-wrap_legend">
    <rule id="disp-formula_with_table-wrap_legend_rule1"
      context="
        table-wrap[@content-type = 'formula-index']
        [preceding-sibling::*[1]/self::disp-formula]
        [caption/title]">
      <report id="disp-formula_with_table-wrap_legend_r1" test="true()"> Put this '<name/>' into a 'legend' element
        inside the preceding 'disp-formula'. The 'title' schould be "<value-of select="caption/title"/>" and is found in
        'caption/title'. <sbf:xsl-fix href="xslt-fixes/legend.xsl" mode="disp-formula_add_legend_from_table-wrap"/>
      </report>
    </rule>
  </pattern>

  <pattern id="disp-formula_with_def-list_legend">
    <rule id="disp-formula_with_def-list_legend_rule1"
      context="
        def-list
        [preceding-sibling::*[1]/self::p[matches(., isosts:i18n-strings('where-heading', .), 'i')]][preceding-sibling::*[2]/self::p/disp-formula]">
      <report id="disp-formula_with_def-list_legend_r1" test="true()"> Put this '<name/>' into a 'legend' element inside
        the preceding 'disp-formula'. The 'title' schould be "<value-of select="preceding-sibling::*[1]"/>" and is found
        in the preceding 'p'. <sbf:xsl-fix href="xslt-fixes/legend.xsl" mode="disp-formula_add_legend_from_def-list"/>
      </report>
    </rule>
  </pattern>

  <pattern id="deprecated_doc-ident">
    <rule id="deprecated_doc-ident_rule1" context="doc-ident[sdo]">
      <report id="deprecated_doc-ident_r1" test="true()"> Please use std-ident since doc-ident will be deprecated in
        future NISO STS versions. <sbf:xsl-fix href="xslt-fixes/nesting.xsl" mode="remove_doc-ident"/>
      </report>
    </rule>
  </pattern>

  <pattern id="NEN_disp-formula_legend_1">
    <rule id="NEN_disp-formula_legend_1_rule1"
      context="
        p/table-wrap[caption/title]
        [@content-type = 'formula-index'][../preceding-sibling::*[1]/self::p/disp-formula]">
      <report test="true()" id="NEN_disp-formula_legend_1_r1"> Put this '<name/>' into a 'legend' element inside the
        preceding 'disp-formula'. The 'title' schould be "<value-of select="caption/title"/>" and is found in
        'caption/title'. 
      <sbf:xsl-fix href="xslt-fixes/legend.xsl" mode="NEN_add_disp-formula_legend"/>
      </report>
    </rule>
  </pattern>

  <pattern id="NEN_disp-formula_legend_2">
    <rule id="NEN_disp-formula_legend_2_rule1"
      context="table-wrap[caption/title]
        [@content-type = 'formula-index']
        [preceding-sibling::*[1]/self::list/list-item/p/disp-formula]">
      <report test="true()" id="NEN_disp-formula_legend_2_r1"> Put this '<name/>' into a 'legend' element inside the
        preceding 'disp-formula'. The 'title' schould be "<value-of select="caption/title"/>" and is found in
        'caption/title'. 
      <sbf:xsl-fix href="xslt-fixes/legend.xsl" mode="NEN_add_disp-formula_legend_2" depends-on="NEN_disp-formula_legend_1_r1"/>
      </report>
    </rule>
  </pattern>
  
<pattern id="text_in_nat-meta">
  <rule id="text_in_nat-meta_rule1" context="nat-meta">
    <report test="text()[normalize-space(.)]" id="text_in_nat-meta_r1">
      Found text: '<value-of select="text()[normalize-space(.)]"/>'. Only elements are allowed in '<name/>'. Text was deleted
      <sbf:xsl-fix href="xslt-fixes/text.xsl" mode="delete_text_in_nat-meta"/>
    </report>
  </rule>
</pattern>
  
   <pattern id="completly_emphasized_xref">
    <let name="emphasis" value="'bold|italic|monospace|underline|sans-serif'" />
    <rule id="completly_emphasized_xref_rule1" context="xref[count(*) = 1][matches(name(*), $emphasis)]
      [not(text()[normalize-space(.)])]">
      <report test="true()" id="completly_emphasized_xref_r1">
        This <name/> seems to be emphasized. Please put the emphasis before the <name/>.
        <sbf:xsl-fix href="xslt-fixes/emphasis.xsl" mode="emphasize_xref"/>
      </report>
    </rule>
  </pattern>
  
  <pattern id="empty_doc-ref">
    <rule id="empty_doc-ref_rule1" context="doc-ref[.='']">
      <report test="true()" id="empty_doc-ref_r1">
        Found empty <name/>.
        <sbf:xsl-fix href="xslt-fixes/doc-ref.xsl" mode="fill_doc-ref"/>
      </report>
    </rule>
  </pattern>
  
  <pattern id="empty_release-date">
    <rule id="empty_release-date_rule1" context="release-date[.='']">
      <report test="true()" id="empty_release-date_r1">
        Found empty <name/>.
        <sbf:xsl-fix href="xslt-fixes/doc-ref.xsl" mode="fill_release-date"/>
      </report>
    </rule>
  </pattern>
  
  <pattern id="AFNOR_remove_enrichments">
    <let name="illegal_elements" value="'refNormative|termOcc|termDef|refCitee|exigence|figure|tableau'"/>
    <let name="elements" value="descendant::*[matches(name(), $illegal_elements)]"/>
    <rule id="AFNOR_remove_enrichments_rule1" context="/*" >
      <report test="$elements" id="AFNOR_remove_enrichments_r1" role="warning">
       <!-- Found at least on illegal element (<value-of select="$illegal_elements"/>)-->
        <value-of select="$elements ! isosts:illegal(.)"/>
        <sbf:xsl-fix href="xslt-fixes/enrichments.xsl" mode="remove_enrichments"/>
      </report>
    </rule>
  </pattern>
  
  
  <pattern id="AFNOR_array_is_disp-formula_legend">
    <rule id="AFNOR_array_is_disp-formula_legend_rule1" context="disp-formula[matches(., isosts:i18n-strings('where-heading', .), 'i')]/array[preceding-sibling::text()[1]]">
      <report test="true()" id="AFNOR_array_is_disp-formula_legend_r1" role="warning">
        This <name/> seems to be a legend.
        <sbf:xsl-fix href="xslt-fixes/legend.xsl" mode="AFNOR_disp-formula_legend"/>
      </report>
    </rule>
  </pattern>
  
   <pattern id="AFNOR_table-wrap_is_fig_legend">
    <rule id="AFNOR_table-wrap_is_fig_legend_rule1" context="table-wrap[@content-type ='fig-index']
      [empty(caption/title)]
      [(table/(thead | tbody)/tr[1])[1]/* ! normalize-space(.) ! lower-case(.) = isosts:i18n-strings('key-heading', .) ! lower-case(.)] ">
      <report test="true()" id="AFNOR_table-wrap_is_fig_legend_r1" role="warning">
        This <name/> seems to be a legend.
        <sbf:xsl-fix href="xslt-fixes/legend.xsl" mode="AFNOR_table-wrap_fig_legend"/>
      </report>
    </rule>
  </pattern>
  

<pattern id="AFNOR_wrong_punctuation_character">
    <rule id="AFNOR_wrong_punctuation_character_rule1" context="label[normalize-space()='-']">
      <report test="true()" id="AFNOR_wrong_punctuation_character_r1" role="warning">
        This <name/> uses a hyphen:<value-of select="."/> instead of a dash like: &#x2014; 
        <sbf:xsl-fix href="xslt-fixes/hyphen.xsl" mode="change_hyphen"/>
      </report>
    </rule>
  <rule id="AFNOR_wrong_punctuation_character_rule2" context="title-wrap//*">
      <report test="text()[matches(., '\s-\s')]" id="AFNOR_wrong_punctuation_character_r2" role="warning">
        This <name/> contains at least one hyphen, that should be a dash
        <sbf:xsl-fix href="xslt-fixes/hyphen.xsl" mode="change_hyphen"/>
      </report>
  </rule>
  </pattern>
  
  <pattern id="AFNOR_annex_doubled_in_label">
    <rule id="AFNOR_annex_doubled_in_label_rule1" context="app/label">
      <report test="matches(., concat($annex_label_regEx,replace($annex_label_regEx, '\^', '')), 'i')" id="AFNOR_annex_doubled_in_label_r1" role="warning">
        This <name/> seems to use the words for annex: <value-of select="."/>
         <sbf:xsl-fix href="xslt-fixes/app-type.xsl" mode="label"/>
      </report>
    </rule>
  </pattern>
  
  <!--<pattern id="wrong_language">
    <let name="language" value="//standard/front/std-meta[last()]/content-language"/>
    <rule id="wrong_language_rule1" context="//standard[front/std-meta[last()]/content-language]//*[@xml:lang]">
      <report test="not(matches(@xml:lang, $language))" id="wrong_language_r1" role="info">
        This <name/> uses <value-of select="@xml:lang"/> as value of '@xml:lang' which differs from the 'content-language': <value-of select="$language"/>
        Please check if this is correct.
      </report>
    </rule>
  </pattern>-->
  
  <pattern id="AFNOR_duplicate_dash">
    <rule id="AFNOR_duplicate_dash_rule1" context="title">
     <report test="*[1]/text()[matches(. ,'^\p{Pd}')]" id="duplicate_dash_r1" role="warning">
       The 'title' contains a dash at the beginning 
       <sbf:xsl-fix href="xslt-fixes/titles.xsl" mode="remove_dash"/>
     </report> 
    </rule>
  </pattern>
  
  <pattern id="xref_wrong_ref-type">
    <rule id="xref_wrong_ref-typep_rule1" context="xref
      [exists(key('by-id', @rid)/self::fn[ancestor::table-wrap-foot])]">
     <report test="not(matches(@ref-type, 'table-fn'))" id="xref_wrong_ref-type_r1" role="warning">
       This <name/> should have @ref-type="table-fn" instead of "<value-of select="@ref-type"/>"
       <sbf:xsl-fix href="xslt-fixes/xref.xsl" mode="change_ref-type"/>
     </report> 
    </rule>
  </pattern>
  
  <pattern id="AFNOR_terms">
    <rule id="AFNOR_wrong_term_sec_rule1" context="sec[@sec-type = 'terms']">
      <report test="not(term-sec) and
         descendant::table-wrap [table/tbody/tr ! count(td) = 2]
          [not(ancestor::table-wrap)]" id="AFNOR_wrong_term_sec_r2" role="warning">
        term-secs seem to be encoded inside a table-wrap.
        <sbf:xsl-fix href="xslt-fixes/term.xsl" mode="change_sec"/>
     </report>
    </rule>
    <rule id="AFNOR_non-normative-note_in_table-wrap_rule1" context="table-wrap[count(descendant::col) = 2]
      [matches(descendant::td[1], isosts:i18n-strings('note-label', .), 'i')]">
     <report test="true()" id="AFNOR_non-normative-note_in_table-wrap_r1" role="warning">
        non-normative-notes seem to be encoded inside <name/>.
       <sbf:xsl-fix href="xslt-fixes/term.xsl" mode="table-wrap_to_non-normative-note"/>
     </report> 
    </rule>
  </pattern>
  
  
  <diagnostics>
    <diagnostic id="NISOSTS_lib_figure_keys_r1_de" xml:lang="de">Sollte dieser Absatz kein Titel (einer Legende)
      sein?</diagnostic>
    <diagnostic id="NISOSTS_iso-like-ids_1_1_de" xml:lang="de">Eine sec- oder app-ID muss wie folgt gebildet werden:
      'sec_' + der Inhalt von label (ohne Text wie z.B. 'Anhang ').</diagnostic>
    <diagnostic id="NISOSTS_table-cell-paras_mixed-p_de" xml:lang="de">Tabellenzellen dürfen nicht sowohl Absätze als
      auch Inline-Elemente oder Text enthalten.</diagnostic>
    <diagnostic id="NISOSTS_bold-tags-in-title_de" xml:lang="de">Titel werden in der Regel fett dargestellt. Zusätzliche
      bold-Elemente können zu einer extrafetten Darstellung führen.</diagnostic>
    <diagnostic id="NISOSTS_listitems-labels_mixed_de" xml:lang="de">Nicht alle Listenelemente verfügen über ein
      label-Element. Möglicherweise handelt es sich dabei um Folgeabsätze des vorhergehenden
      Listenelementes.</diagnostic>
    <diagnostic id="NISOSTS_plausible-listtype_de" xml:lang="de">Listentyp und Inhalte der label-Elemente müssen
      zusammenpassen.</diagnostic>
    <diagnostic id="NISOSTS_xref_rendering-infos_de" xml:lang="de">Darstellungsrelevantes Tagging sollte innerhalb des
      xref-Elementes stehen.</diagnostic>
    <diagnostic id="NISOSTS_fn-without-xref_1_de" xml:lang="de">Tabellenfußnote ohne entsprechende Referenz gefunden.
      Tabellenfußnoten müssen immer referenziert werden.</diagnostic>
    <diagnostic id="NISOSTS_table-cell_colors_2_de">Background-color muss als Hex-code ausgezeichnet sein.</diagnostic>
  </diagnostics>

</schema>
