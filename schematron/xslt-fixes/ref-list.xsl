<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
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
  <xsl:template match="ref-list/@content-type['bibl']" mode="put-into-app"/>
  <xsl:template match="ref-list/title" mode="rmv-ref-list-title"/>
  <xsl:template match="ref-list/@content-type['bibl']" mode="rmv-ref-list-title"/>

<!-- ref-list als Kind von app in einer app-group, aber @content-type fehlt an app  -->
  
  <xsl:template match="back/app-group/app[child::ref-list][not(@content-type = 'bibl')]" mode="content-type-for-app">
    <xsl:copy>
      <xsl:attribute name="content-type">bibl</xsl:attribute>  
        <xsl:apply-templates select="ref-list/title" mode="#current"/>
        <xsl:apply-templates select="ref-list" mode="rmv-ref-list-title"/>
    </xsl:copy>
  </xsl:template>


</xsl:stylesheet>
