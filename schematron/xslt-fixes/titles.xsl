<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  exclude-result-prefixes="sc xs isosts" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>
  
  <xsl:template match="*[name() = ('title', 'th')][bold]
                                                  [every $n in node() satisfies (exists($n/self::bold | $n/self::text()[not(normalize-space())]))]/bold"
                mode="bold-in-title" priority="2">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*[name() = ('title', 'th')][bold]
                                                  [every $n in node() satisfies (exists($n/self::bold | $n/self::text()[not(normalize-space())]))]
                          /node()[position() = (1, last())][self::text()]"
                mode="bold-in-title" priority="2">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*[name() = ('title', 'th')][bold]" mode="bold-in-title">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
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
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="bold" mode="bold-in-title-with-formula">
    <xsl:apply-templates mode="bold-in-title"/>
  </xsl:template>
  
  <xsl:template match="*[name() = ('title', 'th')]
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
      <xsl:when test="$n/self::bold[matches(., '^[\p{P}\p{L}\d]+$')]
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
      <xsl:when test="$n[. is ../node()[1]][matches(., '^\s+$', 's')][following-sibling::bold]">
        <xsl:sequence select="'ignorable'"/>
      </xsl:when>
      <xsl:when test="$n[. is ../node()[last()]][matches(., '^\s+$', 's')]">
        <xsl:sequence select="'ignorable'"/>
      </xsl:when>
      <xsl:when test="$n[matches(., '^\s+$', 's')][preceding-sibling::node()[1]/self::bold]
                                                  [following-sibling::node()[1]/self::bold]">
        <xsl:sequence select="'ws'"/>
      </xsl:when>
      <xsl:when test="$n/self::bold 
                      and 
                      $n/preceding-sibling::node()[1][isosts:title-node-type(., ($seen, $n)) = 'inline-formula']
                      and 
                      $n/following-sibling::node()[1][isosts:title-node-type(., ($seen, $n)) = 'inline-formula']">
        <xsl:sequence select="'inline-formula'"/>
      </xsl:when>
      <xsl:when test="$n/self::text()[preceding-sibling::*[1][isosts:title-node-type(., ($n, $seen)) = 'inline-formula']]
                                     [following-sibling::*[1][isosts:title-node-type(., ($n, $seen)) = 'inline-formula']]
                                     [matches(., '^\s+\S')]">
        <xsl:sequence select="'inline-formula'"/>
      </xsl:when>
      <xsl:when test="$n/self::bold">
        <xsl:sequence select="'bold'"/>
      </xsl:when>
      <xsl:when test="$n/self::text()[preceding-sibling::node()[1]/self::bold[not(isosts:title-node-type(., ($n, $seen)) = 'inline-formula')]][matches(., '^\s+\S')]">
        <xsl:sequence select="('inline-formula', 'ws')"/>
      </xsl:when>
      <xsl:when test="$n/self::text()[matches(., '^\p{P}$')]">
        <xsl:sequence select="'inline-formula'"/>
      </xsl:when>
      <xsl:when test="$n/(self::italic | self::sub | self::sup)">
        <xsl:sequence select="'inline-formula'"/>
      </xsl:when>
      <xsl:when test="matches($n, '^\s+$', 's') 
                      and 
                      $n/preceding-sibling::node()[1][isosts:title-node-type(., ($seen, $n)) = 'inline-formula']
                      and 
                      $n/following-sibling::node()[1][isosts:title-node-type(., ($seen, $n)) = 'inline-formula']">
        <xsl:sequence select="'inline-formula'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="{$fail-on-error}" select="'isosts:title-node-type(): unknown node type for ''', $n, ''' (node ', isosts:index-of($n/../node(), $n),') in ', $n/..,
          '&#xa;  Types: ', $n/../node() ! string-join((name(.), isosts:title-node-type(., ($n, $seen))), ':')"/>
        <xsl:sequence select="'unknown'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:variable name="annex-type-regex" as="xs:string" select="'^\s*(\((normative?|informative?)\))[\s\p{Zs}]+$'"/>

  <xsl:template match="app[empty(annex-type)]/title[node()[1]/self::text()[matches(., $annex-type-regex)]]" mode="annex-type">
    <annex-type>
      <xsl:value-of select="replace(node()[1], $annex-type-regex, '$1')"/>
    </annex-type>
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="app[empty(annex-type)]/title[node()[1]/self::text()[matches(., $annex-type-regex)]]/node()[1]" mode="annex-type"/>


  <xsl:variable name="label-regex" as="xs:string" select="'^\s*(([NZ]?[A-Z]|\d+)(\.\d+)*)[\s\p{Zs}]+$'"/>

  <xsl:template match="title[empty(../label | ../self::caption/../label)][node()[1]/self::text()[matches(., $label-regex)]]/node()[1]" mode="label"/>

  <xsl:template match="title[empty(../label | parent::caption)][node()[1]/self::text()[matches(., $label-regex)]]" mode="label">
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

  <xsl:template match="label[text()][every $n in node() satisfies ($n/self::text())]
                            [not(normalize-space(.) = string(.))]" mode="normalize-space-label">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="continuation" match="title/bold[.='(continued)']">
    <named-content content-type="continuation-note">
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </named-content>
  </xsl:template>

  <xsl:template match="title-wrap[empty(main/node())]
                                 [empty(compl/node())]
                                 [empty(main-title-wrap | compl-title-wrap | intro | intro-title-wrap)]
                                 [matches(full, $dash-in-space-regex)]" mode="title-wrap-only-full">
    <xsl:variable name="split-full" as="element(full)">
      <xsl:apply-templates select="full" mode="title-wrap-only-full_sep"/>
    </xsl:variable>
    <xsl:copy copy-namespaces="no">
      <main>
        <xsl:apply-templates select="main/@*" mode="#current"/>
        <xsl:sequence select="$split-full/node()[following-sibling::sep]"/>
      </main>
      <compl>
        <xsl:apply-templates select="compl/@*" mode="#current"/>
        <xsl:sequence select="$split-full/node()[preceding-sibling::sep]"/>
      </compl>
      <xsl:apply-templates select="*[empty(self::main | self::compl)]"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text()[matches(., $dash-in-space-regex)][1]" mode="title-wrap-only-full_sep">
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

</xsl:stylesheet>