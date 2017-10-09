# STS Schematron Checks

## Legacy ISO Rules

ISOSTS_validation.sch

ISO’s checking rules library, as retrieved from
http://www.iso.org/schema/isosts/resources/schematron/ISOSTS_validation.sch
on 2017-10-09

## NISO STS Library

(Emerging) library of Schematron rules for NISO STS interoperability.

## Profiles

The plan is to assemble individual rules that the libraries provide to
Schematron “checking profiles,” where each profile corresponds to a
Schematron “phase.”

The first profile will be a baseline interoperability rule set that
will flag deprecated markup and try to reduce ambiguity that NISO STS
still permits. One example for such an ambiguity is where to put keys
to figures: In captions or immediately below `fig`? As `def-list` or
as tables? Should the `content-type` of such a list or table assume a
certain value, for example "key"? If a key table contains 4 columns,
should this be regarded as an indication that it is really a 2-column
table with a column break in the middle? Etc.