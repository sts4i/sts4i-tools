<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs" version="2.0">

  <xsl:import href="identity.xsl"/>

  <xsl:template match="fn-group" mode="ungroup-fn"/>

  <xsl:template match="xref[@ref-type = ('fn', 'table-fn')][. is (key('by-rid', @rid) (: all xrefs that point to fn with ID @rid :)
                                                                   [@ref-type = ('fn', 'table-fn')]
                                                                   [not(ancestor::fn) (: ignore refs from one fn to another :)]
                                                                   [if (exists(key('by-id', @rid)/ancestor::table-wrap))
                                                                    then boolean(
                                                                      key('by-id', @rid)/ancestor::table-wrap[last()] 
                                                                      is 
                                                                      ancestor::table-wrap[last()]
                                                                      (: will also return false() if either of the lhs and rhs 
                                                                      around 'is' is empty, i.e., if the fn or the
                                                                      xref are not in a table :)
                                                                    )
                                                                    else true()
                                                                   ]
                                                                 )[1]]" mode="ungroup-fn"> 
    <xsl:apply-templates select="key('by-id', @rid)" mode="#current"/>
  </xsl:template>
  
  <xsl:template match="table-wrap-foot[every $c in * satisfies $c/self::fn-group]" mode="ungroup-fn"/>


  <!-- Mode: group-fn -->
  
  <xsl:variable name="footnote-roots" as="xs:string+"
    select="('body','app','back','fig','notes','sec','supplementary-material','term-sec','table-wrap')"/>
  
    
  <xsl:template match="*[local-name() = $footnote-roots]
                        [descendant::fn]
                        [empty(ancestor::table-wrap[label | caption]) (: don’t add footnotes to simple tables 
                                                                         that are contained in a table cell :)]
                        [some $i in (descendant::fn) satisfies 
                          generate-id(.) = 
                          generate-id($i/ancestor::*[local-name() = $footnote-roots]
                                                    [empty(ancestor::table-wrap[label | caption])]
                                                    [1]) (: this is to match the most specific $footnote-root
                                                            that the given fn is contained in :)
                        ]" mode="group-fn" priority="2">
    <xsl:variable name="generated-id" select="generate-id(.)"/>
    <xsl:variable name="footnotes" as="element(fn)+"
        select="descendant::fn[$generated-id = generate-id(ancestor::*[local-name() = $footnote-roots]
                                                                      [empty(ancestor::table-wrap[label | caption])]
                                                                      [1])]"/>
    <xsl:choose>
      <xsl:when test="self::table-wrap">
        <xsl:next-match>
          <xsl:with-param name="footnotes" select="$footnotes" tunnel="yes"/>
        </xsl:next-match>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*" mode="#current"/>
          <xsl:apply-templates select="node() except (attrib | permissions)" mode="#current"/>
          <fn-group>
            <xsl:apply-templates select="$footnotes" mode="#current">
              <xsl:with-param name="keep-fn" select="true()"/>
            </xsl:apply-templates>
          </fn-group>
          <xsl:apply-templates select="attrib | permissions" mode="#current"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="table-wrap[empty(table-wrap-foot)]
                                 [empty(ancestor::table-wrap[label | caption])]" mode="group-fn">
    <xsl:param name="footnotes" as="element(fn)*" tunnel="yes"/>
    <xsl:copy>
      <xsl:apply-templates select="@* | node() except (attrib | permissions)" mode="#current"/>
      <xsl:if test="exists($footnotes)">
        <table-wrap-foot>
          <fn-group>
            <xsl:apply-templates select="$footnotes" mode="#current">
              <xsl:with-param name="keep-fn" select="true()"/>
            </xsl:apply-templates>
          </fn-group>
        </table-wrap-foot>
      </xsl:if>
      <xsl:apply-templates select="attrib | permissions" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="table-wrap[empty(ancestor::table-wrap[label | caption])]/table-wrap-foot" mode="group-fn">
    <xsl:param name="footnotes" as="element(fn)*"/>
    <xsl:copy>
      <xsl:apply-templates select="@*, node() except fn-group" mode="#current"/>
      <fn-group>
        <xsl:apply-templates select="$footnotes" mode="#current">
          <xsl:with-param name="keep-fn" select="true()"/>
        </xsl:apply-templates>
      </fn-group>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="fn[not(ancestor::*/name() = $footnote-roots)]" mode="group-fn">
    <!-- For fns in, for ex., std-meta. This shouldn’t happen, but we need to make sure that we don’t
      discard them since they don’t have a $footnote-root ancestor. -->
    <xsl:next-match>
      <xsl:with-param name="keep-fn" select="true()"/>
    </xsl:next-match>
  </xsl:template>
  
  <xsl:template match="fn" mode="group-fn">
    <xsl:param name="keep-fn" select="false()" as="xs:boolean?"/>
    <xsl:variable name="generated-id" as="attribute(id)">
      <xsl:apply-templates select="." mode="id"/>
    </xsl:variable>
      <xsl:choose>
      <xsl:when test="$keep-fn">
        <xsl:copy>
          <xsl:apply-templates select="@*" mode="#current"/>
          <xsl:apply-templates select="." mode="id"/>
          <xsl:apply-templates mode="#current"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xref ref-type="fn">
          <xsl:apply-templates select="@* except @id" mode="#current"/>
          <xsl:attribute name="rid" select="$generated-id"/>
          <sup>
            <xsl:value-of select="concat((label, tokenize($generated-id,'[_\.]')[last()])[1],')')"/>
          </sup>
        </xref>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="fn" mode="id" as="attribute(id)">
    <!-- Use of generate-id() is preliminary. First, the generated id may not adhere to ID naming conventions. 
      Secondly, another footnote may already have been assigned the same ID in a previous run. In order to 
      avoid these issues, make sure that each fn has an ID before this fix runs. This might be performed by
      another fix. -->
    <xsl:attribute name="id" select="(@id, concat('fn_', generate-id()))[1]"/>
  </xsl:template>


  </xsl:stylesheet>