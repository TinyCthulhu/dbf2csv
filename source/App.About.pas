(******************************************************************
  File:       App.About.pas
  Function:   About 
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

unit App.About;

interface

procedure ShowAppHeader;

procedure ShowHelp;

procedure ShowLongHelp;

implementation

uses App.Strings, ConsoleCommands, System.SysUtils, Velthuis.Console,
  System.Classes, System.Types;

function GetResourceText(const ResName: String): String;
var
  ResStream: TResourceStream;
  HelpLines: TStringList;
begin
  result := '';
  HelpLines := nil;
  ResStream := nil;
  try
    ResStream := TResourceStream.Create(hInstance, ResName, RT_RCDATA);
    HelpLines := TStringList.Create;
    HelpLines.LoadFromStream(ResStream);

    result := HelpLines.Text;
  finally
    ResStream.Free;
    HelpLines.Free;
  end;
end;

procedure ShowAppHeader;
begin
  TextColor(White);
  Title(Format('%s %s : %s',[AppName, AppVersion, AppCopy]));
  Writeln(AppUrl);
  Writeln;
  NormVideo;
end;

procedure ShowHelp;
begin
  Writeln(GetResourceText('RES_HELP'));
end;

procedure ShowLongHelp;
begin
  ShowHelp;
  Writeln(GetResourceText('RES_HELP2'));
end;

end.
