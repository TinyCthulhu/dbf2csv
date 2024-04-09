(******************************************************************
  File:       App.PathUtils.pas
  Function:   Path validation and manipulation
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


unit App.PathUtils;

interface

type
  TPathValidation = (pvFile, pvDir, pvNewFile, pvDirOnly);

function GetFilePathInfo(const FullFileName: String; var FileName, FileExt, FilePath: String): boolean;

function GetAppPath: String;

function ValidatePath(const Path: String; PathValidation: TPathValidation): boolean;

procedure NormalizePath(const Path: String; var FilePath, Root: String);

function RenamePath(const OldName, NewExtension: String; const NewDir: string = ''): String;

implementation

uses System.SysUtils;

function GetAppPath: String;
begin
  result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
end;

function GetFilePathInfo(const FullFileName: String; var FileName, FileExt, FilePath: String): boolean;
begin
  result := FileExists(FullFileName);

  FilePath := IncludeTrailingPathDelimiter(ExtractFilePath(FullFileName));
  FileExt  := ExtractFileExt(FullFileName);
  FileName := ChangeFileExt(ExtractFileName(FullFileName), '');
end;

function ForcePath(const S: string): Boolean;
var
  path: String;
begin
  result := true;

  try
    path := ExtractFilePath(S);
    if not DirectoryExists(path) then
      ForceDirectories(path);
  except
    result := false;
  end;
end;

function ValidatePath(const Path: String; PathValidation: TPathValidation): boolean;
var
  FileName, FileExt, FilePath: String;

begin
  case PathValidation of

    // existing file
    pvFile: result := FileExists(Path);

    // existing directory or empty
    pvDir:
      begin
        if trim(Path)<>'' then
        begin
          GetFilePathInfo(Path, FileName, FileExt, FilePath);
          result := (DirectoryExists(FilePath)
                    and (trim(FileName)='')
                    and (trim(FileExt)=''));
        end
          else result := true;
      end;

    // existing directory
    pvDirOnly:
      begin
        if trim(Path)<>'' then
        begin
          GetFilePathInfo(Path, FileName, FileExt, FilePath);
          result := DirectoryExists(FilePath);
        end
          else result := false;
      end;

    // valid (or so) path to a file or empty
    pvNewFile:
      begin
        if trim(Path)<>'' then
        begin
          GetFilePathInfo(Path, FileName, FileExt, FilePath);
          result := (DirectoryExists(FilePath)
                    and (trim(FileName)<>''))
        end
          else result := true;
      end;

    else
      result := false;
  end;
end;

procedure NormalizePath(const Path: String; var FilePath, Root: String);
var
  FileName: String;
begin
  Root := IncludeTrailingPathDelimiter(ExtractFilePath(Path));
  if trim(Root) = '\' then Root := GetAppPath;

  FileName := ExtractFileName(Path);
  FilePath := Root+FileName;
end;

function RenamePath(const OldName, NewExtension: String; const NewDir: String = ''): String;
var
  FileName, FileExt, FilePath: String;
begin
  GetFilePathInfo(OldName, FileName, FileExt, FilePath);

  if NewDir = '\' then FilePath := GetAppPath else
    if NewDir <> '' then FilePath := NewDir;

  result := FilePath+FileName+NewExtension;
end;

end.
