# sts4i-tools

STS4i = STS for interoperability

HTML renderer and Schematron rules for [NISO Z39.102-201X Standard Tag Suite (STS)](http://www.niso.org/workrooms/sts/) XML files.

Documentation, schemas, and other supporting material can be found at http://www.niso-sts.org/

There is also a mailing list for all things STS: http://mulberrytech.com/STS/NISO-STS-List.html

This repo provides the original [ISO HTML renderer](isosts2html/isosts2html_standalone.xsl), written in XSLT 2.0, and an [adaptation for NISO STS](nisosts2html/nisosts2html.xsl), also written in XSLT 2.0. Since there is no single canonical representation of standards content in NISO STS (nor is there such a thing for ISO STS), the implementation provided is merely a starting point onto which SDO-specific customizations can be built.

The ultimate aim of STS4i is to provide canonical representations in NISO STS though, and to provide Schematron rules for checking adherence to these canonical forms. Due to the fundamental choices that NISO STS provides – MathML 2 or 3, HTML or CALS tables, TBX or term-display terminology, to name a few – and due to the open-ended value space of many type attributes, NISO STS conformance will always be contingent on the choices that an SDO makes. We will, however, strive to provide a checking and rendering framework that will detect these choices and check/render appropriately.
