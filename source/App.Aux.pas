(******************************************************************
  File:       App.Aux.pas
  Function:   Auxiliary functions
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

unit App.Aux;

interface

uses dbf;

type
  TAux = class
    function EventTranslate(Dbf: TDbf; Src, Dest: PAnsiChar; ToOem: Boolean): Integer;
  end;

implementation

{ TAux }

function TAux.EventTranslate(Dbf: TDbf; Src, Dest: PAnsiChar;
  ToOem: Boolean): Integer;
begin
  //empty OnTranslate event handler
end;

end.
