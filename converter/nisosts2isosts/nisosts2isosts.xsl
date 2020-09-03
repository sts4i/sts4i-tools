<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:ali="http://www.niso.org/schemas/ali/1.0/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:tbx="urn:iso:std:iso:30042:ed-1"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="ali xs xhtml"
  version="2.0">
  
  <!-- Copyright 2018 ISO and contributors

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License. -->

  <xsl:output
    method="xml"
    version="1.0"
    encoding="UTF-8"
    standalone="omit"/>

  <xsl:template match="standard">
    <standard xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:tbx="urn:iso:std:iso:30042:ed-1" xmlns:xlink="http://www.w3.org/1999/xlink">
      <xsl:apply-templates select="@*|node()" />      
    </standard>
  </xsl:template>
  
  <!-- The purpose of this transformation is to convert NISO STS documents to ISOSTS documents. -->
  <!-- Copy everything from the original document -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
  <!-- Update <std-meta> to <iso-meta> -->
  <xsl:template match="std-meta">
    <iso-meta>
      <xsl:call-template name="title-wrap"/>
      <xsl:call-template name="doc-ident"/>
      <xsl:call-template name="std-ident"/>
      <xsl:call-template name="content-language"/>
      <xsl:call-template name="std-ref"/>
      <xsl:call-template name="doc-ref"/>
      <xsl:call-template name="pub-date"/>
      <xsl:call-template name="release-date"/>
      <xsl:call-template name="meta-date"/>
      <xsl:call-template name="comm-ref"/>
      <xsl:call-template name="secretariat"/>
      <xsl:call-template name="ics"/>
      <xsl:call-template name="page-count"/>
      <xsl:call-template name="is-proof"/>
      <xsl:call-template name="std-xref"/>
      <xsl:call-template name="permissions"/>
      <xsl:call-template name="custom-meta-group"/>
    </iso-meta>
  </xsl:template>

  <xsl:template name="title-wrap">
    <xsl:copy-of copy-namespaces="no" select="title-wrap"/>
  </xsl:template>

  <xsl:template name="doc-ident">
    <doc-ident>
      <sdo><xsl:value-of select="std-org/std-org-abbrev"/></sdo>
      <xsl:copy-of copy-namespaces="no" select="proj-id"/>
      <language><xsl:value-of select="string-join(content-language, ',')"/></language>
      <xsl:copy-of copy-namespaces="no" select="release-version"/>
      <urn><xsl:value-of select="self-uri"/></urn>
    </doc-ident>
  </xsl:template>

  <xsl:template name="std-ident">
    <xsl:copy-of copy-namespaces="no" select="std-ident"/>
  </xsl:template>

  <xsl:template name="content-language">
    <xsl:copy-of copy-namespaces="no" select="content-language"/>
  </xsl:template>

  <xsl:template name="std-ref">
    <xsl:copy-of copy-namespaces="no" select="std-ref"/>
  </xsl:template>

  <xsl:template name="doc-ref">
    <xsl:copy-of copy-namespaces="no" select="doc-ref"/>
  </xsl:template>

  <xsl:template name="pub-date">
    <xsl:variable name="pubDate" select="release-date[@date-type eq 'published' and @std-type eq 'edition']"/>
    <xsl:if test="$pubDate">
      <pub-date><xsl:value-of select="$pubDate"/></pub-date>
    </xsl:if>
  </xsl:template>

  <xsl:template name="release-date">
    <!-- release-date is a mandatory element in ISOSTS to we need to find one to generate a valid XML
         to get the right date we use the following order of precedence
         1. release of correction
         2. release of draft standard
         3. any published date, except edition
    -->
    <xsl:variable name="releaseDate" as="xs:string *">
      <xsl:for-each select="release-date[@date-type eq 'released' and @std-type = 'correction']">
        <xsl:value-of select="."/>
      </xsl:for-each>
    <xsl:for-each select="release-date[@date-type eq 'published' and matches(@std-type, 'standard|amendment|corrigenda')]">
        <xsl:value-of select="."/>
    </xsl:for-each>
      <xsl:for-each select="release-date[@date-type eq 'released' and @std-type = 'standard-draft']">
        <xsl:value-of select="."/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:if test="count($releaseDate) gt 0">
      <release-date>
        <xsl:value-of select="$releaseDate[1]"/>
      </release-date>
    </xsl:if>
  </xsl:template>

  <xsl:template name="meta-date">
    <xsl:copy-of copy-namespaces="no" select="meta-date"/>
    <!-- Systematic review date -->
    <xsl:for-each select="release-date[@date-type eq 'published' and @std-type eq 'reaffirmed']">
      <meta-date type="systematic-review"><xsl:value-of select="."/></meta-date>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="comm-ref">
    <xsl:copy-of copy-namespaces="no" select="comm-ref"/>
  </xsl:template>

  <xsl:template name="secretariat">
    <xsl:copy-of copy-namespaces="no" select="secretariat"/>
  </xsl:template>

  <xsl:template name="ics">
    <xsl:copy-of copy-namespaces="no" select="ics"/>
  </xsl:template>

  <xsl:template name="page-count">
    <xsl:copy-of copy-namespaces="no" select="page-count"/>
  </xsl:template>

  <xsl:template name="is-proof">
    <xsl:copy-of copy-namespaces="no" select="is-proof"/>
  </xsl:template>

  <xsl:template name="std-xref">
    <xsl:copy-of copy-namespaces="no" select="std-xref"/>
  </xsl:template>

  <xsl:template name="permissions">
    <xsl:copy-of copy-namespaces="no" select="permissions"/>
  </xsl:template>

  <xsl:template name="custom-meta-group">
    <xsl:copy-of copy-namespaces="no" select="custom-meta-group"/>
  </xsl:template>

  <!-- suppress dtd-version to make make the XML compatible with future dtd-versions -->
  <xsl:template match="@dtd-version"/>

  <!-- STSTOOL-14 List type "dash" to be replaced in ISOSTS conversion-->
  <xsl:template match="list/@list-type[.='dash']">
    <xsl:attribute name="list-type">
      <xsl:value-of select="'bullet'"/>
    </xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
