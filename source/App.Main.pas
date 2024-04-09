(******************************************************************
  File:       App.Main.pas
  Function:   main loop
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

unit App.Main;

interface

// main loop
function GO: String;

implementation

uses System.SysUtils, System.Classes, App.About, App.Strings, App.PathUtils, dbf, Data.DB, App.Aux;

type
  TAppAction = (aaEmpty, aaUnknown, aaSingleFile, aaMultiple, aaHelp, aaNoSource, aaBadSwitch, aaTooMany);
  TFileEncoding = (feDefault, feAscii, feAnsi, feUtf);

var
  AppParams: record
    Transliterate: boolean;
    Overwrite: boolean;
    DeletedRecords: boolean;
    Source: String;
    Dest: String;
    Delimiter: String;
    FileEncoding: TFileEncoding;
  end;


function CheckParams: TAppAction;
var
  S: String;
  ParamId: Integer;

  function ParamSeparator(const Par: String): String;
  begin
    if Length(Par)<3
      then result := ';'
      else result := Par[3]
  end;

begin
  with AppParams do
  begin
    Transliterate := true;
    Overwrite := false;
    DeletedRecords := false;
    Source := '';
    Dest := '';
    Delimiter := ';';
    FileEncoding := feDefault;
  end;

  result := aaUnknown;

  if ParamCount = 0
    then result := aaEmpty
    else
      begin
        ParamId := 1;

        while ((ParamId <= ParamCount) and (result = aaUnknown)) do
        begin
          S := Trim(ParamStr(ParamId));

          if Length(S)>0 then
          begin

            // is it a command/switch ?
            if S[1]='-' then
            begin
              if ((UpperCase(S)='-HELP') or (UpperCase(S) = '-H')) then result := aaHelp else
                if UpperCase(S) = '-T' then AppParams.Transliterate := false else
                  if UpperCase(S) = '-O' then AppParams.Overwrite := true else
                    if UpperCase(S) = '-R' then AppParams.DeletedRecords := true else
                      if UpperCase(S) = '-EA' then AppParams.FileEncoding := feAscii else
                        if UpperCase(S) = '-EU' then AppParams.FileEncoding := feUtf else
                          if UpperCase(S) = '-EE' then AppParams.FileEncoding := feAnsi else
                            if Copy(UpperCase(S), 1, 2)='-D' then AppParams.Delimiter := ParamSeparator(S) else
                    result := aaBadSwitch;
            end else
              begin
                if AppParams.Source = '' then AppParams.Source := S else
                  if AppParams.Dest = '' then AppParams.Dest := S else
                    result := aaTooMany;
              end;
          end;
          inc(ParamId);
        end;

        // if Source contains wildcards assume miltiple file conversion
        // and auto naming of resultfiles, not validating mask at this stage
        if result = aaUnknown then
        begin
          if AppParams.Source='' then result := aaNoSource else
            if (Pos('*', AppParams.Source)>0) or (Pos('?', AppParams.Source)>0)
              then result := aaMultiple
              else result := aaSingleFile;
        end;
      end;
end;


function ConvertFile(const Source, Dest: String): boolean;
var
  DestName, FileName, FileExt, FilePath, S, line: String;
  TabDbf: TDBF;
  i: Integer;
  Aux: TAux;
  DestExists: boolean;
  SWriter: TStreamWriter;

begin
  // if dest is empty provide new DestName in same location as source
  DestName := trim(Dest);
  if DestName = '' then DestName := RenamePath(Source, '.csv');
  DestExists := ValidatePath(DestName, pvFile);

  Writeln(Source+' -> '+DestName); {info}

  // preliminary check
  result := true;
  if trim(Source) = DestName then
  begin
    result := false;
    Writeln(ErrConvertItself);
  end else
    if (not AppParams.Overwrite and DestExists) then
    begin
      result := false;
      Writeln(ErrDestExists);
    end;

  if result then
  begin
    GetFilePathInfo(Source, FileName, FileExt, FilePath);

    Aux := nil;
    TabDbf := nil;
    SWriter := nil;
    try
      Aux := TAux.Create;
      TabDbf := TDBF.Create(nil);
      TabDbf.FilePath := FilePath;
      TabDbf.TableName := FileName+FileExt;
      if AppParams.DeletedRecords
        then TabDbf.ShowDeleted := true;

      case AppParams.FileEncoding of
        feAscii:
          SWriter := TStreamWriter.Create(DestName, false, TEncoding.ASCII);

        feAnsi:
          SWriter := TStreamWriter.Create(DestName, false, TEncoding.ANSI);

        feUtf:
          SWriter := TStreamWriter.Create(DestName, false, TEncoding.UTF8);

        else
          SWriter := TStreamWriter.Create(DestName, false, TEncoding.Default);
      end;

      if not AppParams.Transliterate then
      begin
        TabDbf.OnTranslate := Aux.EventTranslate;
      end;

      try
        TabDbf.Open;
      except
        Writeln(ErrFileOpen);
        result := false;
      end;

      if TabDbf.Active then
      begin
        TabDbf.First;

        // build header
        line := '';
        if TabDbf.FieldCount > 0 then
        for I := 0 to TabDbf.FieldCount-1 do
        begin
          if line<>'' then line := line + AppParams.Delimiter;
          line := line + TabDbf.Fields[I].FieldName;
        end;
        if AppParams.DeletedRecords
          then line := line + AppParams.Delimiter + DELETED;
        SWriter.WriteLine(line);

        // iterate thru records, skip empty ones
        repeat
          line := '';
          try
            for I := 0 to TabDbf.FieldCount-1 do
            begin
              S := TabDbf.Fields[I].AsString;

              // if string contains delimiter use quotations
              if Pos(AppParams.Delimiter, S)>0 then
              begin
                S := Format('"%s"',[S]);
              end;

              if line<>'' then line := line + AppParams.Delimiter;
              line := line + S;
            end;
            if (AppParams.DeletedRecords and (line <> '')) then
            begin
              if TabDbf.IsDeleted
                then S := DELETED
                else S := '';
              line := line + AppParams.Delimiter + S;
            end;

            if line <> ''
              then SWriter.WriteLine(line);
          except
            Writeln(ErrRecord);
          end;

          TabDbf.Next;
        until TabDbf.eof;
      end;


      TabDbf.Close;
    finally
      TabDbf.Free;
      Aux.Free;
      SWriter.Free;
    end;
  end;

  // returns false if not successful
end;

function ConvertMultiple(const Source, Dest: String): Boolean;
var
  FileList: TStringList;
  SearchResult: TSearchRec;
  SearchPath, Root, SrcName, DestName: String;
  I, Success:  integer;
begin
  NormalizePath(Source, SearchPath, Root);

  Success := 0;
  FileList := nil;
  try
    FileList := TStringList.Create;
    if FindFirst(SearchPath, faArchive or faNormal, SearchResult) = 0 then
    begin
      repeat
        FileList.Add(Root+SearchResult.Name);
      until FindNext(SearchResult)<>0;
      FindClose(SearchResult);
    end;

    if (FileList.Count > 0) then
      for I := 0 to FileList.Count -1 do
      begin
        //if dest is not empty provide new DestName *.csv
        SrcName := FileList[I];
        DestName := trim(Dest);
        if DestName <> '' then DestName := RenamePath(SrcName, '.csv', DestName);
        if ConvertFile(SrcName, DestName) then Inc(Success);
      end;
  finally
    result := (FileList.Count > 0);
    if result then Writeln(Format(InfoMultiple,[Success, FileList.Count])); {info}
    FileList.Free;
  end;

  // returns false if no files found
end;

function GO: String;
begin
  ShowAppHeader;
  case CheckParams of
    aaEmpty: ShowHelp;
    aaHelp: ShowLongHelp;

    aaSingleFile:
      begin
        // checking source
        if not ValidatePath(AppParams.Source, pvFile)
          then result := Format(ErrInvalidSource, [AppParams.Source]) else
          begin
            // checking dest
            if not ValidatePath(AppParams.Dest, pvNewFile)
              then result := Format(ErrInvalidDest, [AppParams.Dest]) else
              begin
                if not ConvertFile(AppParams.Source, AppParams.Dest)
                  then ExitCode := 1; // exit code for single file conversion

              end;
          end;
      end;

    aaMultiple:
      begin
        // check validity of source path directory only
        if not ValidatePath(AppParams.Source, pvDirOnly)
          then result := Format(ErrInvalidSrcDir, [AppParams.Source]) else
          begin
            // check validity of dest path
            if not ValidatePath(AppParams.Dest, pvDir)
            then result := Format(ErrInvalidDest, [AppParams.Dest]) else
            begin
              if not ConvertMultiple(AppParams.Source, AppParams.Dest)
                then result := ErrNoFiles;
            end;
          end;
      end;

    aaTooMany: result := HelpTooMany;
    aaNoSource: result := HelpNoSource;
    aaBadSwitch: result := HelpUnknownCommand;

    else
      result := HelpUnknownCommand;
  end;
end;

end.
