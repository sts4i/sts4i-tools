<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
  <p:input port="source" primary="true"/>
  <p:output port="result" primary="true"/>
  <p:xslt>
    <p:input port="stylesheet">
      <p:document href="assemble-schematron.xsl"/>
    </p:input>
  </p:xslt>
</p:declare-step>