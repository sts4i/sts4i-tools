<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:tbx="urn:iso:std:iso:30042:ed-1"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:mle="http://www.iso.org/ns/mle"
  xmlns:isosts="http://www.iso.org/ns/isosts"
  xmlns:loc="http://www.iso.org/ns/localization"
  xmlns:saxon	= "http://saxon.sf.net/"
  xmlns:tmp="http://www.iso.org/ns/tmp"
  xmlns:tr="http://transpect.io"
  xmlns:xscore-content="http://din.com/xscore/content"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xs xlink mml tbx xhtml isosts loc mle saxon tmp tr xscore-content"
  version="2.0">
  
  <!-- Copyright 2017 ISO and contributors

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License. -->
  
  
  <!-- This is a two-pass transformation. If you use Saxon, and assuming your script to invoke Saxon is called 'saxon',
    you can transform NISO or ISO STS files like this (assuming you are in the sts4i-tools directory):

    saxon -xsl:nisosts2html/nisosts2html.xsl -s:/path/to/your/nisosts.xml
    
    The purpose of the 'postprocess' passes is to treat links to other sections differently when only individual sections
    are processed, to optionally include the referenced CSS files and several other tasks, mostly related to snippet-wise
    output (include footnotes at the end of the snippet that they belong to, rather than at the end of the document, etc.). 
    
    Please see below for parameters. You might need to turn an absolute path into an URI on Windows. Example:
    -s:file:/C:/path/to/your/nisosts.xml
    
    Alternatively, you can invoke the transformation via XProc or other means. The two passes are '#default' and 'postprocess'.
    However, this is untested yet. CSS embedding may not work because of unimplemented serialization parameters, and the 
    variable sts-root in the postprocess mode may be set to an HTML element instead of standard or adoption. --> 
  
  <xsl:import href="../isosts2html/isosts2html_standalone.xsl"/>

  <xsl:output method="xhtml" indent="no" encoding="UTF-8" use-character-maps="gt-for-css" omit-xml-declaration="no" 
    doctype-public="" doctype-system="" html-version="5.0"/>
  
  <xsl:character-map name="gt-for-css">
    <xsl:output-character character="&gt;" string="&gt;"/>
  </xsl:character-map>
  
  <xsl:param name="css" as="xs:string" select="'../isosts2html/isosts.css'"/>
  <xsl:param name="niso-css" as="xs:string" select="'nisosts.css'"/>
  <xsl:param name="expand-css" select="'no'" as="xs:string">
    <!-- Whether to include the CSS files in <link> elements -->
  </xsl:param>
  <xsl:param name="sectioning-element" select="'div'"/>
  <xsl:param name="snippet-root-class" as="xs:string" select="''"/>
  <xsl:param name="nav-include-term-sec-in-toc" select="'yes'"/>
  <xsl:param name="sts-variant" select="'niso'" as="xs:string"/>
  <xsl:param name="unlimited" as="xs:boolean" select="false()">
    <!-- For snippet export: Whether the corresponding toc entry specifies subtree="unlimited" because
      it suppresses display of deeper levels in the toc -->
  </xsl:param>
  <xsl:param name="extract-objects-from-p" as="xs:string" select="'yes'">
    <!-- Whether to split an STS p with embedded table-wrap, non-normative-note, fig, disp-formula,
      list, def-list etc. at these objects and pull them up, as is standard HTML practice. Keeping 
      them there will only work if STS p is rendered as HTML div (which is the default for ISO STS
      but which doesn’t work well for block-level commenting). -->
  </xsl:param>
  <xsl:param name="secid" as="xs:string?">
    <!-- restrict output to a specific sec or app element with the given @id
    A special value of 'title' may be given in order to get the main title page.
    If the stylesheet is invoked with -it:toc, it specifies the top-level
    ID for ToC output. A value of secid=title will effect the ToC root to be 
    the standard title, that is, an additional ToC level will be inserted above
    the others. -->
  </xsl:param>
  <xsl:param name="export-snippets" select="'no'" as="xs:string">
    <!-- Whether snippets should be exported while writing the ToC -->
  </xsl:param>
  <xsl:param name="toc-uri" as="xs:string" select="replace(base-uri(/*), '\.xml', '.toc.xml')">
    <!-- file: URI (on some systems, an OS file name will also do) to which the toc will be written 
      when invoking this stylesheet with -it:toc -->
  </xsl:param>
  <xsl:param name="lang" as="xs:string?">
    <!-- will override /*/@xml:lang found in the document -->
  </xsl:param>
  <xsl:param name="nat-originator" as="xs:string?" select="()">
    <!-- for example, 'DIN' -->
  </xsl:param>
  
  <xsl:key name="elment-by-rid" match="*[@rid]" use="@rid"/>

  <xsl:variable name="do-expand-css" select="$expand-css = 'yes' and not($secid)"/>
  <xsl:variable name="do-extract-objects-from-p" as="xs:boolean" select="$extract-objects-from-p = 'yes'"/>


  <!-- INITIALLY MATCHING TEMPLATE IF NO NAMED TEMPLATE IS SPECIFIED: -->
  
  <xsl:template match="/" mode="#default">
    <xsl:apply-templates select="$default" mode="postprocess">
      <xsl:with-param name="doc-lang" tunnel="yes" as="xs:string" select="isosts:doc-lang(/)"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <!-- $default – VARIABLE THAT CONTAINS THE RESULT OF THE FIRST PASS: -->
  
  <xsl:variable name="default" as="document-node()">
    <xsl:call-template name="snippet-or-whole-doc-in-default-mode">
      <xsl:with-param name="include-arbitrarily-deep-subtrees" select="$unlimited" tunnel="yes"/>
    </xsl:call-template> 
  </xsl:variable>

  <xsl:variable name="sts-root" as="document-node(element(*))" select="/"/>

  <xsl:template name="snippet-or-whole-doc-in-default-mode" as="document-node()">
    <xsl:param name="section-id" as="xs:string?" select="$secid"/>
    <xsl:variable name="doc-lang" as="xs:string" select="isosts:doc-lang(/)"/>
    <xsl:document>
      <xsl:choose>
        <xsl:when test="starts-with($section-id, 'title')">
          <div>
            <xsl:sequence select="$snippet-container-class-att"/>
            <div class="sts-content">
              <xsl:call-template name="frontmatter">
                <xsl:with-param name="meta-elements" as="element(*)+" tunnel="yes">
                  <xsl:choose>
                    <xsl:when test="$section-id = 'title.int'">
                      <xsl:sequence select="//standard/front/(iso-meta | std-meta[std-ident/originator = 'ISO'])"/>
                    </xsl:when>
                    <xsl:when test="$section-id = 'title.reg'">
                      <xsl:sequence select="//standard/front/(reg-meta | std-meta[std-ident/originator = 'CEN'])
                                            | //adoption-front/std-meta[std-ident/originator = 'CEN']"/>
                    </xsl:when>
                    <xsl:when test="$section-id = 'title.nat'">
                      <xsl:sequence select="//standard/front/(nat-meta | std-meta[std-ident/originator = $nat-originator])
                                            | //adoption-front/std-meta[std-ident/originator = $nat-originator]"/>
                    </xsl:when>
                  </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="section-id" as="xs:string?" select="$section-id" tunnel="yes"/>
                <xsl:with-param name="doc-lang" as="xs:string" tunnel="yes" select="$doc-lang"/>
              </xsl:call-template>
            </div>
          </div>
        </xsl:when>
        <xsl:when test="$section-id = 'body'">
          <div class="sts-section">
            <div class="sts-content">
              <xsl:apply-templates select="//body[. intersect $snippet-roots]" mode="#default">
                <xsl:with-param name="doc-lang" as="xs:string" tunnel="yes" select="$doc-lang"/>
                <xsl:with-param name="section-id" as="xs:string?" select="$section-id" tunnel="yes"/>
              </xsl:apply-templates>
              <xsl:call-template name="footnotes"/>
            </div>
          </div>
        </xsl:when>
        <xsl:when test="$section-id">
          <xsl:variable name="sec" as="element(*)?" select="key('element-by-id', $section-id)"/>
          <xsl:variable name="level" as="xs:integer" 
            select="count($sec/(ancestor-or-self::sec | ancestor-or-self::app | ancestor-or-self::term-sec)) + 1"/>
          <div class="sts-section">
            <xsl:apply-templates select="$sec" mode="id">
              <xsl:with-param name="doc-lang" as="xs:string" tunnel="yes" select="$doc-lang"/>
            </xsl:apply-templates>
            <xsl:element name="h{$level}">
              <xsl:if test="normalize-space($sec/label)">
                <span class="sts-label">
                  <xsl:apply-templates select="$sec/label/node()" mode="#default"/>
                </span>
              </xsl:if>
              <xsl:apply-templates select="$sec/title/node()" mode="#default">
                <xsl:with-param name="doc-lang" as="xs:string" tunnel="yes" select="$doc-lang"/>
                <xsl:with-param name="section-id" as="xs:string?" select="$section-id" tunnel="yes"/>
              </xsl:apply-templates>
            </xsl:element>
            <xsl:variable name="snippet-secs" as="element(*)*"
              select="key('element-by-id', $section-id)/(node() except (label | title | processing-instruction() | comment())
                                                         | following-sibling::*[empty(. intersect $snippet-roots)]
                                                                               [not(@specific-use = ('standard.text'))]
                                                        )"/>
            <div class="sts-content">
              <xsl:apply-templates select="$snippet-secs" mode="#default">
                <xsl:with-param name="doc-lang" as="xs:string" tunnel="yes" select="$doc-lang"/>
                <xsl:with-param name="section-id" as="xs:string?" select="$section-id" tunnel="yes"/>
              </xsl:apply-templates>
            </div>
            <xsl:call-template name="snippet-footnotes">
              <xsl:with-param name="doc-lang" as="xs:string" tunnel="yes" select="$doc-lang"/>
              <xsl:with-param name="snippet-secs" select="key('element-by-id', $section-id)/title | $snippet-secs" tunnel="yes"/>
              <xsl:with-param name="section-id" as="xs:string?" select="$section-id" tunnel="yes"/>
            </xsl:call-template>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="/*" mode="#default">
            <xsl:with-param name="doc-lang" as="xs:string" tunnel="yes" select="$doc-lang"/>
            <xsl:with-param name="section-id" as="xs:string?" select="$section-id" tunnel="yes"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:document>
  </xsl:template>

  <xsl:variable name="snippet-roots" as="element(*)+" 
    select="/*/(  descendant::app 
                | descendant::sec[empty(parent::notes)]
                                 [label[normalize-space()] | title]
                                 [@id]
                | descendant::term-sec[$nav-include-term-sec-in-toc]
                                 [label[normalize-space()]]
                                 [@id]
                | descendant::body[some $c in * 
                                   satisfies (    not($c/self::sub-part) 
                                              and not($c/self::sec) )])
                | descendant::adoption-front
                | descendant::front"/>

  <xsl:variable name="snippet-container-class-att" as="attribute(class)">
    <xsl:attribute name="class" select="'sts-section'"/>
  </xsl:variable>

  <xsl:template match="adoption-front" mode="#default">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <!-- MODE postprocess: -->

  <!-- identity template: -->

  <xsl:template match="*" mode="postprocess" >
    <xsl:copy>
      <xsl:apply-templates select="." mode="postprocess-class"/>
      <xsl:apply-templates select="@* except @class, node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@* | processing-instruction() | comment()" mode="postprocess">
    <xsl:copy/>
  </xsl:template>
    
  <xsl:template match="*" mode="postprocess-class">
    <xsl:copy-of select="@class"/>
  </xsl:template>
  
  <xsl:template match="xhtml:link[@type = 'text/css'][$do-expand-css]" mode="postprocess">
    <style>
      <xsl:copy-of select="@type"/>
      <xsl:value-of select="replace(unparsed-text(@href), '&#xd;', '')"/>
    </style>
  </xsl:template>


  <!-- MAIN DOCUMENT LANGUAGE -->
  
  <xsl:function name="isosts:doc-lang" as="xs:string">
    <xsl:param name="root" as="document-node(element(*))"/>
    <xsl:sequence select="($lang, $root/*/@xml:lang, $root//standard/front/*/content-language)[1]"/>
  </xsl:function>
  
  
  <!-- FRONTMATTER -->
  
  <xsl:param name="sts-prefix" as="xs:string" select="'sts-'">
    <!-- CSS class prefix -->
  </xsl:param>

  <xsl:template name="frontmatter">
    <xsl:param name="meta-elements" as="element(*)" tunnel="yes"/>
    <xsl:choose>
      <xsl:when test="$sts-variant = 'iso'">
        <xsl:call-template name="frontmatter-for-iso-sts-1.1">
          <xsl:with-param name="meta-elements" as="element(*)" select="$meta-elements" tunnel="yes"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$meta-elements" mode="#default">
          <xsl:with-param name="is-main-meta" tunnel="yes" select="true()"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="main-titles">
    <xsl:param name="is-main-meta" as="xs:boolean?" tunnel="yes"/>
    <xsl:param name="doc-lang" as="xs:string" tunnel="yes"/>
    <xsl:variable name="meta-type" select="replace(./local-name(), '-meta', '')"/>
    <div class="{$sts-prefix}tr--titles">
      <div class="{$sts-prefix}tr--title-dot-1">
        <xsl:apply-templates select="title-wrap[@xml:lang = $doc-lang]/intro,
                                     title-wrap[@xml:lang = $doc-lang]/main,
                                     title-wrap[@xml:lang = $doc-lang]/compl,
                                     custom-meta-group/custom-meta[@xml:lang = $doc-lang][meta-name = 'title.text']
                                     "
                             mode="#current">
          <xsl:with-param name="is-main-meta" select="$is-main-meta"/>
        </xsl:apply-templates>
      </div>
      <xsl:apply-templates select="title-wrap[@xml:lang != $doc-lang]/full" mode="#current"/>
    </div>
  </xsl:template>
  
  <xsl:template name="frontmatter-for-iso-sts-1.1">
    <xsl:param name="meta-elements" as="element(*)+" tunnel="yes"/>
    <xsl:variable name="nat-front-secs" select="/standard/front/sec[ends-with((@specific-use,@id)[1], '.nat')]" as="element(sec)*"/>
    <xsl:variable name="reg-front-secs" select="/standard/front/sec[@id = 'titlepage'] 
                                              | /standard/front/sec[matches((@specific-use,@id)[1], '(^endorsement\.notice$|\.reg$)')]" as="element(sec)*"/>
    <xsl:variable name="iso-front-secs" select="/standard/front/sec[ends-with((@specific-use,@id)[1], '.int')]" as="element(sec)*"/>
    <xsl:variable name="main-meta" as="xs:string" select="replace($meta-elements[last()]/name(), '-meta', '')"/>
    <xsl:apply-templates select="$meta-elements[self::nat-meta]" mode="#default">
      <xsl:with-param name="is-main-meta" tunnel="yes" as="xs:boolean" select="$main-meta = 'nat'"/>
    </xsl:apply-templates>
    <xsl:call-template name="frontmatter-sections">
      <xsl:with-param name="content" select="$nat-front-secs" />
    </xsl:call-template>
    <xsl:apply-templates select="$meta-elements[self::reg-meta]" mode="#default">
      <xsl:with-param name="is-main-meta" tunnel="yes" as="xs:boolean" select="$main-meta = 'reg'"/>
    </xsl:apply-templates>
    <xsl:call-template name="frontmatter-sections">
      <xsl:with-param name="content" select="$reg-front-secs"/>
    </xsl:call-template>
    <xsl:apply-templates select="$meta-elements[self::iso-meta]" mode="#default">
      <xsl:with-param name="is-main-meta" tunnel="yes" as="xs:boolean" select="$main-meta = 'iso'"/>
    </xsl:apply-templates>
    <xsl:call-template name="frontmatter-sections">
      <xsl:with-param name="content" select="$iso-front-secs" />
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="frontmatter-sections">  
    <xsl:param name="content" as="element(*)*"/>
    <xsl:if test="exists($content)">
      <xsl:apply-templates select="$content" mode="#default"/>
      <hr/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="meta-note" mode="#default">
    <div class="standard-meta-note standard-meta-note-{@content-type}">
      <xsl:apply-templates mode="#current"/>  
    </div>
  </xsl:template>
  
  <xsl:template match="adoption-front/sec[last()] | front/sec[last()]" mode="#default">
    <xsl:next-match/>
    <hr/>
  </xsl:template>

  <xsl:template match="std-meta" mode="#default">
    <xsl:param name="doc-lang" as="xs:string" tunnel="yes"/>
    <xsl:variable name="is-main-meta" as="xs:boolean" select="not(../../../*/std-meta)"/>
    <xsl:apply-templates select="std-ident/doc-type, (doc-ref[normalize-space()], std-ref[@type = 'undated'])[1]" mode="#current"/>
    <xsl:call-template name="main-titles">
      <xsl:with-param name="is-main-meta" select="$is-main-meta" tunnel="yes"/>
    </xsl:call-template>
    <xsl:apply-templates select="ics[1], meta-note" mode="#current"/>
    <xsl:if test="$is-main-meta">
      <xsl:apply-templates select="comm-ref, 
                                   custom-meta-group/custom-meta[@xml:lang = $doc-lang][meta-name = 'supply']" mode="#current"/>
    </xsl:if>
    <xsl:if test="self::reg-meta">
      <xsl:apply-templates select="parent::front/sec[@specific-use = 'standard.text']" mode="#current"/>
    </xsl:if>
    <xsl:apply-templates select="permissions/copyright-statement" mode="#current"/>
    <hr/>
  </xsl:template>
  
  <xsl:template match="adoption[parent::adoption]" mode="#default">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <!-- END OF STS FRONTMATTER TREATMENT -->
  
  <xsl:template name="css-links">
    <link rel="stylesheet" type="text/css" href="{$css}"/>
    <link rel="stylesheet" type="text/css" href="{$niso-css}"/>
  </xsl:template>
  
  <xsl:template match="/*" mode="#default">
    <xsl:param name="doc-lang" as="xs:string" tunnel="yes"/>
    <xsl:variable name="meta-elements" as="element(*)+" 
      select="(adoption-front/std-meta, front/iso-meta, front/reg-meta, front/nat-meta, front/std-meta)"/>
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>
          <xsl:value-of select="string-join(
                                  (
                                    $meta-elements[doc-ref][last()]/((doc-ref[normalize-space()], std-ref[@type = 'undated'])[1]),
                                    $meta-elements[title-wrap[@xml:lang=$doc-lang]][last()]/title-wrap[@xml:lang=$doc-lang]/full
                                  ), ', ')"/>
        </title>
        <xsl:call-template name="css-links"/>
      </head>
      <body>
        <div class="sts-standard">
          <xsl:apply-templates mode="#current">
            <xsl:with-param name="doc-lang" as="xs:string" tunnel="yes" select="$doc-lang"/>
          </xsl:apply-templates>
          <xsl:call-template name="footnotes"/>
          <xsl:call-template name="copyright">
            <xsl:with-param name="metadata" select="$meta-elements[last()]"/>
          </xsl:call-template>
        </div>
      </body>
    </html>
  </xsl:template>
  
  <!-- (previously sts2html-frontend-iso.xsl) -->
  
  <xsl:template match="*" mode="id">
    <xsl:copy-of select="@id"/>
  </xsl:template>



  <xsl:template match="xhtml:a[$secid]
                              [@href[starts-with(., '#')]]
                              [@class = ('sts-xref', 'sts-std-ref')]
                              [empty(key('element-by-id', isosts:id-from-href(@href)))]" mode="postprocess">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
    
  <xsl:template match="xhtml:a[@href][@class = 'sts-xref']
                              [key('element-by-id', isosts:id-from-href(@href))/@class = 'sts-fn']/@class" mode="postprocess">
    <xsl:param name="in-toc" as="xs:boolean?" tunnel="yes"/>
    <xsl:param name="section-id" as="xs:string?" tunnel="yes"/>
    <xsl:choose>
      <xsl:when test="$section-id or $in-toc">
        <xsl:attribute name="{name()}" select="'sts-fnref'"/>    
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:key name="elment-by-rid" match="*[@rid]" use="@rid"/>
  
  <!-- toc -->
  
  <xsl:output name="toc" method="xml" indent="yes" saxon:suppress-indentation="xhtml:p xhtml:a xhtml:sup xscore-content:title"/>
  
  <xsl:template name="toc">
    <xsl:result-document format="toc" href="{$toc-uri}">
      <toc xmlns="http://din.com/xscore/content">
        <xsl:copy-of select="/*/@xml:lang"/>
        <xsl:apply-templates select="(key('element-by-id', $secid), /*)[1]" mode="toc">
          <xsl:with-param name="doc-lang" as="xs:string" tunnel="yes" select="isosts:doc-lang($sts-root)"/>
          <xsl:with-param name="in-toc" select="true()" tunnel="yes"/>
        </xsl:apply-templates>
      </toc>
    </xsl:result-document>
  </xsl:template>
  
  <!-- overwrite sts-p (retain IDs) -->

  <xsl:template name="p-style-type">
    <xsl:copy-of select="@id"/>
    <xsl:choose>
      <xsl:when test="@style-type or @content-type">
        <xsl:attribute name="class" select="lower-case(string-join(('sts-p', @style-type,@content-type),' '))"/>
      </xsl:when>
    </xsl:choose>    
  </xsl:template>

  <xsl:template match="tbx:termEntry
                        [exists(.. intersect $snippet-roots)]" mode="toc">
    <title xmlns="http://din.com/xscore/content">
      <xsl:apply-templates select="tbx:langSet[@xml:lang = /*/@xml:lang]/tbx:tig[tbx:normativeAuthorization/@value = 'preferredTerm']/tbx:term/node()" mode="#default">
        <xsl:with-param name="in-toc" select="true()" tunnel="yes"/>
      </xsl:apply-templates>
    </title>
  </xsl:template>
  
  <xsl:template match="xhtml:div[@class = 'tmp-footnotes']" mode="postprocess"/>
  
  <xsl:template match="xhtml:p[@class = 'tmp-para']" mode="postprocess">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*" mode="toc-preserve">
    <xsl:element name="{name()}" xmlns="http://din.com/xscore/content">
      <xsl:apply-templates select="@*, node()" mode="toc-preserve"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="node()" mode="toc">
    <!-- Overwrite built-in template for text nodes, in particular.
      They will be removed by default now. Except in mode toc-preserve.
      There they will be replicated by the preceding template. -->
    <xsl:apply-templates mode="#current"/>
  </xsl:template>


  <!-- next to initial template in default mode -->
  
  <xsl:template match="/standard" mode="#default">
    <xsl:param name="doc-lang" as="xs:string" tunnel="yes"/>
    <xsl:variable name="meta-elements" as="element(*)+" select="(front/iso-meta, front/reg-meta, front/nat-meta, front/std-meta)"/>
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>
          <xsl:value-of select="string-join(
                                  (
                                    $meta-elements[doc-ref][last()]/((doc-ref[normalize-space()], std-ref[@type = 'undated'])[1]),
                                    $meta-elements[title-wrap[@xml:lang=$doc-lang]][last()]/title-wrap[@xml:lang=$doc-lang]/full
                                  ), ', ')"/>
        </title>
        <xsl:call-template name="css-links"/>
      </head>
      <body>
        <div class="sts-standard">
          <xsl:call-template name="frontmatter-for-iso-sts-1.1">
            <xsl:with-param name="meta-elements" as="element(*)+" select="$meta-elements" tunnel="yes"/>
            <xsl:with-param name="doc-lang" as="xs:string" tunnel="yes" select="$doc-lang"/>
          </xsl:call-template>
          <xsl:apply-templates select="body | back" mode="#current">
            <xsl:with-param name="meta-elements" as="element(*)+" select="$meta-elements" tunnel="yes"/>
            <xsl:with-param name="doc-lang" as="xs:string" tunnel="yes" select="$doc-lang"/>
          </xsl:apply-templates>
          <xsl:call-template name="footnotes"/>
          <xsl:call-template name="copyright">
            <xsl:with-param name="metadata" select="$meta-elements[last()]"/>
          </xsl:call-template>
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="app/annex-type" mode="#default">
    <xsl:param name="doc-lang" as="xs:string" tunnel="yes"/>
    <div class="sts-app-header">
      <xsl:choose>
        <xsl:when test="$doc-lang = 'de'">
          <xsl:value-of select="replace(., 'ormative', 'ormativ')"/>    
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>          
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>
  
  <xsl:template match="object-id" mode="#default"/>
  
  <xsl:template match="list[@list-type = ('alpha-lower', 'order', 'alpha-upper')]/list-item/label/text()[last()]" mode="#default">
    <xsl:next-match/>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="ref/label/text()[last()]" mode="#default">
    <xsl:text>[</xsl:text>
    <xsl:next-match/>
    <xsl:text>]</xsl:text>
  </xsl:template>
  
  <xsl:template match="sub-part[@part-type = ('standard.int', 'standard.eur', 'standard.nat')]
                               [every $e in * satisfies $e/(self::title | self::body | self::back)]" mode="#default">
    <xsl:apply-templates select="body | back" mode="#current"/>
  </xsl:template>

  <xsl:template match="sub-part[body/sub-part]/back | back[not(ancestor::sub-part)]" mode="#default">
    <hr/>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="col/@width" mode="table-copy">
    <xsl:attribute name="style" select="string-join(('width', .), ': ')"/>
  </xsl:template>
  
  <xsl:template match="@content-type" mode="table-copy">
    <xsl:attribute name="class" select="for $v in tokenize(., '\s+') return concat('sts-', $v)" separator=" "/>
  </xsl:template>
  
  <xsl:template match="table/@rules" mode="table-copy">
    <!-- for the time being, assume that the ultimate truth is on each cell -->
  </xsl:template>
  
  <xsl:template match="caption" mode="#default">
    <div class="sts-caption">
      <xsl:if test="preceding-sibling::label">
        <xsl:apply-templates select="preceding-sibling::label" mode="caption-label"/>
        <xsl:text>&#x0A;</xsl:text>
        <!-- don't use mdash if label ends with ) -->
        <xsl:if test="not(ends-with(preceding-sibling::label, ')'))">
          <xsl:text>—&#x0A;</xsl:text>
        </xsl:if>
      </xsl:if>
      <xsl:apply-templates select="title" mode="#current"/>
    </div>
  </xsl:template>

  <xsl:template match="fig" mode="#default" priority="-0.25">
    <div class="sts-{local-name()} {@position}">
      <xsl:apply-templates select="@id" mode="#current"/>
      <xsl:call-template name="named-anchor"/>
      <xsl:variable name="known-stuff" as="element(*)*" select="graphic, label[not(following-sibling::caption)], caption"/>
      <xsl:apply-templates select="graphic" mode="#current"/>
      <xsl:call-template name="legend"/>
      <xsl:apply-templates select="label[not(following-sibling::caption)], caption, * except $known-stuff" mode="#current"/>
    </div>
  </xsl:template>
  
  <xsl:template match="fig/@id" mode="#default">
    <xsl:attribute name="id" select="string-join($doc-id, .)"/>
  </xsl:template>

  <!-- §§§ -->
  <xsl:template match="graphic | inline-graphic" mode="#default">
    <xsl:apply-templates/>
    <img alt="{@xlink:href}">
      <xsl:for-each select="alt-text">
        <xsl:attribute name="alt">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:attribute>
      </xsl:for-each>
      <xsl:apply-templates select="@xlink:href" mode="#current"/>
    </img>
  </xsl:template>
  
  <xsl:template match="def-list[@list-type = 'callout']/title" mode="#default">
    <p class="sts-legend-title">
      <xsl:apply-templates mode="#current"/>
    </p>
  </xsl:template>

  <xsl:template match="def-list[@list-type = 'footnotes']/def-item/term//text()[. is (ancestor::term[1]//text())[last()]]
                                                                               [not(ends-with(., ')'))]"
                mode="#default">
    <!-- add same-scope? -->
		<xsl:next-match/>
    <xsl:text>)</xsl:text>
	</xsl:template>
  
  <xsl:template match="def-item[@content-type = 'normal-para'][empty(term/node())]/def" mode="#default">
		<td class="def-def" colspan="2">
			<xsl:call-template name="assign-id"/>
			<xsl:apply-templates mode="#current"/>
		</td>
	</xsl:template>
  
  <xsl:template match="def-item[@content-type = 'normal-para'][empty(term/node())]/term" mode="#default"/>
  
  <xsl:template match="def" mode="#default">
		<!-- §§§ correction -->
    <td class="def-def">
			<xsl:call-template name="assign-id"/>
			<xsl:apply-templates mode="#current"/>
		</td>
	</xsl:template>

  <xsl:template match="mml:*" mode="#default">
    <xsl:element name="{local-name()}" xmlns="http://www.w3.org/1998/Math/MathML">
      <xsl:apply-templates select="@*, node()" mode="#current"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="mml:*/@*" mode="#default">
    <xsl:copy/>
  </xsl:template>
  
  <xsl:template match="non-normative-example" mode="#default">
    <div class="{for $class in (name(), @content-type) return concat('sts-', $class)}">
      <xsl:apply-templates mode="#current"/>
    </div>
  </xsl:template>
  
  <xsl:template match="label" mode="label-fn">
    <span class="sts-label">
      <xsl:apply-templates/>  
    </span>
  </xsl:template>
  
  <xsl:template match="named-content" mode="#default">
    <span>
      <xsl:apply-templates select="@*, node()" mode="#current"/>
    </span>
  </xsl:template>
  
  <xsl:template match="named-content/@content-type" mode="#default">
    <xsl:attribute name="class" select="translate(.,' ','-')"/>
  </xsl:template>
  
  <xsl:template match="named-content/@content-type[. = 'label']" mode="#default" priority="2">
    <xsl:attribute name="class" select="'sts-label'"/>
  </xsl:template>
  
  <xsl:function name="isosts:contains-token" as="xs:boolean">
    <xsl:param name="input" as="xs:string?"/>
    <xsl:param name="tokens" as="xs:string+"/>
    <xsl:sequence select="tokenize($input, '\s+') = $tokens"/>
  </xsl:function>
  
  <!-- (end of what previously was in sts2html-frontend-iso.xsl) -->

  <!-- STS FRONTMATTER HANDLING -->

  <xsl:template match="nat-meta | reg-meta | iso-meta">
    <xsl:param name="is-main-meta" as="xs:boolean?" tunnel="yes"/>
    <xsl:param name="doc-lang" as="xs:string" tunnel="yes"/>
    <xsl:variable name="meta-type" select="replace(local-name(), '-meta', '')"/>
    <xsl:apply-templates select="std-ident/doc-type, (doc-ref[normalize-space()], std-ref[@type = 'undated'])[1]" mode="#current"/>
    <xsl:call-template name="main-titles"/>
    <xsl:apply-templates select="ics[1], 
                                 parent::front//sec[@id = concat('abstract.', $meta-type)], 
                                 parent::front//sec[@id = concat('superseding.note.', $meta-type)], 
                                 parent::front//sec[@id = concat('validity.note.', $meta-type)]" mode="#current"/>
    <xsl:if test="$is-main-meta">
      <xsl:apply-templates select="parent::front//sec[@id = concat('status.note.', $meta-type)], 
                                   comm-ref, 
                                   custom-meta-group/custom-meta[@xml:lang = $doc-lang][meta-name = 'supply']" mode="#current"/>
    </xsl:if>
    <xsl:if test="self::reg-meta">
      <xsl:apply-templates select="parent::front/sec[@specific-use = 'standard.text']" mode="#current"/>
    </xsl:if>
    <xsl:apply-templates select="permissions/copyright-statement" mode="#current"/>
    <hr/>
  </xsl:template>
  
  <xsl:template match="sec[matches(@id, 'status\.note')]" mode="#default">
    <div class="{$sts-prefix}tr--status-dot-note">
      <xsl:apply-templates select="node()"/>
    </div>
  </xsl:template>
  
  <xsl:template match="std-ident/doc-type" mode="#default" priority="3">
    <p class="{$sts-prefix}tr--status">
      <xsl:value-of select="string-join((text(),ancestor::*[matches(local-name(), '-meta$')][1]//release-version/text()), ' • ')"/>
    </p>
  </xsl:template>
  
  <xsl:template match="title-wrap/main" mode="#default">
    <p class="{$sts-prefix}tr--general-dot-title">
      <xsl:apply-templates mode="#current"/>
    </p>
  </xsl:template>
  
  <xsl:template match="title-wrap/intro" mode="#default">
    <p class="{$sts-prefix}tr--group-dot-title">
      <xsl:apply-templates mode="#current"/>
    </p>
  </xsl:template>
  
  <xsl:template match="break">
    <br/>
  </xsl:template>
  
  <xsl:template match="title-wrap/compl" mode="#default">
    <p class="{$sts-prefix}tr--sub-dot-title">
      <xsl:apply-templates mode="#current"/>
    </p>
  </xsl:template>
  
  <xsl:template match="title-wrap/full" mode="#default">
    <xsl:param name="doc-lang" as="xs:string" tunnel="yes"/>
        <p class="{$sts-prefix}tr--title-dot-2">
          <xsl:copy-of select="ancestor::*[@xml:lang][1]/@xml:lang"/>
          <xsl:apply-templates mode="#current"/>
        </p>
  </xsl:template>

  <xsl:template match="doc-ref | std-ref[ancestor::front | ancestor::adoption-front]" mode="#default">
    <xsl:param name="is-main-meta" as="xs:boolean?" tunnel="yes"/>
    <h1>
      <!--There is no child sts-tr-adopted. Did I mean 'sts-tr-\-adopted'? There is no CSS rule for that anyway.  
        <xsl:if test="not($is-main-meta)">
        <xsl:attribute name="class" select="sts-tr-adopted"/>
      </xsl:if>-->
      <xsl:value-of select="."/>
    </h1>
  </xsl:template>
  
  <xsl:template match="custom-meta[@xml:lang][meta-name = 'title.text']" mode="#default">
       <p class="{$sts-prefix}tr--title-dot-text">
         <xsl:value-of select="meta-value/node()"/>
       </p> 
  </xsl:template>
  
  <xsl:template match="custom-meta-group/custom-meta[@xml:lang][meta-name = 'supply']" mode="#default">
       <p class="{$sts-prefix}tr--supply">
         <xsl:value-of select="meta-value/node()"/>
       </p> 
  </xsl:template>  
  
  <xsl:template match="ics" mode="#default">
    <xsl:variable name="ics-text-seq" select="for $t in parent::node()/ics return if (matches($t/text(), '^[A-Za-z]*\s')) then $t/text() else concat('ICS ', $t/text())"/>
    <div class="{$sts-prefix}tr--classification">
      <xsl:value-of select="string-join($ics-text-seq, ' • ')"/>      
    </div>
  </xsl:template>
  
  <xsl:template match="comm-ref" mode="#default">
    <div class="{$sts-prefix}tr--committee">
    <xsl:value-of select="string-join((text(), parent::node()/secretariat/text()), ' • ')"/>
    </div>
  </xsl:template>
  
  <xsl:template match="sec[matches(@id, 'validity\.note')]" mode="#default">
    <div class="{$sts-prefix}tr--validity-dot-note">
      <xsl:apply-templates select="node()"/>
    </div>
  </xsl:template>

  <!-- Ovveride isosts2html because of verbose nbsp -->
  <xsl:template match="td">
    <xsl:element name="{node-name(.)}">
      <xsl:variable name="colpos" select="position()"/>
      <xsl:apply-templates select="@*" mode="table-copy"/>
      <xsl:variable name="col" select="ancestor::table/colgroup/col[$colpos]"/>
      <xsl:if test="not(@align) and $col/@align">
        <xsl:attribute name="align" select="$col/@align"/>
      </xsl:if>
      <xsl:if test="not(@valign) and $col/@valign">
        <xsl:attribute name="valign" select="$col/@valign"/>
      </xsl:if>
      <!-- provide nbsp; for empty table cells -->
      <xsl:if test="not(text()|./*)">
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template  name="copyright">
    <xsl:param name="metadata"/>
  </xsl:template>
  
  <!-- Not actually frontmatter, but should be centralized for QC and full rendering -->
  
  <xsl:template match="tbx:see" mode="#default">
    <p class="tr--related-dot-entries">
      <xsl:apply-templates select="@*, node()"/>
    </p>
  </xsl:template>

  
  <!-- PRIMARY CONTENT ELEMENTS -->
  
  <xsl:template match="app | disp-formula | sec | fig | non-normative-note | p | ref-list | table-wrap" mode="#default">
    <xsl:variable name="possibly-suppressed-subtree" as="item()*">
      <!-- Check whether the lower-precedence-or-priority template 
           that matches *[$secid] would have suppressed this subtree 
           (and if so, don’t create any result here, either): -->
      <xsl:next-match/>
    </xsl:variable>
    <xsl:if test="exists($possibly-suppressed-subtree)">
      <xsl:variable name="target-elt" as="xs:string">
        <xsl:apply-templates select="." mode="target-element"/>
      </xsl:variable>
      <xsl:element name="{$target-elt}">
        <xsl:apply-templates select="." mode="class-att"/>
        <!-- id rendering has to be the last attribute that is processed 
          because adaptations may choose to generate a elements with IDs rather 
          than IDs -->
        <xsl:apply-templates select="." mode="id"/>
        <xsl:apply-templates select="." mode="inner"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  
  <xsl:function name="isosts:para-splitting-role" as="xs:string">
    <xsl:param name="node" as="node()"/>
    <xsl:choose>
      <xsl:when test="$node/name() = ('table-wrap', 'disp-formula', 'non-normative-note', 'fig', 'list', 'def-list')">
        <xsl:sequence select="$node/name()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:template name="consecutive-numbering-PI"/>
  
  <xsl:template match="p[$do-extract-objects-from-p]" mode="#default" priority="2">
    <xsl:param name="doc-lang" as="xs:string" tunnel="yes"/>
    <xsl:variable name="target-elt" as="xs:string">
      <xsl:apply-templates select="." mode="target-element"/>
    </xsl:variable>
    <xsl:variable name="class" as="attribute(class)?">
      <xsl:apply-templates select="." mode="class-att">
        <xsl:with-param name="doc-lang" select="$doc-lang" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="id" as="item()*"><!-- id attribute or html:a elements with IDs -->
      <xsl:apply-templates select="." mode="id">
        <xsl:with-param name="doc-lang" select="$doc-lang" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="label" as="element(xhtml:span)?">
      <xsl:call-template name="isosts:section-label"/>
      <xsl:call-template name="isosts:list-label"/>
    </xsl:variable>
    <xsl:variable name="first-node" select="(node()[not(isosts:para-splitting-role(.))])[1]" as="node()?"/>
    <xsl:variable name="para-genid" select="generate-id()" as="xs:string"/>
    <xsl:variable name="consecutive-numbering-PI" as="processing-instruction(generated-id)?">
      <xsl:call-template name="consecutive-numbering-PI"/>
    </xsl:variable>
    <xsl:for-each-group select="node()" group-adjacent="isosts:para-splitting-role(.)">
      <xsl:choose>
        <xsl:when test="current-grouping-key()">
          <xsl:apply-templates select="current-group()" mode="#current"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="is-first-group" as="xs:boolean" 
            select="some $item in current-group() satisfies ($item is $first-node)"/>
          <xsl:if test="normalize-space($consecutive-numbering-PI) and not($is-first-group) and not(current-grouping-key())">
            <xsl:processing-instruction name="generated-id" select="string-join(($consecutive-numbering-PI, generate-id()), '__')"/>  
          </xsl:if>
          <xsl:element name="{$target-elt}">
            <xsl:sequence select="$class"/>
            <xsl:if test="$is-first-group">
              <xsl:sequence select="$id"/>
              <xsl:sequence select="$label"/>
            </xsl:if>
            <xsl:apply-templates select="current-group()" mode="#current"/>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template match="*" mode="target-element" as="xs:string">
    <xsl:sequence select="$sectioning-element"/>
  </xsl:template>
  
  <xsl:template match="p" mode="target-element" as="xs:string">
    <xsl:sequence select="'div'"/>
  </xsl:template>
  
  <xsl:template match="*" mode="inner">
    <xsl:apply-templates mode="#default"/>
  </xsl:template>
  
  <xsl:template name="legend">
    <xsl:variable name="legendary-stuff" as="element(*)*" select="caption/*[not(self::title)]"/>
    <xsl:if test="exists($legendary-stuff)">
      <div class="sts-legend">
        <xsl:apply-templates select="$legendary-stuff" mode="#current"/>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="fig" mode="inner">
    <xsl:variable name="known-stuff" as="element(*)*" select="graphic, label[not(following-sibling::caption)], caption"/>
    <xsl:apply-templates select="graphic" mode="#default"/>
    <xsl:call-template name="legend"/>
    <xsl:apply-templates select="label[not(following-sibling::caption)], caption, * except $known-stuff"/>
  </xsl:template>
  
  <xsl:template match="disp-formula" mode="inner">
    <xsl:apply-templates mode="#default"/>
    <xsl:if test="label">
      <div class="sts-{local-name()}-label"><xsl:value-of select="label"/></div>  
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="isosts:section-label">
    <xsl:if test="parent::sec and preceding-sibling::*[1][self::label[normalize-space()]]">
      <span class="sts-section-label">
        <xsl:apply-templates select="preceding-sibling::label" mode="sec-title"/>
        <xsl:text>&#xA0;&#xA0;&#xA0;</xsl:text>
      </span>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="isosts:list-label">
    <xsl:if test="parent::list-item and preceding-sibling::*[1][self::label[normalize-space()]]">
      <span class="sts-label">
        <xsl:apply-templates select="preceding-sibling::label/node()" mode="#default"/>
        <xsl:text>&#xA0;&#xA0;&#xA0;</xsl:text>
      </span>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="p" mode="inner">
    <xsl:call-template name="isosts:section-label"/>
    <xsl:call-template name="isosts:list-label"/>
    <xsl:apply-templates mode="#default"/>
  </xsl:template>
  
  <xsl:template match="ref-list" mode="inner">
    <ul class="sts-ref-list">
      <xsl:apply-templates mode="#default"/>
    </ul>
  </xsl:template>
  
  <xsl:template match="*" mode="class-att">
    <xsl:param name="doc-lang" as="xs:string" tunnel="yes"/>
    <xsl:variable name="additional-class-atts" as="xs:string?">
      <xsl:apply-templates select="." mode="additional-class-atts"/>
    </xsl:variable>
    <xsl:attribute name="class" separator=" ">
      <xsl:sequence select="string-join(('sts', isosts:name-for-class(.)), '-')"/>
      <xsl:sequence select="$additional-class-atts[normalize-space()]"/>
      <xsl:apply-templates select="." mode="snippet-root"/>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="*" mode="snippet-root" as="xs:string?">
    <xsl:if test="exists(. intersect $snippet-roots)">
      <xsl:sequence select="$snippet-root-class[normalize-space()]"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="sec" mode="name-for-class" as="xs:string">
    <xsl:sequence select="'section'"/>
  </xsl:template>
  
  <xsl:template match="disp-formula" mode="name-for-class" as="xs:string">
    <xsl:sequence select="'disp-formula-panel'"/>
  </xsl:template>
  
  <xsl:template match="*" mode="additional-class-atts" as="xs:string?"/>
  
  <xsl:template match="fig" mode="additional-class-atts" as="xs:string?">
    <xsl:sequence select="@position"/>
  </xsl:template>
  
  <xsl:template match="ref-list" mode="additional-class-atts" as="xs:string?">
    <xsl:sequence select="sts-section"/>
  </xsl:template>
  
  <xsl:template match="p" mode="additional-class-atts" as="xs:string?">
    <xsl:sequence select="string-join((@style-type, @content-type), ' ')"/>
  </xsl:template>
  
  <xsl:template match="table-wrap" mode="additional-class-atts" as="xs:string?">
    <xsl:sequence select="@content-type"/>
  </xsl:template>
  
  <xsl:template match="*" mode="name-for-class" as="xs:string">
    <xsl:sequence select="local-name()"/>
  </xsl:template>
  
  <xsl:function name="isosts:name-for-class" as="xs:string">
    <xsl:param name="elt" as="element(*)"/>
    <xsl:apply-templates select="$elt" mode="name-for-class"/>
  </xsl:function>

  <xsl:template match="*[@id]" mode="id">
    <xsl:attribute name="id" select="string-join(('toc_', $doc-id, @id), '_')"/>
  </xsl:template>
  
  <xsl:template match="*[empty(@id)]" mode="id"/>

  <xsl:function name="isosts:doc-layer-id" as="xs:string">
    <xsl:param name="elt" as="element(*)"/>
    <xsl:variable name="layer" as="element(*)" select="isosts:get-layer($elt)"/>
    <xsl:sequence select="(
                            isosts:docid-from-urn(
                              $layer/(front | adoption-front)/std-meta/std-ident/urn
                            )(:,
                            $layer/self::sub-part/@id:)
                          )[1]"/>
  </xsl:function>
  
  <!--<xsl:template name="custom-html-meta">
    <meta name="doc-id" content="isosts:doc-layer-id(/*)"/>
  </xsl:template>-->
  
  <xsl:function name="isosts:get-layer" as="element(*)"><!-- standard or adoption -->
    <xsl:param name="elt" as="element(*)"/>
    <!-- sub-part is for legacy ISO STS docs -->
    <xsl:sequence select="$elt/(ancestor-or-self::standard | ancestor-or-self::adoption (:| ancestor-or-self::sub-part:))[last()]"/>
  </xsl:function>
  
  <xsl:function name="isosts:docid-from-urn" as="xs:string?">
    <xsl:param name="urn" as="xs:string?"/>
    <xsl:sequence select="if ($urn) 
                          then replace(replace($urn,':','_'),'_-','-') 
                          else ()"/>
  </xsl:function>
  
  <xsl:function name="isosts:inner-language" as="xs:string">
    <xsl:param name="doc" as="document-node(element(*))"/>
    <xsl:sequence select="string($doc//standard/front/std-meta/content-language)"/>
  </xsl:function>


  <xsl:template match="term-sec" mode="#default">
    <xsl:element name="{$sectioning-element}">
      <xsl:apply-templates select="." mode="class-att"/>
      <xsl:apply-templates select="." mode="id"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="term-sec" mode="class-att">
    <xsl:attribute name="class" separator=" ">
      <xsl:sequence select="'sts-section sts-tbx-sec'"/>
      <xsl:apply-templates select="." mode="snippet-root"/>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="term-sec[@id]" mode="id" priority="1">
    <xsl:attribute name="id" select="string-join(($doc-id, tbx:termEntry[1]/@id), '_')"/>
  </xsl:template>

  <xsl:template match="xref[@ref-type = 'fn']" mode="#default">
    <a class="sts-xref" href="#{@rid}">
      <xsl:attribute name="title">
        <xsl:value-of select="key('element-by-id', @rid)/*[not(self::label)]"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>
  
  <xsl:template match="xhtml:a[@href][@class = 'sts-xref']
                              [key('element-by-id', isosts:id-from-href(@href))/@class = 'sts-fn']/@class" mode="postprocess">
    <xsl:param name="in-toc" as="xs:boolean?" tunnel="yes"/>
    <xsl:param name="section-id" as="xs:string?" tunnel="yes"/>
    <xsl:choose>
      <xsl:when test="$section-id or $in-toc">
        <xsl:attribute name="{name()}" select="'sts-fnref'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:function name="isosts:id-from-href" as="xs:string">
    <xsl:param name="href" as="xs:string"/>
    <xsl:sequence select="replace($href, '^#', '')"/>
  </xsl:function>

  <xsl:template match="fn" mode="footnote">
    <div class="sts-fn">
      <xsl:apply-templates select="." mode="id"/>
      <xsl:apply-templates mode="#current"/>
    </div>
  </xsl:template>
  
  <!-- SNIPPET FOOTNOTES -->
  
  <xsl:template name="snippet-footnotes">
    <xsl:param name="snippet-secs" as="element(*)*" tunnel="yes"/>
    <xsl:param name="descendant-snippets" as="element(*)*" select="$snippet-roots[exists(ancestor-or-self::* intersect $snippet-secs)]"/>
    <xsl:variable name="fns" select="//fn[some $ref in key('elment-by-rid', @id) 
                                          satisfies (
                                                      exists($ref/ancestor::* intersect $snippet-secs)
                                                      and
                                                      empty($ref/ancestor::* intersect $descendant-snippets)
                                                    )]"/>
    <xsl:if test="$fns">
      <div class="sts-footnotes">
        <xsl:apply-templates select="$fns" mode="footnote"/>
      </div>      
    </xsl:if>
  </xsl:template>
  
  <!-- REFS -->
  
  <xsl:template name="ref">
    <xsl:param name="std" as="element(std)+"/>
    <xsl:param name="doc-lang" as="xs:string" tunnel="yes"/>
    <xsl:variable name="filtered" as="element(std)+">
      <xsl:for-each select="$std"> 
        <xsl:variable name="from-std-id" as="element(std-id)*">
          <xsl:if test="@std-id">
            <!-- expectation: space-separated list of URNs -->
            <xsl:variable name="this-std" as="element(std)" select="."/>
            <xsl:for-each select="tokenize(@std-id, '\s+')">
              <std-id std-id-link-type="urn" std-id-type="{$this-std/@type}" xmlns="">
                <xsl:value-of select="replace(., '^urn:iso:std:[^:]+:([^:]+):.*$', '$1')"/>
              </std-id>  
            </xsl:for-each>
          </xsl:if>
        </xsl:variable>
        <xsl:copy>
          <xsl:variable name="internal-pub-ids" as="element(std-id)*" select=".//std-id[@std-id-link-type = 'internal-pub-id']"/>
          <xsl:for-each select="($internal-pub-ids,
                                 $from-std-id)[1]">
            <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:call-template name="link-href"/>
            </xsl:copy>
          </xsl:for-each>
        </xsl:copy>
      </xsl:for-each>  
    </xsl:variable>
    <!--<xsl:if test="@id = 'nor-2-1'">
      <xsl:message select="'IIIIIIIIIII ',std[1]/@std-id, replace(std[1]/@std-id, '^urn:iso:std:[^:]+:([^:]+):.*$', '$1')"></xsl:message>
    </xsl:if>-->
    <xsl:if test="distinct-values($filtered/std-id/std-id-type) gt 1">
      <xsl:message terminate="yes">1:error:Mix of dated and undated references is not supported in <xsl:sequence select="$filtered"/></xsl:message>
    </xsl:if>
    <xsl:if test="count($std) gt 1 and exists($std//text()[not(ancestor::std-id)][normalize-space()])">
      <xsl:message terminate="yes">1:error:Cannot handle multiple std when they contain text</xsl:message>
    </xsl:if>
    <a href="{string-join($filtered/std-id/@href, ' ')}" class="sts-std-ref">
      <xsl:choose>
        <xsl:when test="self::xref">
          <xsl:apply-templates mode="#current"/>
        </xsl:when>
        <xsl:otherwise><!-- context: ref -->
          <xsl:apply-templates select="$std/(node() except (std-id | std-id-group))" mode="#current"/>    
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>

  <xsl:template name="link-href"><!-- context: std-id element, not necessarily in a document (but in a fragment) -->
    <xsl:attribute name="href" separator=":">
      <xsl:sequence select="."/>
      <xsl:sequence select="'FIXME'"/>
      <xsl:sequence
        select="if (@std-id-type = 'dated') 
                then 'fixed'
                else 'floating'"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="ref[@content-type = 'standard'][std]" mode="#default">
    <li>
      <xsl:call-template name="ref">
        <xsl:with-param name="std" select="std" as="element(std)+"/>
      </xsl:call-template>
    </li>
  </xsl:template>

  <xsl:template match="ref[@content-type = 'standard' or ancestor::ref-list[@content-type='bibl']][mixed-citation]" mode="#default">
    <li>
      <xsl:apply-templates mode="#current"/>  
    </li>
  </xsl:template>

  <xsl:template match="xref[@ref-type = 'bibr']
                           [key('element-by-id', @rid)/parent::ref-list[@content-type = 'invisible-citation-list']]"
                mode="#default">
    <xsl:call-template name="ref">
      <xsl:with-param name="std" as="element(std)+">
        <xsl:sequence select="key('element-by-id', @rid)/std"/>    
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="std[@std-id | std-id | std-id-group][not(parent::ref)]" mode="#default">
    <xsl:call-template name="ref">
      <xsl:with-param name="std" as="element(std)+">
        <xsl:sequence select="."/>    
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <!-- overwrite template from isosts2html.xsl -->
  <xsl:template match="ref/std/std-ref[following-sibling::title]" mode="#default">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
</xsl:stylesheet>