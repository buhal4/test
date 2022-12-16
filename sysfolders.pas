unit SysFolders;

interface

uses Windows, SysUtils, ShlObj;

function GetUserAppDataFolderPath : String;
function GetUserMyDocumentsFolderPath : String;
function GetUserFavoritesFolderPath : String;

function GetCommonAppDataFolderPath : String;

function GetWindowsFolerPath : String;
function GetTempFolderPath : String;

implementation

const
  {$EXTERNALSYM CSIDL_COMMON_APPDATA}
  CSIDL_COMMON_APPDATA = $0023;

function GetSpecialFolderPath(CSIDL : Integer) : String;
var
  Path : PChar;
begin
  Result := '';
  GetMem(Path,MAX_PATH);
  Try
    If Not SHGetSpecialFolderPath(0,Path,CSIDL,False) Then
      Raise Exception.Create('Shell function SHGetSpecialFolderPath fails.');
    Result := Trim(StrPas(Path));
    If Result = '' Then
      Raise Exception.Create('Shell function SHGetSpecialFolderPath return an empty string.');
    Result := IncludeTrailingPathDelimiter(Result);
  Finally
    FreeMem(Path,MAX_PATH);
  End;
end;

function GetTempFolderPath : String;
var
  Path : PChar;
begin
  Result := ExtractFilePath(ParamStr(0));
  GetMem(Path,MAX_PATH);
  Try
    If GetTempPath(MAX_PATH,Path) <> 0 Then
      Begin
        Result := Trim(StrPas(Path));
        Result := IncludeTrailingPathDelimiter(Result);
      End;
  Finally
    FreeMem(Path,MAX_PATH);
  End;
end;

function GetWindowsFolerPath : String;
var
  Path : PChar;
begin
  Result := ExtractFilePath(ParamStr(0));
  GetMem(Path,MAX_PATH);
  Try
    If GetWindowsDirectory(Path, MAX_PATH) <> 0 Then
      Begin
        Result := Trim(StrPas(Path));
        Result := IncludeTrailingPathDelimiter(Result);
      End;
  Finally
    FreeMem(Path,MAX_PATH);
  End;
end;

function GetUserAppDataFolderPath : String;
begin
  Result := GetSpecialFolderPath(CSIDL_APPDATA);
end;

function GetUserMyDocumentsFolderPath : String;
begin
  Result := GetSpecialFolderPath(CSIDL_PERSONAL);
end;

function GetUserFavoritesFolderPath : String;
begin
  Result := GetSpecialFolderPath(CSIDL_FAVORITES);
end;

function GetCommonAppDataFolderPath : String;
begin
  Result := GetSpecialFolderPath(CSIDL_COMMON_APPDATA);
end;

end.

