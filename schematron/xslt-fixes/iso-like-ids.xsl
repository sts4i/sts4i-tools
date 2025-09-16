<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:isosts="http://www.iso.org/ns/isosts"
  xmlns:sbf="http://transpect.io/schematron-batch-fix"
  xmlns:tbx="urn:iso:std:iso:30042:ed-1"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="sbf isosts xs" version="3.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>

  <xsl:mode name="iso-like-ids"/>
  
  <xsl:variable name="id-pool" as="element()?">
    <xsl:variable name="prelim" as="element()">
      <prelim>
        <xsl:for-each select="//*[self::sec or self::app][label[text()]][@id][@id ne isosts:id-string-by-label(.)]">
          <id val="{@id}">
            <xsl:sequence select="isosts:id-string-by-label(.)"/>
          </id>
        </xsl:for-each>
      </prelim>
    </xsl:variable>
    <ids>
      <xsl:for-each select="$prelim/id">
        <xsl:choose>
          <xsl:when test="current() = preceding-sibling::*">
            <xsl:copy>
              <xsl:sequence select="current()/@*, concat(text(), '_', generate-id())"/>
            </xsl:copy>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="current()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </ids>
  </xsl:variable>
  
  <xsl:function name="isosts:map-id">
    <xsl:param name="id" as="attribute()"/>
    <xsl:sequence select="$id-pool/id[@val = $id]"/>
  </xsl:function>
  
  <xsl:template match="*[@id = $id-pool/id/@val]/@id" mode="iso-like-ids">
    <xsl:attribute name="id" select="isosts:map-id(.)"/>
  </xsl:template>
  
  <xsl:template match="xref[@id = $id-pool/id/@val]/@rid" mode="iso-like-ids">
    <xsl:attribute name="rid" select="isosts:map-id(.)"/>
  </xsl:template>
  
</xsl:stylesheet>