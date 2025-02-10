<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config" xmlns:isosts="http://www.iso.org/ns/isosts"
  exclude-result-prefixes="sc xs isosts" version="3.0">

  <xsl:import href="identity.xsl"/>

  <xsl:include href="../NISOSTS_lib.xsl"/>

  <xsl:template match="@sec-type[matches(., '^foreword\.')]" mode="sec-type-strip-suffix">
    <xsl:attribute name="{name()}" select="'foreword'"/>
  </xsl:template>

</xsl:stylesheet>
