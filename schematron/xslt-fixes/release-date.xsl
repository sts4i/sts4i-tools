<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  exclude-result-prefixes="sc xs" version="2.0">

  <xsl:import href="identity.xsl"/>

  <xsl:template match="std-meta[empty(release-date)]
                                                   [exists(std-ident/year)
                                                    or
                                                    contains(std-ref[@type = 'dated'], ':')]" mode="infer">
    <xsl:variable name="before" as="node()+" 
      select="title-wrap, proj-id, release-version, std-ident, (std-org | std-org-group), content-language, std-ref, doc-ref, pub-date"/>
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:sequence select="node()[$before[last()] >> .] union $before"/>
      <release-date date-type="published" std-type="standard">
        <xsl:value-of select="(substring-after(std-ref[@type = 'dated'], ':')[normalize-space()], std-ident/year)[1]"/>
      </release-date>
      <xsl:sequence select="node()[. >> $before[last()]]"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>