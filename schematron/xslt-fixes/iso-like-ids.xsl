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
  
  <xsl:key name="affected-sec-by-rid" match="*[self::sec or self::app][label[text()]][@id][@id ne isosts:id-string-by-label(.)]"
    use="@id"/>
  
  <xsl:template match="*[self::sec or self::app][label[text()]][@id][@id ne isosts:id-string-by-label(.)]/@id" mode="iso-like-ids">
    <xsl:attribute name="id" select="isosts:id-string-by-label(..)"/>
  </xsl:template>
  
  <xsl:template match="xref[exists(key('affected-sec-by-rid', @rid))]/@rid" mode="iso-like-ids">
    <xsl:attribute name="rid" select="isosts:id-string-by-label(key('affected-sec-by-rid', .))"/>
  </xsl:template>
  
</xsl:stylesheet>