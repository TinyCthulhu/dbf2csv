program dbf2csv;

{$APPTYPE CONSOLE}

{$R *.res}

(******************************************************************
  File:       dbf2Csv.dpr
  Function:   project file
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

{$R *.dres}

uses
  System.SysUtils,
  Velthuis.Console in 'Velthuis.Console.pas',
  ConsoleCommands in 'ConsoleCommands.pas',
  Velthuis.AutoConsole in 'Velthuis.AutoConsole.pas',
  App.Strings in 'App.Strings.pas',
  App.About in 'App.About.pas',
  App.Main in 'App.Main.pas',
  App.PathUtils in 'App.PathUtils.pas',
  dbf in 'C:\Library\tDbf\src\dbf.pas',
  App.Aux in 'App.Aux.pas';

begin
  try
    Writeln(GO);
    Writeln;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
