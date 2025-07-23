<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  exclude-result-prefixes="sc xs" version="3.0">

  <xsl:import href="identity.xsl"/>

  <xsl:template match="br | ital | equation" mode="unknown-element">
    <xsl:variable name="element-map" as="map(xs:string, xs:string)">
      <xsl:map>
        <xsl:map-entry key="'br'" select="'break'"/>
        <xsl:map-entry key="'ital'" select="'italic'"/>
        <xsl:map-entry key="'equation'" select="'disp-formula'"/>
      </xsl:map>
    </xsl:variable>
    <xsl:element name="{$element-map(name())}">
      <xsl:apply-templates mode="#current"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
