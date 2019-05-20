<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ttt="http://transpect.io/tokenized-to-tree" xmlns:c="http://www.w3.org/ns/xproc-step"
  version="1.0" xmlns:cx="http://xmlcalabash.com/ns/extensions" xmlns:tr="http://transpect.io"
  name="batch-val">

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
  <p:output port="errors">
    <p:pipe port="result" step="wrap-errors"/>
  </p:output>
  <p:serialization port="errors" omit-xml-declaration="false"/>
  
  <p:documentation>see find-files.xpl for options documentation</p:documentation>
  <p:option name="input-filename-regex" select="'\.xml$'"/>
  <p:option name="file-list-txt" select="''"/>
  <p:option name="input-dir"/>
  <p:option name="depth" select="'-1'"/>
  <p:option name="uninteresting-dir-regex" select="''"/>
  
  <p:import href="../find-files/find-files.xpl"/>
  <p:import href="http://transpect.io/xproc-util/file-uri/xpl/file-uri.xpl"/>
  <p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
  <p:import href="http://transpect.io/calabash-extensions/rng-extension/xpl/validate-with-rng-declaration.xpl"/>

  <tr:find-files name="find-files">
    <p:with-option name="input-dir" select="$input-dir"/>
    <p:with-option name="file-list-txt" select="$file-list-txt"/>
    <p:with-option name="depth" select="$depth"/>
    <p:with-option name="input-filename-regex" select="$input-filename-regex"/>
    <p:with-option name="uninteresting-dir-regex" select="''"/>
  </tr:find-files>
  
<!--  <p:delete match="c:file[c:errors]"/>-->

  <p:for-each name="file-iteration">
    <p:iteration-source select="//c:file[exists(standard | adoption)]"/>
    <p:output port="errors" sequence="true" primary="true">
      <p:pipe port="errors" step="val"/>
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

        <p:choose name="load-schema">
          <p:xpath-context>
            <p:pipe port="matched" step="actual-standard-doc"/>
          </p:xpath-context>
          <p:when test="/*/@dtd-version = '1.0' or empty(//nat-meta | //reg-meta | //iso-meta)">
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
        <tr:validate-with-rng name="rng">
          <p:input port="source">
            <p:pipe port="matched" step="actual-standard-doc"/>
          </p:input>
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
        <!--<p:try name="rng">
          <p:group>
            <p:output port="errors" primary="true"/>
            <p:validate-with-relax-ng assert-valid="true">
              <p:input port="source">
                <p:pipe port="matched" step="actual-standard-doc"/>
              </p:input>
              <p:input port="schema">
                <p:pipe port="result" step="load-schema"/>
              </p:input>
            </p:validate-with-relax-ng>
            <p:sink/>
            <p:identity>
              <p:input port="source">
                <p:inline>
                  <c:ok/>
                </p:inline>
              </p:input>
            </p:identity>
          </p:group>
          <p:catch name="catch">
            <p:output port="errors" primary="true">
              <p:pipe port="result" step="add-uri-to-error"/>
            </p:output>
            <p:add-attribute name="add-uri-to-error" match="/*" attribute-name="xml:base">
              <p:input port="source">
                <p:pipe port="error" step="catch"/>
              </p:input>
              <p:with-option name="attribute-value" select="$output-file-uri"/>
            </p:add-attribute>
          </p:catch>
        </p:try>-->

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
        <p:identity>
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

  <p:xslt name="svrl2html">
    <p:with-param name="common-path" select="/*/@xml:base">
      <p:pipe port="result" step="find-files"/>
    </p:with-param>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
    <p:input port="source">
      <p:pipe port="errors" step="file-iteration"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="svrl2html.xsl"/>
    </p:input>
  </p:xslt>

</p:declare-step>
