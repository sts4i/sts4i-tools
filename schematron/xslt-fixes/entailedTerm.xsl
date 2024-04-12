<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:tbx="urn:iso:std:iso:30042:ed-1"
  xmlns:sc="http://transpect.io/schematron-config"
  exclude-result-prefixes="sc xs" version="2.0">

  <xsl:import href="identity.xsl"/>


  <xsl:template match="xref[@ref-type = 'other']
                           [key('by-id', @rid)/self::term-sec]
                           [count(italic) = 1]
                           [some $t in //tbx:term satisfies contains(normalize-space(italic[1]), $t)]
                           [count(text()[matches(., '\(\d+\.\d+\)')]) = 1]" mode="SN-italic-entailedTerm">
    <xsl:apply-templates mode="#current">
      <xsl:with-param name="do-the-needful" as="xs:boolean" tunnel="yes" select="true()"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <!--<xsl:template match="xref" mode="SN-italic-entailedTerm">
    <xsl:param name="do-the-needful" as="xs:boolean?" tunnel="yes"/>
    <xsl:choose>
      <xsl:when test="$do-the-needful">
        <xsl:apply-templates mode="#current"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->
  
  <xsl:template match="xref/italic" mode="SN-italic-entailedTerm">
    <xsl:param name="do-the-needful" as="xs:boolean?" tunnel="yes"/>
    <xsl:choose>
      <xsl:when test="$do-the-needful">
        <tbx:entailedTerm>
          <xsl:attribute name="target" select="key('by-id', ../@rid)/self::term-sec/tbx:termEntry[1]/@id"/>
          <xsl:apply-templates mode="#current"/>
        </tbx:entailedTerm>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="xref/text()" mode="SN-italic-entailedTerm">
    <xsl:param name="do-the-needful" as="xs:boolean?" tunnel="yes"/>
    <xsl:variable name="context" as="element(xref)" select=".."/>
    <xsl:choose>
      <xsl:when test="$do-the-needful">
        <xsl:analyze-string select="." regex="\((\d+\.\d+)\)">
          <xsl:matching-substring>
            <xsl:text>(</xsl:text>
            <xref ref-type="term">
              <xsl:apply-templates select="$context/@*" mode="#current"/>
              <xsl:value-of select="regex-group(1)"/>
            </xref>
            <xsl:text>)</xsl:text>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <xsl:value-of select="."/>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>