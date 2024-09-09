<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:c="http://www.w3.org/ns/xproc-step"
        xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
        queryBinding="xslt2"
        xml:lang="en">
   <pattern id="LATINSMALLLETTERNWITHLONGRIGHTLEG">
      <rule context="/*" id="LATINSMALLLETTERNWITHLONGRIGHTLEG_rule">
         <let name="value" value="414"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="LATINSMALLLETTERNWITHLONGRIGHTLEG_report"
                 test="some $u in $uni-chars satisfies $value = $u">
              This Document contains the char 'LATIN SMALL LETTER N WITH LONG RIGHT LEG' use the char 'GREEK SMALL LETTER ETA' (03B7) instead.
            </report>
      </rule>
   </pattern>
   <pattern id="CyrillicSupplement">
      <rule context="/*" id="CyrillicSupplement_rule">
         <let name="start" value="1280"/>
         <let name="end" value="1327"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CyrillicSupplement_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Cyrillic Supplement' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Armenian">
      <rule context="/*" id="Armenian_rule">
         <let name="start" value="1328"/>
         <let name="end" value="1423"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Armenian_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Armenian' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Hebrew">
      <rule context="/*" id="Hebrew_rule">
         <let name="start" value="1424"/>
         <let name="end" value="1535"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Hebrew_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Hebrew' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="ArabicSupplement">
      <rule context="/*" id="ArabicSupplement_rule">
         <let name="start" value="1872"/>
         <let name="end" value="1919"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="ArabicSupplement_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Arabic Supplement' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Thaana">
      <rule context="/*" id="Thaana_rule">
         <let name="start" value="1920"/>
         <let name="end" value="1983"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Thaana_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Thaana' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="NKo">
      <rule context="/*" id="NKo_rule">
         <let name="start" value="1984"/>
         <let name="end" value="2047"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="NKo_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'NKo' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Samaritan">
      <rule context="/*" id="Samaritan_rule">
         <let name="start" value="2048"/>
         <let name="end" value="2111"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Samaritan_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Samaritan' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Mandaic">
      <rule context="/*" id="Mandaic_rule">
         <let name="start" value="2112"/>
         <let name="end" value="2143"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Mandaic_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Mandaic' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="SyriacSupplement">
      <rule context="/*" id="SyriacSupplement_rule">
         <let name="start" value="2144"/>
         <let name="end" value="2159"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="SyriacSupplement_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Syriac Supplement' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="ArabicExtended-B">
      <rule context="/*" id="ArabicExtended-B_rule">
         <let name="start" value="2160"/>
         <let name="end" value="2207"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="ArabicExtended-B_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Arabic Extended-B' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="ArabicExtended-A">
      <rule context="/*" id="ArabicExtended-A_rule">
         <let name="start" value="2208"/>
         <let name="end" value="2303"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="ArabicExtended-A_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Arabic Extended-A' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Devanagari">
      <rule context="/*" id="Devanagari_rule">
         <let name="start" value="2304"/>
         <let name="end" value="2431"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Devanagari_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Devanagari' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Bengali">
      <rule context="/*" id="Bengali_rule">
         <let name="start" value="2432"/>
         <let name="end" value="2559"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Bengali_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Bengali' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Gurmukhi">
      <rule context="/*" id="Gurmukhi_rule">
         <let name="start" value="2560"/>
         <let name="end" value="2687"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Gurmukhi_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Gurmukhi' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Gujarati">
      <rule context="/*" id="Gujarati_rule">
         <let name="start" value="2688"/>
         <let name="end" value="2815"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Gujarati_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Gujarati' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Oriya">
      <rule context="/*" id="Oriya_rule">
         <let name="start" value="2816"/>
         <let name="end" value="2943"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Oriya_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Oriya' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Tamil">
      <rule context="/*" id="Tamil_rule">
         <let name="start" value="2944"/>
         <let name="end" value="3071"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Tamil_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Tamil' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Telugu">
      <rule context="/*" id="Telugu_rule">
         <let name="start" value="3072"/>
         <let name="end" value="3199"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Telugu_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Telugu' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Kannada">
      <rule context="/*" id="Kannada_rule">
         <let name="start" value="3200"/>
         <let name="end" value="3327"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Kannada_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Kannada' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Malayalam">
      <rule context="/*" id="Malayalam_rule">
         <let name="start" value="3328"/>
         <let name="end" value="3455"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Malayalam_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Malayalam' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Sinhala">
      <rule context="/*" id="Sinhala_rule">
         <let name="start" value="3456"/>
         <let name="end" value="3583"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Sinhala_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Sinhala' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Thai">
      <rule context="/*" id="Thai_rule">
         <let name="start" value="3584"/>
         <let name="end" value="3711"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Thai_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Thai' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Lao">
      <rule context="/*" id="Lao_rule">
         <let name="start" value="3712"/>
         <let name="end" value="3839"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Lao_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Lao' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Tibetan">
      <rule context="/*" id="Tibetan_rule">
         <let name="start" value="3840"/>
         <let name="end" value="4095"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Tibetan_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Tibetan' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Myanmar">
      <rule context="/*" id="Myanmar_rule">
         <let name="start" value="4096"/>
         <let name="end" value="4255"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Myanmar_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Myanmar' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Georgian">
      <rule context="/*" id="Georgian_rule">
         <let name="start" value="4256"/>
         <let name="end" value="4351"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Georgian_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Georgian' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="HangulJamo">
      <rule context="/*" id="HangulJamo_rule">
         <let name="start" value="4352"/>
         <let name="end" value="4607"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="HangulJamo_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Hangul Jamo' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Ethiopic">
      <rule context="/*" id="Ethiopic_rule">
         <let name="start" value="4608"/>
         <let name="end" value="4991"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Ethiopic_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Ethiopic' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="EthiopicSupplement">
      <rule context="/*" id="EthiopicSupplement_rule">
         <let name="start" value="4992"/>
         <let name="end" value="5023"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="EthiopicSupplement_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Ethiopic Supplement' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Cherokee">
      <rule context="/*" id="Cherokee_rule">
         <let name="start" value="5024"/>
         <let name="end" value="5119"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Cherokee_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Cherokee' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="UnifiedCanadianAboriginalSyllabics">
      <rule context="/*" id="UnifiedCanadianAboriginalSyllabics_rule">
         <let name="start" value="5120"/>
         <let name="end" value="5759"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="UnifiedCanadianAboriginalSyllabics_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Unified Canadian Aboriginal Syllabics' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Ogham">
      <rule context="/*" id="Ogham_rule">
         <let name="start" value="5760"/>
         <let name="end" value="5791"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Ogham_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Ogham' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Runic">
      <rule context="/*" id="Runic_rule">
         <let name="start" value="5792"/>
         <let name="end" value="5887"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Runic_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Runic' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Tagalog">
      <rule context="/*" id="Tagalog_rule">
         <let name="start" value="5888"/>
         <let name="end" value="5919"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Tagalog_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Tagalog' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Hanunoo">
      <rule context="/*" id="Hanunoo_rule">
         <let name="start" value="5920"/>
         <let name="end" value="5951"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Hanunoo_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Hanunoo' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Buhid">
      <rule context="/*" id="Buhid_rule">
         <let name="start" value="5952"/>
         <let name="end" value="5983"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Buhid_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Buhid' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Tagbanwa">
      <rule context="/*" id="Tagbanwa_rule">
         <let name="start" value="5984"/>
         <let name="end" value="6015"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Tagbanwa_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Tagbanwa' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Khmer">
      <rule context="/*" id="Khmer_rule">
         <let name="start" value="6016"/>
         <let name="end" value="6143"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Khmer_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Khmer' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Mongolian">
      <rule context="/*" id="Mongolian_rule">
         <let name="start" value="6144"/>
         <let name="end" value="6319"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Mongolian_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Mongolian' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="UnifiedCanadianAboriginalSyllabicsExtended">
      <rule context="/*" id="UnifiedCanadianAboriginalSyllabicsExtended_rule">
         <let name="start" value="6320"/>
         <let name="end" value="6399"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="UnifiedCanadianAboriginalSyllabicsExtended_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Unified Canadian Aboriginal Syllabics Extended' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Limbu">
      <rule context="/*" id="Limbu_rule">
         <let name="start" value="6400"/>
         <let name="end" value="6479"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Limbu_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Limbu' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="TaiLe">
      <rule context="/*" id="TaiLe_rule">
         <let name="start" value="6480"/>
         <let name="end" value="6527"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="TaiLe_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Tai Le' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="NewTaiLue">
      <rule context="/*" id="NewTaiLue_rule">
         <let name="start" value="6528"/>
         <let name="end" value="6623"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="NewTaiLue_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'New Tai Lue' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="KhmerSymbols">
      <rule context="/*" id="KhmerSymbols_rule">
         <let name="start" value="6624"/>
         <let name="end" value="6655"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="KhmerSymbols_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Khmer Symbols' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Buginese">
      <rule context="/*" id="Buginese_rule">
         <let name="start" value="6656"/>
         <let name="end" value="6687"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Buginese_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Buginese' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="TaiTham">
      <rule context="/*" id="TaiTham_rule">
         <let name="start" value="6688"/>
         <let name="end" value="6831"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="TaiTham_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Tai Tham' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CombiningDiacriticalMarksExtended">
      <rule context="/*" id="CombiningDiacriticalMarksExtended_rule">
         <let name="start" value="6832"/>
         <let name="end" value="6911"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CombiningDiacriticalMarksExtended_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Combining Diacritical Marks Extended' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Balinese">
      <rule context="/*" id="Balinese_rule">
         <let name="start" value="6912"/>
         <let name="end" value="7039"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Balinese_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Balinese' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Sundanese">
      <rule context="/*" id="Sundanese_rule">
         <let name="start" value="7040"/>
         <let name="end" value="7103"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Sundanese_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Sundanese' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Batak">
      <rule context="/*" id="Batak_rule">
         <let name="start" value="7104"/>
         <let name="end" value="7167"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Batak_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Batak' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Lepcha">
      <rule context="/*" id="Lepcha_rule">
         <let name="start" value="7168"/>
         <let name="end" value="7247"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Lepcha_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Lepcha' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="OlChiki">
      <rule context="/*" id="OlChiki_rule">
         <let name="start" value="7248"/>
         <let name="end" value="7295"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="OlChiki_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Ol Chiki' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CyrillicExtended-C">
      <rule context="/*" id="CyrillicExtended-C_rule">
         <let name="start" value="7296"/>
         <let name="end" value="7311"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CyrillicExtended-C_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Cyrillic Extended-C' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="GeorgianExtended">
      <rule context="/*" id="GeorgianExtended_rule">
         <let name="start" value="7312"/>
         <let name="end" value="7359"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="GeorgianExtended_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Georgian Extended' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="SundaneseSupplement">
      <rule context="/*" id="SundaneseSupplement_rule">
         <let name="start" value="7360"/>
         <let name="end" value="7375"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="SundaneseSupplement_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Sundanese Supplement' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="VedicExtensions">
      <rule context="/*" id="VedicExtensions_rule">
         <let name="start" value="7376"/>
         <let name="end" value="7423"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="VedicExtensions_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Vedic Extensions' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="PhoneticExtensions">
      <rule context="/*" id="PhoneticExtensions_rule">
         <let name="start" value="7424"/>
         <let name="end" value="7551"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="PhoneticExtensions_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Phonetic Extensions' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="LatinExtendedAdditional">
      <rule context="/*" id="LatinExtendedAdditional_rule">
         <let name="start" value="7680"/>
         <let name="end" value="7935"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="LatinExtendedAdditional_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Latin Extended Additional' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CurrencySymbols">
      <rule context="/*" id="CurrencySymbols_rule">
         <let name="start" value="8352"/>
         <let name="end" value="8399"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <let name="exceptions" value="(8364)"/>
         <report id="CurrencySymbols_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end and (some $e in $exceptions satisfies not($e = $u))">
              This Document contains chars of the unicode-block 'Currency Symbols' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="COMBININGENCLOSINGCIRCLE">
      <rule context="/*" id="COMBININGENCLOSINGCIRCLE_rule">
         <let name="value" value="8413"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="COMBININGENCLOSINGCIRCLE_report"
                 test="some $u in $uni-chars satisfies $value = $u">
              This Document contains the char 'COMBINING ENCLOSING CIRCLE' use the char 'WHITE CIRCLE' (25CB) instead.
            </report>
      </rule>
   </pattern>
   <pattern id="COMBININGRIGHTARROWABOVE">
      <rule context="/*" id="COMBININGRIGHTARROWABOVE_rule">
         <let name="value" value="8407"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="COMBININGRIGHTARROWABOVE_report"
                 test="some $u in $uni-chars satisfies $value = $u">
              This Document contains the char 'COMBINING RIGHT ARROW ABOVE' use the char 'RIGHTWARDS ARROW' (2192) instead.
            </report>
      </rule>
   </pattern>
   <pattern id="COMBININGENCLOSINGSQUARE">
      <rule context="/*" id="COMBININGENCLOSINGSQUARE_rule">
         <let name="value" value="8414"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="COMBININGENCLOSINGSQUARE_report"
                 test="some $u in $uni-chars satisfies $value = $u">
              This Document contains the char 'COMBINING ENCLOSING SQUARE' use the char 'WHITE SQUARE' (25A1) instead.
            </report>
      </rule>
   </pattern>
   <pattern id="COMBININGANTICLOCKWISEARROWABOVE">
      <rule context="/*" id="COMBININGANTICLOCKWISEARROWABOVE_rule">
         <let name="value" value="8404"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="COMBININGANTICLOCKWISEARROWABOVE_report"
                 test="some $u in $uni-chars satisfies $value = $u">
              This Document contains the char 'COMBINING ANTICLOCKWISE ARROW ABOVE' use the char 'TOP ARC ANTICLOCKWISE ARROW' (293A) instead.
            </report>
      </rule>
   </pattern>
   <pattern id="BoxDrawing">
      <rule context="/*" id="BoxDrawing_rule">
         <let name="start" value="9472"/>
         <let name="end" value="9599"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="BoxDrawing_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Box Drawing' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="MiscellaneousMathematicalSymbols-B">
      <rule context="/*" id="MiscellaneousMathematicalSymbols-B_rule">
         <let name="start" value="10624"/>
         <let name="end" value="10751"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="MiscellaneousMathematicalSymbols-B_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Miscellaneous Mathematical Symbols-B' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="GeorgianSupplement">
      <rule context="/*" id="GeorgianSupplement_rule">
         <let name="start" value="11520"/>
         <let name="end" value="11567"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="GeorgianSupplement_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Georgian Supplement' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Tifinagh">
      <rule context="/*" id="Tifinagh_rule">
         <let name="start" value="11568"/>
         <let name="end" value="11647"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Tifinagh_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Tifinagh' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="EthiopicExtended">
      <rule context="/*" id="EthiopicExtended_rule">
         <let name="start" value="11648"/>
         <let name="end" value="11743"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="EthiopicExtended_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Ethiopic Extended' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CyrillicExtended-A">
      <rule context="/*" id="CyrillicExtended-A_rule">
         <let name="start" value="11744"/>
         <let name="end" value="11775"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CyrillicExtended-A_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Cyrillic Extended-A' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="SupplementalPunctuation">
      <rule context="/*" id="SupplementalPunctuation_rule">
         <let name="start" value="11776"/>
         <let name="end" value="11903"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="SupplementalPunctuation_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Supplemental Punctuation' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="IdeographicDescriptionCharacters">
      <rule context="/*" id="IdeographicDescriptionCharacters_rule">
         <let name="start" value="12272"/>
         <let name="end" value="12287"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="IdeographicDescriptionCharacters_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Ideographic Description Characters' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CJKSymbolsandPunctuation">
      <rule context="/*" id="CJKSymbolsandPunctuation_rule">
         <let name="start" value="12288"/>
         <let name="end" value="12351"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CJKSymbolsandPunctuation_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'CJK Symbols and Punctuation' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Hiragana">
      <rule context="/*" id="Hiragana_rule">
         <let name="start" value="12352"/>
         <let name="end" value="12447"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Hiragana_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Hiragana' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Kanbun">
      <rule context="/*" id="Kanbun_rule">
         <let name="start" value="12688"/>
         <let name="end" value="12703"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Kanbun_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Kanbun' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="BopomofoExtended">
      <rule context="/*" id="BopomofoExtended_rule">
         <let name="start" value="12704"/>
         <let name="end" value="12735"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="BopomofoExtended_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Bopomofo Extended' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CJKStrokes">
      <rule context="/*" id="CJKStrokes_rule">
         <let name="start" value="12736"/>
         <let name="end" value="12783"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CJKStrokes_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'CJK Strokes' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="KatakanaPhoneticExtensions">
      <rule context="/*" id="KatakanaPhoneticExtensions_rule">
         <let name="start" value="12784"/>
         <let name="end" value="12799"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="KatakanaPhoneticExtensions_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Katakana Phonetic Extensions' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="EnclosedCJKLettersandMonths">
      <rule context="/*" id="EnclosedCJKLettersandMonths_rule">
         <let name="start" value="12800"/>
         <let name="end" value="13055"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="EnclosedCJKLettersandMonths_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Enclosed CJK Letters and Months' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CJKCompatibility">
      <rule context="/*" id="CJKCompatibility_rule">
         <let name="start" value="13056"/>
         <let name="end" value="13311"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CJKCompatibility_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'CJK Compatibility' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CJKUnifiedIdeographsExtensionA">
      <rule context="/*" id="CJKUnifiedIdeographsExtensionA_rule">
         <let name="start" value="13312"/>
         <let name="end" value="19903"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CJKUnifiedIdeographsExtensionA_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'CJK Unified Ideographs Extension A' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CJKUnifiedIdeographs">
      <rule context="/*" id="CJKUnifiedIdeographs_rule">
         <let name="start" value="19968"/>
         <let name="end" value="40959"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CJKUnifiedIdeographs_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'CJK Unified Ideographs' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="YiSyllables">
      <rule context="/*" id="YiSyllables_rule">
         <let name="start" value="40960"/>
         <let name="end" value="42127"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="YiSyllables_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Yi Syllables' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Lisu">
      <rule context="/*" id="Lisu_rule">
         <let name="start" value="42192"/>
         <let name="end" value="42239"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Lisu_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Lisu' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Vai">
      <rule context="/*" id="Vai_rule">
         <let name="start" value="42240"/>
         <let name="end" value="42559"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Vai_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Vai' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CyrillicExtended-B">
      <rule context="/*" id="CyrillicExtended-B_rule">
         <let name="start" value="42560"/>
         <let name="end" value="42655"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CyrillicExtended-B_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Cyrillic Extended-B' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Bamum">
      <rule context="/*" id="Bamum_rule">
         <let name="start" value="42656"/>
         <let name="end" value="42751"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Bamum_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Bamum' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="LatinExtended-D">
      <rule context="/*" id="LatinExtended-D_rule">
         <let name="start" value="42784"/>
         <let name="end" value="43007"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="LatinExtended-D_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Latin Extended-D' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="SylotiNagri">
      <rule context="/*" id="SylotiNagri_rule">
         <let name="start" value="43008"/>
         <let name="end" value="43055"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="SylotiNagri_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Syloti Nagri' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CommonIndicNumberForms">
      <rule context="/*" id="CommonIndicNumberForms_rule">
         <let name="start" value="43056"/>
         <let name="end" value="43071"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CommonIndicNumberForms_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Common Indic Number Forms' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Phags-pa">
      <rule context="/*" id="Phags-pa_rule">
         <let name="start" value="43072"/>
         <let name="end" value="43135"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Phags-pa_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Phags-pa' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Saurashtra">
      <rule context="/*" id="Saurashtra_rule">
         <let name="start" value="43136"/>
         <let name="end" value="43231"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Saurashtra_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Saurashtra' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="DevanagariExtended">
      <rule context="/*" id="DevanagariExtended_rule">
         <let name="start" value="43232"/>
         <let name="end" value="43263"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="DevanagariExtended_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Devanagari Extended' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="KayahLi">
      <rule context="/*" id="KayahLi_rule">
         <let name="start" value="43264"/>
         <let name="end" value="43311"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="KayahLi_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Kayah Li' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Rejang">
      <rule context="/*" id="Rejang_rule">
         <let name="start" value="43312"/>
         <let name="end" value="43359"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Rejang_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Rejang' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="HangulJamoExtended-A">
      <rule context="/*" id="HangulJamoExtended-A_rule">
         <let name="start" value="43360"/>
         <let name="end" value="43391"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="HangulJamoExtended-A_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Hangul Jamo Extended-A' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Javanese">
      <rule context="/*" id="Javanese_rule">
         <let name="start" value="43392"/>
         <let name="end" value="43487"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Javanese_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Javanese' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="MyanmarExtended-B">
      <rule context="/*" id="MyanmarExtended-B_rule">
         <let name="start" value="43488"/>
         <let name="end" value="43519"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="MyanmarExtended-B_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Myanmar Extended-B' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Cham">
      <rule context="/*" id="Cham_rule">
         <let name="start" value="43520"/>
         <let name="end" value="43615"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Cham_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Cham' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="MyanmarExtended-A">
      <rule context="/*" id="MyanmarExtended-A_rule">
         <let name="start" value="43616"/>
         <let name="end" value="43647"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="MyanmarExtended-A_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Myanmar Extended-A' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="TaiViet">
      <rule context="/*" id="TaiViet_rule">
         <let name="start" value="43648"/>
         <let name="end" value="43743"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="TaiViet_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Tai Viet' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="MeeteiMayekExtensions">
      <rule context="/*" id="MeeteiMayekExtensions_rule">
         <let name="start" value="43744"/>
         <let name="end" value="43775"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="MeeteiMayekExtensions_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Meetei Mayek Extensions' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="EthiopicExtended-A">
      <rule context="/*" id="EthiopicExtended-A_rule">
         <let name="start" value="43776"/>
         <let name="end" value="43823"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="EthiopicExtended-A_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Ethiopic Extended-A' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="LatinExtended-E">
      <rule context="/*" id="LatinExtended-E_rule">
         <let name="start" value="43824"/>
         <let name="end" value="43887"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="LatinExtended-E_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Latin Extended-E' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CherokeeSupplement">
      <rule context="/*" id="CherokeeSupplement_rule">
         <let name="start" value="43888"/>
         <let name="end" value="43967"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CherokeeSupplement_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Cherokee Supplement' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="MeeteiMayek">
      <rule context="/*" id="MeeteiMayek_rule">
         <let name="start" value="43968"/>
         <let name="end" value="44031"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="MeeteiMayek_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Meetei Mayek' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="HangulSyllables">
      <rule context="/*" id="HangulSyllables_rule">
         <let name="start" value="44032"/>
         <let name="end" value="55215"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="HangulSyllables_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Hangul Syllables' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="HangulJamoExtended-B">
      <rule context="/*" id="HangulJamoExtended-B_rule">
         <let name="start" value="55216"/>
         <let name="end" value="55295"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="HangulJamoExtended-B_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Hangul Jamo Extended-B' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="HighSurrogates">
      <rule context="/*" id="HighSurrogates_rule">
         <let name="start" value="55296"/>
         <let name="end" value="56191"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="HighSurrogates_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'High Surrogates' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="HighPrivateUseSurrogates">
      <rule context="/*" id="HighPrivateUseSurrogates_rule">
         <let name="start" value="56192"/>
         <let name="end" value="56319"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="HighPrivateUseSurrogates_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'High Private Use Surrogates' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="LowSurrogates">
      <rule context="/*" id="LowSurrogates_rule">
         <let name="start" value="56320"/>
         <let name="end" value="57343"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="LowSurrogates_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Low Surrogates' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="PrivateUseArea">
      <rule context="/*" id="PrivateUseArea_rule">
         <let name="start" value="57344"/>
         <let name="end" value="63743"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="PrivateUseArea_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Private Use Area' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CJKCompatibilityIdeographs">
      <rule context="/*" id="CJKCompatibilityIdeographs_rule">
         <let name="start" value="63744"/>
         <let name="end" value="64255"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CJKCompatibilityIdeographs_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'CJK Compatibility Ideographs' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="ArabicPresentationForms-A">
      <rule context="/*" id="ArabicPresentationForms-A_rule">
         <let name="start" value="64336"/>
         <let name="end" value="65023"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="ArabicPresentationForms-A_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Arabic Presentation Forms-A' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CombiningHalfMarks">
      <rule context="/*" id="CombiningHalfMarks_rule">
         <let name="start" value="65056"/>
         <let name="end" value="65071"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CombiningHalfMarks_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Combining Half Marks' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CJKCompatibilityForms">
      <rule context="/*" id="CJKCompatibilityForms_rule">
         <let name="start" value="65072"/>
         <let name="end" value="65103"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CJKCompatibilityForms_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'CJK Compatibility Forms' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="SmallFormVariants">
      <rule context="/*" id="SmallFormVariants_rule">
         <let name="start" value="65104"/>
         <let name="end" value="65135"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="SmallFormVariants_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Small Form Variants' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="AegeanNumbers">
      <rule context="/*" id="AegeanNumbers_rule">
         <let name="start" value="65792"/>
         <let name="end" value="65855"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="AegeanNumbers_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Aegean Numbers' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="AncientGreekNumbers">
      <rule context="/*" id="AncientGreekNumbers_rule">
         <let name="start" value="65856"/>
         <let name="end" value="65935"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="AncientGreekNumbers_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Ancient Greek Numbers' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="AncientSymbols">
      <rule context="/*" id="AncientSymbols_rule">
         <let name="start" value="65936"/>
         <let name="end" value="65999"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="AncientSymbols_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Ancient Symbols' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="PhaistosDisc">
      <rule context="/*" id="PhaistosDisc_rule">
         <let name="start" value="66000"/>
         <let name="end" value="66047"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="PhaistosDisc_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Phaistos Disc' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Lycian">
      <rule context="/*" id="Lycian_rule">
         <let name="start" value="66176"/>
         <let name="end" value="66207"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Lycian_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Lycian' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Carian">
      <rule context="/*" id="Carian_rule">
         <let name="start" value="66208"/>
         <let name="end" value="66271"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Carian_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Carian' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CopticEpactNumbers">
      <rule context="/*" id="CopticEpactNumbers_rule">
         <let name="start" value="66272"/>
         <let name="end" value="66303"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CopticEpactNumbers_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Coptic Epact Numbers' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="OldItalic">
      <rule context="/*" id="OldItalic_rule">
         <let name="start" value="66304"/>
         <let name="end" value="66351"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="OldItalic_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Old Italic' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Gothic">
      <rule context="/*" id="Gothic_rule">
         <let name="start" value="66352"/>
         <let name="end" value="66383"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Gothic_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Gothic' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="OldPermic">
      <rule context="/*" id="OldPermic_rule">
         <let name="start" value="66384"/>
         <let name="end" value="66431"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="OldPermic_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Old Permic' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Ugaritic">
      <rule context="/*" id="Ugaritic_rule">
         <let name="start" value="66432"/>
         <let name="end" value="66463"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Ugaritic_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Ugaritic' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="OldPersian">
      <rule context="/*" id="OldPersian_rule">
         <let name="start" value="66464"/>
         <let name="end" value="66527"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="OldPersian_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Old Persian' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Deseret">
      <rule context="/*" id="Deseret_rule">
         <let name="start" value="66560"/>
         <let name="end" value="66639"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Deseret_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Deseret' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Shavian">
      <rule context="/*" id="Shavian_rule">
         <let name="start" value="66640"/>
         <let name="end" value="66687"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Shavian_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Shavian' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Osmanya">
      <rule context="/*" id="Osmanya_rule">
         <let name="start" value="66688"/>
         <let name="end" value="66735"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Osmanya_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Osmanya' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Osage">
      <rule context="/*" id="Osage_rule">
         <let name="start" value="66736"/>
         <let name="end" value="66815"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Osage_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Osage' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Elbasan">
      <rule context="/*" id="Elbasan_rule">
         <let name="start" value="66816"/>
         <let name="end" value="66863"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Elbasan_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Elbasan' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CaucasianAlbanian">
      <rule context="/*" id="CaucasianAlbanian_rule">
         <let name="start" value="66864"/>
         <let name="end" value="66927"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CaucasianAlbanian_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Caucasian Albanian' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Vithkuqi">
      <rule context="/*" id="Vithkuqi_rule">
         <let name="start" value="66928"/>
         <let name="end" value="67007"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Vithkuqi_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Vithkuqi' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="LinearA">
      <rule context="/*" id="LinearA_rule">
         <let name="start" value="67072"/>
         <let name="end" value="67455"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="LinearA_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Linear A' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="LatinExtended-F">
      <rule context="/*" id="LatinExtended-F_rule">
         <let name="start" value="67456"/>
         <let name="end" value="67519"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="LatinExtended-F_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Latin Extended-F' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CypriotSyllabary">
      <rule context="/*" id="CypriotSyllabary_rule">
         <let name="start" value="67584"/>
         <let name="end" value="67647"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CypriotSyllabary_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Cypriot Syllabary' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="ImperialAramaic">
      <rule context="/*" id="ImperialAramaic_rule">
         <let name="start" value="67648"/>
         <let name="end" value="67679"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="ImperialAramaic_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Imperial Aramaic' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Palmyrene">
      <rule context="/*" id="Palmyrene_rule">
         <let name="start" value="67680"/>
         <let name="end" value="67711"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Palmyrene_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Palmyrene' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Nabataean">
      <rule context="/*" id="Nabataean_rule">
         <let name="start" value="67712"/>
         <let name="end" value="67759"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Nabataean_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Nabataean' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Hatran">
      <rule context="/*" id="Hatran_rule">
         <let name="start" value="67808"/>
         <let name="end" value="67839"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Hatran_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Hatran' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Phoenician">
      <rule context="/*" id="Phoenician_rule">
         <let name="start" value="67840"/>
         <let name="end" value="67871"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Phoenician_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Phoenician' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Lydian">
      <rule context="/*" id="Lydian_rule">
         <let name="start" value="67872"/>
         <let name="end" value="67903"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Lydian_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Lydian' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="MeroiticHieroglyphs">
      <rule context="/*" id="MeroiticHieroglyphs_rule">
         <let name="start" value="67968"/>
         <let name="end" value="67999"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="MeroiticHieroglyphs_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Meroitic Hieroglyphs' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="MeroiticCursive">
      <rule context="/*" id="MeroiticCursive_rule">
         <let name="start" value="68000"/>
         <let name="end" value="68095"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="MeroiticCursive_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Meroitic Cursive' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Kharoshthi">
      <rule context="/*" id="Kharoshthi_rule">
         <let name="start" value="68096"/>
         <let name="end" value="68191"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Kharoshthi_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Kharoshthi' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="OldSouthArabian">
      <rule context="/*" id="OldSouthArabian_rule">
         <let name="start" value="68192"/>
         <let name="end" value="68223"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="OldSouthArabian_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Old South Arabian' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="OldNorthArabian">
      <rule context="/*" id="OldNorthArabian_rule">
         <let name="start" value="68224"/>
         <let name="end" value="68255"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="OldNorthArabian_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Old North Arabian' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Manichaean">
      <rule context="/*" id="Manichaean_rule">
         <let name="start" value="68288"/>
         <let name="end" value="68351"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Manichaean_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Manichaean' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Avestan">
      <rule context="/*" id="Avestan_rule">
         <let name="start" value="68352"/>
         <let name="end" value="68415"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Avestan_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Avestan' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="InscriptionalParthian">
      <rule context="/*" id="InscriptionalParthian_rule">
         <let name="start" value="68416"/>
         <let name="end" value="68447"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="InscriptionalParthian_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Inscriptional Parthian' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="InscriptionalPahlavi">
      <rule context="/*" id="InscriptionalPahlavi_rule">
         <let name="start" value="68448"/>
         <let name="end" value="68479"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="InscriptionalPahlavi_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Inscriptional Pahlavi' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="PsalterPahlavi">
      <rule context="/*" id="PsalterPahlavi_rule">
         <let name="start" value="68480"/>
         <let name="end" value="68527"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="PsalterPahlavi_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Psalter Pahlavi' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="OldTurkic">
      <rule context="/*" id="OldTurkic_rule">
         <let name="start" value="68608"/>
         <let name="end" value="68687"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="OldTurkic_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Old Turkic' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="OldHungarian">
      <rule context="/*" id="OldHungarian_rule">
         <let name="start" value="68736"/>
         <let name="end" value="68863"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="OldHungarian_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Old Hungarian' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="HanifiRohingya">
      <rule context="/*" id="HanifiRohingya_rule">
         <let name="start" value="68864"/>
         <let name="end" value="68927"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="HanifiRohingya_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Hanifi Rohingya' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="RumiNumeralSymbols">
      <rule context="/*" id="RumiNumeralSymbols_rule">
         <let name="start" value="69216"/>
         <let name="end" value="69247"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="RumiNumeralSymbols_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Rumi Numeral Symbols' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Yezidi">
      <rule context="/*" id="Yezidi_rule">
         <let name="start" value="69248"/>
         <let name="end" value="69311"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Yezidi_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Yezidi' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="ArabicExtended-C">
      <rule context="/*" id="ArabicExtended-C_rule">
         <let name="start" value="69312"/>
         <let name="end" value="69375"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="ArabicExtended-C_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Arabic Extended-C' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="OldSogdian">
      <rule context="/*" id="OldSogdian_rule">
         <let name="start" value="69376"/>
         <let name="end" value="69423"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="OldSogdian_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Old Sogdian' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Sogdian">
      <rule context="/*" id="Sogdian_rule">
         <let name="start" value="69424"/>
         <let name="end" value="69487"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Sogdian_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Sogdian' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="OldUyghur">
      <rule context="/*" id="OldUyghur_rule">
         <let name="start" value="69488"/>
         <let name="end" value="69551"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="OldUyghur_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Old Uyghur' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Chorasmian">
      <rule context="/*" id="Chorasmian_rule">
         <let name="start" value="69552"/>
         <let name="end" value="69599"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Chorasmian_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Chorasmian' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Elymaic">
      <rule context="/*" id="Elymaic_rule">
         <let name="start" value="69600"/>
         <let name="end" value="69631"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Elymaic_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Elymaic' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Brahmi">
      <rule context="/*" id="Brahmi_rule">
         <let name="start" value="69632"/>
         <let name="end" value="69759"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Brahmi_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Brahmi' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Kaithi">
      <rule context="/*" id="Kaithi_rule">
         <let name="start" value="69760"/>
         <let name="end" value="69839"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Kaithi_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Kaithi' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="SoraSompeng">
      <rule context="/*" id="SoraSompeng_rule">
         <let name="start" value="69840"/>
         <let name="end" value="69887"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="SoraSompeng_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Sora Sompeng' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Chakma">
      <rule context="/*" id="Chakma_rule">
         <let name="start" value="69888"/>
         <let name="end" value="69967"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Chakma_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Chakma' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Mahajani">
      <rule context="/*" id="Mahajani_rule">
         <let name="start" value="69968"/>
         <let name="end" value="70015"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Mahajani_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Mahajani' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Sharada">
      <rule context="/*" id="Sharada_rule">
         <let name="start" value="70016"/>
         <let name="end" value="70111"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Sharada_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Sharada' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="SinhalaArchaicNumbers">
      <rule context="/*" id="SinhalaArchaicNumbers_rule">
         <let name="start" value="70112"/>
         <let name="end" value="70143"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="SinhalaArchaicNumbers_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Sinhala Archaic Numbers' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Khojki">
      <rule context="/*" id="Khojki_rule">
         <let name="start" value="70144"/>
         <let name="end" value="70223"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Khojki_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Khojki' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Multani">
      <rule context="/*" id="Multani_rule">
         <let name="start" value="70272"/>
         <let name="end" value="70319"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Multani_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Multani' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Khudawadi">
      <rule context="/*" id="Khudawadi_rule">
         <let name="start" value="70320"/>
         <let name="end" value="70399"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Khudawadi_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Khudawadi' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Grantha">
      <rule context="/*" id="Grantha_rule">
         <let name="start" value="70400"/>
         <let name="end" value="70527"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Grantha_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Grantha' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Newa">
      <rule context="/*" id="Newa_rule">
         <let name="start" value="70656"/>
         <let name="end" value="70783"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Newa_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Newa' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Tirhuta">
      <rule context="/*" id="Tirhuta_rule">
         <let name="start" value="70784"/>
         <let name="end" value="70879"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Tirhuta_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Tirhuta' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Siddham">
      <rule context="/*" id="Siddham_rule">
         <let name="start" value="71040"/>
         <let name="end" value="71167"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Siddham_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Siddham' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Modi">
      <rule context="/*" id="Modi_rule">
         <let name="start" value="71168"/>
         <let name="end" value="71263"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Modi_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Modi' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="MongolianSupplement">
      <rule context="/*" id="MongolianSupplement_rule">
         <let name="start" value="71264"/>
         <let name="end" value="71295"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="MongolianSupplement_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Mongolian Supplement' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Takri">
      <rule context="/*" id="Takri_rule">
         <let name="start" value="71296"/>
         <let name="end" value="71375"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Takri_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Takri' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Ahom">
      <rule context="/*" id="Ahom_rule">
         <let name="start" value="71424"/>
         <let name="end" value="71503"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Ahom_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Ahom' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Dogra">
      <rule context="/*" id="Dogra_rule">
         <let name="start" value="71680"/>
         <let name="end" value="71759"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Dogra_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Dogra' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="WarangCiti">
      <rule context="/*" id="WarangCiti_rule">
         <let name="start" value="71840"/>
         <let name="end" value="71935"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="WarangCiti_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Warang Citi' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="DivesAkuru">
      <rule context="/*" id="DivesAkuru_rule">
         <let name="start" value="71936"/>
         <let name="end" value="72031"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="DivesAkuru_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Dives Akuru' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Nandinagari">
      <rule context="/*" id="Nandinagari_rule">
         <let name="start" value="72096"/>
         <let name="end" value="72191"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Nandinagari_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Nandinagari' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="ZanabazarSquare">
      <rule context="/*" id="ZanabazarSquare_rule">
         <let name="start" value="72192"/>
         <let name="end" value="72271"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="ZanabazarSquare_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Zanabazar Square' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Soyombo">
      <rule context="/*" id="Soyombo_rule">
         <let name="start" value="72272"/>
         <let name="end" value="72367"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Soyombo_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Soyombo' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="UnifiedCanadianAboriginalSyllabicsExtended-A">
      <rule context="/*" id="UnifiedCanadianAboriginalSyllabicsExtended-A_rule">
         <let name="start" value="72368"/>
         <let name="end" value="72383"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="UnifiedCanadianAboriginalSyllabicsExtended-A_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Unified Canadian Aboriginal Syllabics Extended-A' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="PauCinHau">
      <rule context="/*" id="PauCinHau_rule">
         <let name="start" value="72384"/>
         <let name="end" value="72447"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="PauCinHau_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Pau Cin Hau' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="DevanagariExtended-A">
      <rule context="/*" id="DevanagariExtended-A_rule">
         <let name="start" value="72448"/>
         <let name="end" value="72543"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="DevanagariExtended-A_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Devanagari Extended-A' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Bhaiksuki">
      <rule context="/*" id="Bhaiksuki_rule">
         <let name="start" value="72704"/>
         <let name="end" value="72815"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Bhaiksuki_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Bhaiksuki' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Marchen">
      <rule context="/*" id="Marchen_rule">
         <let name="start" value="72816"/>
         <let name="end" value="72895"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Marchen_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Marchen' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="MasaramGondi">
      <rule context="/*" id="MasaramGondi_rule">
         <let name="start" value="72960"/>
         <let name="end" value="73055"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="MasaramGondi_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Masaram Gondi' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="GunjalaGondi">
      <rule context="/*" id="GunjalaGondi_rule">
         <let name="start" value="73056"/>
         <let name="end" value="73135"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="GunjalaGondi_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Gunjala Gondi' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Makasar">
      <rule context="/*" id="Makasar_rule">
         <let name="start" value="73440"/>
         <let name="end" value="73471"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Makasar_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Makasar' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Kawi">
      <rule context="/*" id="Kawi_rule">
         <let name="start" value="73472"/>
         <let name="end" value="73567"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Kawi_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Kawi' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="LisuSupplement">
      <rule context="/*" id="LisuSupplement_rule">
         <let name="start" value="73648"/>
         <let name="end" value="73663"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="LisuSupplement_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Lisu Supplement' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="TamilSupplement">
      <rule context="/*" id="TamilSupplement_rule">
         <let name="start" value="73664"/>
         <let name="end" value="73727"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="TamilSupplement_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Tamil Supplement' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Cuneiform">
      <rule context="/*" id="Cuneiform_rule">
         <let name="start" value="73728"/>
         <let name="end" value="74751"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Cuneiform_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Cuneiform' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CuneiformNumbersandPunctuation">
      <rule context="/*" id="CuneiformNumbersandPunctuation_rule">
         <let name="start" value="74752"/>
         <let name="end" value="74879"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CuneiformNumbersandPunctuation_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Cuneiform Numbers and Punctuation' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="EarlyDynasticCuneiform">
      <rule context="/*" id="EarlyDynasticCuneiform_rule">
         <let name="start" value="74880"/>
         <let name="end" value="75087"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="EarlyDynasticCuneiform_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Early Dynastic Cuneiform' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Cypro-Minoan">
      <rule context="/*" id="Cypro-Minoan_rule">
         <let name="start" value="77712"/>
         <let name="end" value="77823"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Cypro-Minoan_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Cypro-Minoan' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="EgyptianHieroglyphs">
      <rule context="/*" id="EgyptianHieroglyphs_rule">
         <let name="start" value="77824"/>
         <let name="end" value="78895"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="EgyptianHieroglyphs_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Egyptian Hieroglyphs' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="EgyptianHieroglyphFormatControls">
      <rule context="/*" id="EgyptianHieroglyphFormatControls_rule">
         <let name="start" value="78896"/>
         <let name="end" value="78943"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="EgyptianHieroglyphFormatControls_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Egyptian Hieroglyph Format Controls' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="AnatolianHieroglyphs">
      <rule context="/*" id="AnatolianHieroglyphs_rule">
         <let name="start" value="82944"/>
         <let name="end" value="83583"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="AnatolianHieroglyphs_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Anatolian Hieroglyphs' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="BamumSupplement">
      <rule context="/*" id="BamumSupplement_rule">
         <let name="start" value="92160"/>
         <let name="end" value="92735"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="BamumSupplement_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Bamum Supplement' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Mro">
      <rule context="/*" id="Mro_rule">
         <let name="start" value="92736"/>
         <let name="end" value="92783"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Mro_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Mro' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Tangsa">
      <rule context="/*" id="Tangsa_rule">
         <let name="start" value="92784"/>
         <let name="end" value="92879"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Tangsa_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Tangsa' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="BassaVah">
      <rule context="/*" id="BassaVah_rule">
         <let name="start" value="92880"/>
         <let name="end" value="92927"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="BassaVah_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Bassa Vah' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="PahawhHmong">
      <rule context="/*" id="PahawhHmong_rule">
         <let name="start" value="92928"/>
         <let name="end" value="93071"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="PahawhHmong_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Pahawh Hmong' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Medefaidrin">
      <rule context="/*" id="Medefaidrin_rule">
         <let name="start" value="93760"/>
         <let name="end" value="93855"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Medefaidrin_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Medefaidrin' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Miao">
      <rule context="/*" id="Miao_rule">
         <let name="start" value="93952"/>
         <let name="end" value="94111"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Miao_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Miao' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="IdeographicSymbolsandPunctuation">
      <rule context="/*" id="IdeographicSymbolsandPunctuation_rule">
         <let name="start" value="94176"/>
         <let name="end" value="94207"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="IdeographicSymbolsandPunctuation_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Ideographic Symbols and Punctuation' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Tangut">
      <rule context="/*" id="Tangut_rule">
         <let name="start" value="94208"/>
         <let name="end" value="100351"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Tangut_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Tangut' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="TangutComponents">
      <rule context="/*" id="TangutComponents_rule">
         <let name="start" value="100352"/>
         <let name="end" value="101119"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="TangutComponents_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Tangut Components' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="KhitanSmallScript">
      <rule context="/*" id="KhitanSmallScript_rule">
         <let name="start" value="101120"/>
         <let name="end" value="101631"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="KhitanSmallScript_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Khitan Small Script' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="TangutSupplement">
      <rule context="/*" id="TangutSupplement_rule">
         <let name="start" value="101632"/>
         <let name="end" value="101759"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="TangutSupplement_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Tangut Supplement' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="KanaExtended-B">
      <rule context="/*" id="KanaExtended-B_rule">
         <let name="start" value="110576"/>
         <let name="end" value="110591"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="KanaExtended-B_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Kana Extended-B' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="KanaSupplement">
      <rule context="/*" id="KanaSupplement_rule">
         <let name="start" value="110592"/>
         <let name="end" value="110847"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="KanaSupplement_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Kana Supplement' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="KanaExtended-A">
      <rule context="/*" id="KanaExtended-A_rule">
         <let name="start" value="110848"/>
         <let name="end" value="110895"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="KanaExtended-A_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Kana Extended-A' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="SmallKanaExtension">
      <rule context="/*" id="SmallKanaExtension_rule">
         <let name="start" value="110896"/>
         <let name="end" value="110959"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="SmallKanaExtension_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Small Kana Extension' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Nushu">
      <rule context="/*" id="Nushu_rule">
         <let name="start" value="110960"/>
         <let name="end" value="111359"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Nushu_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Nushu' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Duployan">
      <rule context="/*" id="Duployan_rule">
         <let name="start" value="113664"/>
         <let name="end" value="113823"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Duployan_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Duployan' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="ShorthandFormatControls">
      <rule context="/*" id="ShorthandFormatControls_rule">
         <let name="start" value="113824"/>
         <let name="end" value="113839"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="ShorthandFormatControls_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Shorthand Format Controls' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="ZnamennyMusicalNotation">
      <rule context="/*" id="ZnamennyMusicalNotation_rule">
         <let name="start" value="118528"/>
         <let name="end" value="118735"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="ZnamennyMusicalNotation_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Znamenny Musical Notation' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="ByzantineMusicalSymbols">
      <rule context="/*" id="ByzantineMusicalSymbols_rule">
         <let name="start" value="118784"/>
         <let name="end" value="119039"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="ByzantineMusicalSymbols_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Byzantine Musical Symbols' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="MusicalSymbols">
      <rule context="/*" id="MusicalSymbols_rule">
         <let name="start" value="119040"/>
         <let name="end" value="119295"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="MusicalSymbols_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Musical Symbols' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="AncientGreekMusicalNotation">
      <rule context="/*" id="AncientGreekMusicalNotation_rule">
         <let name="start" value="119296"/>
         <let name="end" value="119375"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="AncientGreekMusicalNotation_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Ancient Greek Musical Notation' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="KaktovikNumerals">
      <rule context="/*" id="KaktovikNumerals_rule">
         <let name="start" value="119488"/>
         <let name="end" value="119519"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="KaktovikNumerals_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Kaktovik Numerals' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="MayanNumerals">
      <rule context="/*" id="MayanNumerals_rule">
         <let name="start" value="119520"/>
         <let name="end" value="119551"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="MayanNumerals_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Mayan Numerals' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="TaiXuanJingSymbols">
      <rule context="/*" id="TaiXuanJingSymbols_rule">
         <let name="start" value="119552"/>
         <let name="end" value="119647"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="TaiXuanJingSymbols_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Tai Xuan Jing Symbols' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CountingRodNumerals">
      <rule context="/*" id="CountingRodNumerals_rule">
         <let name="start" value="119648"/>
         <let name="end" value="119679"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CountingRodNumerals_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Counting Rod Numerals' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="MathematicalAlphanumericSymbols">
      <rule context="/*" id="MathematicalAlphanumericSymbols_rule">
         <let name="start" value="119808"/>
         <let name="end" value="120831"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="MathematicalAlphanumericSymbols_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Mathematical Alphanumeric Symbols' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="SuttonSignWriting">
      <rule context="/*" id="SuttonSignWriting_rule">
         <let name="start" value="120832"/>
         <let name="end" value="121519"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="SuttonSignWriting_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Sutton SignWriting' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="GlagoliticSupplement">
      <rule context="/*" id="GlagoliticSupplement_rule">
         <let name="start" value="122880"/>
         <let name="end" value="122927"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="GlagoliticSupplement_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Glagolitic Supplement' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CyrillicExtended-D">
      <rule context="/*" id="CyrillicExtended-D_rule">
         <let name="start" value="122928"/>
         <let name="end" value="123023"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CyrillicExtended-D_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Cyrillic Extended-D' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="NyiakengPuachueHmong">
      <rule context="/*" id="NyiakengPuachueHmong_rule">
         <let name="start" value="123136"/>
         <let name="end" value="123215"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="NyiakengPuachueHmong_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Nyiakeng Puachue Hmong' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Toto">
      <rule context="/*" id="Toto_rule">
         <let name="start" value="123536"/>
         <let name="end" value="123583"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Toto_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Toto' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Wancho">
      <rule context="/*" id="Wancho_rule">
         <let name="start" value="123584"/>
         <let name="end" value="123647"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Wancho_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Wancho' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="NagMundari">
      <rule context="/*" id="NagMundari_rule">
         <let name="start" value="124112"/>
         <let name="end" value="124159"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="NagMundari_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Nag Mundari' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="EthiopicExtended-B">
      <rule context="/*" id="EthiopicExtended-B_rule">
         <let name="start" value="124896"/>
         <let name="end" value="124927"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="EthiopicExtended-B_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Ethiopic Extended-B' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="MendeKikakui">
      <rule context="/*" id="MendeKikakui_rule">
         <let name="start" value="124928"/>
         <let name="end" value="125151"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="MendeKikakui_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Mende Kikakui' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Adlam">
      <rule context="/*" id="Adlam_rule">
         <let name="start" value="125184"/>
         <let name="end" value="125279"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Adlam_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Adlam' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="IndicSiyaqNumbers">
      <rule context="/*" id="IndicSiyaqNumbers_rule">
         <let name="start" value="126064"/>
         <let name="end" value="126143"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="IndicSiyaqNumbers_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Indic Siyaq Numbers' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="OttomanSiyaqNumbers">
      <rule context="/*" id="OttomanSiyaqNumbers_rule">
         <let name="start" value="126208"/>
         <let name="end" value="126287"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="OttomanSiyaqNumbers_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Ottoman Siyaq Numbers' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="ArabicMathematicalAlphabeticSymbols">
      <rule context="/*" id="ArabicMathematicalAlphabeticSymbols_rule">
         <let name="start" value="126464"/>
         <let name="end" value="126719"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="ArabicMathematicalAlphabeticSymbols_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Arabic Mathematical Alphabetic Symbols' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="MahjongTiles">
      <rule context="/*" id="MahjongTiles_rule">
         <let name="start" value="126976"/>
         <let name="end" value="127023"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="MahjongTiles_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Mahjong Tiles' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="DominoTiles">
      <rule context="/*" id="DominoTiles_rule">
         <let name="start" value="127024"/>
         <let name="end" value="127135"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="DominoTiles_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Domino Tiles' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="PlayingCards">
      <rule context="/*" id="PlayingCards_rule">
         <let name="start" value="127136"/>
         <let name="end" value="127231"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="PlayingCards_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Playing Cards' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="EnclosedAlphanumericSupplement">
      <rule context="/*" id="EnclosedAlphanumericSupplement_rule">
         <let name="start" value="127232"/>
         <let name="end" value="127487"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="EnclosedAlphanumericSupplement_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Enclosed Alphanumeric Supplement' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="EnclosedIdeographicSupplement">
      <rule context="/*" id="EnclosedIdeographicSupplement_rule">
         <let name="start" value="127488"/>
         <let name="end" value="127743"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="EnclosedIdeographicSupplement_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Enclosed Ideographic Supplement' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="MiscellaneousSymbolsandPictographs">
      <rule context="/*" id="MiscellaneousSymbolsandPictographs_rule">
         <let name="start" value="127744"/>
         <let name="end" value="128511"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="MiscellaneousSymbolsandPictographs_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Miscellaneous Symbols and Pictographs' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Emoticons">
      <rule context="/*" id="Emoticons_rule">
         <let name="start" value="128512"/>
         <let name="end" value="128591"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Emoticons_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Emoticons' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="TransportandMapSymbols">
      <rule context="/*" id="TransportandMapSymbols_rule">
         <let name="start" value="128640"/>
         <let name="end" value="128767"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="TransportandMapSymbols_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Transport and Map Symbols' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="AlchemicalSymbols">
      <rule context="/*" id="AlchemicalSymbols_rule">
         <let name="start" value="128768"/>
         <let name="end" value="128895"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="AlchemicalSymbols_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Alchemical Symbols' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="GeometricShapesExtended">
      <rule context="/*" id="GeometricShapesExtended_rule">
         <let name="start" value="128896"/>
         <let name="end" value="129023"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="GeometricShapesExtended_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Geometric Shapes Extended' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="SupplementalArrows-C">
      <rule context="/*" id="SupplementalArrows-C_rule">
         <let name="start" value="129024"/>
         <let name="end" value="129279"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="SupplementalArrows-C_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Supplemental Arrows-C' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="SupplementalSymbolsandPictographs">
      <rule context="/*" id="SupplementalSymbolsandPictographs_rule">
         <let name="start" value="129280"/>
         <let name="end" value="129535"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="SupplementalSymbolsandPictographs_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Supplemental Symbols and Pictographs' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="ChessSymbols">
      <rule context="/*" id="ChessSymbols_rule">
         <let name="start" value="129536"/>
         <let name="end" value="129647"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="ChessSymbols_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Chess Symbols' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="SymbolsandPictographsExtended-A">
      <rule context="/*" id="SymbolsandPictographsExtended-A_rule">
         <let name="start" value="129648"/>
         <let name="end" value="129791"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="SymbolsandPictographsExtended-A_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Symbols and Pictographs Extended-A' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="SymbolsforLegacyComputing">
      <rule context="/*" id="SymbolsforLegacyComputing_rule">
         <let name="start" value="129792"/>
         <let name="end" value="130047"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="SymbolsforLegacyComputing_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Symbols for Legacy Computing' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CJKUnifiedIdeographsExtensionB">
      <rule context="/*" id="CJKUnifiedIdeographsExtensionB_rule">
         <let name="start" value="131072"/>
         <let name="end" value="173791"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CJKUnifiedIdeographsExtensionB_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'CJK Unified Ideographs Extension B' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CJKUnifiedIdeographsExtensionC">
      <rule context="/*" id="CJKUnifiedIdeographsExtensionC_rule">
         <let name="start" value="173824"/>
         <let name="end" value="177983"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CJKUnifiedIdeographsExtensionC_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'CJK Unified Ideographs Extension C' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CJKUnifiedIdeographsExtensionD">
      <rule context="/*" id="CJKUnifiedIdeographsExtensionD_rule">
         <let name="start" value="177984"/>
         <let name="end" value="178207"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CJKUnifiedIdeographsExtensionD_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'CJK Unified Ideographs Extension D' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CJKUnifiedIdeographsExtensionE">
      <rule context="/*" id="CJKUnifiedIdeographsExtensionE_rule">
         <let name="start" value="178208"/>
         <let name="end" value="183983"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CJKUnifiedIdeographsExtensionE_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'CJK Unified Ideographs Extension E' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CJKUnifiedIdeographsExtensionF">
      <rule context="/*" id="CJKUnifiedIdeographsExtensionF_rule">
         <let name="start" value="183984"/>
         <let name="end" value="191471"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CJKUnifiedIdeographsExtensionF_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'CJK Unified Ideographs Extension F' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CJKCompatibilityIdeographsSupplement">
      <rule context="/*" id="CJKCompatibilityIdeographsSupplement_rule">
         <let name="start" value="194560"/>
         <let name="end" value="195103"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CJKCompatibilityIdeographsSupplement_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'CJK Compatibility Ideographs Supplement' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CJKUnifiedIdeographsExtensionG">
      <rule context="/*" id="CJKUnifiedIdeographsExtensionG_rule">
         <let name="start" value="196608"/>
         <let name="end" value="201551"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CJKUnifiedIdeographsExtensionG_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'CJK Unified Ideographs Extension G' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="CJKUnifiedIdeographsExtensionH">
      <rule context="/*" id="CJKUnifiedIdeographsExtensionH_rule">
         <let name="start" value="201552"/>
         <let name="end" value="205743"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="CJKUnifiedIdeographsExtensionH_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'CJK Unified Ideographs Extension H' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="Tags">
      <rule context="/*" id="Tags_rule">
         <let name="start" value="917504"/>
         <let name="end" value="917631"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="Tags_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Tags' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="VariationSelectorsSupplement">
      <rule context="/*" id="VariationSelectorsSupplement_rule">
         <let name="start" value="917760"/>
         <let name="end" value="917999"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="VariationSelectorsSupplement_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Variation Selectors Supplement' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="SupplementaryPrivateUseArea-A">
      <rule context="/*" id="SupplementaryPrivateUseArea-A_rule">
         <let name="start" value="983040"/>
         <let name="end" value="1048575"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="SupplementaryPrivateUseArea-A_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Supplementary Private Use Area-A' which are not permitted.
            </report>
      </rule>
   </pattern>
   <pattern id="SupplementaryPrivateUseArea-B">
      <rule context="/*" id="SupplementaryPrivateUseArea-B_rule">
         <let name="start" value="1048576"/>
         <let name="end" value="1114111"/>
         <let name="uni-chars" value="isosts:uni-chars(descendant::text())"/>
         <report id="SupplementaryPrivateUseArea-B_report"
                 test="some $u in $uni-chars satisfies $start &lt;= $u and $u &lt;= $end">
              This Document contains chars of the unicode-block 'Supplementary Private Use Area-B' which are not permitted.
            </report>
      </rule>
   </pattern>
</schema>
