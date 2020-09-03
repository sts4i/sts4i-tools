#ISOSTS to NISO-STS Converter

The XSLT transforms a valid NISO-STS to a ISOSTS XML.

The script 
* converts an existing `std-meta` to an `iso-meta` section, XML documents containing multiple `std-meta` will generate invalid XML
  and `std-meta` sections not originating from ISO will most likely generate an `iso-meta` with incorrect data  
* in the content body transforms `list/@list-type` from `dash` to `bullet`. 
  NISO-STS added a new list-type "dash" according to ISO and IEC coding guidelines which was not used within ISOSTS 
  produced by ISO.

The resulting XML targets validity with [ISOSTS version 1.1](https://www.iso.org/schema/isosts/v1.1/doc/index.html) but does not generate a reference to a specific DTD or XSD.  
