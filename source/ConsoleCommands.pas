(**************************************************************
  File:       ConsoleCommands.pas
  Function:   Shortcut commands for Velthuis.Console unit
  Author:     Rudolph Velthuis
  Copyright:  Rudolph Velthuis, TinyCthulhu
  Disclaimer: Useful shortut commands edited from
              Rudolph Velthuis' ConsoleDemo
              from https://github.com/rvelthuis/Consoles
                            
**************************************************************)

unit ConsoleCommands;

interface

uses Velthuis.Console;

// prints underscored string
procedure Title(const S: String);

// prints text in new color, preserving old color
procedure WriteColor(const Text: string; Color: Byte; EOL: boolean = false);

implementation

procedure Title(const S: String);
begin
  Writeln(S);
  Writeln(StringOfChar('-', Length(S)));
end;

procedure WriteColor(const Text: string; Color: Byte; EOL: boolean = false);
var
  OldColor: Byte;
begin
  OldColor := TextColor;
  TextColor(Color);
  Write(Text);
  TextColor(OldColor);
  if EOL then WriteLn;
end;


end.
