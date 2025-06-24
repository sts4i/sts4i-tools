<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:isosts="http://www.iso.org/ns/isosts" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sc="http://transpect.io/schematron-config"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:tbx="urn:iso:std:iso:30042:ed-1"
  exclude-result-prefixes="sc xs isosts" version="3.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>
  
 <xsl:template match="table-wrap[not(caption/title)]
                                [not(table/thead)]
                                [not(table/tfoot)]
                                [count(descendant::col) = 2]
                                [matches(descendant::td[1], isosts:i18n-strings('note-label', .), 'i')]"
   mode="table-wrap_to_non-normative-note">
   <xsl:for-each select="descendant::tr">
     <non-normative-note>
       <label>
        <xsl:value-of select="td[1]"/>
       </label>
       <p>
         <xsl:value-of select="td[2]"/>
       </p>
     </non-normative-note>
   </xsl:for-each>
 </xsl:template>
  
 <xsl:template match="sec[@sec-type = 'terms']" mode="change_sec">
   <xsl:copy>
     <xsl:apply-templates select="@*, node()"
     mode="#current"/>
     <xsl:apply-templates select="descendant::table-wrap[table/tbody/tr ! count(td) = 2]
   [not(ancestor::table-wrap)]"
     mode="add_term-secs"/>
   </xsl:copy>
 </xsl:template>
  
  <xsl:template match="table-wrap[ancestor::sec[@sec-type = 'terms']]
   [table/tbody/tr ! count(td) = 2]
   [not(ancestor::table-wrap)]"
   mode="change_sec"/>
 
 <xsl:template match="table-wrap[ancestor::sec[@sec-type = 'terms']]
   [table/tbody/tr ! count(td) = 2]
   [not(ancestor::table-wrap)]"
   mode="add_term-secs">
   <xsl:for-each select="table/tbody/tr">
     <xsl:variable name="label" select="concat(ancestor::sec[@sec-type = 'terms']/label,'.', position())"/>
     <term-sec>
       <xsl:attribute name="id" select="concat('sub-',$label,'.')"/>
       <label>
         <xsl:value-of select="$label"/>
       </label>
       <tbx:termEntry>
          <xsl:attribute name="id" select="string-join(('term', $label), '_')"/>
         <tbx:langSet>
           <xsl:attribute name="xml:lang" select="isosts:lang(.)"/>
           <tbx:definition>
             <xsl:apply-templates select="td[2]/p[1]/node()" mode="#current"/>
             <xsl:apply-templates select="td[2]/p[2]/node()" mode="#current"/>
           </tbx:definition>
           <xsl:if test="exists(td[2]/p[3])">
             <tbx:source>
              <xsl:apply-templates select="td[2]/p[3]/node()" mode="#current"/>
               </tbx:source>
               </xsl:if>
           <tbx:tig>
              <tbx:term>
                <xsl:apply-templates select="td[1]/node()" mode="#current"/>
              </tbx:term>
            </tbx:tig>
         </tbx:langSet>
       </tbx:termEntry>
     </term-sec>
   </xsl:for-each>
 </xsl:template>
  
  
  <xsl:template match="tbx:termEntry[empty(@id)][../label]" mode="add_id">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:attribute name="id" select="string-join(('term', ../label/normalize-space()), '_')"/>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
   <xsl:template match="tbx:entailedTerm[@xtarget]
                                        [key('by-id',substring-after(@xtarget, '#'))]" 
                                         mode="xtarget_to_target">
    <xsl:copy>
      <xsl:apply-templates select="@* except @xtarget" mode="#current"/>
      <xsl:attribute name="target" select="key('by-id',substring-after(@xtarget, '#'))/tbx:termEntry/@id"/>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
