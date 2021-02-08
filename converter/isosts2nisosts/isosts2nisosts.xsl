<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:tbx="urn:iso:std:iso:30042:ed-1"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:csl="http://www.w3.org/1999/XSL/Transform"
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

  <xsl:output
    method="xml"
    version="1.0"
    encoding="UTF-8"
    standalone="omit"/>

  <!-- The purpose of this transformation is to convert ISOSTS documents to NISO STS documents. -->
  <!-- Copy everything from the original document -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <!-- Update iso-meta to std-meta -->
  <xsl:template match="iso-meta">
    <std-meta>
      <xsl:call-template name="title-wrap"/>
      <xsl:call-template name="proj-id"/>
      <xsl:call-template name="release-version"/>
      <xsl:call-template name="std-ident"/>
      <xsl:call-template name="std-org"/>
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
      <xsl:call-template name="self-uri"/>
      <xsl:call-template name="custom-meta-group"/>
    </std-meta>
  </xsl:template>

  <xsl:template name="title-wrap">
    <xsl:copy-of select="title-wrap"/>
  </xsl:template>

  <xsl:template name="proj-id">
    <xsl:copy-of select="doc-ident/proj-id"/>
  </xsl:template>

  <xsl:template name="release-version">
    <xsl:copy-of select="doc-ident/release-version"/>
  </xsl:template>

  <xsl:template name="std-ident">
    <xsl:copy-of select="std-ident"/>
  </xsl:template>

  <xsl:template name="std-org">
    <xsl:if test="doc-ident/sdo">
      <std-org>
        <std-org-abbrev><xsl:value-of select="doc-ident/sdo"/></std-org-abbrev>
      </std-org>
    </xsl:if>
  </xsl:template>

  <xsl:template name="content-language">
    <xsl:copy-of select="content-language"/>
  </xsl:template>

  <xsl:template name="std-ref">
    <xsl:copy-of select="std-ref"/>
  </xsl:template>

  <xsl:template name="doc-ref">
    <xsl:copy-of select="doc-ref"/>
  </xsl:template>

  <xsl:template name="pub-date">
    <xsl:if test="pub-date">
      <xsl:variable name="stdType">
        <xsl:choose>
          <xsl:when test="lower-case(std-ident/suppl-type) = 'amd'">
            <xsl:text>amendment</xsl:text>
          </xsl:when>
          <xsl:when test="lower-case(std-ident/suppl-type) = 'cor'">
            <xsl:text>corrigenda</xsl:text>
          </xsl:when>
          <!-- pass legacy types as is -->
          <xsl:when test="std-ident/suppl-type/text()">
            <xsl:value-of select="std-ident/suppl-type"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>standard</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <!-- For the edition date of amd/cor we can only generate an approximation (year-01-01) using the standard reference
           because in ISOSTS the pub-date corresponds to the publishing of the amd/cor and not to the main document -->
      <xsl:variable name="edition-date-from-stdref">
        <!-- extract year of publication of main document from std-ref -->
        <xsl:analyze-string regex=".*:(\d{{4}})/(amd|cor).*" flags="i" select="/standard/front/iso-meta/std-ref[@type='dated']">
            <xsl:matching-substring>
              <xsl:value-of select="concat(regex-group(1), '-01-01')"/>
            </xsl:matching-substring>
          </xsl:analyze-string>
      </xsl:variable>
      <xsl:variable name="edition-date">
        <xsl:choose>
          <xsl:when test="$edition-date-from-stdref != ''">
            <xsl:value-of select="$edition-date-from-stdref"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="pub-date"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <release-date date-type="published" std-type="edition" iso-8601-date="{$edition-date}"><xsl:value-of select="$edition-date"/></release-date>
      <release-date date-type="published" std-type="{$stdType}" iso-8601-date="{pub-date}"><xsl:value-of select="pub-date"/></release-date>
    </xsl:if>
  </xsl:template>

  <xsl:template name="release-date">
    <xsl:if test="release-date">
      <!-- Check if this release was for a corrected version -->
      <xsl:choose>
        <!-- correction for a main document -->
        <xsl:when test="not(std-ident/suppl-type/text()) and std-ident/version[text() !='1']">
          <release-date date-type="released" std-type="correction" iso-8601-date="{release-date}"><xsl:value-of select="release-date"/></release-date>
        </xsl:when>
        <!-- correction for a supplement -->
        <xsl:when test="std-ident/suppl-type/text() and std-ident/suppl-version[text() !='1']">
          <release-date date-type="released" std-type="correction" iso-8601-date="{release-date}"><xsl:value-of select="release-date"/></release-date>
        </xsl:when>
      </xsl:choose>
      <!-- for drafts we don't have an edition date but a release-date of type standard-draft -->
      <xsl:if test="doc-ident/release-version != 'IS'">
        <release-date date-type="released" std-type="standard-draft" iso-8601-date="{release-date}"><xsl:value-of select="release-date"/></release-date>
      </xsl:if>
    </xsl:if>
    <xsl:for-each select="meta-date[@type='systematic-review']">
      <release-date date-type="reaffirmed" std-type="standard" iso-8601-date="{.}"><xsl:value-of select="."/></release-date>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="meta-date">
    <xsl:copy-of select="meta-date[@type!='systematic-review']"/>
  </xsl:template>

  <xsl:template name="comm-ref">
    <xsl:copy-of select="comm-ref"/>
  </xsl:template>

  <xsl:template name="secretariat">
    <xsl:copy-of select="secretariat"/>
  </xsl:template>

  <xsl:template name="ics">
    <xsl:copy-of select="ics"/>
  </xsl:template>

  <xsl:template name="page-count">
    <xsl:copy-of select="page-count"/>
  </xsl:template>

  <xsl:template name="is-proof">
    <xsl:copy-of select="is-proof"/>
  </xsl:template>

  <xsl:template name="std-xref">
    <xsl:copy-of select="std-xref"/>
  </xsl:template>

  <xsl:template name="permissions">
    <xsl:copy-of select="permissions"/>
  </xsl:template>

  <xsl:template name="self-uri">
    <xsl:if test="doc-ident/urn">
      <self-uri><xsl:value-of select="doc-ident/urn"/></self-uri>
    </xsl:if>
  </xsl:template>

  <xsl:template name="custom-meta-group">
    <xsl:copy-of select="custom-meta-group"/>
  </xsl:template>

  <!-- suppress dtd-version to make make the XML compatible with future dtd-versions -->
  <xsl:template match="@dtd-version"/>

</xsl:stylesheet>
