<?xml version="1.0" encoding="UTF-8"?>
<schema queryBinding="xslt2"
  xmlns:sc="http://transpect.io/schematron-config"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  xmlns="http://purl.oclc.org/dsdl/schematron"
  xml:lang="de">
  <pattern id="id_empty_pattern">
    <rule id="id_empty_rule" context="adoption">
      <report role="error" test="true()">This should never fire</report>
    </rule>
  </pattern>
</schema>