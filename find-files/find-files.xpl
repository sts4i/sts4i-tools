<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:tr="http://transpect.io"
  xmlns:cx="http://xmlcalabash.com/ns/extensions"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
  name="find-files" type="tr:find-files">
  
  <p:output port="result" primary="true">
    <p:documentation>A recursive directory listing (c:directory[@name][@cml:base]) with matching files 
      as c:file[@name] elements.
      If $read-files = 'true', the file (if it is well-formed) will be embedded below its c:file element.
      Please note that this pipeline needs a frontend project with transpect libraries (Calabash, xproc-util, 
      xslt-util).
    </p:documentation>
  </p:output>
  <p:serialization port="result" omit-xml-declaration="false"/>

  <p:option name="input-filename-regex" select="''">
    <p:documentation>see the variable 'default-input-filename-regex' below for an example</p:documentation>
  </p:option>
  <p:option name="file-list-txt" select="''">
    <p:documentation>URI of a text file, one item per line. Within the line, fields are separated by the 
      pound char ('#'). The second-to-last field contains the base part of a file name, for example 'DIN_EN_1466_2016-12'.
    This is a preliminary format that is likely to change.
    </p:documentation>
  </p:option>
  <p:option name="depth" select="'-1'">
    <p:documentation>The depth at which the converter looks for input files. 0 means: only in the
      given directory, 1 means: *only* at the directories below the given one, etc. -1 means: look at
      any depth. Only relevant if processing a recursive directory list.</p:documentation>
  </p:option>
  <p:option name="input-dir">
    <p:documentation>URI or OS name. Relative paths will be resolved against current working directory.</p:documentation>
  </p:option>
  <p:option name="uninteresting-dir-regex" select="''">
    <p:documentation>If the regex is non-empty, exclude directories that match it.</p:documentation>
  </p:option>
  <p:option name="read-files" select="'true'">
    <p:documentation>Whether to try to parse the found files and include them as children of the c:file elements.
    Parsing or validation errors will be caught and will produce a c:errors[c:error] element below c:file.
    </p:documentation>
  </p:option>
  <p:option name="dtd-validate" select="'true'"/>
  <p:option name="debug" required="false" select="'no'"/>
  <p:option name="debug-dir-uri" required="false" select="'debug'"/>


  <p:import href="http://transpect.io/xproc-util/recursive-directory-list/xpl/recursive-directory-list.xpl">
    <p:documentation>See https://transpect.github.io/tutorial.html on how to set up a transpect project
    with git submodules and XML catalogs.</p:documentation>
  </p:import>
  <p:import href="http://transpect.io/xproc-util/file-uri/xpl/file-uri.xpl"/>
  <p:import href="http://transpect.io/xproc-util/store-debug/xpl/store-debug.xpl"/>
  <p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>

  <p:variable name="default-input-filename-regex" select="'\.xml$'"/>
  <p:variable name="calculated-input-filename-regex" 
    select="if (normalize-space($file-list-txt))
            then concat(
                   '(',
                   string-join(
                     for $line in tokenize(
                                    unparsed-text($file-list-txt),
                                    '&#xa;'
                                  )[position() gt 1]
                     return
                     tokenize(
                       $line,
                       '#'
                     )[position() = last() - 1],
                     '|'
                   ),
                   ')\.xml$'
                 )
            else ($input-filename-regex[normalize-space()], $default-input-filename-regex)[1]">
    <p:documentation>If round or square brackets may appear in the file-list-txt entries, some escaping needs to be done.</p:documentation>
  </p:variable>
  
  <tr:file-uri name="input-dir-uri" fetch-http="false">
    <p:with-option name="filename" select="$input-dir"/>
  </tr:file-uri>
  
  <cx:message name="m1">
    <p:with-option name="message" select="'Input filename regex: ', $calculated-input-filename-regex"/>
  </cx:message>

  <p:sink name="sink0"/>
  
  <p:group name="main" cx:depends-on="m1">
    <p:variable name="input-dir-uri" select="/*/@local-href">
      <p:pipe port="result" step="input-dir-uri"/>
    </p:variable>

    <tr:recursive-directory-list name="dirlist" exclude-filter="(^#|->)">
      <p:with-option name="path" select="$input-dir-uri"/>
    </tr:recursive-directory-list>
    
    <p:delete name="delete-uninteresting-dirs">
      <p:with-option name="match" 
        select="concat('c:directory[if (''', $uninteresting-dir-regex, ''') 
                                    then matches(@name, ''', $uninteresting-dir-regex, ''') 
                                    else false()]')"/>
    </p:delete>
    <p:xslt name="add-relpath">
      <p:input port="stylesheet">
        <p:inline>
          <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
            <xsl:template match="* | @*">
              <xsl:copy>
                <xsl:apply-templates select="@*, node()"/>
              </xsl:copy>
            </xsl:template>
            <xsl:template match="c:file/@name">
              <xsl:copy/>
              <xsl:attribute name="relpath" select="string-join((ancestor::c:directory[position() lt last()]/@name, .), '/')"/>
            </xsl:template>
          </xsl:stylesheet>
        </p:inline>
      </p:input>
      <p:input port="parameters"><p:empty/></p:input>
    </p:xslt>
    <tr:store-debug>
      <p:with-option name="pipeline-step" select="'find-files/recursive-directory-list'"/>
      <p:with-option name="active" select="$debug"/>
      <p:with-option name="base-uri" select="$debug-dir-uri"/>
    </tr:store-debug>
    <p:choose>
      <p:when test="number($depth) ge 0">
        <p:delete>
          <p:with-option name="match" select="concat('c:file[not(count(ancestor::c:directory) = ', $depth, ')]')"/>
        </p:delete>
      </p:when>
      <p:otherwise>
        <p:identity/>
      </p:otherwise>
    </p:choose>
    <p:delete>
      <p:with-option name="match" 
        select="concat('c:file[not(matches(@name, ''', $calculated-input-filename-regex, '''))]')"/>
    </p:delete>

    <p:viewport name="load-file-viewport" match="c:file">
      <p:variable name="input-file-uri" select="resolve-uri(/*/@name, base-uri(/*))"/>
      <p:try name="try-load">
        <p:group>
          <p:output port="result" primary="true"/>
          <p:load name="load">
            <p:with-option name="dtd-validate" select="$dtd-validate"/>
            <p:documentation>All possible public/system identifiers need to be specified in a catalog, and of course
            copies of the respective DTD and entity files need to be included in </p:documentation>
            <p:with-option name="href" select="$input-file-uri"/>
          </p:load>
        </p:group>
        <p:catch name="catch">
          <p:output port="result" primary="true"/>
          <p:identity>
            <p:input port="source">
              <p:pipe port="error" step="catch"/>
            </p:input>
          </p:identity>
          <p:try name="try-load2">
            <p:group>
              <p:output port="result" primary="true"/>
              <p:load name="load-without-dtd" dtd-validate="false">
                <p:with-option name="href" select="$input-file-uri"/>
              </p:load>
            </p:group>
            <p:catch name="catch22">
              <p:output port="result" primary="true"/>
              <p:identity>
                <p:input port="source">
                  <p:pipe port="error" step="catch22"/>
                </p:input>
              </p:identity>
            </p:catch>
          </p:try>
          <cx:message>
            <p:with-option name="message" select="'Could not parse ', $input-file-uri"/>
          </cx:message>
        </p:catch>
      </p:try>
      
      <p:sink name="sink2"/>
      
      <p:insert name="insert" position="last-child">
        <p:input port="source">
          <p:pipe port="current" step="load-file-viewport"/>
        </p:input>
        <p:input port="insertion">
          <p:pipe port="result" step="try-load"/>
        </p:input>
      </p:insert>
      
    </p:viewport>
    
    <tr:store-debug>
      <p:with-option name="pipeline-step" select="'find-files/result'"/>
      <p:with-option name="active" select="$debug"/>
      <p:with-option name="base-uri" select="$debug-dir-uri"/>
    </tr:store-debug>
  </p:group>

</p:declare-step>
