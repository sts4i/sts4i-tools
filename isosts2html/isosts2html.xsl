<?xml version="1.0"?>
<!-- ============================================================= -->
<!--  Purpose: Convert ISOSTS XML to XHTML 1.1                     -->
<!--  Author: Holger APEL (apel@iso.org)                           -->
<!--  LastRevision: e1691e3ec3259313cd468e29ad3ce16ddedaa20f       -->
<!--  LastChanged: 2015-05-20 18:40:10                             -->
<!--  Copyright © ISO. All rights reserved.                        -->
<!-- ============================================================= -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:tbx="urn:iso:std:iso:30042:ed-1"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:mle="http://www.iso.org/ns/mle"
  xmlns:isosts="http://www.iso.org/ns/isosts"
  xmlns:loc="http://www.iso.org/ns/localization"
  xmlns:tmp="http://www.iso.org/ns/tmp"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xs xlink mml tbx xhtml isosts loc mle tmp">

  <xsl:output encoding="UTF-8" omit-xml-declaration="yes" method="xhtml"/>

  <xsl:strip-space elements="*"/>   

  <!-- Space is preserved in all elements allowing #PCDATA -->
  <xsl:preserve-space
    elements="abbrev abbrev-journal-title access-date addr-line aff 
              alt-text alt-title article-id article-title attrib 
              award-id bold chapter-title chem-struct collab comment 
              compound-kwd-part conf-acronym conf-date conf-loc conf-name 
              conf-num conf-sponsor conf-theme copyright-holder 
              copyright-statement copyright-year corresp country 
              date-in-citation day def-head degrees disp-formula 
              edition elocation-id email etal ext-link fax fpage 
              funding-source funding-statement given-names glyph-data gov 
              inline-formula inline-supplementary-material institution 
              isbn issn issue issue-id issue-part issue-sponsor 
              issue-title italic journal-id journal-subtitle 
              journal-title kwd label license-p long-desc lpage 
              meta-name meta-value mixed-citation monospace month 
              named-content object-id on-behalf-of overline p 
              page-range part-title patent phone person-group prefix preformat 
              price principal-award-recipient principal-investigator 
              product pub-id publisher-loc publisher-name 
              related-article related-object role roman sans-serif 
              sc season self-uri series series-text series-title 
              sig sig-block size source speaker std strike 
              string-conf string-date string-name styled-content sub 
              subject subtitle suffix sup supplement surname target 
              td term term-head tex-math textual-form th time-stamp 
              title trans-source trans-subtitle trans-title underline 
              unstructured-kwd-group uri verse-line volume volume-id 
              volume-series x xref year std-ref

              mml:annotation mml:ci mml:cn mml:csymbol mml:mi mml:mn 
              mml:mo mml:ms mml:mtext"/>


  <xsl:param name="doc-id" select="replace(replace(/standard/front/iso-meta/doc-ident/urn,':','_'),'_-','-')"/>
  <xsl:param name="urn" select="/standard/front/iso-meta/doc-ident/urn"/>
  <xsl:param name="resPrefix">
    <xsl:value-of select="$doc-id"/>
  </xsl:param>
  <xsl:param name="imgPath" select="''"/> 
  <xsl:param name="xhtmlImgPath" select="''"/>
  <xsl:param name="dpi" select="'96'"/>
  <xsl:param name="table-scaling-factor" as="xs:double">
    <xsl:choose>
      <xsl:when test="$dpi = '96'">
        <xsl:value-of select="number(1 div 0.75)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="number(1)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:variable name="localized-labels">
    <loc:entry name="tbx:example" lang="en">EXAMPLE</loc:entry>
    <loc:entry name="tbx:example" lang="fr">EXAMPLE</loc:entry>
    <loc:entry name="tbx:example" lang="ru">ПРИМЕР</loc:entry>
    <loc:entry name="tbx:example" lang="es">EJEMPLO</loc:entry>
    <loc:entry name="tbx:example" lang="de">BEISPIEL</loc:entry>
    <loc:entry name="tbx:example" lang="zh">示例</loc:entry>
    <loc:entry name="tbx:note" lang="en">Note # to entry</loc:entry>
    <loc:entry name="tbx:note" lang="fr">Note # à l’article</loc:entry>
    <loc:entry name="tbx:note" lang="ru">Примечание # к записи</loc:entry>
    <loc:entry name="tbx:note" lang="es">Nota # a la entrada</loc:entry>
    <loc:entry name="tbx:note" lang="de">Anmerkung # zum Begriff</loc:entry>    
    <loc:entry name="tbx:note" lang="zh">标注#号以进入</loc:entry>
    <loc:entry name="tbx:see" lang="en">SEE</loc:entry>
    <loc:entry name="tbx:see" lang="fr">VOIR</loc:entry>
    <loc:entry name="tbx:see" lang="ru">ПОСМОТРЕТЬ</loc:entry>
    <loc:entry name="tbx:see" lang="es">VER</loc:entry>
    <loc:entry name="tbx:see" lang="de">SIEHE</loc:entry>
    <loc:entry name="tbx:see" lang="zh">见</loc:entry>
    <loc:entry name="tbx:crossReference" lang="en">cf. </loc:entry>
    <loc:entry name="tbx:crossReference" lang="fr">cf. </loc:entry>
    <loc:entry name="tbx:crossReference" lang="ru">cf. </loc:entry>
    <loc:entry name="tbx:crossReference" lang="es">cf. </loc:entry>
    <loc:entry name="tbx:crossReference" lang="de">cf. </loc:entry>
    <loc:entry name="tbx:crossReference" lang="zh">参见 </loc:entry>
    <loc:entry name="tbx:source" lang="en">SOURCE: </loc:entry>
    <loc:entry name="tbx:source" lang="fr">SOURCE: </loc:entry>
    <loc:entry name="tbx:source" lang="ru">ИСХОДНИКИ: </loc:entry>
    <loc:entry name="tbx:source" lang="es">ORIGEN: </loc:entry>
    <loc:entry name="tbx:source" lang="de">QUELLE: </loc:entry>
    <loc:entry name="tbx:source" lang="zh">源: </loc:entry>
    <loc:entry name="tbx:term-deprecated" lang="en">DEPRECATED: </loc:entry>
    <loc:entry name="tbx:term-deprecated" lang="fr">DÉCONSEILLÉ: </loc:entry>
    <loc:entry name="tbx:term-deprecated" lang="ru">DEPRECATED: </loc:entry>
    <loc:entry name="tbx:term-deprecated" lang="es">DEPRECATED: </loc:entry>
    <loc:entry name="tbx:term-deprecated" lang="de">DEPRECATED: </loc:entry>
    <loc:entry name="tbx:term-deprecated" lang="zh">DEPRECATED: </loc:entry>
  </xsl:variable>
  
  <!-- keys -->
  <xsl:key name="element-by-id" match="*[@id]" use="@id"/> 
  
  <!-- ============================================================= -->
  <!--  ROOT TEMPLATE - HANDLES HTML FRAMEWORK                       -->
  <!-- ============================================================= -->

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- ============================================================= -->
  <!-- PASS THROUGH ELEMENTS (to not generate a warning)             -->
  <!-- ============================================================= --> 
  <xsl:template match="standard">
    <div class="sts-standard">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="front | body | back | app-group | std">
    <xsl:apply-templates/>
  </xsl:template>

	<!-- ============================================================= -->
	<!--  bibliography elements                                        -->
	<!-- ============================================================= -->
  <xsl:template match="comment | collab | source | publisher-name | publisher-loc | article-title | source | year | volume | edition | fpage | lpage | size | etal | chapter-title | issue | supplement">
    <xsl:apply-templates/>
  </xsl:template>
  
   <xsl:template match="person-group">
    <xsl:apply-templates/><xsl:text> </xsl:text>
  </xsl:template>
	<!-- ============================================================= -->
	<!--  Writing a name                                               -->
	<!-- ============================================================= -->

  <!-- Called when displaying structured names in metadata         -->

  <xsl:template name="write-name" match="name">
    <xsl:if test="preceding-sibling::name">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="prefix" mode="inline-name"/>
    <xsl:apply-templates select="surname[../@name-style='eastern']"
      mode="inline-name"/>
    <xsl:apply-templates select="given-names" mode="inline-name"/>
    <xsl:apply-templates select="surname[not(../@name-style='eastern')]"
      mode="inline-name"/>
    <xsl:apply-templates select="suffix" mode="inline-name"/>
  </xsl:template>


  <xsl:template match="prefix" mode="inline-name">
    <xsl:apply-templates/>
    <xsl:if test="../surname | ../given-names | ../suffix">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>


  <xsl:template match="given-names" mode="inline-name">
    <xsl:apply-templates/>
    <xsl:if test="../surname[not(../@name-style='eastern')] | ../suffix">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>


  <xsl:template match="contrib/name/surname" mode="inline-name">
    <xsl:apply-templates/>
    <xsl:if test="../given-names[../@name-style='eastern'] | ../suffix">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>


  <xsl:template match="surname" mode="inline-name">
    <xsl:apply-templates/>
    <xsl:if test="../given-names[../@name-style='eastern'] | ../suffix">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>


  <xsl:template match="suffix" mode="inline-name">
    <xsl:apply-templates/>
  </xsl:template>

  
  <!-- string-name elements are written as is -->
  
  <xsl:template match="string-name">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <xsl:template match="string-name/*">
    <xsl:apply-templates/>
  </xsl:template>
  
   

  <!-- ============================================================= -->
  <!--  METADATA PROCESSING                                          -->
  <!-- ============================================================= -->

  <xsl:template match="iso-meta">
  </xsl:template>
  
  <!-- ============================================================= -->
  <!--  REGULAR (DEFAULT) MODE                                       -->
  <!-- ============================================================= -->
  <xsl:template match="sub-part">
    <div class="sts-sub-part">
      <xsl:if test="@id">
        <xsl:attribute name="id">
          <xsl:value-of select="concat('toc_', $doc-id, '_', @id)"/>
        </xsl:attribute>
      </xsl:if>
      <h1 class="sts-sub-part-title"><xsl:value-of select="label"/><xsl:text>&#xA0;&#xA0;&#xA0;</xsl:text><xsl:value-of select="title"/></h1>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="sec">
    <div class="sts-section">
      <xsl:if test="@id">
        <xsl:attribute name="id">
          <xsl:value-of select="concat('toc_', $doc-id, '_', @id)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="app">
    <div class="sts-app" id="{concat('toc_', $doc-id, '_', @id)}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="app/label|app/title">
    <h1 class="sts-app-header"><xsl:apply-templates/></h1>
  </xsl:template>

  <xsl:template match="app/annex-type">
    <div class="sts-app-header"><xsl:apply-templates/></div>
  </xsl:template>
    
  <xsl:template match="ref-list[@content-type='bibl' or ancestor::ref-list[@content-type='bibl']]">
    <div class="sts-section sts-ref-list">
      <xsl:if test="@id">
        <xsl:attribute name="id" select="concat('toc_', $doc-id,'_',@id)"/>
      </xsl:if>
      <xsl:for-each select="title">
        <xsl:call-template name="sec-title">
          <xsl:with-param name="level" select="count(ancestor::ref-list)+1"></xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
      <table class="sts-ref-list">
        <xsl:for-each select="ref">
          <tr>
            <td class="sts-label">
              <xsl:if test="@id">
                <a name="{$urn}:{replace(@id, '_', ':')}" id="{concat($doc-id,'_',@id)}"/>
              </xsl:if>              
              <xsl:for-each select="label">              
              <xsl:call-template name="list-label"/>
            </xsl:for-each>
            </td>
            <td><xsl:apply-templates/></td>
          </tr>
        </xsl:for-each>
      </table>
      <xsl:apply-templates select="ref-list"/>
    </div>
  </xsl:template>

  <xsl:template match="ref-list" name="ref-list">
    <div class="sts-section sts-ref-list">
      <ul class="sts-ref-list">
        <xsl:for-each select="ref">
          <li>
            <xsl:apply-templates/>
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>

  
  <!-- ============================================================= -->
  <!--  Titles                                                       -->
  <!-- ============================================================= -->

  <xsl:template match="sec/title" name="sec-title">
    <xsl:param name="level" select="count(ancestor-or-self::sec)"/>
    <xsl:param name="contents">
      <xsl:apply-templates select="." mode="sec-title"/>
    </xsl:param>
    <xsl:if test="normalize-space($contents)">
      <xsl:element name="{concat('h',$level)}">
      <xsl:attribute name="class">sts-sec-title</xsl:attribute>
        <xsl:copy-of select="$contents"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template name="block-title" priority="2"
    match="list/title | def-list/title | boxed-text/title |
           verse-group/title | glossary/title | kwd-group/title">
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>   
    <xsl:if test="normalize-space($contents)">
      <!-- coding defensively since empty titles make glitchy HTML -->
      <h4 class="sts-block-title">
        <xsl:copy-of select="$contents"/>
      </h4>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="title" mode="sec-title">
    <xsl:if test="preceding-sibling::label//text()">
      <xsl:apply-templates select="preceding-sibling::label" mode="sec-title"/>
      <xsl:text>&#xA0;&#xA0;&#xA0;</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="caption/title" priority="2">
    <span class="sts-caption-title">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="title"></xsl:template>


<!-- ============================================================= -->
<!--  Figures, lists and block-level objects                       -->
<!-- ============================================================= -->  
  <xsl:template match="array | disp-formula-group | fig-group | table-wrap-foot | table-wrap-group">
    <div class="sts-{local-name()}">
      <div class="sts-{local-name()}-content">
        <xsl:apply-templates/>
      </div>
    </div>
  </xsl:template>
  
  <xsl:template match="fig">
    <div class="sts-{local-name()} {@position}" id="{$doc-id}_{@id}">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates/>
      <xsl:apply-templates mode="footnote" select="self::table-wrap//fn[not(ancestor::table-wrap-foot)]"/>
    </div>
  </xsl:template>
  
  <xsl:template match="table-wrap">
    <div class="sts-{local-name()} {@content-type}">
      <xsl:if test="@id">
        <xsl:attribute name="id">
          <xsl:value-of select="concat($doc-id, '_', @id)"/>
        </xsl:attribute>
      </xsl:if>    
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="fig/label[not(following-sibling::caption)]" priority="3">
    <div class="sts-caption">
      <xsl:apply-templates mode="caption-label"/>
    </div>
  </xsl:template>

  <xsl:template match="table-wrap/label[not(following-sibling::caption)]" priority="3">
    <div class="sts-caption">
      <xsl:apply-templates mode="caption-label"/>
    </div>
  </xsl:template>
  
  <xsl:template match="caption">
    <div class="sts-caption">
      <xsl:if test="preceding-sibling::label">
        <xsl:apply-templates select="preceding-sibling::label" mode="caption-label"/>
        <xsl:text>&#x0A;</xsl:text>
        <!-- don't use mdash if label ends with ) -->
        <xsl:if test="not(ends-with(preceding-sibling::label, ')'))">
          <xsl:text>—&#x0A;</xsl:text>
        </xsl:if>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- in case a graphic has a label without caption  -->
  <xsl:template match="graphic/label[not(following-sibling::caption)]">
    <div class="sts-caption">
      <xsl:apply-templates select="." mode="caption-label"/>
    </div>  
  </xsl:template>


  <xsl:template match="label" mode="caption-label">
    <span class="sts-caption-label">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="disp-formula">
    <div class="sts-{local-name()}-panel">
      <xsl:if test="@id">
        <xsl:attribute name="id">
          <xsl:value-of select="concat($doc-id, '_', @id)"/>
        </xsl:attribute>
      </xsl:if>      
      <xsl:call-template name="named-anchor"/>      
      <xsl:apply-templates/>
      <div class="sts-{local-name()}-label"><xsl:value-of select="label"/></div>
    </div>
  </xsl:template>

  <xsl:template match="graphic | inline-graphic">
    <xsl:apply-templates/>
    <img alt="{@xlink:href}">
      <xsl:for-each select="alt-text">
        <xsl:attribute name="alt">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:attribute>
      </xsl:for-each>
      <xsl:call-template name="assign-src"/>
    </img>
  </xsl:template>
  
  
  <xsl:template match="alt-text">
    <!-- handled with graphic or inline-graphic -->
  </xsl:template>
  
  <xsl:template match="list">
    <div class="list">
      <xsl:apply-templates select="label | title"/>
      <xsl:apply-templates select="." mode="list"/>
    </div>
  </xsl:template>
  

  <xsl:template priority="2" mode="list"
    match="list[@list-type='simple' or list-item/label]">
    <ul style="list-style-type: none">
      <xsl:apply-templates select="list-item"/>
    </ul>
  </xsl:template>
  

  <xsl:template match="list[@list-type='bullet' or not(@list-type)]" mode="list">
    <ul>
      <xsl:apply-templates select="list-item"/>
    </ul>
  </xsl:template>


  <xsl:template match="list" mode="list">
    <xsl:variable name="style">
      <xsl:choose>
        <xsl:when test="@list-type='alpha-lower'">lower-alpha</xsl:when>
        <xsl:when test="@list-type='alpha-upper'">upper-alpha</xsl:when>
        <xsl:when test="@list-type='roman-lower'">lower-roman</xsl:when>
        <xsl:when test="@list-type='roman-upper'">upper-roman</xsl:when>
        <xsl:otherwise>decimal</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <ol style="list-style-type: {$style}">
      <xsl:apply-templates select="list-item"/>
    </ol>
  </xsl:template>
  

	<xsl:template match="list-item">
		<li>
			<xsl:apply-templates/>
		</li>
	</xsl:template>


	<xsl:template match="list-item/label">
	  <!-- if the next sibling is a p, the label will be called as
	       a run-in -->
	  <xsl:if test="following-sibling::*[1][not(self::p)]">
	    <xsl:call-template name="list-label"/>
	  </xsl:if>
	</xsl:template>
  
  
  <xsl:template match="p">
    <div class="sts-p">
      <xsl:call-template name="p-style-type"/>
      <!-- if only label without title, the label will just be added to the p as starting text --> 
      <xsl:if test="parent::sec and preceding-sibling::*[1][self::label]">
        <span class="sts-section-label">
          <xsl:apply-templates select="preceding-sibling::label" mode="sec-title"/>
          <xsl:text>&#xA0;&#xA0;&#xA0;</xsl:text>
        </span>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  

  <xsl:template match="list-item/p[not(preceding-sibling::*[not(self::label)])]">
    <div class="sts-p">
      <xsl:call-template name="p-style-type"/>
      <xsl:for-each select="preceding-sibling::label">
        <span class="sts-label">
          <xsl:apply-templates/>
        </span>
      <xsl:text> </xsl:text>
      </xsl:for-each>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <xsl:template match="permissions">
    <div class="permissions">
    <xsl:apply-templates select="copyright-statement"/>
    <xsl:if test="copyright-year | copyright-holder">
      <p class="copyright">
        <span class="generated">Copyright</span>
        <xsl:for-each select="copyright-year | copyright-holder">
            <xsl:apply-templates/>
            <xsl:if test="not(position()=last())">
              <span class="generated">, </span>
            </xsl:if>
        </xsl:for-each>
      </p>
    </xsl:if>
    <xsl:apply-templates select="license"/>
    </div>
  </xsl:template>
  
  
  <xsl:template match="copyright-statement">
    <p class="copyright">
      <xsl:apply-templates></xsl:apply-templates>
    </p>
  </xsl:template>


  <xsl:template match="def-list">
    <div class="def-list">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates select="label | title"/>
      <table class="def-list">
        <xsl:if test="term-head|def-head">
          <tr>
            <th class="def-list-head">
              <xsl:apply-templates select="term-head"/>
            </th>
            <th class="def-list-head">
              <xsl:apply-templates select="def-head"/>
            </th>
          </tr>
        </xsl:if>
        <xsl:apply-templates select="def-item"/>
      </table>
      <xsl:apply-templates select="def-list"/>
    </div>
  </xsl:template>


	<xsl:template match="def-item">
		<tr>
			<xsl:call-template name="assign-id"/>
			<xsl:apply-templates/>
		</tr>
	</xsl:template>


	<xsl:template match="term">
		<td class="def-term">
			<xsl:call-template name="assign-id"/>
		  <p>
				<xsl:apply-templates/>
		  </p>
		</td>
	</xsl:template>


	<xsl:template match="def">
		<td valign="def-def">
			<xsl:call-template name="assign-id"/>
			<xsl:apply-templates/>
		</td>
	</xsl:template>


  <xsl:template match="disp-quote">
    <div class="blockquote">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="boxed-text">
    <div class="sts-boxed-text">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="preformat">
    <pre class="sts-preformat {@preformat-type}">
      <xsl:apply-templates/>
    </pre>
  </xsl:template> 

  <xsl:template match="std/title">
    <span class="sts-std-title"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="ref/std" priority="2">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="std[not(title)]" priority="1">
    <xsl:choose>
      <xsl:when test="@std-id">
        <a class="sts-std-ref" href="#{@std-id}"><xsl:apply-templates/></a>
      </xsl:when>
      <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
    </xsl:choose>    
  </xsl:template>

  <xsl:template match="std-ref[not(following-sibling::title)]">
     <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="std-ref[following-sibling::title]">
    <xsl:choose>
      <xsl:when test="../@std-id">
        <a class="sts-std-ref" href="#{../@std-id}"><xsl:apply-templates/></a>
      </xsl:when>
      <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
    </xsl:choose>    
  </xsl:template>

  <xsl:template match="mixed-citation">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="boxed-text/label | chem-struct-wrap/label |
    fig/label | fn/label | ref/label |
    statement/label | supplementary-material/label | table-wrap/label"
    priority="2">
    <!-- suppressed, since acquired by their parents in mode="label" -->
  </xsl:template>


  <xsl:template match="sec/label" mode="sec-title">
      <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="non-normative-note | non-normative-example">
      <div class="sts-{node-name(.)}">
        <xsl:apply-templates/>
      </div>
  </xsl:template>
  
  <xsl:template match="non-normative-example/label">
    <p><span class="sts-non-normative-example-label"><xsl:apply-templates/></span></p>
  </xsl:template>

  <xsl:template match="non-normative-note/label[not(following-sibling::p)]">
    <p><span class="sts-non-normative-note-label"><xsl:apply-templates/></span></p>
  </xsl:template>
  
  <xsl:template match="non-normative-note/p[not(preceding-sibling::*[not(self::label)])]">
    <p>
      <xsl:call-template name="p-style-type"/>
      <xsl:for-each select="preceding-sibling::label">
        <span class="sts-{node-name(parent::node())}-label">
          <xsl:apply-templates/>
        </span>
        <xsl:text> </xsl:text>
      </xsl:for-each>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template name="list-label">
    <!-- other labels are displayed as blocks -->
    <span class="sts-label">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="label"/>
  
  
  <!-- ============================================================= -->
  <!--  TABLES                                                       -->
  <!-- ============================================================= -->
  <!--  Tables are already in XHTML, and can simply be copied
        through                                                      -->
  
  <xsl:template match="table | thead | tbody | tfoot |
      col | colgroup | tr | th">
    <!-- create new element rather than using copy-of to make sure
         the copied element belongs to the same default namespace -->
    <xsl:element name="{node-name(.)}">
      <xsl:apply-templates select="@*" mode="table-copy"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>  
  
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
        <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>  
  
  <xsl:template match="@*" mode="table-copy">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <xsl:template match="col/@width | table/@width" mode="table-copy">
    <!-- scale the width while preserving the unit if present -->
    <xsl:choose>
      <xsl:when test="$table-scaling-factor != 1">
        <xsl:variable name="lexical-unit">
          <xsl:analyze-string select="." regex="^(\d+(\.\d+)?)(px|pt)?$">
            <xsl:matching-substring>
              <tmp:number>
                <xsl:value-of select="regex-group(1)"/>
              </tmp:number>
              <tmp:unit>
                <xsl:value-of select="regex-group(3)"/>
              </tmp:unit>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
              <tmp:non-matching/>
            </xsl:non-matching-substring>
          </xsl:analyze-string>
        </xsl:variable>
        <!-- <xsl:message><xsl:copy-of select="$lexical-unit"></xsl:copy-of></xsl:message> -->
        <xsl:choose>
          <xsl:when test="$lexical-unit/tmp:non-matching">
            <!--<xsl:message>leave as is</xsl:message>-->
            <!-- must be percentage -->
            <xsl:attribute name="width" select="."/>
          </xsl:when>
          <xsl:otherwise>
            <!--<xsl:message>converted from <xsl:value-of select="."/> to <xsl:value-of select="concat(round($lexical-unit/tmp:number * $table-scaling-factor), $lexical-unit/tmp:unit)"/></xsl:message>-->
            <xsl:if test="$table-scaling-factor &gt; 0">
              <xsl:attribute name="width" select="concat(round($lexical-unit/tmp:number * $table-scaling-factor), $lexical-unit/tmp:unit)"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="width" select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="@content-type" mode="table-copy"/>
  
  <!-- ============================================================= -->
  <!--  TBX                                                          -->
  <!-- ============================================================= -->
  <xsl:template match="term-sec">
    <div class="sts-section sts-tbx-sec" id="{$doc-id}_{tbx:termEntry[1]/@id}">      
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="term-sec/label">
    <div class="sts-tbx-label"><xsl:apply-templates/></div>
  </xsl:template>

  <xsl:template match="tbx:termEntry">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tbx:langSet">
    <!-- copyinf the for-each statement to make sure that preferredTerm are displayed first -->
    <xsl:for-each select="tbx:tig[tbx:normativeAuthorization/@value='preferredTerm']">
      <xsl:apply-templates/>
    </xsl:for-each>
    <!-- then the entries without tbx:normativeAuthorization being considered as preferredTerm -->
    <xsl:for-each select="tbx:tig[not(tbx:normativeAuthorization)]">
      <xsl:apply-templates/>
    </xsl:for-each>
    <!-- tand finaly anything else than preferredTerm -->
    <xsl:for-each select="tbx:tig[tbx:normativeAuthorization/@value!='preferredTerm']">
      <xsl:apply-templates/>
    </xsl:for-each>
    <xsl:apply-templates select="*[not(self::tbx:tig)]"/>
  </xsl:template>
  
  <xsl:template match="tbx:term">
    <div class="sts-tbx-term {tbx:termType/@value} {following-sibling::tbx:termType/@value} {following-sibling::tbx:normativeAuthorization/@value}">
      <xsl:if test="following-sibling::tbx:normativeAuthorization[@value = 'deprecatedTerm']">
        <span class="sts-tbx-term-depr-label">
          <xsl:call-template name="tbx-localized-label">
            <xsl:with-param name="label-name" select="'tbx:term-deprecated'"/>
          </xsl:call-template>
        </span>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="tbx:subjectField">
    <!-- is handle within definition -->
  </xsl:template>

  <xsl:template match="tbx:definition">
    <div class="sts-tbx-def">
      <xsl:if test="preceding-sibling::tbx:subjectField!=''">
        <xsl:text>&lt;</xsl:text><xsl:value-of select="preceding-sibling::tbx:subjectField"/><xsl:text>&gt;</xsl:text><xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="tbx:note">
    <div class="sts-tbx-note">
      <span class="sts-tbx-note-label">
        <xsl:call-template name="tbx-localized-label"/>
        <xsl:text>: </xsl:text>
      </span>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="tbx:example">
    <div class="sts-tbx-example">
      <div class="sts-tbx-example-label">
        <xsl:call-template name="tbx-localized-label"/>
        <xsl:if test="following-sibling::tbx:example or preceding-sibling::tbx:example">
          &#xA0;<xsl:number/>
        </xsl:if>
        <xsl:text>:</xsl:text>
      </div>
      <div class="sts-tbx-example-content"><xsl:apply-templates/></div>
    </div>
  </xsl:template>
  
  <xsl:template match="tbx:partOfSpeech">
    <xsl:if test=". != 'noun'">
      <xsl:value-of select="."/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="tbx:termType | tbx:normativeAuthorization">
    <!-- no rendering -->
  </xsl:template>
  
  <xsl:template match="tbx:source">
    <div class="sts-tbx-source">
      <xsl:text>[</xsl:text>
      <xsl:call-template name="tbx-localized-label"/>
      <xsl:text></xsl:text>
      <xsl:apply-templates/>
      <xsl:text>]</xsl:text>
    </div>
  </xsl:template>

  <xsl:template match="tbx:see[@target]">
    <xsl:variable name="target-id" select="@target"/>
    <div class="sts-tbx-see">
      <span class="sts-tbx-see-label">
        <xsl:call-template name="tbx-localized-label"/>
        <xsl:text>:&#xA0;&#xA0;&#xA0;</xsl:text>
      </span>
      <a href="{isosts:localhref($target-id)}">
        <xsl:variable name="ref-elem" select="//*[@id=$target-id]"/>
        <!-- prefix with figure label if reference is to individual image -->          
        <xsl:if test="$ref-elem/ancestor::fig">
          <xsl:value-of select="$ref-elem/ancestor::fig/label"/>
          <xsl:text>&#xA0;</xsl:text>
        </xsl:if>
        <xsl:value-of select="$ref-elem/label"/>
      </a>
    </div>
  </xsl:template>
  
  <xsl:template match="tbx:entailedTerm/text()">
	  <xsl:analyze-string select="normalize-space(.)" regex="(.*)(\([0-9\.]+\))">
	      <xsl:matching-substring>
	        <xsl:value-of select="regex-group(1)"/>
	        <xsl:text>&#x0A;</xsl:text>
	        <span class="sts-tbx-entailedTerm-num">
	          <xsl:value-of select="regex-group(2)"/>
	        </span>
	      </xsl:matching-substring>
	      <xsl:non-matching-substring>
	         <xsl:value-of select="."/>
	      </xsl:non-matching-substring>
	   </xsl:analyze-string>
  </xsl:template>
  
  <xsl:template match="tbx:crossReference[not(preceding-sibling::tbx:crossReference)]" priority="10">
    <div class="sts-tbx-{local-name()}">
      <span class="sts-tbx-{local-name()}-label">
        <xsl:call-template name="tbx-localized-label"/>
      </span>
      <xsl:apply-templates select="(../tbx:crossReference)" mode="crossref"/>
    </div>
  </xsl:template>
  <xsl:template match="tbx:crossReference">
    <!-- all handled by previous template -->
  </xsl:template>
  <xsl:template match="tbx:crossReference" mode="crossref">
    <xsl:variable name="href">
      <xsl:choose>
        <xsl:when test="@target"><xsl:value-of select="concat($urn, ':', replace(@target,'_',':'))"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@xtarget"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="preceding-sibling::tbx:crossReference">
      <xsl:text >, </xsl:text>
    </xsl:if>
    <span class="sts-tbx-{local-name()}">
      <a href="#{$href}">
        <xsl:choose>
          <xsl:when test="normalize-space(.) = ''">
            <xsl:variable name="target" select="@target"/>
            <xsl:apply-templates select="//tbx:termEntry[@id=$target]/tbx:langSet/tbx:tig[1]/tbx:term[1]/(*|text())"></xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>            
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </span>
  </xsl:template>
  
  <xsl:template match="tbx:entailedTerm">
    <xsl:variable name="href">
      <xsl:choose>
        <xsl:when test="@target"><xsl:value-of select="concat($urn, ':', replace(@target,'_',':'))"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="@xtarget"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <span class="sts-tbx-{local-name()}">
      <a href="#{$href}">
         <xsl:apply-templates/>
      </a>
    </span>
  </xsl:template>
  
  <xsl:template name="tbx-localized-label">
    <xsl:param name="label-name" select="name(.)"/>
    <xsl:variable name="num">
      <xsl:number/>
    </xsl:variable>    
    <xsl:variable name="label-lang" select="ancestor::tbx:langSet[1]/@xml:lang"/>
    <xsl:value-of select="replace($localized-labels/loc:entry[@name=$label-name and @lang=$label-lang], '#', $num)"/>
  </xsl:template>
  
  <!-- ============================================================= -->
  <!--  XHTML, legacy TBX can contain xhtml                          -->
  <!-- ============================================================= -->  
  <xsl:template match="xhtml:*">
    <xsl:element name="{node-name(.)}">
      <xsl:apply-templates select="@*" mode="xhtml-copy"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="@*" mode="xhtml-copy">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <xsl:template match="xhtml:img/@src" mode="xhtml-copy">
    <xsl:attribute name="src" select="concat($xhtmlImgPath,.)"/>
  </xsl:template>
  
  
  <!-- ============================================================= -->
  <!--  MathML                                                       -->
  <!-- ============================================================= -->
  <xsl:template match="mml:math">
    <!-- just generate the image based on id -->
    <img class="math" alt="{@id}">
      <xsl:call-template name="assign-math-src"/>
    </img>
  </xsl:template>
  
  <!--<xsl:template match="mml:*">
    <!-\- this stylesheet simply copies MathML through. If your browser
      supports it, you will get it -\->
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>-->

  <!-- ============================================================= -->
  <!--  INLINE MISCELLANEOUS                                         -->
  <!-- ============================================================= -->
  <!--  Templates strictly for formatting follow; these are templates
        to handle various inline structures -->
  
  <xsl:template match="break">
    <br class="br"/>
  </xsl:template>

  <xsl:template match="email">
    <a href="mailto:{.}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  
  <xsl:template match="ext-link | uri">
    <a target="_blank">
      <xsl:attribute name="href">
        <xsl:value-of select="."/>
      </xsl:attribute>
      <!-- if an @href is present, it overrides the href
           just attached -->
      <xsl:call-template name="assign-href"/>
      <xsl:call-template name="assign-id"/>
      <xsl:apply-templates/>
      <xsl:if test="not(normalize-space())">
        <xsl:value-of select="@xlink:href"/>
      </xsl:if>
    </a>
  </xsl:template>
  

  <xsl:template match="hr">
    <hr/>
  </xsl:template>
  

  <!-- inline-graphic is handled above, with graphic -->
  
  
  <xsl:template match="inline-formula | chem-struct">
    <span class="{local-name()}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="chem-struct-wrap/chem-struct">
    <div class="{local-name()}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <!-- preformat is handled above -->
  
  <xsl:template match="target">
    <xsl:call-template name="named-anchor"/>
  </xsl:template>
  
  
  <xsl:template match="styled-content">
    <span>
      <xsl:copy-of select="@style"/>
      <xsl:for-each select="@style-type">
        <xsl:attribute name="class">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:for-each>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  
  <xsl:template match="named-content">
    <span>
      <xsl:for-each select="@content-type">
        <xsl:attribute name="class">
          <xsl:value-of select="translate(.,' ','-')"/>
        </xsl:attribute>
      </xsl:for-each>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="xref">
    <a class="sts-xref" href="#{$urn}:{replace(@rid,'_',':')}">
      <xsl:choose>
        <xsl:when test="@ref-type='fn'">
          <xsl:attribute name="title">
            <xsl:value-of select="key('element-by-id',@rid)/*[not(self::label)]"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="@ref-type='bibr'">
          <xsl:attribute name="title">
            <xsl:value-of select="string-join(key('element-by-id',@rid)/*, ' ')"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates/>
    </a>
  </xsl:template>


  
  <!-- ============================================================= -->
  <!--  Formatting elements                                          -->
  <!-- ============================================================= -->


  <xsl:template match="bold">
    <b>
      <xsl:apply-templates/>
    </b>
  </xsl:template>


  <xsl:template match="italic">
    <i>
      <xsl:apply-templates/>
    </i>
  </xsl:template>


  <xsl:template match="monospace">
    <tt>
      <xsl:apply-templates/>
    </tt>
  </xsl:template>


  <xsl:template match="overline">
    <span style="text-decoration: overline">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="roman">
    <span style="font-style: normal">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="sans-serif">
    <span style="font-family: sans-serif; font-size: 80%">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="sc">
    <span style="font-variant: small-caps">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="strike">
    <span style="text-decoration: line-through">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <xsl:template match="sub">
    <sub>
      <xsl:apply-templates/>
    </sub>
  </xsl:template>


  <xsl:template match="sup">
    <sup>
      <xsl:apply-templates/>
    </sup>
  </xsl:template>


  <xsl:template match="underline">
    <span style="text-decoration: underline">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  <!-- ============================================================= -->
  <!--  BACK MATTER                                                  -->
  <!-- ============================================================= --> 
  
  <!-- ============================================================= -->
  <!--  FOOTNOTES                                                    -->
  <!-- ============================================================= -->
    
  <xsl:template match="table-wrap-foot/fn | td/fn | fig/fn | table-wrap-foot/fn-group | fig/fn-group | notes/fn-group">
    <!-- all fn and fn-groups which should be rendered at their current position, all other will be grouped at the end of the document  -->
    <xsl:apply-templates select="." mode="footnote"/>
  </xsl:template>
  
  <xsl:template match="fn | fn-group">
    <!-- any fn not captured by the above will be processed with the named template footnote at the end of the document -->
  </xsl:template>
  
  
  <xsl:template match="fn-group" mode="footnote">
    <div class="sts-fn-group">
      <xsl:apply-templates mode="footnote"/>
    </div>
  </xsl:template>
  
  
  <xsl:template match="fn" mode="footnote">
    <div class="sts-fn">
      <xsl:if test="@id">
        <xsl:attribute name="id" select="concat($doc-id,'_',@id)"/>
      </xsl:if>
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates mode="footnote"/>
    </div>
  </xsl:template>
  
  <xsl:template match="fn/label" mode="footnote">
    <!-- already processed with  fn/p -->
  </xsl:template>
  
  <xsl:template match="fn/p" mode="footnote">
    <div>
      <xsl:if test="not(preceding-sibling::p)">
        <xsl:apply-templates select="parent::fn/label" mode="label-fn"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  
  <xsl:template name="footnotes">
    <xsl:variable name="fn-groups" select="//fn-group[parent::sec or parent::back or parent::term-sec]"/>
    <xsl:variable name="fns" select="//fn[not(parent::fn-group or parent::table-wrap-foot or parent::td or parent::th or parent::fig)]"/>
    <xsl:if test="$fn-groups or $fns">
      <div class="sts-footnotes">
        <hr />
        <xsl:apply-templates select="$fn-groups" mode="footnote"/>
        <xsl:apply-templates select="$fns" mode="footnote"/>
      </div>      
    </xsl:if>
  </xsl:template>
  
  <!-- ============================================================= -->
  <!--  MODE 'label-text'
	      Generates label text for elements and their cross-references -->
  <!-- ============================================================= -->

  <xsl:template mode="label" match="*" name="block-label">
    <xsl:param name="contents">
      <xsl:apply-templates select="." mode="label-text"/>
    </xsl:param>
    <xsl:if test="normalize-space($contents)">
      <!-- not to create an h5 for nothing -->
      <h5 class="label">
        <xsl:copy-of select="$contents"/>
      </h5>
    </xsl:if>
  </xsl:template>


  <xsl:template mode="label" match="ref">
    <xsl:param name="contents">
      <xsl:apply-templates select="." mode="label-text"/>
    </xsl:param>
    <xsl:if test="normalize-space($contents)">
      <!-- we're already in a p -->
        <span class="sts-label">
          <xsl:copy-of select="$contents"/>
        </span>
    </xsl:if>
  </xsl:template>

  <xsl:template match="label" mode="label-fn">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="label" mode="label-text">
    <xsl:apply-templates mode="inline-label-text"/>
  </xsl:template>
  
  <xsl:template match="text()" mode="inline-label-text">
    <!-- when displaying labels, space characters become non-breaking spaces -->
    <xsl:value-of select="translate(normalize-space(.),' &#xA;&#x9;','&#xA0;&#xA0;&#xA0;')"/>
  </xsl:template>

<!-- ============================================================= -->
<!--  Any undefined rendering should print a warning               -->
<!-- ============================================================= -->
  <xsl:template match="*" priority="-1">
    <span class="sts-unknown-element">
      [no rendering defined for element: 
      <xsl:value-of select="name(.)"/>
      ]
    </span>
    <xsl:apply-templates/>
  </xsl:template>
  
<!-- ============================================================= -->
<!--  UTILITY TEMPLATES                                           -->
<!-- ============================================================= -->

  <xsl:template name="assign-id">
    <xsl:variable name="id">
      <xsl:apply-templates select="." mode="id"/>
    </xsl:variable>
    <xsl:attribute name="id">
      <xsl:value-of select="$id"/>
    </xsl:attribute>
  </xsl:template>


  <xsl:template name="assign-src">
    <xsl:if test="@xlink:href">
      <xsl:variable name="res-prefix">
        <xsl:call-template name="build-res-prefix"/>
      </xsl:variable>
      <xsl:attribute name="src">
        <xsl:value-of select="string-join(($imgPath, $res-prefix, concat(@xlink:href, '.png')), '/')"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="assign-math-src">
      <xsl:attribute name="src">
        <xsl:variable name="res-prefix">
          <xsl:call-template name="build-res-prefix"/>
        </xsl:variable>
        <xsl:value-of select="string-join(($imgPath, $res-prefix, concat(@id, '.png')), '/')"/>
      </xsl:attribute>
  </xsl:template>

  <xsl:template name="build-res-prefix">
    <xsl:choose>
      <!-- Special handling needed by OBP in cases where we render standalone tbx.
           Here we can't build the refPrefix from the urn in iso-meta. But we can build it from the uri of the originating document
           which is stored in the mle:source attribute of one of the parents (normally the tbx:langSet) -->
      <xsl:when test="$resPrefix = '' and ancestor::node()[@mle:source]">
        <!-- same as get basename of xml filename -->
        <xsl:value-of select="substring-before(tokenize(ancestor::node()/@mle:source[1], '/')[last()], '.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$resPrefix"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
  <xsl:template name="assign-href">
    <xsl:for-each select="@xlink:href">
      <xsl:attribute name="href">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:for-each>
  </xsl:template>


  <xsl:template name="named-anchor">
    <!-- generates an HTML named anchor, using
         the source ID when found, otherwise a unique ID -->
    <xsl:variable name="id">
      <xsl:value-of select="@id"/>
      <xsl:if test="not(normalize-space(@id))">
        <xsl:value-of select="generate-id(.)"/>
      </xsl:if>
    </xsl:variable>
    <a id="a_{$doc-id}_{$id}"/>
  </xsl:template>

  <xsl:template name="p-style-type">
    <xsl:choose>
      <xsl:when test="@style-type or @content-type">
        <xsl:attribute name="class" select="lower-case(string-join(('sts-p', @style-type,@content-type),' '))"/>
      </xsl:when>
    </xsl:choose>    
  </xsl:template>

<!-- ============================================================= -->
<!--  id mode                                                      -->
<!-- ============================================================= -->
<!-- An id can be derived for any element. If an @id is given,
     it is presumed unique and copied. If not, one is generated.   -->

  <xsl:template match="*" mode="id">
    <xsl:value-of select="@id"/>
    <xsl:if test="not(@id)">
      <xsl:value-of select="generate-id(.)"/>
    </xsl:if>
  </xsl:template>

  <!-- ============================================================= -->
  <!--  local functions                                              -->
  <!-- ============================================================= -->

  <xsl:function name="isosts:localhref" as="item()">
    <xsl:param name="target-id" as="item()"/>
    <xsl:copy-of select="concat('#a_',replace(replace($urn,':','_'),'_-','-'),'_',$target-id)"/>    
  </xsl:function>

  <!-- ============================================================= -->
  <!--  COPYRIGHT                                                    -->
  <!-- ============================================================= -->
  <xsl:template  name="copyright">
    <xsl:param name="metadata"/>
    <div class="sts-copyright">
      <xsl:for-each select="$metadata/permissions">
        <div><xsl:text>©&#xA0;</xsl:text><xsl:value-of select="copyright-year"/><xsl:text>&#xA0;</xsl:text><xsl:value-of select="copyright-holder"/><xsl:text> — </xsl:text><xsl:value-of select="copyright-statement"/></div>
      </xsl:for-each>
    </div>
  </xsl:template>
  
<!-- ============================================================= -->
<!--  End stylesheet                                               -->
<!-- ============================================================= -->

</xsl:stylesheet>
