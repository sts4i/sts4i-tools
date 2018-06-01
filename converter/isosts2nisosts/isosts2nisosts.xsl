<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:tbx="urn:iso:std:iso:30042:ed-1"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xs xlink mml tbx xhtml"
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

  <!-- Doctype set to actual version of NISO STS Interchange Tag Set with MathML 2.0 -->
  <xsl:output
    method="xml"
    version="1.0"
    encoding="UTF-8"
    indent="yes"
    standalone="no"
    doctype-public="-//NISO//DTD NISO STS Interchange Tag Set (NISO STS) DTD with MathML 2.0 v1.0//EN"
    doctype-system="NISO-STS-extended-1-mathml2.dtd"/>

  <!-- The purpose of this transformation is to convert ISOSTS documents to NISO STS documents. -->
  <!-- Copy everything from the original document -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <!-- Update iso-meta to std-meta -->
  <xsl:template match="iso-meta">
    <std-meta><xsl:apply-templates select="@*|node()" /></std-meta>
  </xsl:template>

  <!-- Replace ISOSTS @dtd-version attribute to reflect NISOSTS dtd-version -->
  <xsl:template match="@dtd-version">
    <xsl:attribute name="{name()}">
      <xsl:text>1.0</xsl:text>
    </xsl:attribute>
  </xsl:template>

  <!-- Copy doc-ident proj-id + release-version + urn to std-ident -->
  <xsl:template match="std-ident">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
      <xsl:apply-templates select="//doc-ident/sdo" />
      <xsl:apply-templates select="//doc-ident/proj-id" />
    </xsl:copy>
  </xsl:template>

  <!-- Convert <sdo> to <std-org> and moved to <std-ident> -->
  <xsl:template match="//doc-ident/sdo">
    <std-org><xsl:apply-templates select="@*|node()" /></std-org>
  </xsl:template>

  <!-- Element <proj-id> is kept but moved to <std-ident> -->
  <xsl:template match="//doc-ident/proj-id">
    <proj-id><xsl:apply-templates select="@*|node()" /></proj-id>
  </xsl:template>

  <!-- Element <release-version> is kept but moved to <std-meta> -->
  <xsl:template match="release-version">
    <release-version><xsl:apply-templates select="@*|node()" /></release-version>
  </xsl:template>

  <!-- Element <urn> is kept but moved to <self-uri> -->
  <xsl:template match="urn">
    <self-uri><xsl:apply-templates select="@*|node()" /></self-uri>
  </xsl:template>

  <!-- Remove <doc-ident> from <std-meta> -->
  <xsl:template match="doc-ident">
    <xsl:apply-templates select="release-version"/>
    <xsl:apply-templates select="urn"/>
  </xsl:template>

  <!-- For NISO STS Tag Set, the publishing date should be recorded using the <release-date> element -->
  <xsl:template match="pub-date">
    <release-date date-type="published" std-type="new-standard" iso-8601-date="{.}"><xsl:value-of select="."/></release-date>

    <!-- Corrected version -->
    <!-- No room in ISOSTS to fit it properly, this is solved in NISO STS -->
    <xsl:if test="//iso-meta/std-ident/version[text()='2']">
      <release-date date-type="editorial-change" std-type="IS" iso-8601-date="{//release-date}"><xsl:value-of select="//release-date"/></release-date>
    </xsl:if>
  </xsl:template>

  <xsl:template match="release-date">
    <release-date date-type="published" std-type="IS" iso-8601-date="{.}"><xsl:value-of select="."/></release-date>
  </xsl:template>

  <!-- Systematic review date -->
  <xsl:template match="meta-date[@type='systematic-review']">
    <release-date date-type="reaffirmed" std-type="IS" iso-8601-date="{.}"><xsl:value-of select="."/></release-date>
  </xsl:template>

</xsl:stylesheet>
