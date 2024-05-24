<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:sbf="http://transpect.io/schematron-batch-fix"
  xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:s="http://purl.oclc.org/dsdl/schematron"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns="http://www.w3.org/1999/xhtml"
  version="2.0"
  exclude-result-prefixes="svrl s xs html"
  >

  <xsl:param name="common-path" as="xs:string"/>
  <xsl:param name="group-by-error-code" as="xs:boolean" select="true()"/>

  <xsl:key name="by-id" match="*[@id]" use="@id"/>
  <xsl:key name="by-location" match="*[@location]" use="@location"/>

  <xsl:template match="/" mode="#default">
    <xsl:variable name="content" as="element(html:tr)*">
      <xsl:variable name="individual-reports" as="document-node(element(*))*">
        <xsl:for-each select="/reports/*">
          <xsl:document>
            <xsl:copy-of select="."/>
          </xsl:document>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="original-reports" as="document-node(element(*))*" 
        select="$individual-reports[not(ends-with(base-uri(/*), 'fixed.xml.val'))]"/>
      <xsl:variable name="post-fix-reports" as="document-node(element(*))*" 
        select="$individual-reports[ends-with(base-uri(/*), 'fixed.xml.val')]"/>
      <xsl:variable name="msgs" as="element(*)*" 
        select="$original-reports//svrl:failed-assert | $original-reports//svrl:successful-report 
                | $original-reports//c:error"/>
      <xsl:if test="exists($msgs)">
        <xsl:for-each-group select="$msgs" 
          group-by="(.//svrl:text/sch:span[@class='srcfile'], replace(base-uri(/*), '\.val$', ''))[1]">
          <xsl:sort select="current-grouping-key()"/>
          <tr id="file{format-number(position(), '0000')}" class="sep">
            <th colspan="5">
              <xsl:value-of select="substring-after(replace(current-grouping-key(), '//+', '/'), 
                                                    replace($common-path, '//+', '/'))"/>
            </th>
          </tr>
          <xsl:for-each-group select="current-group()" 
            group-by="(preceding-sibling::svrl:active-pattern[1]/@id, 'Schema'[current()/self::c:error])[1]">
            <xsl:variable name="active-pattern" select="key('by-id', current-grouping-key())/self::svrl:active-pattern" 
              as="node()?"/>
            <xsl:for-each select="current-group()">
              <tr id="{generate-id()}">
                <xsl:if test="position() = 1">
                  <xsl:attribute name="class" select="'sep'" />
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="exists($active-pattern)">
                    <td class="impact {(@role, 'error')[1]}">
                      <xsl:value-of select="(@role, 'error')[1]"/>
                    </td>
                    <td class="path">
                      <code>
                        <xsl:value-of select="if (not(matches($active-pattern/@document, '\.xpl$'))) 
                                              then @location 
                                              else replace(@location, '^.+xproc-step[^/]+(.+)$', '$1')"/>
                      </code>
                    </td>
                    <td class="message">
                        <xsl:apply-templates select="svrl:text/node()" mode="#current"/>
                    </td>
                    <td class="pattern-id">
                      <xsl:value-of select="tokenize(svrl:text/sch:span[@class = 'rule-base-uri'], '/')[last()], 
                                            $active-pattern/@id, @id" separator=" + "/>
                    </td>
                    <xsl:variable name="corresponding-post-fix-report" as="document-node(element(*))?"
                      select="$post-fix-reports[base-uri(/*) = replace(base-uri(current()), '\.xml\.val$', '.fixed.xml.val')]"/>
<!--                    <xsl:message select="'CCCCCCCCCCCCCCCC ',exists($corresponding-post-fix-report), base-uri(), ' :: ', $post-fix-reports/*/base-uri()"></xsl:message>-->
                    <xsl:variable name="location" as="xs:string?" select="@location"/>
                    <xsl:variable name="fixed" as="xs:boolean"
                      select="if (exists($corresponding-post-fix-report))
                              then empty(key('by-id', @id, $corresponding-post-fix-report)[svrl:text/sch:span[@class = 'srcpath'] = $location])
                              else false()"/>
                    <td class="fixed {$fixed}">
                      <xsl:value-of select="$fixed"/>
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <td class="impact error">
                      error
                    </td>
                    <td class="path">
                      <code><xsl:value-of select="@xpath"/></code> 
                    </td>
                    <td>
                      <xsl:value-of select="."/>
                    </td>
                    <td>
                      Schema: <xsl:value-of select="replace(../@schema, '\.rng$', '')"/>
                    </td>
                    <td> </td>
                  </xsl:otherwise>
                </xsl:choose>
              </tr>
            </xsl:for-each>
          </xsl:for-each-group>  
        </xsl:for-each-group>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="ok" as="element(html:tr)+">
      <tr xmlns="http://www.w3.org/1999/xhtml">
        <td class="Status" colspan="5"><p class="ok">Ok</p></td>
      </tr>
    </xsl:variable>

    <xsl:call-template name="output-table">
      <xsl:with-param name="content" select="if ($content) then $content else $ok" />
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="sch:span[@class = ('srcpath', 'rule-base-uri')]" mode="#default"/>

  <xsl:function name="html:impact-sortkey" as="xs:integer">
    <xsl:param name="elt" as="element(*)"/>
    <xsl:variable name="class" select="if($elt/@class) then replace($elt/@class, '\s*impact\s*', '') else ''"/>
    <xsl:choose>
      <xsl:when test="$class = 'fatal'">
        <xsl:sequence select="4"/>
      </xsl:when>
      <xsl:when test="$class = 'error'">
        <xsl:sequence select="3"/>
      </xsl:when>
      <xsl:when test="$class = 'warning'">
        <xsl:sequence select="2"/>
      </xsl:when>
      <xsl:when test="$class = 'info'">
        <xsl:sequence select="1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <xsl:template name="statistics">
    <xsl:param name="content" as="element(html:tr)*"/>
    <xsl:param name="td-class" as="xs:string"/>
    <xsl:for-each-group select="$content" group-by="html:td[@class eq $td-class]">
      <xsl:sort select="count(current-group())" order="descending"/>
      <tr xmlns="http://www.w3.org/1999/xhtml">
        <td xmlns="http://www.w3.org/1999/xhtml">
          <xsl:value-of select="current-grouping-key()"/>
        </td>
        <td xmlns="http://www.w3.org/1999/xhtml">
          <a href="{concat('by-', $td-class)}.html#{current-group()[1]/@id}">
            <xsl:value-of select="count(current-group())"/>
          </a>
        </td>
      </tr>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:template name="output-table">
    <xsl:param name="pre" as="element(*)*"/>
    <xsl:param name="content" as="element(html:tr)*"/>
    <xsl:if test="$content">
      <html xmlns="http://www.w3.org/1999/xhtml">
        <head xmlns="http://www.w3.org/1999/xhtml">
          <meta charset="UTF-8"/>
          <title xmlns="http://www.w3.org/1999/xhtml"></title>
          <style type="text/css">
            body {font-family: Calibri, Helvetica, sans-serif; background-color: #eee}
            @media(min-width: 1200px) {#tr-minitoc {position:fixed; display:block !important; max-width:20%; width:20%; overflow-y:auto; height:100%}}
            #tr-minitoc {display:none}
            ul.nav {padding-left: 10px;}
            ul.nav li {border-left: 2px solid #1e1e89}
            ul {list-style: none; padding-left:2px;}
            li {padding: 2px 0 2px .5rem;}
            li a {color: #777; text-decoration:none}
            div.header {background-color: #1e1e89; height: 65px; margin-bottom: 10px;}
            ul.header-list {color: #fff;}
            ul.header-list.right {float: right; padding-right: 2%}
            li.name {font-size: 150%; padding-right: 20px}
            li.date {padding-top: 8px}
            ul.header-list li {float: left;}
            @media(min-width: 1200px) {div.content {width:75% !important;}}
            div.content {width:95%; float:left; padding: 10px; background-color: #fff; margin-top: 12px; margin-left: 10px; position: relative}
            table {border-collapse: collapse; border: 1px solid #eee; table-layout: fixed; width: 100%; word-break: break-word}            
            tr.head th {background-color: #ccc;}
            th {background-color: #eee;}
            td, th { vertical-align: top; padding: 0.5em; text-align:left }
            td.path p { margin-top: 0; margin-bottom: 0.5em; }
            .ok, .fixed.true { color: #6d6; font-weight: bold; }
            .info { color: #ddd; font-weight: bold; }
            .warning { color: #FFB935; font-weight: bold; }
            .error, .fixed.false  { color: #ff1400; font-weight: bold; }
            .fatal { color: #f39; font-weight: bold; }
            details > details { margin-left: 1.5em; }
          </style>      
        </head>
        <body xmlns="http://www.w3.org/1999/xhtml">
          <div class="header">
            <ul class="header-list">
              <li><!--<img class="logo" src="http://this.transpect.io/a9s/common/template/icons/dav.svg"/>--></li>
            </ul>
            <ul class="header-list right">
              <li class="name">Nationales Prüfprofil</li>
              <li class="date">
                <xsl:value-of select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01], [H01]:[m01]')"/>
              </li>
            </ul>
          </div>
          <xsl:sequence select="$pre"/>
          <nav id="tr-minitoc" class="navbar-minitoc">
            <ul class="BC_minitoc nav">
              <li class="hidden active">
                <a class="page-scroll" href="#page-top"/>
              </li>
              <xsl:for-each select="$content[html:th]">
                <li class="BC_minitoc-item">
                  <a class="page-scroll" href="#file{format-number(position(), '0000')}">
                    <xsl:value-of select="tokenize(current()/html:th, '/')[last()]"/>
                  </a>
                </li>
              </xsl:for-each>
            </ul>
          </nav>
          <div class="content">
            <xsl:choose>
              <xsl:when test="$group-by-error-code">
                <details open="true">
                  <summary>
                    <xsl:sequence select="$content[exists(*/@colspan)]/*/node()"/>
                  </summary>
                  <xsl:for-each-group select="$content[empty(*/@colspan)]" group-by="html:td[@class = 'pattern-id']">
                    <xsl:variable name="fixed-count" as="xs:integer"
                                  select="count(current-group()/html:td[tokenize(@class, '\s+') = 'fixed']
                                                                       [tokenize(@class, '\s+') = 'true'])"/>
                    <details>
                      <summary>
                        <xsl:value-of select="current-grouping-key()"/>
                        <xsl:text> – </xsl:text>
                        <span>
                          <xsl:sequence select="html:td[tokenize(@class, '\s+') = 'impact']/(@class, node())"/>
                        </span>
                        <xsl:text>: </xsl:text>
                        <span>
                          <xsl:sequence select="html:td[tokenize(@class, '\s+') = 'impact']/@class"/>
                          <xsl:value-of select="count(current-group())"/>
                        </span>
                        <span>
                          <xsl:attribute name="class" 
                            select="if ($fixed-count = 0)
                                    then 'fixed false'
                                    else if (count(current-group()) - $fixed-count = 0)
                                         then 'fixed true'
                                         else 'warning'"/>
                          <xsl:text>, fixed: </xsl:text>
                          <xsl:value-of select="count(current-group()/html:td[tokenize(@class, '\s+') = 'fixed']
                                                                             [tokenize(@class, '\s+') = 'true'])"/>
                        </span>
                      </summary>
                      <xsl:call-template name="output-table-now-really">
                        <xsl:with-param name="content" select="current-group()"/>
                      </xsl:call-template>
                    </details>
                  </xsl:for-each-group>
                </details>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="output-table-now-really">
                    <xsl:with-param name="content" select="$content"/>
                  </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </body> 
        <!--<script src="http://this.transpect.io/a9s/common/template/js/jquery-2.1.4.min.js"></script>
        <script src="http://this.transpect.io/a9s/common/template/js/jquery.easing.1.3.js"/>
        <script src="http://this.transpect.io/a9s/common/template/js/scrolling-nav.js"/>-->
      </html>
    </xsl:if>
  </xsl:template>

  <xsl:template name="output-table-now-really">
    <xsl:param name="content" as="element(html:tr)+"/>
    <table border="1" valign="top">
      <tr class="head">
        <th style="width:8%">Severity</th>
        <th style="width:30%">XPath</th>
        <th style="width:35%">Message</th>
        <th style="width:21%">Schema name + Pattern ID + Report/Assert ID</th>
        <th style="width:6%">fixed</th>
      </tr>
      <xsl:sequence select="$content"/>
    </table>
  </xsl:template>

  <xsl:variable name="block-names" as="xs:string+" select="('dl', 'div', 'ol', 'ul', 'c:errors', 'c:error')"/>

  <xsl:template match="svrl:schematron-output/svrl:text" mode="#default">
    <xsl:for-each-group select="node()" group-adjacent="name() = $block-names">
      <xsl:choose>
        <xsl:when test="current-grouping-key()">
          <xsl:apply-templates select="current-group()" mode="#current" />
        </xsl:when>
        <xsl:otherwise>
          <p>
            <xsl:apply-templates select="current-group()" mode="#current" />
          </p>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template match="svrl:schematron-output/sbf:xsl-fix" mode="#default"/>
  
  <xsl:template match="sch:span[@class = 'srcfile']" mode="#default"/>

  <xsl:template match="c:errors" mode="#default">
    <dl class="errors">
      <xsl:apply-templates mode="#current"/>
    </dl>
  </xsl:template>
  
  <xsl:template match="c:ok" mode="#default"/>

  <xsl:template match="c:error" mode="#default">
    <dt>
      <xsl:value-of select="@code"/>
    </dt>
    <dd>
      <xsl:apply-templates select="@line, @xpath, node()" mode="#current"/>
    </dd>
  </xsl:template>
  
  <xsl:template match="c:error/text()" mode="#default">
    <xsl:value-of select="replace(., '^.+file:.+?;\s*', '')"/>
  </xsl:template>

  <xsl:template match="s:emph" mode="#default">
    <em xmlns="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates mode="#current" />
    </em>
  </xsl:template>

  <xsl:template match="* | @*" mode="#default">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>