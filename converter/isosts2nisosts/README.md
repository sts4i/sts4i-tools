#ISOSTS to NISO-STS Converter

The XSLT transforms a valid ISOSTS to NISO-STS XML.

The script 
* converts the `iso-meta` to a `std-meta` section 
* does an identity transform for other metadata sections and the content structure.

This implies that using the converter with documents containing `nat-meta` or `reg-meta` elements 
will result in invalid NISO-STS documents. 

The resulting XML targets validity with [NISO-STS version 1.0](https://www.niso-sts.org/standard-html/v1-0/index.html) but does not generate a reference to a specific DTD or XSD.
