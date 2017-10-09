<?xml version="1.0" encoding="UTF-8"?>
<!--
	# =============================================================================
	# Copyright © ISO. All rights reserved.
	#
	# $LastChangedRevision$
    # $LastChangedDate$
    #
	# =============================================================================
	
	Change log
	===============================================================================
	When       Who  What
	2014-06-04 HA   Add relase-version check to urn validation
	2014-03-10 HA   Fix calculation of colspans in fct:check-table 
	2014-02-24 HA   New TBX_41 to check mutliple langSet with same language in termEntry 
	2014-01-09 HA   Change check for missing or empty copyright-statement to warning (due to legacy documents)
	2013-12-05 HA   New check for width values in table, col, colgroup
	2013-12-03 HA   Fix check for copyright statment
	2013-11-15 HA   Add correct handling of css colors
	                New check to enforce that term-sec are within a sec@sec-type="terms"
	2013-11-06 HA   New metadata checks to validate pub-year in doc-ref and std-ref
	2013-10-29 HA   Fix function to build urn from metadata
	2013-10-28 HA   New metadata check for urn
	2013-10-16 HA   New metadata checks for permissions and doc-ref
	2013-10-03 SJ   Warning notice missing in check "Safety-precautions"
	2013-05-13 HA   Add zh as valid tbx language
	                Change rule GRP_4 (name of inline graphics) to warning
	2015-09-16 HA   Fix metadata check META_8 to not check for publication year in doc-ref of DIS/FDIS
	2015-09-21 HA   Add META_11,12 to detect wrong std-ref for published documents
	2015-09-24 SJ   Added new sec-type 'index' for standards like 9000, 9001 or 14001
	2017-05-29 HA   Remove long-desc from unpermitted use (GEN_1)
	2017-07-28 HA   Add new check for external links LNK_1
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:iso="http://purl.oclc.org/dsdl/schematron" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:tbx="urn:iso:std:iso:30042:ed-1" 
    xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fct="http://www.iso.org/ns/fct"
    xmlns:css="http://www.iso.org/ns/css-parser">
    <ns uri="http://www.iso.org/isosts" prefix="i"/>
    <ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
    <ns uri="urn:iso:std:iso:30042:ed-1" prefix="tbx"/>
    <ns uri="http://www.w3.org/1998/Math/MathML" prefix="mml"/>
    <ns prefix="fct" uri="http://www.iso.org/ns/fct"/>
    <ns prefix="css" uri="http://www.iso.org/ns/css-parser"/>
        
    <!-- [1] General Guidance  -->
    <!-- [11] Use assert (fires if test is false) to ensure that something is as expected -->
    <!-- [12] Use report (fires if test is true) to report errors that can be anticipated-->
    <!-- [13] Errors are reported against the context node, so avoid testing other elements where possible -->
    <!-- [14] For ease of maintenance rules are grouped and should use unique identifier such a [TAB_1] -->
    <!-- [15] WARNING: no two rules should check the same context (all but the first is ignored) -->

    <title>ISOSTS validation $LastChangedRevision$</title>
    <pattern>

        <title>[GEN] General rules</title>
        <rule context="abbrev | ack | address | addr-line | aff | aff-alternatives | alternatives | alt-text | annotation | anonymous | attrib | author-comment | award-id | bio | chem-struct | chem-struct-wrap | conf-date | conf-loc | conf-name | conf-sponsor | contrib | contrib-group | country | def | def-head | def-item | def-list | elocation-id | fax | funding-source | glyph-data | glyph-ref | gov | inline-supplementary-material | institution | isbn | issn | journal-id | leading-org | milestone-end | milestone-start | private-char | related-article | related-object | season | speaker | speech | trans-source | trans-title | verse-group | verse-line">
            <assert test="false()" role="error">
                [GEN_1] <name/> should not be used
            </assert>
        </rule>
        
        <title>[META] Check metadata</title>
        <rule context="iso-meta">
            <assert test="permissions" role="error">
                [META_1] missing permissions in <name/> 
            </assert>
        </rule>
        <rule context="doc-ident">
            <assert test="(release-version = 'IS' and ../pub-date) or release-version != 'IS'" role="error">
                [META_2] doc-ident/release-version = IS requires element pub-date to be defined:: value '<value-of select="release-version"/>' 
            </assert>
        </rule>
        <rule context="permissions">
            <assert test="copyright-holder and copyright-year" role="error">
                [META_3] <name/> misses required copyright-holder and copyright-year
            </assert>
            <assert test="copyright-statement" role="warn">
                [META_31] <name/> misses copyright-statement
            </assert>
        </rule>
        <rule context="copyright-holder | copyright-year">
            <assert test="normalize-space() != ''" role="error">
                [META_4] <name/> must not be empty 
            </assert>
        </rule>
        <rule context="copyright-statement">
            <assert test="normalize-space() != ''" role="warn">
                [META_5] <name/> is empty 
            </assert>
        </rule>
        <rule context="content-language">
            <let name="lang" value="."/>
            <assert test="$lang = '' or preceding-sibling::title-wrap[@xml:lang = $lang]" role="error">
                [META_6] found <name/> with '<value-of select="."/>' but no title in this language 
            </assert>
        </rule>
        <rule context="doc-ref">
            <let name="pub-year" value="substring(../pub-date, 1, 4)"/>
            <let name="lang-ident" value="string-join(../content-language,',')"/>
            <assert test="matches(., concat('.*\(', $lang-ident, '\)$'))" role="error">
                [META_7] <name/>: '<value-of select="."/>' doesn't contain content-language <value-of select="$lang-ident"/>
            </assert>
            <assert test="../doc-ident/release-version != 'IS' or matches(., concat('.*:', $pub-year, '\(.*'))" role="error">
                [META_8] <name/>: '<value-of select="."/>' doesn't contain year of publication <value-of select="$pub-year"/> 
            </assert>
        </rule>
        <rule context="urn">
            <let name="urn" value="fct:build-urn(ancestor::iso-meta)"/>
            <assert test=". = $urn" role="error">
                [META_9] <name/>: <value-of select="."/> doesn't match urn build from matadata <value-of select="$urn"/> 
            </assert>
        </rule>
        <rule context="std-ref[@type='dated']">
            <let name="pub-year" value="substring(../pub-date, 1, 4)"/>
            <assert test="not(../pub-date) or ends-with(., $pub-year)" role="error">
                [META_10] <name/>[@type=dated]: <value-of select="."/> doesn't contain year of publication <value-of select="$pub-year"/> 
            </assert>
            <assert test="(../doc-ident/release-version = 'IS' and not(matches(., '.*(/FDIS|/DIS|/PRF).*'))) or ../doc-ident/release-version != 'IS'" role="error">
                [META_11] <name/>[@type=dated]: <value-of select="."/> must not contain /DIS,/FIDS,/PRF 
            </assert>
        </rule>
        <rule context="std-ref[@type='undated']">
            <assert test="(../doc-ident/release-version = 'IS' and not(matches(., '.*(/FDIS|/DIS|/PRF).*'))) or ../doc-ident/release-version != 'IS'" role="error">
                [META_12] <name/>[@type=undated]: <value-of select="."/> must not contain /DIS,/FIDS,/PRF 
            </assert>
        </rule>
        
        <title>[FRONT] Check front</title>
        <rule context="front">
            <report test="count(sec[@sec-type='foreword'])&gt;1" role="warn">
                [FRONT_1] <name/> contain more than one "foreword" sec
            </report>
            <report test="count(sec[@sec-type='intro'])&gt;1" role="warn">
                [FRONT_2] <name/> contains more than one "intro" sec
            </report>
        </rule>
        
        <rule context="front//sec">
            <report test="@sec-type and not(index-of(('intro','foreword','abstract'), @sec-type))" role="warn">
                [FRONT_3] <name/> in front not of type "intro" or "foreword" </report>
        </rule>      

        <title>[BODY] Check body</title>
        <rule context="standard/body">
            <assert test="count(.//sec[@sec-type='scope'] and not(ancestor::sub-part))=1" role="error">
                [BODY_1] <name/> should contain a single "scope" sec
            </assert>
            <assert test="count(.//sec[@sec-type='norm-refs'] and not(ancestor::sub-part))&lt;=1" role="error">
                [BODY_2] <name/> should not contain more than one "norm-refs" sec
            </assert>
        </rule>

        <title>[BACK] Check back</title>
        <rule context="standard/back">
            <assert test="count(ref-list[@content-type='bibl'])&lt;=1" role="error">
                [BACK_1] <name/> should not contain more than one ref-list (bibliography)
            </assert>
        </rule>

        <title>[SEC] Check each sec</title>
        <rule context="sec | term-sec">
            <!-- all sec should have @id except within boxed-text or sec which are not part of the structure, e.g. in corrigenda or ome prolog notes -->
            <assert test="@id or ancestor::boxed-text or (label = '' and not(title))" role="error">
                [SEC_1] <name/> must have @id
            </assert>
                
            <report test="@sec-type and not(index-of((('intro','foreword','abstract','scope','norm-refs','terms','index')), @sec-type))" role="error">
                [SEC_2] <name/> has unknown sec-type '<value-of select="@sec-type"/>'
            </report>

            <report test="@sec-type = 'norm-refs' and .//list//std" role="warn">
                [SEC_3] the norm-refs section uses std in normal list but should use ref-list
            </report>
            
            <report test="self::term-sec and not(ancestor::sec[@sec-type = 'terms'])" role="error">
                [SEC_4] <name/> must be contained in a sec wich sec-type="terms"
            </report>
        </rule>
        <rule context="sec[@sec-type='norm-refs']//ref-list/ref/std">
            <assert test="title">
                [SEC_5] std in norm-refs ref-list must have a title
            </assert>            
        </rule>
        
        <rule context="app">
            <!-- strip out parentheses, tabs and non-breaking-spaces, and remove excess spaces -->
            <let name="normlabel" value="normalize-space(translate(label,'()&#x0009;&#x00A0;','&#x0020;&#x0020;&#x0020;&#x0020;'))"/>
            <let name="labelsuffix" value="substring-after($normlabel,' ')"/>
            <let name="labelsuffix" value="if(string-length($labelsuffix)=0) then $normlabel else $labelsuffix"/>

            <assert test="matches(@id, '^sec_[\w\._]+$')" role="warn">
                [SEC_5] <name/> should have id="<value-of select="concat('sec_',$labelsuffix)"/>"
            </assert>
            <assert test="count(label)=1" role="error">
                [SEC_6] <name/> should contain a label
            </assert>
            <assert test="count(title)=1" role="error">
                [SEC_7] <name/> should contain a title
            </assert>
        </rule>
        
        <title>[FN] Check footnote</title>
        <rule context="fn">
            <assert test="@id or ancestor::fig or ancestor::table-wrap" role="error">
                [FN_1] <name/> should have an id 
            </assert>
            <report test="not(ancestor::table-wrap) and not(ancestor::fig) and @id and not(matches(@id,'fn_\d+'))" role="warn">
                [FN_2] @id of <name/> should be "fn_" followed by sequential number # 
            </report>
            <report test="ancestor::table-wrap[not(contains(@content-type, 'index'))] and @id and not(starts-with(@id, 'table-fn_'))" role="warn">
                [FN_3] @id of <name/> should be "table-fn_" followed by footnote # (table footnote)
            </report>
        </rule>

        <title>[NOTE] Check non-normative-note and non-normative-example</title>
        <rule context="non-normative-note | non-normative-example">
            <assert test="label" role="warn">
                [NOTE_1] <name/> should have a label
            </assert>
            <report test="@content-type and not(index-of(('warning','important','caution','danger','safety-precautions'), @content-type))" role="error">
                [NOTE_2] <name/> has an invalid content-type
            </report>
        </rule>

        <title>[TAB] Check table-wrap</title>
        <rule context="table-wrap[label]">
            <assert test="matches(@id, '^(tab|fig)_[\w\.\-_]+$')" role="error">
                [TAB_1] <name/> with labels must have @id startig with tab_ (formal table)
            </assert>
        </rule>
        <rule context="td | th">
            <report test="@colspan and not(matches(@colspan,'^\d+$') and xs:integer(@colspan) &gt; 0)" role="error">
                [TAB_2] invalid colspan value: <value-of select="./@colspan"/>
            </report>
            <report test="@rowspan and not(matches(@rowspan,'^\d+$') and xs:integer(@rowspan) &gt; 0)" role="error">
                [TAB_3] invalid rowspan value: <value-of select="./@rowspan"/>
            </report>
            <let name="css" value="css:parse(@style)"/>
            <report test="@style and $css//css:error" role="error">
                [TAB_4] problem in CSS <value-of select="$css//css:error"/>
            </report>
        </rule>
        <rule context="table">
            <assert test="not(@width) or matches(@width, '^\d+(\.\d+)?(px|pt|[%])?$')" role="error">
                [TAB_5] attribute width for table is not a valid decimal @width=<value-of select="@width"/>
            </assert> 
            <let name="errors" value="fct:check-table(.)"/>
            <assert test="count($errors) = 0" role="error">
                [TAB_6] problem in table with @id=<value-of select="ancestor::table-wrap/@id"/>: <value-of select="$errors"/>
            </assert>
            <let name="css" value="css:parse(@style)"/>
            <report test="@style and $css//css:error" role="error">
                [TAB_7] problem in CSS <value-of select="$css//css:error"/>
            </report>            
        </rule>
        <rule context="col/@width | colgroup/@width">
            <assert test="matches(., '^\d+(\.\d+)?(px|pt|[%])?$')" role="error">
                [TAB_8] attribute width for <value-of select="name(parent::node())"/> is not a valid decimal @width=<value-of select="."/>
            </assert> 
        </rule>
                
        <title>[FOR] Check disp-formula</title>
        <rule context="disp-formula[@id and label]">
            <assert test="label and matches(@id, '^formula_.*$')" role="error">
                [FOR_1] <name/> containing a label should have id starting with formula_ current value: <value-of select="@id"/>
            </assert>
        </rule>
        <rule context="disp-formula[not(@id)]">
            <assert test="not(label) and not(@id)" role="error">
                [FOR_2] <name/> that doesn't contain a label should not have an id (unnumbered formula)
            </assert>
        </rule>

        <title>[MML] Check mml:math</title>
        <rule context="mml:math">
            <assert test="matches(@id,'^mml_[\w\.\-_]+$')" role="error">
                [MML_1] <name/> should have an id starting "mml_"
            </assert>
        </rule>

        <title>[FIG] Check fig</title>
        <rule context="fig">
            <!-- strip out parens, tabs and non-breaking spaces, remove excess spaces (these lines are reused) -->
            <let name="normlabel" value="normalize-space(translate(label,'()&#x0009;&#x00A0;','&#x0020;&#x0020;&#x0020;&#x0020;'))"/>
            <let name="labelsuffix" value="substring-after($normlabel,' ')"/>
            <let name="labelsuffix" value="if(string-length($labelsuffix)=0) then $normlabel else $labelsuffix"/>

            <assert test="matches(@id, '^fig_[\w\.\-_]+$')" role="error">
                [FIG_1] <name/> should have id="<value-of select="concat('fig_',$labelsuffix)"/>" matching its label
            </assert>
            <assert test="label" role="error">
                [FIG_2] <name/> should contain a label (formal figure)
            </assert>
            <assert test="caption/title" role="warn">
                [FIG_3] <name/> does not contain a title (formal figure)
            </assert>
            <assert test="graphic or array or table-wrap or p/boxed-text" role="error">
                [FIG_4] <name/> should have a graphic or table
            </assert>
        </rule>

        <title>[TBX] tbx check</title>
        <rule context="tbx:termEntry">
            <assert test="matches(@id, '^term_[\w\.]+$')" role="error">
                [TBX_1] @id of <name/> must start with term_ current value is <value-of select="@id"/> 
            </assert>
        </rule>
        <rule context="tbx:langSet">
            <let name="tbx-lang" value="@xml:lang"/>
            <assert test="index-of(('en','fr','ru','es','ar','de','zh'), @xml:lang)" role="error">
                [TBX_2] @xml:lang of <name/> contains invalid value <value-of select="@xml:lang"/> 
            </assert>
            <assert test="count(tbx:tig) = 1 or not(tbx:tig[not(tbx:normativeAuthorization)])" role="warn">
                [TBX_3] Whenever a term entry contains more than one term, you must rank them by using tbx:normativeAuthorization 
            </assert>
            <assert test="//iso-meta[content-language = $tbx-lang]" role="error">
                [TBX_4] found tbx:langSet with xml:lang=<value-of select="$tbx-lang"/> value which is not defined as content-language 
            </assert>
            <report test="count(../tbx:langSet[@xml:lang = $tbx-lang]) &gt; 1" role="error">
                [TBX_41] found more than one tbx:langSet with xml:lang=<value-of select="$tbx-lang"/> for term: <value-of select="../@id"/>
            </report>
        </rule>
        <rule context="tbx:see">
            <let name="target" value="@target"/>
            <report test="@target and //tbx:termEntry[@id=$target]" role="error">
                [TBX_5] <name/> should not be used to refer to other terms, use tbx:crossReference instead
            </report>
        </rule>
        <rule context="tbx:crossReference">
            <let name="target" value="@target"/>
            <assert test="not(@target) or //tbx:termEntry[@id=$target]" role="error">
                [TBX_6] <name/> does not reference a tbx:termEntry
            </assert>
        </rule>
        <rule context="tbx:definition">
            <assert test="not(matches(normalize-space(), '^\[.*\]$'))" role="warn">
                [TBX_7] <name/> is enclosed with square brackets [], check if this should rather be a tbx:source
            </assert>
        </rule>
        <rule context="tbx:source">
            <assert test="not(matches(normalize-space(), '^\[.*\]$'))" role="warn">
                [TBX_8] <name/> should not be enclosed with square brackets []
            </assert>
        </rule> 
        
        <title>[XREF] Check xref</title>
        <rule context="xref">
            <assert test="@ref-type" role="warn">
                [XREF_1] <name/> should have a ref-type attribute
            </assert>
            <assert test="@rid" role="error">
                [XREF_2] <name/> should have an rid attribute
            </assert>
        </rule>

        <title>[SREF] Check standard references</title>
        <rule context="ref">
            <assert test="count(std) &lt;= 1" role="error">
                [SREF_1] <name/> must contain only one std
            </assert>
        </rule>

        <title>[LBL] Check label</title>
        <rule context="sec/label | fig/label | table-wrap/label | app/label | term-sec/label">
            <report test="matches(., '.+[\s\-—\.:]$')" role="warn">
                [LBL_1] <name/> should not end in a space, tab, hyphen, m-dash, period, or colon
            </report>
        </rule>

        <title>[GRP] Check graphic</title>
        <rule context="fig/graphic">

            <!-- ensure that filenames for graphical elements of a fig include the id of the fig -->
            <assert test="matches(@xlink:href, concat('^', parent::fig/@id, '([\._][\w\.\-_]+)?$'))" role="error">
                [GRP_1] xlink:href of <name/> within fig should start with <value-of select="../@id"/>
            </assert>

            <!-- ensure that filenames have no file type extension -->
            <report test="matches(@xlink:href, '.*\.(png|PNG)$')" role="error">
                [GRP_2] xlink:href of <name/> references filename with type extension "<value-of select="@xlink:href"/>" (coding instruction)
            </report>
        </rule>
        <rule context="table-wrap[@id]/graphic">
            <assert test="matches(@xlink:href, '^(tab|img)_[\w\.\-_]+$')" role="error">
                [GRP_3] xlink:href of substitution graphic for table should be tab_# or img_#
            </assert>
        </rule>
        <rule context="graphic[not(ancestor::fig) and not(ancestor::table-wrap[@content-type='comparison']) and not(ancestor::boxed-text[@content-type='foreign-source'])]">
            <assert test="matches(@xlink:href, '^img_[\w\.\-_]+$')" role="warn">
                [GRP_4] xlink:href of inline <name/> should be img_#
            </assert>
        </rule>
        <rule context="table-wrap[@content-type='comparison']//graphic">
            <assert test="matches(@xlink:href, '^cmp_\d_[\w\.\-_]+$')" role="error">
                [GRP_5] xlink:href of inline <name/> in comparison table should be cmp_#_*
            </assert>
        </rule>
        <rule context="boxed-text[@content-type='foreign-source']//graphic">
            <assert test="matches(@xlink:href, '^fs_[\w\.\-_]+$')" role="error">
                [GRP_6] xlink:href of inline <name/> in boxed-text with @content-type='foreign-source' should start with fs_*
            </assert>
        </rule>
        
        <title>[LST] Check lists</title>
        <rule context="list">
            <assert test="@list-type" role="error">
                [LST_1] <name/> should have a list-type 
            </assert>
            <!-- lists are not allowed as child of certain elements by the DTD -->
            <report test="parent::p and not(ancestor::fn) and not(ancestor::table-wrap-foot)" role="error">
                [LST_2] <name/> must be out side of p
            </report>
        </rule>
        <rule context="list[@list-type = 'bullet']/list-item">
            <assert test="matches(label, '^[\-–−—•]$')" role="warn">
                [LST_3] <name/> of @list-type = 'bullet' should use - — • as label
            </assert>
        </rule>
        <rule context="list[@list-type = 'simple']/list-item">
            <assert test="not(label)" role="warn">
                [LST_4] <name/> of @list-type = 'simple' should not use label
            </assert>
        </rule>
        
        <title>[BIB] Check bibliography</title>
        <rule context="back/ref-list">
            <assert test="@content-type='bibl'" role="error">
                [BIB_1] <name/> should have content-type="bibl" (bibliography)
            </assert>
        </rule>        
        <rule context="ref-list[@content-type='bibl']">
            <assert test="../back" role="warn">
                [BIB_2] bibl ref-list should be direct child of back
            </assert>
            <assert test="@id" role="error">
                [BIB_3] bibl ref-list must have @id
            </assert>
        </rule>
        <rule context="back//ref-list/ref/label">
            <report test="matches(., '^\[\d+\]$') and not(ancestor::ref-list[@content-type='bibl'])" role="warn">
                [BIB_4] ref-list label with [XX] in ref-list outside the bibl ref-list found
            </report>
        </rule>

        <title>[STY] Styles</title>
        <rule context="styled-content">
            <report test="@style-type and not(index-of(('normal','addition'), @style-type))" role="error">
                [STY_1] <name/> uses unknown style-type=<value-of select="@style-type"/>
            </report>
            <let name="css" value="css:parse(@style)"/>
            <report test="@style and $css//css:error" role="error">
                [STY_2] problem in CSS <value-of select="$css//css:error"/>
            </report>            
        </rule>
        <rule context="p">
            <report test="@style-type and not(index-of(('align-left','align-right','align-center','valign-top','valign-bottom','valign-middle','indent'), @style-type))" role="error">
                [STY_3] <name/> uses unknown style-type=<value-of select="@style-type"/>
            </report>
            <let name="css" value="css:parse(@style)"/>
            <report test="@style and $css//css:error" role="error">
                [STY_4] problem in CSS <value-of select="$css//css:error"/>
            </report>            
        </rule>        

        <title>[LNK] Link definition</title>
        <rule context="ext-link">
            <assert test="matches(@xlink:href, '(http|https|ftp)://.+')" role="error">
                [LNK_1] ext-link must use http(s) or ftp protocol not refer to external resources: <value-of select="@xlink:href"/>
            </assert>
        </rule>
        
        <title>[CSS] Css definition</title>
        <rule context="*[@style]">
            <let name="css" value="css:parse(@style)"/>
            <assert test="not($css//css:error)" role="error">
                [CSS_1] problem in CSS <value-of select="$css//css:error"/>
            </assert>
        </rule>
        
        <!-- TO ADD: check that no http:// or www. strings appear outside uri tags -->
        <!-- TO ADD: check that no ISO... strings outside std-ref tags -->
        <!-- TO ADD: check for <annex-type>? -->
        
        <!-- table checks
            * valid values for span etc
            * rowspan, colspan matching
        -->

    </pattern>    

    <!-- 
        Function to validate correctness of table. 
        Currently only row and col spans are checked but more may be added when needed.
     -->
    <xsl:function name="fct:check-table" as="element(fct:error)*">
        <xsl:param name="table" as="element()"/>
        <xsl:choose>
            <!-- check for valid col and rowspan values before running the table check to avoid conversion errors, 
                 additional schematron rules should be used to point to the exact td where this is wrong -->
            <xsl:when test="$table//(@colspan|@rowspan)[not(matches(., '^\d+$'))]">
                <fct:error>invalid value in colspan or rowspan found</fct:error>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="num-cols">
                    <xsl:choose>
                        <xsl:when test="$table//col">
                            <!-- take col definitions -->
                            <xsl:value-of select="count($table//col[not(@span)]) + sum($table/colgroup/col/@span)"/>
                        </xsl:when>
                        <xsl:when test="$table/thead">
                            <!-- take first row of table header -->
                            <xsl:value-of select="count($table/thead/tr[1]/th[not(@colspan)]) + sum($table/thead/tr[1]/th/@colspan)"/>
                        </xsl:when>
                        <xsl:when test="not($table/thead) and $table/tbody">
                            <!-- take first row of table body -->
                            <xsl:value-of select="count($table/tbody/tr[1]/td[not(@colspan)]) + sum($table/tbody/tr[1]/td/@colspan)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- count cols in first row -->
                            <xsl:value-of select="count($table/tr[1]/td[not(@colspan)]) + sum($table/tr[1]/td/@colspan)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:if test="$table/thead">
                    <xsl:copy-of select="fct:check-col-row-spans($num-cols, $table/thead/tr, 1, ())"/>
                </xsl:if>
                <xsl:if test="$table/tbody">
                    <xsl:copy-of select="fct:check-col-row-spans($num-cols, $table/tbody/tr, 1, ())"/>
                </xsl:if>        
                <xsl:if test="$table/tfoot">
                    <xsl:copy-of select="fct:check-col-row-spans($num-cols, $table/tfoot/tr, 1, ())"/>
                </xsl:if>                
                <xsl:if test="$table/tr">
                    <xsl:copy-of select="fct:check-col-row-spans($num-cols, $table/tr, 1, ())"/>
                </xsl:if>                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- 
         This functions validates if row and col span are correct. 
         The function iterates (via recursion) over the list of tr elements (taken from the table)
         and passes along elements with rowspan for the calculation of next row's column.
         In case of a mismatch, an error element will be return, so that at the end of the recursion
         a list of errors can be returned.
    -->
    <xsl:function name="fct:check-col-row-spans" as="element(fct:error)*">
        <xsl:param name="num-cols" as="xs:integer"/>
        <xsl:param name="source-rows" as="element()+"/>
        <xsl:param name="index" as="xs:integer"/>
        <xsl:param name="row-spanned-cols" as="element()*"/>
        
        <!-- calculation of current number of columns is based on existing td/th elements and their colspans + any previous colums with rowspans (+ any colspan they have). 
             The spanned rows count already as colspan=1 so we have to substract 1 from every col with colspan. -->
        <xsl:variable name="curr-cols" select="count($source-rows[$index]/*[not(@colspan)]) + sum($source-rows[$index]/*/@colspan) + count($row-spanned-cols) + sum($row-spanned-cols[@colspan]/@colspan) - count($row-spanned-cols[@colspan])"/>
        <!-- select columns with rowspan for next iteration. Take it from current row columns and previous -->
        <xsl:variable name="new-rowspan" as="element()*">
            <xsl:for-each select="($source-rows[$index]/*, $row-spanned-cols)[@rowspan &gt; 1]">
                <!-- decrement rowspan because this row is already processed -->
                <td rowspan="{@rowspan - 1}">
                    <!-- copy existing colspan -->
                    <xsl:copy-of select="@colspan"/>
                </td>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:if test="$curr-cols != $num-cols">
            <fct:error><xsl:value-of select="node-name($source-rows/..)"/>: invalid col count in row=<xsl:value-of select="$index"/> (required=<xsl:value-of select="$num-cols"/>, calculated=<xsl:value-of select="$curr-cols"/>)</fct:error>
        </xsl:if>
        
        <xsl:if test="$index &lt; count($source-rows)">
            <xsl:copy-of select="fct:check-col-row-spans($num-cols, $source-rows, $index+1, $new-rowspan)"/>
        </xsl:if>
    </xsl:function>

    <!-- CSS parser -->
    <xsl:function name="css:parse" as="element(css:css)*">
        <xsl:param name="style"/>
        <css:css>
            <xsl:if test="normalize-space($style)">                
                <xsl:for-each select="tokenize($style, ';')">
                    <xsl:variable name="css-def" select="."/>
                    <xsl:variable name="css-prop-name" select="normalize-space(substring-before($css-def,':'))"/>
                    <xsl:variable name="css-prop-values" select="normalize-space(substring-after($css-def,':'))"/>
                    <xsl:choose>
                        <xsl:when test="not($css-def)">
                            <!-- can be empty due to starting or ending ; -->
                        </xsl:when>
                        <xsl:when test="not($css-prop-values)">
                            <css:error>css property without values: <xsl:value-of select="$css-def"/></css:error>
                        </xsl:when>
                        <xsl:when test="not($css-prop-name)">
                            <css:error>empty css property name found before colon <xsl:value-of select="$css-def"/></css:error>
                        </xsl:when>
                        <xsl:when test="not(matches($css-prop-name,'^[a-z][a-z0-9\-]+$'))">
                            <css:error>invalid css property name: '<xsl:value-of select="$css-prop-name"/>'</css:error>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="css:{$css-prop-name}">
                                <xsl:choose>
                                    <xsl:when test="$css-prop-name = 'font-family'">
                                        <xsl:copy-of select="css:build-font-family-values($css-prop-values)"/>
                                    </xsl:when>
                                    <xsl:when test="matches($css-prop-name, '.*color.*')">
                                        <xsl:copy-of select="css:build-color-values($css-prop-values)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:copy-of select="css:build-generic-values($css-prop-values)"/>                                        
                                    </xsl:otherwise>
                                </xsl:choose>                                
                            </xsl:element>                            
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>
        </css:css>
    </xsl:function>
    
    <xsl:function name="css:build-generic-values" as="element()*">
        <xsl:param name="value-string"/>
        <xsl:for-each select="tokenize($value-string, '\s')">
            <xsl:variable name="css-prop-value" select="normalize-space(.)"/>
            <xsl:choose>
                <xsl:when test="matches($css-prop-value, '^(\d+\.?\d*)(px|pt|em)?$')">
                    <xsl:analyze-string select="$css-prop-value" regex="^(\d+\.?\d*)(px|pt|em)?$">
                        <xsl:matching-substring>
                            <css:dimension>
                                <xsl:choose>
                                    <xsl:when test="regex-group(2)">
                                        <xsl:attribute name="unit" select="regex-group(2)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="unit">px</xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="regex-group(1)"/>
                            </css:dimension>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:when test="matches($css-prop-value, '^([a-z]+)\((.*)\)$')">
                    <xsl:analyze-string select="$css-prop-value" regex="^([a-z]+)\((.*)\)$">
                        <xsl:matching-substring>
                            <xsl:element name="css:{regex-group(1)}">
                                <xsl:value-of select="regex-group(2)"/>
                            </xsl:element>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:when test="contains($css-prop-value,':')">
                    <css:error>invalid style-value found: <xsl:value-of select="$css-prop-value"/></css:error>
                </xsl:when>
                <xsl:when test="not(matches($css-prop-value,'^[a-z][a-z0-9\-]+$'))">
                    <css:error>invalid style-value found: <xsl:value-of select="$css-prop-value"/></css:error>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="css:{$css-prop-value}"/>                                            
                </xsl:otherwise>            
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
    
    <xsl:function name="css:build-color-values" as="element()*">
        <xsl:param name="value-string"/>
        <xsl:variable name="css-prop-value" select="lower-case(normalize-space($value-string))"/>
        <xsl:choose>
            <!-- match hex colors such as #ff0000 -->
            <xsl:when test="matches($css-prop-value, '^#[a-f0-9]{6}$')">
                <css:color type="hex"><xsl:value-of select="$css-prop-value"/></css:color>
            </xsl:when>
            <!-- match color names, such as blue -->
            <xsl:when test="matches($css-prop-value, '^\w+$')">
                <css:color type="named"><xsl:value-of select="$css-prop-value"/></css:color>
            </xsl:when>
            <!-- match rgb(127, 127, 127) -->
            <xsl:when test="matches($css-prop-value, '^rgb\(\s*\d{1,3}\s*,\s*\d{1,3}\s*,\s*\d{1,3}\s*\)$')">
                <css:color type="rgb"><xsl:value-of select="$css-prop-value"/></css:color>
            </xsl:when>
            <xsl:otherwise>
                <css:error>invalid value for color style-value found: <xsl:value-of select="$css-prop-value"/></css:error>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="css:build-font-family-values" as="element()*">
        <xsl:param name="value-string"/>
        <xsl:for-each select="tokenize($value-string, ',')">
            <css:font name="{.}"/>
        </xsl:for-each>
    </xsl:function>

    <!-- 
        Function to build urn form metadata 
     -->
    <xsl:function name="fct:build-urn" as="xs:string">
        <xsl:param name="iso-meta" as="element(iso-meta)"/>
        <xsl:variable name="urn">
         <xsl:text>iso:std:</xsl:text> 
         <xsl:value-of select="replace(lower-case($iso-meta/std-ident/originator), '/', '-')"/>
         <xsl:if test="$iso-meta/std-ident/doc-type != 'IS'">
             <xsl:text>:</xsl:text>
             <xsl:value-of select="replace(lower-case($iso-meta/std-ident/doc-type), '/', '-')"/>             
         </xsl:if>
         <xsl:text>:</xsl:text>
         <xsl:value-of select="$iso-meta/std-ident/doc-number"/>
         <xsl:if test="$iso-meta/std-ident/part-number != ''">
             <xsl:text>:-</xsl:text>
             <xsl:value-of select="$iso-meta/std-ident/part-number"/>
         </xsl:if>
         <xsl:if test="$iso-meta/doc-ident/release-version != 'IS'">
             <xsl:text>:</xsl:text>
             <xsl:value-of select="lower-case($iso-meta/doc-ident/release-version)"/>
         </xsl:if>
         <xsl:text>:ed-</xsl:text>
         <xsl:value-of select="$iso-meta/std-ident/edition"/>
         <xsl:text>:v</xsl:text>
         <xsl:value-of select="$iso-meta/std-ident/version"/>
         <xsl:if test="$iso-meta/std-ident/suppl-type != ''">
             <xsl:text>:</xsl:text>
             <xsl:value-of select="$iso-meta/std-ident/suppl-type"/>
             <xsl:text>:</xsl:text>
             <xsl:value-of select="$iso-meta/std-ident/suppl-number"/>
             <xsl:text>:v</xsl:text>
             <xsl:value-of select="$iso-meta/std-ident/suppl-version"/>
         </xsl:if>
         <xsl:text>:</xsl:text>
         <xsl:value-of select="string-join($iso-meta/content-language, ',')"/>
        </xsl:variable>
        <xsl:value-of select="normalize-space($urn)"/>
    </xsl:function>
</schema>
