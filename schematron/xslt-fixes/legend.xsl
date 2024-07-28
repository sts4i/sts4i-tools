<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  exclude-result-prefixes="sc xs isosts" version="3.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>

  <xsl:template match="fig[caption][table-wrap[@content-type = 'fig-index'][caption/title]]/caption" mode="legends">
    <xsl:next-match/>
    <xsl:apply-templates select="../table-wrap[@content-type = 'fig-index'][caption/title]" mode="create-legends"/>
  </xsl:template>

  <xsl:template match="fig[caption]/table-wrap[@content-type = 'fig-index'][caption/title]" mode="legends"/>

  <xsl:template match="fig[caption][table-wrap[@content-type = 'fig-index'][caption/title]]/fn-group" mode="legends"/>

  <xsl:template match="fig[caption]/table-wrap[@content-type = 'fig-index'][caption/title]" mode="create-legends">
    <legend>
      <xsl:apply-templates select="caption/title" mode="#current"/>
      <xsl:next-match>
        <xsl:with-param name="suppress" as="node()*" tunnel="yes" select="caption"/>
      </xsl:next-match>
      <xsl:apply-templates select="../fn-group" mode="#current"/>
    </legend>
  </xsl:template>

  <xsl:template match="fig[caption][table-wrap[@content-type = 'fig-index'][caption/title]]/fn-group"
    mode="create-legends">
    <def-list list-type="footnotes">
      <xsl:apply-templates select="fn" mode="#current"/>
    </def-list>
  </xsl:template>

  <xsl:template match="fn" mode="create-legends">
    <def-item>
      <term>
        <xsl:apply-templates select="label/node()" mode="#current"/>
      </term>
      <def>
        <xsl:apply-templates select="* except label" mode="#current"/>
      </def>
    </def-item>
  </xsl:template>

  <xsl:template match="fn/label/sup" mode="create-legends">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="*" mode="legends create-legends">
    <xsl:param name="suppress" as="node()*" tunnel="yes"/>
    <xsl:if test="empty(. intersect $suppress)">
      <xsl:next-match/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="
      fig[non-normative-note[@content-type = 'explanatory']]
      /graphic[1]"
    mode="SN-legends">
    <legend>
      <xsl:apply-templates mode="#current"
        select="../non-normative-note[@content-type = 'explanatory']/(@* except @content-type, node())"/>
    </legend>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="fig[graphic]/non-normative-note[@content-type = 'explanatory']" mode="SN-legends"/>

  <xsl:template
    match="
      non-normative-note[@content-type = 'explanatory'][empty(title)]/label
      | non-normative-note[@content-type = 'explanatory'][empty(title)][empty(label)][*[2]/self::def-list]/*[1][self::p]"
    mode="SN-legends">
    <title>
      <xsl:apply-templates mode="#current"/>
    </title>
  </xsl:template>

  <xsl:template mode="table-key"
    match="table-wrap[table-wrap-foot[fn[1][lower-case(isosts:i18n-strings('key-heading', .)) = lower-case(normalize-space(.))]]]/caption">
    <xsl:next-match/>
    <legend>
      <xsl:apply-templates select="../table-wrap-foot/fn[empty(label)][1]" mode="table-key-to-legend"/>
      <def-list>
        <xsl:apply-templates select="../table-wrap-foot/fn[empty(label)][position() gt 1]" mode="table-key-to-legend"/>
      </def-list>
    </legend>
  </xsl:template>
  <xsl:template match="fn[1]" mode="table-key-to-legend">
    <title>
      <xsl:value-of select="normalize-space(.)"/>
    </title>
  </xsl:template>

  <xsl:template match="fn/p[1]" mode="table-key-to-legend">
    <xsl:variable name="first-text-node" select="text()[1]"/>
    <def-item>
      <term>
        <xsl:sequence select="node()[$first-text-node >> .]"/>
      </term>
      <def>
        <p>
          <xsl:value-of select="replace($first-text-node, '^\s+', '')"/>
          <xsl:sequence select="node()[. >> $first-text-node]"/>
        </p>
        <xsl:apply-templates select="../*[position() gt 1]" mode="#current"/>
      </def>
    </def-item>
  </xsl:template>
  <xsl:template mode="table-key" match="table-wrap-foot/fn[empty(label)]"/>

  <xsl:template match="fn" mode="table-key-to-legend">
    <xsl:apply-templates select="p[1]" mode="#current"/>
  </xsl:template>


  <xsl:template match="
      legend[*[1]/self::table-wrap/caption/title]
      [isosts:is-legend-table(table-wrap[1])]"
    mode="table-wrap-title-to-legend">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*" mode="#current"/>
      <array>
        <xsl:apply-templates select="table-wrap[1]/(@* except @position, table)" mode="#current"/>
      </array>
    </xsl:copy>
  </xsl:template>

  <xsl:template
    match="
      fig[def-list/title = isosts:i18n-strings('key-heading', .)
      or def-list/@list-content = 'figure']"
    mode="legends">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="
          @*, editing-instructions,
          object-id, label, caption"
        mode="#current"/>
      <legend>
        <xsl:apply-templates select="def-list/title" mode="#current"/>
        <def-list>
          <xsl:apply-templates select="def-list/@*, def-list/* except (def-list/title)" mode="#current"/>
        </def-list>
      </legend>
      <xsl:apply-templates
        select="
          node() except (editing-instructions,
          object-id, label, caption, def-list)"
        mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="
      fig[table-wrap/@content-type = 'key']
      [table-wrap[empty(caption/title)]]"
    mode="legend_title_in_table">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="
          @*, editing-instructions,
          object-id, label, caption"
        mode="#current"/>
      <legend>
        <xsl:variable name="title"
          select="table-wrap/(table/(thead | tbody)/tr[1])[1][lower-case(normalize-space(.)) = isosts:i18n-strings('key-heading', .) ! lower-case(.)]"/>
        <xsl:if test="$title">
          <title>
            <xsl:value-of select="$title"/>
          </title>
        </xsl:if>
        <table-wrap>
          <xsl:apply-templates select="table-wrap/@*, table-wrap/*" mode="#current"/>
        </table-wrap>
      </legend>
      <xsl:apply-templates
        select="
          node() except (editing-instructions,
          object-id, label, caption, table-wrap)"
        mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template
    match="
      table-wrap/table/*/tr[. is (ancestor::table[1]/(thead | tbody)/tr[1])[1]]
      [lower-case(normalize-space(.)) = isosts:i18n-strings('key-heading', .) ! lower-case(.)]"
    mode="legend_title_in_table"/>

  <xsl:template mode="disp-formula_with_legend_from_p"
    match="
      p[@style-type = 'indent']
      [following-sibling::*[1]/self::table-wrap[@content-type = 'formula-index']]">
    <disp-formula>
      <xsl:apply-templates mode="#current" select="@* except @style-type, node()"/>
      <xsl:apply-templates mode="disp-formula_table-wrap_to_legend_from_p" select="following-sibling::*[1]"/>
    </disp-formula>
  </xsl:template>

  <xsl:template mode="disp-formula_with_legend_from_p"
    match="
      table-wrap[@content-type = 'formula-index']
      [preceding-sibling::*[1]/self::p[@style-type = 'indent']]"/>

  <xsl:template mode="disp-formula_table-wrap_to_legend_from_p"
    match="
      table-wrap[@content-type = 'formula-index']
      [preceding-sibling::*[1]/self::p[@style-type = 'indent']]
      [caption/title]">
    <legend>
      <xsl:apply-templates mode="#current" select="caption/title"/>
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates mode="#current" select="@*, node() except caption"/>
      </xsl:copy>
    </legend>
  </xsl:template>

  <xsl:template mode="disp-formula_add_legend_from_array"
    match="
      disp-formula
      [following-sibling::*[1]/self::p[matches(., isosts:i18n-strings('where-heading', .), 'i')]][following-sibling::*[2]/self::array]">
    <xsl:copy>
      <xsl:apply-templates mode="#current" select="@*, node()"/>
      <legend>
        <title>
          <xsl:value-of select="following-sibling::*[1]"/>
        </title>
        <xsl:apply-templates mode="disp-formula_add_array" select="following-sibling::*[2]"/>
      </legend>
    </xsl:copy>
  </xsl:template>


  <xsl:template mode="disp-formula_add_legend_from_array"
    match="
      array
      [preceding-sibling::*[1]/self::p[matches(., isosts:i18n-strings('where-heading', .), 'i')]]
      [preceding-sibling::*[2]/self::disp-formula]"/>

  <xsl:template mode="disp-formula_add_legend_from_array"
    match="
      p[matches(., isosts:i18n-strings('where-heading', .), 'i')]
      [following-sibling::*[1]/self::array]
      [preceding-sibling::*[1]/self::disp-formula]"/>


  <xsl:template mode="disp-formula_add_legend_from_table-wrap"
    match="
      disp-formula
      [following-sibling::*[1]/self::table-wrap[@content-type = 'formula-index']]">
    <xsl:copy>
      <xsl:apply-templates mode="#current" select="@*, node()"/>
      <xsl:apply-templates mode="disp-formula_add_table-wrap_to_legend" select="following-sibling::*[1]"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="disp-formula_add_legend_from_table-wrap"
    match="
      table-wrap[@content-type = 'formula-index']
      [preceding-sibling::*[1]/self::disp-formula]"/>

  <xsl:template mode="disp-formula_add_table-wrap_to_legend"
    match="
      table-wrap[@content-type = 'formula-index']
      [preceding-sibling::*[1]/self::disp-formula]
      [caption/title]">
    <legend>
      <xsl:apply-templates mode="#current" select="caption/title"/>
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates mode="#current" select="@*, node() except caption"/>
      </xsl:copy>
    </legend>
  </xsl:template>

  <xsl:template mode=" disp-formula_add_legend_from_def-list"
    match="
      disp-formula
      [../self::p/following-sibling::*[1]/self::p[matches(., isosts:i18n-strings('where-heading', .), 'i')]][../self::p/following-sibling::*[2]/self::def-list]">
    <xsl:copy>
      <xsl:apply-templates mode="#current" select="@*, node()"/>
      <legend>
        <title>
          <xsl:value-of select="../following-sibling::*[1]"/>
        </title>
        <xsl:apply-templates mode="disp-formula_add_def-ist" select="../following-sibling::*[2]"/>
      </legend>
    </xsl:copy>
  </xsl:template>


  <xsl:template mode=" disp-formula_add_legend_from_def-list"
    match="
      def-list
      [preceding-sibling::*[1]/self::p[matches(., isosts:i18n-strings('where-heading', .), 'i')]][preceding-sibling::*[2]/self::p/disp-formula]"/>

  <xsl:template mode=" disp-formula_add_legend_from_def-list"
    match="
      p[matches(., isosts:i18n-strings('where-heading', .), 'i')]
      [following-sibling::*[1]/self::def-list]
      [preceding-sibling::*[1]/self::p/disp-formula]"/>


  <xsl:template match="p/disp-formula
        [../following-sibling::*[1]/self::p/table-wrap [caption/title][@content-type = 'formula-index']]"
    mode="NEN_add_disp-formula_legend">
    <xsl:copy>
      <xsl:apply-templates mode="#current" select="@*, node()"/>
      <legend>
        <xsl:apply-templates mode="#current" select="../following-sibling::*[1]/table-wrap/caption/title"/>
        <xsl:apply-templates mode="add_table-wrap" select="../following-sibling::*[1]/table-wrap"/>
      </legend>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="p/table-wrap[caption/title]
        [@content-type = 'formula-index']
        [../preceding-sibling::*[1]/self::p/disp-formula]"
    mode="add_table-wrap">
    <xsl:copy>
      <xsl:apply-templates mode="#current" select="@*, node() except caption"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="p[table-wrap/caption/title]
        [table-wrap/@content-type = 'formula-index']
        [preceding-sibling::*[1]/self::p/disp-formula]"
    mode="NEN_add_disp-formula_legend"/>
  
  
   <xsl:template match="list/list-item/p/disp-formula 
        [../../../following-sibling::*[1]/self::table-wrap[caption/title]
        [@content-type = 'formula-index']]
        [not(legend)]"
    mode="NEN_add_disp-formula_legend_2">
    <xsl:copy>
      <xsl:apply-templates mode="#current" select="@*, node()"/>
      <legend>
        <xsl:apply-templates mode="#current" select="../../../following-sibling::*[1]/caption/title"/>
        <xsl:apply-templates mode="add_table-wrap_2" select="../../../following-sibling::*[1]"/>
      </legend>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="table-wrap[caption/title]
        [@content-type = 'formula-index']
        [preceding-sibling::*[1]/self::list/list-item/p/disp-formula]
        "
    mode="add_table-wrap_2">
    <xsl:copy>
      <xsl:apply-templates mode="#current" select="@*, node() except caption"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="table-wrap[caption/title]
        [@content-type = 'formula-index']
        [preceding-sibling::*[1]/self::list/list-item/p/disp-formula]"
    mode="NEN_add_disp-formula_legend_2"/>

<xsl:template match="disp-formula[matches(., isosts:i18n-strings('where-heading', .), 'i')]/text()[following-sibling::*[1]/self::array]" 
  mode="AFNOR_disp-formula_legend">
  <legend>
    <title>
      <xsl:value-of select="."/>
    </title>
    <xsl:apply-templates select="following-sibling::*[1]" mode="AFNOR_add_array"/>
  </legend>
</xsl:template>
  
  <xsl:template match="disp-formula[matches(., isosts:i18n-strings('where-heading', .), 'i')]/array[preceding-sibling::text()[1]]" mode="AFNOR_disp-formula_legend"/>


<xsl:template mode="AFNOR_table-wrap_fig_legend" match="fig[table-wrap/@content-type ='fig-index']
      [empty(table-wrap/caption/title)]">
       <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="
          @*, editing-instructions,
          object-id, label, caption"
        mode="#current"/>
      <legend>
        <xsl:variable name="title"
          select="table-wrap/(table/(thead | tbody)/tr[1])[1][lower-case(normalize-space(.)) = isosts:i18n-strings('key-heading', .) ! lower-case(.)]"/>
        <xsl:if test="$title">
          <title>
            <xsl:value-of select="$title"/>
          </title>
        </xsl:if>
        <table-wrap>
          <xsl:apply-templates select="table-wrap/@*, table-wrap/*" mode="#current"/>
        </table-wrap>
      </legend>
      <xsl:apply-templates
        select="
          node() except (editing-instructions,
          object-id, label, caption, table-wrap)"
        mode="#current"/>
    </xsl:copy>
</xsl:template>


  <xsl:template
    match="
      table-wrap/table/*/tr[. is (ancestor::table[1]/(thead | tbody)/tr[1])[1]]
      [lower-case(normalize-space(.)) = isosts:i18n-strings('key-heading', .) ! lower-case(.)]"
    mode="AFNOR_table-wrap_fig_legend"/>
  
  
  
   <xsl:template
    match="
      table-wrap[@content-type = 'fig-index']/table[1][count(*/tr) = 1]"
    mode="AFNOR_table-wrap_fig_legend"/>
  
  
 <xsl:template match="table-wrap[table-wrap-foot/p[matches(., isosts:i18n-strings-no-lang('key-heading'))]]" 
   mode="table-wrap-foot_p_to_legend">
    <xsl:variable name="before-legend" as="element(*)*" select="editing-instructions | object-id | label | caption"/>
    <xsl:copy>
    <xsl:apply-templates select="@*, $before-legend" mode="#current"/>
     <legend>
       <title>
         <xsl:value-of select="table-wrap-foot/p[matches(., isosts:i18n-strings-no-lang('key-heading'))]"/>
       </title>
       <xsl:apply-templates select="table-wrap-foot/p[preceding-sibling::p[matches(., isosts:i18n-strings-no-lang('key-heading'))]]" mode="add_p"/>
     </legend>
    <xsl:apply-templates select="node() except $before-legend" mode="#current"/>
    </xsl:copy>
 </xsl:template>

<xsl:template match="table-wrap-foot/p" mode="table-wrap-foot_p_to_legend"/>

<xsl:template match="table-wrap[descendant::tr[descendant::*[matches(., isosts:i18n-strings('key-heading', .))]][last()]]" mode="tr_to_legend">
    <xsl:variable name="before-legend" as="element(*)*" select="editing-instructions | object-id | label | caption"/>
    <xsl:copy>
      <xsl:apply-templates select="@*, $before-legend" mode="#current"/>
      <legend>
        <title>
          <xsl:value-of select="descendant::tr[last()]/descendant::*[matches(., isosts:i18n-strings('key-heading', .))][last()]"/>
        </title>
        <xsl:apply-templates select="descendant::tr[last()]/td/*[not(matches(., isosts:i18n-strings('key-heading', .)))]" mode="#current"/>
      </legend>
      <xsl:apply-templates select="node() except $before-legend" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="tr[descendant::*[matches(., isosts:i18n-strings('key-heading', .))]][last()]" mode="tr_to_legend"/>
  
  
<xsl:template match="disp-formula[following-sibling::*[1]/self::p[matches(., isosts:i18n-strings('where-heading', .))]]
  [following-sibling::def-list]" 
  mode="p_and_def-list_to_legend">
  <xsl:copy>
  <xsl:apply-templates select="@*, node()" mode="#current"/>
    <legend>
      <title>
        <xsl:value-of select="following-sibling::*[1]"/>
      </title>
       <xsl:apply-templates select="following-sibling::def-list[1]" mode="add_def-list"/>
    </legend>
   </xsl:copy>
</xsl:template>
  
  <xsl:template match="disp-formula[preceding-sibling::p[matches(., isosts:i18n-strings('where-heading', .))]]
  [following-sibling::*[1]/self::def-list]" 
  mode="p_and_def-list_to_legend">
  <xsl:copy>
  <xsl:apply-templates select="@*, node()" mode="#current"/>
    <legend>
       <xsl:apply-templates select="following-sibling::*[1]" mode="add_def-list"/>
    </legend>
   </xsl:copy>
</xsl:template> 
  
  
  <xsl:template mode="p_and_def-list_to_legend" 
   match="p[matches(., isosts:i18n-strings('where-heading', .))]
   [preceding-sibling::*[1]/self::disp-formula]"/>
  
  <xsl:template match="def-list[preceding-sibling::p[matches(., isosts:i18n-strings('where-heading', .))]]
    [preceding-sibling::*[position() &lt;= 2]/self::disp-formula]" 
    mode="p_and_def-list_to_legend"/>
  
  
  <xsl:template match="fig[def-list[@list-type = 'key'][following-sibling::*[1]/self::table-wrap[descendant::disp-formula]]]
    [following-sibling::*[1]/self::p[matches(., isosts:i18n-strings('where-heading', .))][following-sibling::*[1]/self::def-list]]" mode="multiple_legends">
    <xsl:variable name="before-legend" as="element(*)*" select="editing-instructions | object-id | label | caption"/>
    <xsl:copy>
      <xsl:apply-templates select="@*, $before-legend" mode="#current"/>
      <legend>
        <title>
          <xsl:value-of select="def-list[@list-type = 'key']"/>
        </title>
        <xsl:apply-templates select="def-list[@list-type = 'key']/following-sibling::*[1]" mode="add_table-wrap_with_legend"/>
      </legend>
      <xsl:apply-templates select="node() except $before-legend" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="table-wrap[descendant::disp-formula][preceding-sibling::*[1]/self::def-list[@list-type = 'key']]
    [parent::fig[following-sibling::*[1]/self::p[matches(., isosts:i18n-strings('where-heading', .))][following-sibling::*[1]/self::def-list]]]" mode="add_table-wrap_with_legend">
     <xsl:variable name="before-legend" as="element(*)*" select="editing-instructions | object-id | label | caption"/>
    <xsl:copy>
      <xsl:apply-templates select="@*, $before-legend" mode="#current"/>
      <legend>
        <title>
          <xsl:value-of select="../following-sibling::*[1]"/>
        </title>
        <xsl:apply-templates select="../following-sibling::*[1]/following-sibling::*[1]" mode="#current"/>
      </legend>
      <xsl:apply-templates select="node() except $before-legend" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="multiple_legends" match="p[preceding-sibling::*[1]/self::fig[def-list[@list-type = 'key'][following-sibling::*[1]/self::table-wrap[descendant::disp-formula]]]
    [following-sibling::*[1]/self::p[matches(., isosts:i18n-strings('where-heading', .))][following-sibling::*[1]/self::def-list]]]"/>
  
  <xsl:template mode="multiple_legends" match="def-list[preceding-sibling::*[1]/self::p[preceding-sibling::*[1]/self::fig[def-list[@list-type = 'key'][following-sibling::*[1]/self::table-wrap[descendant::disp-formula]]]
    [following-sibling::*[1]/self::p[matches(., isosts:i18n-strings('where-heading', .))][following-sibling::*[1]/self::def-list]]]]"/>
  
  <xsl:template match="def-list[@list-type = 'key'][following-sibling::*[1]/self::table-wrap[descendant::disp-formula]]
    [parent::fig[following-sibling::*[1]/self::p[matches(., isosts:i18n-strings('where-heading', .))][following-sibling::*[1]/self::def-list]]]" mode="multiple_legends"/>
  
  <xsl:template match="table-wrap[descendant::disp-formula][preceding-sibling::*[1]/self::def-list[@list-type = 'key']]
    [parent::fig[following-sibling::*[1]/self::p[matches(., isosts:i18n-strings('where-heading', .))][following-sibling::*[1]/self::def-list]]]" mode="multiple_legends"/>
  
  
</xsl:stylesheet>
