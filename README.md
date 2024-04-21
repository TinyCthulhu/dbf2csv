# dbf2csv 
This windows console application lets you convert dbf tables to character delimited files (.csv).

Application allows:
- single file convertions
- batch convertions (with use of wildcards *?)
- generation of .csv files using ascii, ansi or utf8 encoding
- reading records marked as deleted

## How to use
open console and type:

**dbf2csv** [\<commands>] <source_name> [<destination_name>] [\<commands>]
```
Commands:
  -help, -h : help
  -t  : disable character transliteration for text columns
  -o  : overwrite csv file if exists
  -r  : read records marked as deleted  
  -d# : change default (;) delimiter character in output csv file to new one (#)
  -ea : force ascii encoding for output file
  -eu : force utf8 encoding for output file
  -ee : force ansi encoding for output file
```

### Examples: 
  `dbf2csv Somefile.dbf`
  
  converts a single source file Somefile.dbf to Somefile.csv

  `dbf2csv c:\sourcedir\*.dbf`
  
  converts all dbf files from c:\sourcedir\ and places the resulting files in the same directory

  `dbf2csv c:\sourcedir\*.dbf d:\resultdir\ -o`
  
  converts all dbf files from c:\sourcedir\ and places the resulting files in d:\resultdir\ replacing existing files

  `dbf2csv -d, c:\sourcedir\Somefile.dbf d:\resultdir\Newfile.csv`
  
  converts file c:\sourcedir\Somefile.dbf and places the result as file d:\resultdir\Newfile.csv, using a `,` character as a column delimiter

### Remarks:
  - omiting \<destination_name> creates result file with same filename as source file and .csv extension
  - commands are allowed either at the beginning or end of the parameter string
  - disabling transliteration (-t) preserves original strings, paired with ascii encoding (-ea) usually helps with poorly (or exotically) encoded dbf files
  - recovery (-r) command adds new "deleted" column in the resulting files
  - data containing delimiter converts in to a quoted string

## Attribution
This software uses some code from R.Velthuis **`consoles`** project: https://github.com/rvelthuis/Consoles (marked by author as freeware)

and depends on **`tDBF component for Delphi and BCB`** https://sourceforge.net/projects/tdbf/ under GNU Library or Lesser General Public License version 2.0 (LGPLv2)

## Contribute
If you found a bug or you have a proposed enhacement you can fill an issue in issue tracker.

