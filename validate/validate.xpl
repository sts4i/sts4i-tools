<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ttt="http://transpect.io/tokenized-to-tree" xmlns:c="http://www.w3.org/ns/xproc-step"
  version="1.0" xmlns:cx="http://xmlcalabash.com/ns/extensions" xmlns:tr="http://transpect.io"
  name="batch-val" type="tr:batch-val-sts">

  <p:input port="iso-rng">
    <p:document href="http://niso-sts.org/sts4i-tools/schema/isosts/rng/ISOSTS.rng"/>
  </p:input>
  <p:input port="niso-interchange-mathml3-rng">
    <p:document href="http://niso-sts.org/sts4i-tools/schema/nisosts/RNG-NISO-STS-interchange-1-mathml3/NISO-STS-interchange-1-mathml3.rng"/>
  </p:input>
  <p:input port="schematron">
    <p:document href="http://niso-sts.org/sts4i-tools/schematron/empty.sch"/>
  </p:input>

  <p:output port="htmlreport" primary="true"/>
  <p:serialization port="htmlreport" omit-xml-declaration="false" method="xhtml"/>
  <p:output port="errors" sequence="true">
    <p:pipe port="result" step="insert-post-fix-svrl"/>
  </p:output>
  <p:serialization port="errors" omit-xml-declaration="false"/>
  
  <p:documentation>see find-files.xpl for options documentation</p:documentation>
  <p:option name="input-filename-regex" select="'\.xml$'"/>
  <p:option name="file-list-txt" select="''"/>
  <p:option name="input-dir"/>
  <p:option name="depth" select="'-1'"/>
  <p:option name="uninteresting-dir-regex" select="''"/>
  <p:option name="default-niso-doctype-system" select="'NISO-STS-interchange-1-mathml3.dtd'"/>
  <p:option name="default-niso-doctype-public" 
    select="'-//NISO//DTD NISO STS Interchange Tag Set (NISO STS) DTD with MathML 3.0 v1.0 20171031//EN'"/>
  <p:option name="debug-dir-uri" select="''"/>
  <p:option name="debug" select="'no'"/>
  
  <p:import href="../find-files/find-files.xpl"/>
  <p:import href="http://transpect.io/xproc-util/file-uri/xpl/file-uri.xpl"/>
  <p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
  <p:import href="http://transpect.io/xproc-util/store-debug/xpl/store-debug.xpl"/>
  <p:import href="http://transpect.io/calabash-extensions/rng-extension/xpl/validate-with-rng-declaration.xpl"/>
  <p:import href="apply-xsl-fixes.xpl"/>

  <tr:find-files name="find-files">
    <p:with-option name="input-dir" select="$input-dir"/>
    <p:with-option name="file-list-txt" select="$file-list-txt"/>
    <p:with-option name="depth" select="$depth"/>
    <p:with-option name="input-filename-regex" select="$input-filename-regex"/>
    <p:with-option name="uninteresting-dir-regex" select="''"/>
    <p:with-option name="debug" select="$debug"/>
    <p:with-option name="debug-dir-uri" select="$debug-dir-uri"/>
  </tr:find-files>
  
  <p:for-each name="file-iteration">
    <p:iteration-source select="//c:file[exists(standard | adoption)]"/>
    <p:output port="errors" sequence="true" primary="true">
      <p:pipe port="errors" step="val"/>
    </p:output>
    <p:output port="docs">
      <p:pipe port="result" step="val"/>
    </p:output>
    <p:variable name="input-file-uri" select="resolve-uri(/*/@name, base-uri(/*))"/>
    <p:variable name="output-file-uri" select="concat($input-file-uri, '.val')"/>
    
    <p:unwrap match="/*" name="unwrap"/>
    
    <p:split-sequence test="exists(/standard | /adoption)" name="actual-standard-doc"/>

    <p:count name="count-actual-standard-doc"/>

    <p:choose name="val">
      <p:when test="/* = 1">
        <p:documentation>A standard document could be loaded</p:documentation>
        <p:output port="errors" primary="true" sequence="true">
          <p:pipe port="result" step="add-uri-to-error"/>
          <p:pipe port="result" step="add-uri-to-svrl"/>
        </p:output>
        <p:output port="result">
          <p:pipe port="result" step="add-base-uri"/>
        </p:output>

        <p:choose name="load-schema">
          <p:xpath-context>
            <p:pipe port="matched" step="actual-standard-doc"/>
          </p:xpath-context>
          <p:when test="/*/@dtd-version = '1.0' 
                        or empty(//nat-meta | //reg-meta | //iso-meta)
                        or exists(/adoption)">
            <p:output port="result" primary="true"/>
            <p:identity>
              <p:input port="source">
                <p:pipe port="niso-interchange-mathml3-rng" step="batch-val"/>
              </p:input>
            </p:identity>
          </p:when>
          <p:otherwise>
            <p:output port="result" primary="true"/>
            <p:identity>
              <p:input port="source">
                <p:pipe port="iso-rng" step="batch-val"/>
              </p:input>
            </p:identity>
          </p:otherwise>
        </p:choose>
        <p:sink name="sink1"/>
        <p:xslt name="add-base-uri" template-name="main">
          <p:input port="source">
            <p:pipe port="matched" step="actual-standard-doc"/>
          </p:input>
          <p:input port="parameters"><p:empty/></p:input>
          <p:input port="stylesheet">
            <p:inline>
              <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
                <xsl:template name="main">
                  <xsl:sequence select="/"/>
                </xsl:template>
              </xsl:stylesheet>
            </p:inline>
          </p:input>
          <p:with-option name="output-base-uri" select="resolve-uri(/*/@name, base-uri(/*))">
            <p:pipe port="current" step="file-iteration"/>
          </p:with-option>
        </p:xslt>
        <tr:validate-with-rng name="rng">
          <p:input port="schema">
            <p:pipe port="result" step="load-schema"/>
          </p:input>
        </tr:validate-with-rng>
        <p:sink name="sink2"/>
        <p:add-attribute name="add-schema-to-error" match="/*" attribute-name="schema">
          <p:input port="source">
            <p:pipe port="report" step="rng"/>
          </p:input>
          <p:with-option name="attribute-value" select="replace(base-uri(), '^.+/', '')">
            <p:pipe port="result" step="load-schema"/>
          </p:with-option>
        </p:add-attribute>
        <p:add-attribute name="add-uri-to-error" match="/*" attribute-name="xml:base">
          <p:with-option name="attribute-value" select="$output-file-uri"/>
        </p:add-attribute>

        <p:validate-with-schematron name="single-sch" assert-valid="false">
          <p:with-param name="allow-foreign" select="'true'"/>
          <p:input port="source">
            <p:pipe port="matched" step="actual-standard-doc"/>
          </p:input>
          <p:input port="schema">
            <p:pipe port="schematron" step="batch-val"/>
          </p:input>
        </p:validate-with-schematron>
        <p:sink/>
        <p:add-attribute name="add-uri-to-svrl" match="/*" attribute-name="xml:base">
          <p:input port="source">
            <p:pipe port="report" step="single-sch"/>
          </p:input>
          <p:with-option name="attribute-value" select="$output-file-uri"/>
        </p:add-attribute>
        <p:sink/>
      </p:when>
      <p:otherwise>
        <p:documentation>No standard document could be loaded, but there should be a c:errors document reporting about
          it.</p:documentation>
        <p:output port="errors" sequence="true" primary="true"/>
        <p:output port="result">
          <p:pipe port="result" step="id"/>
        </p:output>
        <p:identity name="id">
          <p:input port="source">
            <p:pipe port="not-matched" step="actual-standard-doc"/>
          </p:input>
        </p:identity>
      </p:otherwise>
    </p:choose>
  </p:for-each>
  
  <p:wrap-sequence wrapper="reports" name="wrap-errors">
    <p:input port="source">
      <p:pipe port="errors" step="file-iteration"/>
    </p:input>
  </p:wrap-sequence>
  
  <tr:store-debug>
    <p:with-option name="pipeline-step" select="'reports'"/>
    <p:with-option name="active" select="$debug"/>
    <p:with-option name="base-uri" select="$debug-dir-uri"/>
  </tr:store-debug>
  
  <tr:apply-xsl-fixes name="apply-fixes">
    <p:input port="schematron">
      <p:pipe port="schematron" step="batch-val"/>
    </p:input>
    <p:input port="source">
      <p:pipe port="docs" step="file-iteration"/>
    </p:input>
    <p:with-option name="debug" select="$debug"/>
    <p:with-option name="debug-dir-uri" select="$debug-dir-uri"/>
  </tr:apply-xsl-fixes>
  
  <p:for-each name="post-fix-schematron">
    <p:output port="report" primary="true"/>
    <p:variable name="unparsed" select="substring(unparsed-text(replace(base-uri(), '(\.fixed)+\.xml$', '.xml')), 1, 500)"/>
    <p:variable name="doctype-public" 
      select="if (contains($unparsed, '!DOCTYPE')) 
              then replace($unparsed, '.*?&lt;!DOCTYPE\s+\S+\s+PUBLIC\s+&quot;([^&quot;]+)&quot;\s+&quot;([^&quot;]+)&quot;.+$', '$1', 's')
              else $default-niso-doctype-public"/>
    <p:variable name="doctype-system" 
      select="if (contains($unparsed, '!DOCTYPE'))
              then replace($unparsed, '.*?&lt;!DOCTYPE\s+\S+\s+PUBLIC\s+&quot;([^&quot;]+)&quot;\s+&quot;([^&quot;]+)&quot;.+$', '$2', 's')
              else $default-niso-doctype-system"/>
    <p:validate-with-schematron name="single-sch2" assert-valid="false">
      <p:with-param name="allow-foreign" select="'true'"/>
      <p:input port="schema">
        <p:pipe port="schematron" step="batch-val"/>
      </p:input>
    </p:validate-with-schematron>
    <p:choose>
      <p:when test="ends-with(base-uri(), '.xpl')">
        <cx:message>
          <p:with-option name="message" select="'WARNING: Won’t store because base URI ends with .xpl: ', base-uri()"/>
        </cx:message>
        <p:sink name="sink4"/>
      </p:when>
      <p:otherwise>
        <cx:namespace-delete prefixes="c"/>
        <cx:message>
          <p:with-option name="message" select="'PPPPPPPPPPP ', base-uri()"/>
        </cx:message>
        <p:store omit-xml-declaration="false">
          <p:with-option name="href" select="base-uri()"/>
          <p:with-option name="doctype-public" select="$doctype-public"/>
          <p:with-option name="doctype-system" select="$doctype-system"/>
        </p:store>    
      </p:otherwise>
    </p:choose>
    <p:add-attribute name="add-uri-to-post-fix-svrl" match="/*" attribute-name="xml:base">
      <p:input port="source">
        <p:pipe port="report" step="single-sch2"/>
      </p:input>
      <p:with-option name="attribute-value" select="concat(base-uri(/*), '.val')">
        <p:pipe port="current" step="post-fix-schematron"/>
      </p:with-option>
    </p:add-attribute>
  </p:for-each>
  
  <p:sink name="sink5"/>
  
  <p:insert name="insert-post-fix-svrl" position="last-child">
    <p:input port="source">
      <p:pipe port="result" step="wrap-errors"/>
    </p:input>
    <p:input port="insertion">
      <p:pipe port="report" step="post-fix-schematron"/>
    </p:input>
  </p:insert>

  <p:xslt name="svrl2html">
    <p:with-param name="common-path" select="/*/@xml:base">
      <p:pipe port="result" step="find-files"/>
    </p:with-param>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="svrl2html.xsl"/>
    </p:input>
  </p:xslt>

</p:declare-step>
