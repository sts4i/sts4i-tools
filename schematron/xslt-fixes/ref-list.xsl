<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  exclude-result-prefixes="sc xs" version="2.0">

  <xsl:import href="identity.xsl"/>

<!-- ref-list als Kind von app-group -->
  
  <xsl:template match="ref-list[parent::app-group]" mode="ref-list-in-app">
    <app content-type="bibl">
      <xsl:apply-templates select="title" mode="#current"/>      
      <xsl:apply-templates select="." mode="rmv-ref-list-title"/>
    </app>
  </xsl:template>

<!-- ref-list als Kind von back, es gibt keine app-group -->
  
  <xsl:template match="ref-list[parent::back]" mode="ref-list-in-back">
    <app-group>
      <app content-type="bibl">
        <xsl:apply-templates select="title" mode="#current"/>
        <xsl:copy>
          <xsl:apply-templates mode="put-into-app" select="@* | node()"/>
        </xsl:copy>
      </app>
    </app-group>
  </xsl:template>
  
<!-- ref-list als Kind von back, es gibt eine app-group 
  
  <xsl:template match="app-group[following-sibling::ref-list]" mode="ref-list">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="#current"/> 
        <app content-type="bibl">
          <xsl:apply-templates select="following-sibling::ref-list/title"/>
          <xsl:apply-templates select="following-sibling::ref-list" mode="put-into-app"/>  
        </app>       
    </xsl:copy>
  </xsl:template> -->
  
  <xsl:template match="ref-list" mode="put-into-app">
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="back/ref-list/title" mode="put-into-app"/>
<!--  <xsl:template match="ref-list/@content-type['bibl']" mode="put-into-app"/>-->
  <xsl:template match="ref-list/title" mode="rmv-ref-list-title"/>
<!--  <xsl:template match="ref-list/@content-type['bibl']" mode="rmv-ref-list-title"/>-->

<!-- ref-list als Kind von app in einer app-group, aber @content-type fehlt an app  -->
  
  <xsl:template match="back/app-group/app[child::ref-list][not(@content-type = 'bibl')]" mode="content-type-for-app">
    <xsl:copy>
      <xsl:attribute name="content-type">bibl</xsl:attribute>  
        <xsl:apply-templates select="ref-list/title" mode="#current"/>
        <xsl:apply-templates select="ref-list" mode="rmv-ref-list-title"/>
    </xsl:copy>
  </xsl:template>



  <xsl:template match="app-group[isosts:is-ref-list-wrapper-app-group(.)]" mode="unwrap-app-around-ref-list" priority="1">
    <xsl:comment select="isosts:is-ref-list-wrapper-app-group(.)"></xsl:comment>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="app-group[app[isosts:is-ref-list-wrapper-app(.)]]" mode="unwrap-app-around-ref-list">
    <xsl:copy>
      <xsl:apply-templates select="@*, node() except app[isosts:is-ref-list-wrapper-app(.)]" mode="#current"/>  
    </xsl:copy>
    <xsl:apply-templates select="app[isosts:is-ref-list-wrapper-app(.)]" mode="#current"/>
  </xsl:template>
  
  <xsl:template match="app[isosts:is-ref-list-wrapper-app(.)]" mode="unwrap-app-around-ref-list">
    <xsl:apply-templates select="node() except (label | title)" mode="#current"/>
  </xsl:template>
  
  <xsl:template match="app[isosts:is-ref-list-wrapper-app(.)]/ref-list" mode="unwrap-app-around-ref-list">
    <xsl:copy>
      <xsl:apply-templates select="@*, ../(label | title)" mode="#current"/>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:function name="isosts:is-ref-list-wrapper-app" as="xs:boolean">
    <xsl:param name="_app" as="element(app)"/>
    <xsl:sequence select="every $c in $_app/*[not(name() = ('label', 'title'))]
                          satisfies $c/self::ref-list[@content-type = 'bibl'][empty(label | title)]"/>
  </xsl:function>
  
  <xsl:function name="isosts:is-ref-list-wrapper-app-group" as="xs:boolean">
    <xsl:param name="app-group" as="element(app-group)"/>
    <xsl:sequence select="exists($app-group[app[ref-list[@content-type = 'bibl']]]
                                      [every $app in app satisfies (
                                        exists($app/ref-list[@content-type = 'bibl'][empty(label | title)])
                                        and isosts:is-ref-list-wrapper-app($app)
                                       )])"/>
  </xsl:function>

  <xsl:template match="sec[@sec-type='norm-refs'][not(descendant::ref-list)][*[last()][self::p][count(node())=count(std[std-ref][title])]]" mode="norm-refs-p-to-ref-list">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:for-each-group select="node()[not(self::text()[not(normalize-space())])]" group-adjacent="if (self::p[count(node())=count(std[std-ref][title])]) then true() else false()">
        <xsl:choose>
          <xsl:when test="current-grouping-key() and current-group()[last()][not(following-sibling::*)]">
            <ref-list>
              <xsl:for-each select="current-group()">
                <ref content-type="standard">
                  <xsl:apply-templates select="node()" mode="#current"/>
                </ref>
              </xsl:for-each>
            </ref-list>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="current-group()" mode="#current"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
