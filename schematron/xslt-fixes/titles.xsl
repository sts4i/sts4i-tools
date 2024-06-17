<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isosts="http://www.iso.org/ns/isosts"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sc="http://transpect.io/schematron-config"
  exclude-result-prefixes="sc xs isosts" version="3.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>

  <xsl:template
    match="
      *[name() = ('title', 'th')][bold]
      [every $n in node()
        satisfies (exists($n/self::bold | $n/self::text()[not(normalize-space())]))]/bold"
    mode="bold-in-title" priority="2">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template
    match="
      *[name() = ('title', 'th')][bold]
      [every $n in node()
        satisfies (exists($n/self::bold | $n/self::text()[not(normalize-space())]))]
      /node()[position() = (1, last())][self::text()]"
    mode="bold-in-title" priority="2">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="*[name() = ('title', 'th')][bold]" mode="bold-in-title">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:try>
        <xsl:for-each-group select="node()" group-adjacent="isosts:title-node-type(., ())[1]">
          <xsl:choose>
            <xsl:when test="current-grouping-key() = 'ignorable'"/>
            <xsl:when test="current-grouping-key() = 'bold'">
              <xsl:apply-templates select="current-group()" mode="bold-in-title-with-formula"/>
            </xsl:when>
            <xsl:when test="current-grouping-key() = 'inline-formula'">
              <xsl:if test="isosts:title-node-type(., ()) = 'ws'">
                <xsl:value-of select="replace(., '^(\s+).+', '$1')"/>
              </xsl:if>
              <inline-formula>
                <xsl:apply-templates select="current-group()" mode="bold-in-title-with-formula"/>
              </inline-formula>
            </xsl:when>
            <xsl:when test="current-grouping-key() = 'ws'">
              <xsl:apply-templates select="current-group()" mode="bold-in-title"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="current-group()" mode="bold-in-title"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each-group>
        <xsl:catch>
          <xsl:apply-templates mode="#current"/>
        </xsl:catch>
      </xsl:try>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="bold" mode="bold-in-title-with-formula">
    <xsl:apply-templates mode="bold-in-title"/>
  </xsl:template>

  <xsl:template
    match="
      *[name() = ('title', 'th')]
      [bold]/text()[../name() = ('title', 'th') (: this predicate suppresses an error message in Saxon 10.6 that tried to match text() in italic :)]
      [isosts:title-node-type(., ()) = 'inline-formula'
      and
      isosts:title-node-type(., ()) = 'ws']"
    mode="bold-in-title-with-formula">
    <xsl:value-of select="replace(., '^(\s+)(.+)', '$2')"/>
  </xsl:template>

  <xsl:function name="isosts:title-node-type" as="xs:string+">
    <xsl:param name="n" as="node()?"/>
    <xsl:param name="seen" as="node()*"/>
    <xsl:choose>
      <xsl:when
        test="
          $n/self::bold[matches(., '^[\p{P}\p{L}\d]+$')]
          (:[preceding-sibling::*[1][isosts:title-node-type(., ($n, $seen)) = 'inline-formula']]:)
          [following-sibling::*[1][isosts:title-node-type(., ($n, $seen)) = 'inline-formula']]">
        <xsl:sequence select="'inline-formula'"/>
      </xsl:when>
      <xsl:when test="exists($seen intersect $n)">
        <xsl:sequence select="'unknown'"/>
      </xsl:when>
      <xsl:when test="empty($n)">
        <xsl:sequence select="'ws'"/>
      </xsl:when>
      <xsl:when test="$n/self::break">
        <xsl:sequence select="'ws'"/>
      </xsl:when>
      <xsl:when test="$n[. is ../node()[1]][matches(., '^\s+$', 's')][following-sibling::bold]">
        <xsl:sequence select="'ignorable'"/>
      </xsl:when>
      <xsl:when test="$n[. is ../node()[last()]][matches(., '^\s+$', 's')]">
        <xsl:sequence select="'ignorable'"/>
      </xsl:when>
      <xsl:when
        test="
          $n[matches(., '^\s+$', 's')][preceding-sibling::node()[not(isosts:title-node-type(., (., $seen)) = ('ignorable', 'ws'))][1]/self::bold]
          [following-sibling::node()[not(isosts:title-node-type(., (., $seen)) = ('ignorable', 'ws'))][1]/self::bold]">
        <xsl:sequence select="'ws'"/>
      </xsl:when>
      <xsl:when
        test="
          $n/self::bold
          and
          $n/preceding-sibling::node()[1][isosts:title-node-type(., ($seen, $n)) = 'inline-formula']
          and
          $n/following-sibling::node()[1][isosts:title-node-type(., ($seen, $n)) = 'inline-formula']">
        <xsl:sequence select="'inline-formula'"/>
      </xsl:when>
      <xsl:when
        test="
          $n/self::text()[preceding-sibling::*[1][isosts:title-node-type(., ($n, $seen)) = 'inline-formula']]
          [following-sibling::*[1][isosts:title-node-type(., ($n, $seen)) = 'inline-formula']]
          [matches(., '^\s+\S')]">
        <xsl:sequence select="'inline-formula'"/>
      </xsl:when>
      <xsl:when test="$n/self::bold">
        <xsl:sequence select="'bold'"/>
      </xsl:when>
      <xsl:when
        test="$n/self::text()[preceding-sibling::node()[1]/self::bold[not(isosts:title-node-type(., ($n, $seen)) = 'inline-formula')]][matches(., '^\s+\S')]">
        <xsl:sequence select="('inline-formula', 'ws')"/>
      </xsl:when>
      <xsl:when test="$n/self::text()[matches(., '^\p{P}$')]">
        <xsl:sequence select="'inline-formula'"/>
      </xsl:when>
      <xsl:when test="$n/(self::italic | self::sub | self::sup)">
        <xsl:sequence select="'inline-formula'"/>
      </xsl:when>
      <xsl:when
        test="
          matches($n, '^\s+$', 's')
          and
          $n/preceding-sibling::node()[1][isosts:title-node-type(., ($seen, $n)) = 'inline-formula']
          and
          $n/following-sibling::node()[1][isosts:title-node-type(., ($seen, $n)) = 'inline-formula']">
        <xsl:sequence select="'inline-formula'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="{$fail-on-error}"
          select="
            'isosts:title-node-type(): unknown node type for ''', $n, ''' (node ', isosts:index-of($n/../node(), $n), ') in ', $n/..,
            '&#xa;  Types: ', $n/../node() ! string-join((name(.), isosts:title-node-type(., ($n, $seen))), ':')"/>
        <xsl:sequence select="'unknown'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:variable name="annex-type-regex" as="xs:string" select="'^\s*(\((normative?|informative?)\))[\s\p{Zs}]+$'"/>

  <xsl:template match="app[empty(annex-type)]/title[node()[1]/self::text()[matches(., $annex-type-regex)]]"
    mode="annex-type">
    <annex-type>
      <xsl:value-of select="replace(node()[1], $annex-type-regex, '$1')"/>
    </annex-type>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="app[empty(annex-type)]/title[node()[1]/self::text()[matches(., $annex-type-regex)]]/node()[1]"
    mode="annex-type"/>


  <xsl:variable name="label-regex" as="xs:string" select="'^\s*(([NZ]?[A-Z]|\d+)(\.\d+)*)[\s\p{Zs}]+$'"/>

  <xsl:template
    match="title[empty(../label | ../self::caption/../label)][node()[1]/self::text()[matches(., $label-regex)]]/node()[1]"
    mode="label"/>

  <xsl:template match="title[empty(../label | parent::caption)][node()[1]/self::text()[matches(., $label-regex)]]"
    mode="label">
    <label>
      <xsl:value-of select="replace(node()[1], $label-regex, '$1')"/>
    </label>
    <xsl:next-match/>
  </xsl:template>



  <xsl:template match="caption[empty(../label)][title/node()[1]/self::text()[matches(., $label-regex)]]" mode="label">
    <label>
      <xsl:value-of select="replace(title/node()[1], $label-regex, '$1')"/>
    </label>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="caption[not(../label)][title/node()[1]/self::text()[matches(., $table_label_regEx)]]" mode="label">
    <label>
      <xsl:value-of select="normalize-space(replace(title/node()[1], $table_label_regEx, '$1'))"/>
    </label>
  </xsl:template>

  <xsl:template
    match="title[empty(../label | ../self::caption/../label)][node()[1]/self::text()[matches(., $table_label_regEx)]]/node()[1]"
    mode="label"/>



  <xsl:template
    match="
      label[text()][every $n in node()
        satisfies ($n/self::text())]
      [not(normalize-space(.) = string(.))]"
    mode="normalize-space-label">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="continuation" match="title/bold[. = '(continued)']">
    <named-content content-type="continuation-note">
      <xsl:apply-templates select="@* | node()" mode="#current"/>
    </named-content>
  </xsl:template>

  <xsl:template
    match="
      title-wrap[empty(main/node())]
      [empty(compl/node())]
      [empty(main-title-wrap | compl-title-wrap | intro | intro-title-wrap)]
      [matches(full, $dash-in-space-regex)]"
    mode="title-wrap-only-full">
    <xsl:variable name="split-full" as="element(full)">
      <xsl:apply-templates select="full" mode="title-wrap-only-full_sep"/>
    </xsl:variable>
    <xsl:variable name="selected-sep" as="element(sep)"
      select="($split-full/sep[following-sibling::node()[1]/self::text()[matches(., '^(Part(ie)?|Teil)[\s\p{Zs}]+\d')]], $split-full/sep[1])[1]"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*" mode="#current"/>
      <main>
        <xsl:apply-templates select="main/@*" mode="#current"/>
        <xsl:apply-templates select="$split-full/node()[$selected-sep >> .]" mode="strip_ids"/>
      </main>
      <compl>
        <xsl:apply-templates select="compl/@*" mode="#current"/>
        <xsl:apply-templates select="$split-full/node()[. >> $selected-sep]" mode="strip_ids"/>
      </compl>
      <xsl:apply-templates select="*[empty(self::main | self::compl)]"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template
    match="
      title-wrap[empty(main/node())]
      [empty(compl/node())]
      [not(matches(full, $dash-in-space-regex))]
      [not(main-title-wrap | compl-title-wrap | intro-title-wrap)]"
    mode="title-wrap-only-full">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*, intro" mode="#current"/>
      <main>
        <xsl:apply-templates select="main/@*" mode="#current"/>
        <xsl:apply-templates select="full/node()" mode="strip_ids"/>
      </main>
      <compl>
        <xsl:apply-templates select="compl/@*" mode="#current"/>
      </compl>
      <xsl:apply-templates select="full" mode="#current"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="@id" mode="strip_ids"/>



  <xsl:template match="sep" mode="title-wrap-only-full strip_ids">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="text()[matches(., $dash-in-space-regex)][1]"
    mode="title-wrap-only-full_sep main-title-wrap-only-subtitle_sep">
    <xsl:analyze-string select="." regex="{$dash-in-space-regex}">
      <xsl:matching-substring>
        <sep>
          <xsl:value-of select="."/>
        </sep>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template match="title/*[1]/text()[matches(., '^\p{Pd}')]" mode="remove_dash">
    <xsl:value-of select="replace(., '\p{Pd}', '')"/>
  </xsl:template>




  <xsl:template match="title-wrap[main-title-wrap/main = ''][matches(main-title-wrap/subtitle, $dash-in-space-regex)]"
    mode="main-title-wrap-only-subtitle">
    <xsl:variable name="split-subtitle" as="element(*)">
      <xsl:apply-templates select="main-title-wrap/subtitle/*" mode="main-title-wrap-only-subtitle_sep"/>
    </xsl:variable>
    <xsl:variable name="selected-sep" as="element(sep)"
      select="($split-subtitle/sep[following-sibling::node()[1]/self::text()[matches(., '^(Part(ie)?|Teil)[\s\p{Zs}]+\d')]], $split-subtitle/sep[1])[1]"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*" mode="#current"/>
      <main>
        <xsl:apply-templates select="main-title-wrap/main/@*" mode="#current"/>
        <xsl:apply-templates select="$split-subtitle/node()[$selected-sep >> .]" mode="strip_ids"/>
      </main>
      <compl>
        <xsl:apply-templates select="main-title-wrap/subtitle/@*" mode="#current"/>
        <xsl:apply-templates select="$split-subtitle/node()[. >> $selected-sep]" mode="strip_ids"/>
      </compl>
       <xsl:apply-templates select="node() except main-title-wrap" mode="#current"/>
      </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
