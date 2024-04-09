(******************************************************************
  File:       App.Strings.pas
  Function:   Resorcestring unit
  Author:     TinyCthulu
  Copyright:  (c) 2024 TinyCthulu
  Disclaimer: part of a project
              https://github.com/TinyCthulhu/dbf2csv
              consult project page for more details.

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.
*******************************************************************)

unit App.Strings;

interface

resourcestring
{$IFDEF WIN64}
  AppName = 'dbf2csv (x64)';
{$ELSE}
  AppName = 'dbf2csv';
{$ENDIF}
  AppVersion = '1.00';
  AppCopy = 'Copyright (c) 2024 TinyCthulu';
  AppUrl = 'https://github.com/TinyCthulhu/dbf2csv';
  HelpUnknownCommand = 'Unknown command. Type: "dbf2csv -help" for help.';
  HelpNoSource = '<source_name> not declared, type: "dbf2csv -help" for help.';
  HelpTooMany = 'Too many parameters. Type: "dbf2csv -help" for help.';
  ErrInvalidSource = 'Invalid parameter, file "%s" does not exist.';
  ErrInvalidSrcDir = 'Error in parameter <%s>, source directory is invalid.';
  ErrInvalidDest = 'Error in parameter <%s>, <destination_name> is invalid.';
  ErrNoFiles = 'No matching files.';
  InfoMultiple = '%d out of %d file(s) converted.';
  ErrConvertItself = 'Error: cannot convert itself.';
  ErrRecord = 'Error while reading record data.';
  ErrFileOpen = 'Source file open error, skipped.';
  ErrDestExists = 'Skipped, destination file exists.';
  Deleted = 'DELETED';
implementation

end.
