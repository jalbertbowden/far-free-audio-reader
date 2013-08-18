unit VPAExt;

interface

uses Windows,Classes,StdCtrls,SysUtils,ComCtrls,Forms,
     Controls,Registry,DateUtils,Menus;

const CR = #13;
      CRLF = #13#10;
      TAB = #9;
      ESC = #27;
      c_BadFileChars = '\/:;*?"<>|';
      c_Debug = 'c:\temp\DebugStr.txt';

type TObjStr = class
       s : string;
       constructor Create(Str : string); overload;
     end;

     TObjFile = class
       SRec : TSearchRec;
       constructor Create(sr : TSearchRec); overload;
     end;

     TFileStrings = class(TStringList)
     public
       Dir,Spec : string;
       NoObj,SubDirs : boolean;
       procedure GetDirList;
       procedure GetRecursedList;
       procedure StripPaths(bStripExt : boolean);
       constructor Create(sDir,sSpec : string; bNoObj,bSubDirs : boolean); overload;
       destructor Destroy; override;
     private
     end;

type TMicroDB = class
       DBFile : string;
       Fields : TStringList; // as kv pairs: name,len
       Recs : TStringList;
       constructor Create(sFile : string); overload;
       destructor Destroy; override;
       procedure Load;
       procedure Pop(Vals : TStrings);
       procedure Save;
       function Val(Fld : string) : string;
       function EOF : boolean;
       procedure Next;
       function Dump : string;
     private
       RecIdx : integer;
     end;

var HDir : string;
    dtUpTime : TDateTime;

// type TReplaceFlags = set of (rfReplaceAll,rfIgnoreCase);
// s := StringReplace(s,ReplaceMe,WithMe,[rfReplaceAll,rfIgnoreCase]);
// function StringReplace(const S,OldStr,NewStr: string; Flags: TReplaceFlags): string;
function ReplaceStr(s,old,new : string) : string;
function ReplaceChar(s : string; old,new : char) : string;
procedure QuickSort(var A : array of Integer; iLo,iHi : Integer);
function SLZ(sNum : string) : string;
function IsNumeric(sNum : string) : boolean;
function StrToInt2(s : string) : int64;
function Uptime : string;
function GetFileSize(FileName : string) : comp;
function GetFileDate(sFile : string) : integer;
function GetFileDT(sFile : string) : TDateTime;
function SetFileDate(f : string; dt: TDateTime): string;
function PadR(s : string; n : word) : string;
function PadL(s : string; n : word) : string;
function ZeroPad(s : string; n : word) : string;
function CommaStr(cs : string) : string;
function Rep(n : integer; c : char) : string;
function SafeName(sName : string) : string;
function SerFile(sFile : string) : string;
function SerExt(sFileNoExt : string) : string;
function NewExt(sFile,sExt : string) : string;
function NewPreExt(sFile,sPre,sExt : string) : string;
procedure WinExec(sEXE,sFile : string);
procedure ExecParms(sEXE,sParms : string);
function WinExecAndWait32(App : TApplication; Execute,Params : string; Visibility : integer) : longword;
procedure DosExec(Cmd : string);
procedure SendEmail(Recip,Subject,Body : string);
function UniqueID : string;
function NiceID(TimeStampID : string) : string;
function UnNiceID(sNiceID : string) : string;
function UnformatNum(sNum : string) : string;
function Delimited(sFile : string) : integer;
function HeaderStr(sFile : string) : string;
function Reformat_DOS(sFile : string; GoodLen : integer) : boolean;
function DelDir(sDir : string): boolean;
procedure DelSpec(sSpec : string);
procedure UpdateStr(var s : string; sValue : string; nPos,nValLen,nTotStrLen : integer);
function AgedAR(dt : TDateTime) : integer;
function Strip(s,StripChars : string) : string;
function CharCount(s,ss : string) : integer;
function GetWord(Words : string; Index : integer) : string;
function GetInnerText(sStr,sLeftDelim,sRightDelim : string) : string;
procedure RunAssoc(sFile : string);
function IsAlpha(s : string; DashOk : boolean = false) : boolean;
function ValidSSN(sSSN : string) : boolean;
function ReadTabField(sLine : string; FieldNum : byte): string;
function PrettyMS(MilliSecs : comp) : string;
function YN(sYN : string) : boolean; overload;
function YN(b : boolean) : string; overload;
procedure Associate(cMyExt,cMyFileType,cMyDescription,ExeName : string; IcoIndex: integer; DoUpdate: boolean = true);
procedure UnAssociate(cExt,cFileType : string);
function FinalBS(sPath : string) : string;
function NoFinalBS(sPath : string) : string;
function FinalDir(sPath : string) : string;
function DirectoryEmpty(const Dir : string) : boolean;
function StripVol(sFile : string) : string;
function StrToReal(sNum : string) : extended;
function XMLStr(s : string) : string;
function UnXMLStr(s : string) : string;
function URLStr(s : string) : string;
function StripTags(s : string) : string;
function Confirm(App,Prompt : string) : boolean;
function CopyFile(FileFrom,FileTo : string) : boolean;
function StrToSecs(s : string) : longword;
function SecsToStr(n : longword) : string;
procedure DebugStr(s : string);
function AddFileText(sFile,s : string) : boolean;
function DelFileText(sFile,sLine : string; bExact : boolean) : boolean;
function StrUntil(s,ss : string) : string;
function StrAfter(s,ss : string) : string;
function InStrSet(s,sset : string) : boolean;
function InRange(n,lo,hi : comp) : boolean;
function HTMLStr(s : string) : string;
function DelEnd(s,EndingWith : string) : string;
function DateStr(dt : TDateTime) : string;
function TimeStr(dt : TDateTime) : string;
function InnerTrim(s : string) : string;
function Jumble(s : string) : string;
function FatStr(s : string) : string;
function DietStr(s : string) : string;
function ProperCase(s : string) : string;
function GetElapsed(TimeStr : string) : cardinal;
procedure FreeObjStrs(sl : TStrings);
function FilesExist(Spec : string) : boolean;
function StripExt(s : string) : string;
function LastDir(sPathOrFile : string) : string;
function CharSet(s : string) : TSysCharSet;
function SetStr(ssets : string) : string;
procedure SaveApp(App : TApplication);
procedure LoadApp(App : TApplication);
procedure AddAppVar(App,k,v : string);
function GetAppVar(App,k : string) : string;
procedure SaveWinPos(frm : TForm; sFile : string);
procedure LoadWinPos(frm : TForm; sFile : string);
procedure CopyRTF(redFrom,redTo : TRichEdit);
procedure StrToRTF(sRTF : string; var red : TRichEdit; Append : boolean);
function StrToStream(s : string) : TStringStream;
function RTFToStr(red : TRichEdit) : string;
procedure AppendRed(const src,trg : TRichEdit);
function RTFToStream(red : TRichEdit) : TMemoryStream;
function MSToStr(ms : TMemoryStream) : string;
function GetVersion(EXE : string) : string;
function NoQuotes(s : string; Mode : integer) : string;
function GetWindowsDir : string;
function FileStr(sFile : string) : string;
procedure GetURL(sFile,sURL : string);
function CloseFormClass(FormClass : string) : boolean;
function GetDataPath : string;
function GetDirectory(Title : string) : string;
function GotNet : boolean;
function GetCurrentUserName : string;
function KeyOf(kvstr : string) : string;
function ValOf(kvstr : string) : string;
function FileSpec(s : string) : boolean;
function FileSizeText(nBytes : comp) : string;
procedure StrToBuff(s : string; var aBuff : array of char);
function Recycle(sFile : string) : boolean;
function GetCPLList : TStringList;
procedure RunCPL(sFile,sName : string);
function InParams(sParam : string) : boolean;
procedure slAdd(sl : TStringList; k,v : string);
procedure DelEmpty(sRoot : string);
procedure MkDirs(sRoot : string);
procedure SetRegistryData(RootKey: HKEY; Key,Value : string; RegDataType: TRegDataType; Data: variant);
procedure SetWallpaper(const Filename : TFilename; Tiled: boolean);
procedure AddHist(cmb : TComboBox; s : string);
procedure PopCombo(cmb : TComboBox; Name,Data : string);
procedure SetCombo(cmb : TComboBox; Data : string);
function ComboData(cmb : TComboBox) : string;
function ListBoxData(lst : TListBox) : string;
function DelimitedList(List,Delim : string) : TStringList;
function FreeSpace(DrvLetter : char; var nFree,nSize : int64) : boolean;

implementation

{$WARN SYMBOL_PLATFORM OFF}

uses ShellAPI,StrUtils,IdSync,
     ExtActns,ShlObj,Dialogs,RichEdit,Messages,
     SHFolder;

constructor TObjStr.Create(Str : string);
begin
  inherited Create;
  s := Str;
end;

constructor TObjFile.Create(sr : TSearchRec);
begin
  inherited Create;
  with sr do SRec := sr;
end;

constructor TFileStrings.Create(sDir,sSpec : string; bNoObj,bSubDirs : boolean);
begin
  inherited Create;
  Dir := sDir;
  Spec := sSpec;
  NoObj := bNoObj;
  SubDirs := bSubDirs;

  if bSubDirs then
    GetRecursedList
  else
    GetDirList;
end;

destructor TFileStrings.Destroy;

var n : integer;

begin
  if not NoObj then
    for n := 0 to Count - 1 do
      TObjFile(Objects[n]).Free;

  inherited;
end;

procedure TFileStrings.GetDirList;

var n : integer;
    sr : TSearchRec;

begin
  if copy(Dir,length(Dir),1) <> '\' then
    Dir := Dir + '\';

  if copy(Dir,length(Dir) - 1,2) = '\\' then
    Dir := copy(Dir,1,length(Dir) - 1);

  n := FindFirst(Dir + Spec,faArchive,sr);

  while n = 0 do
  begin
    if NoObj then
      Self.Add(Dir + sr.Name)
    else
      Self.AddObject(Dir + sr.Name,TObjFile.Create(sr));

    n := FindNext(sr);
  end;

  SysUtils.FindClose(sr);
end;

{$I-}
procedure TFileStrings.GetRecursedList;

procedure DoProcess(DirName : string);

var sr : TSearchRec;
    f : integer;
    s : string;

begin
  if DirectoryExists(DirName) then
    ChDir(DirName)
  else
    exit;

  f := FindFirst('*.*',faDirectory,sr);

  while f = 0 do
  begin
    if (sr.name <> '.') AND (sr.name <> '..') AND
      ((sr.attr AND faDirectory) <> 0) then
    begin
      if DirName[length(DirName)] = '\' then
        DoProcess(DirName + sr.Name)
      else
        DoProcess(DirName + '\' + sr.Name);

      ChDir(DirName);
    end;

    f := FindNext(sr);
  end;

  SysUtils.FindClose(sr);
  f := FindFirst(Spec,faArchive,sr);

  while f = 0 do
  begin
    if (sr.name <> '.') AND (sr.name <> '..') then
    begin
      if DirName[length(DirName)] = '\' then
        s := DirName + sr.Name
      else
        s := DirName + '\' + sr.Name;

      if NoObj then
        Add(s)
      else
        AddObject(s,TObjFile.Create(sr));
    end;

    f := FindNext(sr);
  end;

  SysUtils.FindClose(sr);
end;

begin // TFileStrings.GetRecursedList
  Clear;
  DoProcess(Dir);
end;

procedure TFileStrings.StripPaths(bStripExt : boolean);

var n : integer;

begin
  for n := 0 to Count - 1 do
  begin
    Self[n] := ExtractFileName(Self[n]);

    if bStripExt then
      Self[n] := StripExt(Self[n]);
  end;
end;

constructor TMicroDB.Create(sFile : string);
begin
  inherited Create;
  RecIdx := -1;
  DBFile := sFile;
  Fields := TStringList.Create;
  Fields.CaseSensitive := false;
  Fields.Duplicates := dupIgnore;
  Recs := TStringList.Create;
  Recs.CaseSensitive := false;
  Recs.Duplicates := dupAccept;
  if FileExists(DBFile) then Load;
end;

destructor TMicroDB.Destroy;
begin
  Fields.Free;
  Recs.Free;
  inherited;
end;

procedure TMicroDB.Load;

var n : integer;

begin
  Recs.LoadFromFile(DBFile);

  for n := 0 to Recs.Count - 1 do
  begin
    if Recs[n] = '.' then break;
    Fields.Add(Recs[n]);
  end;

  while Recs.IndexOf('.') <> -1 do
    Recs.Delete(0);

  if Recs.Count > 0 then RecIdx := 0;
end;

procedure TMicroDB.Pop(Vals : TStrings);

var n,l : integer;

begin
  Recs[RecIdx] := '';

  for n := 0 to Vals.Count - 1 do
  begin
    l := StrToInt2(Fields.Values[Vals[n]]);
    Recs[RecIdx] := Recs[RecIdx] + PadR(Vals[n],l);
  end;
end;

function TMicroDB.Val(Fld : string) : string;
begin
  Result := Fields.Names[Fields.IndexOfName(Fld)];
end;

function TMicroDB.EOF : boolean;
begin
  Result := RecIdx <> -1;
end;

procedure TMicroDB.Next;
begin
  if RecIdx >= Recs.Count - 1 then
    RecIdx := -1
  else
    inc(RecIdx);
end;

procedure TMicroDB.Save;

var n : integer;

begin
  Recs.Insert(0,'.');

  for n := Fields.Count - 1 downto 0 do
    Recs.Insert(0,'_fld_' + Fields[n]);

  Recs.SaveToFile(DBFile);
end;

function TMicroDB.Dump : string;
begin
  Result := Recs.Text;
end;

procedure QuickSort(var A : array of Integer; iLo,iHi : Integer);

var Lo,Hi,Pivot,T : integer;

begin
  Lo := iLo; Hi := iHi;
  Pivot := A[(Lo + Hi) div 2];

  repeat
    while A[Lo] < Pivot do Inc(Lo);
    while A[Hi] > Pivot do Dec(Hi);

    if Lo <= Hi then
    begin
      T := A[Lo];
      A[Lo] := A[Hi];
      A[Hi] := T;
      Inc(Lo);
      Dec(Hi);
    end;
  until Lo > Hi;

  if Hi > iLo then QuickSort(A,iLo,Hi);
  if Lo < iHi then QuickSort(A,Lo,iHi);
end;

function SLZ(sNum : string) : string;

var bNeg : boolean;

begin
  bNeg := pos('-',sNum) > 0;

  while (length(sNum) > 0) and (not CharInSet(sNum[1],CharSet('123456789.'))) do
    system.delete(sNum,1,1);

  if sNum = '' then
    Result := '0'
  else if bNeg then
    Result := '-' + sNum
  else
    Result := sNum;
end;

function IsNumeric(sNum : string) : boolean;

var n : integer;

begin
  Result := true;

  for n := 1 to length(sNum) do
    if not CharInSet(sNum[n],CharSet(
     '0123456789.-+')) then
      Result := false;
end;

function StrToInt2(s : string) : int64;

var e : integer;

begin
  if pos('.',s) > 0 then
    s := copy(s,1,pos('.',s) - 1);

  s := UnformatNum(s);
  val(s,Result,e);
  if e <> 0 then Result := 0;
end;

function Uptime : string;

var nElapsedSecs : integer;

begin
  nElapsedSecs := Round((Now - dtUpTime) * 86400);

  Result :=
   ZeroPad(IntToStr(nElapsedSecs div 3600),2) + ':' +
   ZeroPad(IntToStr((nElapsedSecs mod 3600) div 60),2) + ':' +
   ZeroPad(IntToStr((nElapsedSecs mod 3600) mod 60),2);
end;

function GetFileSize(FileName : string) : comp;

var fs : TFileStream;

begin
  try
    fs := TFileStream.Create(Filename,fmShareCompat);

    try
      Result := fs.Size;
    finally
      fs.Free;
    end;
  except
    Result := -1;
  end;
end;

function GetFileDate(sFile : string) : integer;

var fh : integer;

begin
  try
    fh := FileOpen(sFile,fmOpenRead or fmShareDenyNone);

    if fh > 0 then
      Result := FileGetDate(fh)
    else
      Result := -1;

    FileClose(fh);
  except
    Result := -1;
  end;
end;

function GetFileDT(sFile : string) : TDateTime;
begin
  try
    Result := FileDateToDateTime(GetFileDate(sFile));
  except
    Result := -1;
  end;
end;

function PadR(s : string; n : word) : string;

var ts : string;

begin
  ts := s;
  if length(ts) > n then ts := copy(ts,1,n);
  while length(ts) < n do ts := ts + #32;
  Result := ts;
end;

function PadL(s : string; n : word) : string;

var ts : string;

begin
  ts := s;
  if length(ts) > n then ts := copy(ts,1,n);
  while length(ts) < n do ts := #32 + ts;
  Result := ts;
end;

function ZeroPad(s : string; n : word) : string;
begin
  Result := trim(s);
  while length(Result) < n do Result := '0' + Result;
end;

function CommaStr(cs : string) : string;

var s,sDec : string;
    x,y : byte;
    bNeg : boolean;

begin
  if pos('.',cs) <> 0 then
  begin
    sDec := copy(cs,pos('.',cs),9);
    s := trim(copy(cs,1,pos('.',cs) - 1));
  end
  else
  begin
    sDec := '';
    s := trim(cs);
  end;

  if s = '' then
  begin
    Result := '0';
    exit;
  end;

  if s[1] = '-' then
  begin
    delete(s,1,1);
    bNeg := true;
  end
  else bNeg := false;

  x := length(s);
  y := 0;

  while x > 1 do
  begin
    dec(x);
    inc(y);

    if y = 3 then
    begin
      y := 0;
      insert(',',s,x + 1);
    end;
  end;

  if bNeg then s := '-' + s;
  Result := s + sDec;
end;

function Rep(n : integer; c : char) : string;
begin
  Result := '';
  while length(Result) < n do Result := Result + c;
end;

function SerFile(sFile : string) : string;

var nHigh : word;
    sBase,sExt : string;

begin
  if not FileExists(sFile) then
  begin
    Result := sFile;
    exit;
  end;

  if pos('.',sFile) > 0 then
  begin
    sBase := copy(sFile,1,pos('.',sFile) - 1);
    sExt := copy(sFile,pos('.',sFile),length(sFile));
  end
  else
  begin
    sBase := sFile;
    sExt := '.unk';
  end;

  nHigh := 2;

  repeat
    Result := sBase + IntToStr(nHigh) + sExt;
    inc(nHigh);
  until not FileExists(Result);
end;

function SafeName(sName : string) : string;

var n : integer;

begin
  Result := '';

  for n := 1 to length(sName) do
  begin
    if pos(copy(sName,n,1),c_BadFileChars) = 0 then
      Result := Result + sName[n];
  end;
end;

function NewExt(sFile,sExt : string) : string;
begin
  Result := ChangeFileExt(sFile,sExt);
end;

function NewPreExt(sFile,sPre,sExt : string) : string;

var n : integer;
    bExt : boolean;

begin
  bExt := false;

  for n := length(sFile) downto 1 do
  begin
    if sFile[n] = '.' then
    begin
      Result := copy(sFile,1,n - 1) + sPre + '.' + sExt;
      bExt := true;
      break;
    end;
  end;

  if not bExt then Result := sFile + sPre + '.' + sExt;
end;

// can pass dir or url as sEXE
procedure WinExec(sEXE,sFile : string);
begin
  if sFile = '' then
    ShellExecute(0,'open',pchar(sEXE),nil,nil,SW_SHOWNORMAL)
  else
    ShellExecute(0,'open',pchar(sEXE),pchar(sFile),nil,SW_SHOWNORMAL);
end;

procedure ExecParms(sEXE,sParms : string);

var pf : string;

begin
  pf := ExtractFilePath(sEXE) + StripExt(ExtractFilename(sEXE)) + '.prm';
  DeleteFile(pchar(pf));
  AddFileText(pf,sParms);
  ShellExecute(0,'open',pchar(sEXE),nil,nil,SW_SHOWNORMAL);
end;

procedure SendEmail(Recip,Subject,Body : string);

var em_mail : string;

begin
  em_mail := 'mailto:' + Recip + '?subject=' +
   Subject + '&body=' + Body;

  ShellExecute(0,'open',PChar(em_mail),nil,nil,SW_SHOWNORMAL);
end;

function WinExecAndWait32(App : TApplication; Execute,Params : string; Visibility : integer) : longword;

var SEInfo : TShellExecuteInfo;

begin
  Result := MaxInt;
  FillChar(SEInfo,SizeOf(SEInfo),0);
  SEInfo.cbSize := SizeOf(TShellExecuteInfo);

  with SEInfo do begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    nShow := Visibility;
    Wnd := Application.Handle;
    lpFile := PChar(Execute);
    lpParameters := PChar(Params);
    { WrkDir = working directory, def = curr
    lpDirectory := PChar(WrkDir);}
  end;

  if ShellExecuteEx(@SEInfo) then
  begin
    repeat
      App.ProcessMessages;
      GetExitCodeProcess(SEInfo.hProcess,Result);
    until (Result <> STILL_ACTIVE) or (App.Terminated);
  end;
end;

function DelDir(sDir : string): boolean;

var fos : TSHFileOpStruct;

begin
  ZeroMemory(@fos,SizeOf(fos));

  with fos do
  begin
    wFunc := FO_DELETE;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
    pFrom := PChar(sDir + #0);
  end;

  Result := (ShFileOperation(fos) = 0);
end;

function UniqueID : string;
begin
  Result := FormatDateTime('yyyymmddhhnnsszzz',Now);
end;

function NiceID(TimeStampID : string) : string;
begin
  Result :=
   copy(TimeStampID,1,4) + '-' +
   copy(TimeStampID,5,2) + '-' +
   copy(TimeStampID,7,2) + ' ' +
   copy(TimeStampID,9,2) + ':' +
   copy(TimeStampID,11,2) + ':' +
   copy(TimeStampID,13,2) + '.' +
   copy(TimeStampID,15,3);
end;

function UnNiceID(sNiceID : string) : string;
begin
  Result :=
   copy(sNiceID,1,4) +
   copy(sNiceID,6,2) +
   copy(sNiceID,9,2) +
   copy(sNiceID,12,2) +
   copy(sNiceID,15,2) +
   copy(sNiceID,18,2) +
   copy(sNiceID,21,3);
end;

function SerExt(sFileNoExt : string) : string;

var nHigh : word;

begin
  nHIgh := 0;

  repeat
    inc(nHigh);
    Result := sFileNoExt + '.' + ZeroPad(IntToStr(nHigh),3);
  until not FileExists(Result);
end;

function UnformatNum(sNum : string) : string;

var n : integer;
    bNeg : boolean;

begin
  Result := '';
  bNeg := false;

  for n := 1 to length(sNum) do
  begin
    if CharInSet(sNum[n],CharSet('0123456789.')) then
      Result := Result + sNum[n];

    if sNum[n] = '-' then bNeg := true;
  end;

  while (length(Result) > 0) and (Result[1] = '0') do system.delete(Result,1,1);
  if Result = '' then Result := '0';
  if bNeg then Result := '-' + Result;
  if Result = '.00' then Result := '0.00';
end;

function Delimited(sFile : string) : integer;

var cPrior : char;
    buffer : array[0..2047] of char;
    n,nFileHandle,nReadIn : integer;

begin
  nFileHandle := FileOpen(sFile,fmOpenRead);
  Result := nFileHandle;
  if nFileHandle = -1 then exit;
  FileSeek(nFileHandle,0,0);
  nReadIn := FileRead(nFileHandle,Buffer,2047);
  FileClose(nFileHandle);
  cPrior := #0;

  for n := 1 to nReadIn do
  begin
    if (Buffer[n] = #10) and (cPrior = #13) then
    begin
      Result := n;
      exit;
    end
    else cPrior := Buffer[n];
  end;

  Result := 0;
end;

function HeaderStr(sFile : string) : string;

var b : array[0..47] of char;
    f : integer;

begin
  Result := '';
  f := FileOpen(sFile,fmOpenRead);
  if f = -1 then exit;

  try
    FileSeek(f,0,0);
    FileRead(f,b,47);
  finally
    FileClose(f);
  end;

  Result := b;
end;

function Reformat_DOS(sFile : string; GoodLen : integer) : boolean;

var s : string;
    buffer : array[0..2047] of char;
    nFileHandle : Integer;
    n,nReadIn : Integer;
    bDone : boolean;
    sTmpFile : string;
    txtTmp : textfile;

begin
  Result := false;
  bDone := false;
  nFileHandle := FileOpen(sFile,fmOpenRead);
  if nFileHandle = -1 then exit;
  sTmpFile := NewExt(sFile,'tmp');
  AssignFile(txtTmp,sTmpFile);
  Rewrite(txtTmp);
  FileSeek(nFileHandle,0,0);
  s := '';

  while not bDone do
  begin
    nReadIn := FileRead(nFileHandle,Buffer,2047);

    for n := 0 to nReadIn do
    begin
      if (Buffer[n] < #32) and (Buffer[n] <> #9) then
      begin
        s := trim(s);

        if s <> '' then
        begin
          while length(s) < GoodLen do s := s + ' ';
          if length(s) > GoodLen then s := copy(s,1,GoodLen);
          writeln(txtTmp,s);
          s := '';
        end;
      end
      else s := s + Buffer[n];
    end;

    bDone := (nReadIn < 2047);
  end;

  if length(s) = GoodLen then writeln(txtTmp,s);
  FileClose(nFileHandle);
  CloseFile(txtTmp);
  RenameFile(sFile,NewExt(sFile,'old'));
  RenameFile(sTmpFile,sFile);
  Result := true;
end;

procedure DelSpec(sSpec : string);

var sr : TSearchRec;
    found : integer;

begin
  found := FindFirst(sSpec,faArchive,sr);

  while found = 0 do
  begin
    SysUtils.DeleteFile(ExtractFilePath(sSpec) + sr.name);
    found := FindNext(sr);
  end;

  sysutils.FindClose(sr);
end;

procedure UpdateStr(var s : string; sValue : string; nPos,nValLen,nTotStrLen : integer);
begin
  sValue := PadR(sValue,nValLen);

  s := PadR(copy(s,1,nPos - 1) + sValue +
   copy(s,nPos + nValLen,nTotStrLen),nTotStrLen);
end;

function AgedAR(dt : TDateTime) : integer;
begin
  Result := Trunc(Now - dt);
end;

function Strip(s,StripChars : string) : string;

var n : integer;

begin
  Result := '';

  for n := Length(s) downto 1 do
  begin
    if pos(s[n],StripChars) = 0 then
      Result := s[n] + Result;
  end;
end;

function CharCount(s,ss : string) : integer;

var n : integer;

begin
  Result := 0;

  for n := 1 to length(s) do
    if s[n] = ss then inc(Result);
end;

function GetWord(Words : string; Index : integer) : string;

var n,nWord : integer;
    sWord : string;
    bDone : boolean;

function Delim : boolean;
begin
  Result := CharInSet(Words[n],CharSet(' ,'));
end;

begin // GetWord
  Result := '';
  if Index = 0 then exit;
  Words := InnerTrim(Words);
  if Words = '' then exit;
  nWord := 0;
  sWord := '';
  bDone := false;
  if Index < 0 then n := Length(Words) else n := 1;

  while not bDone do
  begin
    if Index < 0 then
      bDone := (n = 1)
    else
      bDone := (n = Length(Words));

    if Delim then
    begin
      inc(nWord);

      if nWord <> abs(Index) then
        sWord := ''
      else
        break;
    end
    else
    begin
      if Index < 0 then
        sWord := Words[n] + sWord
      else
        sWord := sWord + Words[n];
    end;

    if Index < 0 then dec(n) else inc(n);
  end;

  if (nWord <> abs(Index)) and
   (sWord <> '') then
     inc(nWord);

  if nWord = abs(Index) then Result := sWord;
end;

function GetInnerText(sStr,sLeftDelim,sRightDelim : string) : string;

var n1,n2 : integer;

begin
  Result := '';
  n1 := pos(sLeftDelim,sStr);
  if n1 = 0 then exit;
  n2 := pos(sRightDelim,sStr);

  if n2 < n1 then
    Result := copy(sStr,n1 + 1,length(sStr))
  else
    Result := copy(sStr,n1 + 1, n2 - n1 - 1);
end;

procedure RunAssoc(sFile : string);

var sEXE,sPrm : string;

begin
{  if ExtractFileExt(sFile) = '.txt' then
    WinExec('notepad',sFile)
  else} if pos('.exe',lowercase(sFile)) > 0 then
  begin
    if pos('"',sFile) = 0 then
    begin
      sEXE := GetWord(sFile,1);
      sPrm := copy(sFile,Length(sEXE) + 2,Length(sFile));
      WinExec(sEXE,sPrm);
    end
    else
    begin
      sEXE := copy(sFile,2,Length(sFile));
      sEXE := '"' + copy(sEXE,1,pos('"',sEXE));
      sPrm := copy(sFile,Length(sEXE) + 1,Length(sFile));
      WinExec(sEXE,sPrm);
    end;
  end
  else ShellExecute(0,'open',pchar(sFile),nil,nil,SW_SHOWNORMAL);
end;

function IsAlpha(s : string; DashOk : boolean = false) : boolean;

var n : integer;
    ss : string;

begin
  Result := true;
  ss := ' ,A..Z,a..z';
  if DashOk then ss := '-,' + ss;

  for n := 1 to length(s) do
  begin
    if not CharInSet(s[n],CharSet(SetStr(ss))) then
    begin
      Result := false;
      break;
    end;
  end;
end;

(*
Illegal values include
000000000,111111111,333333333,123456789
Any SSN with first three digits in the range 800-999
or first three digits = 000
or first three digits = 666
*)
function ValidSSN(sSSN : string) : boolean;

const BadSSN = '000000000-111111111-333333333-123456789';

begin
  Result := false;
  if length(sSSN) <> 9 then exit;
  if pos(sSSN,BadSSN) <> 0 then exit;
  if StrToInt2(SLZ(sSSN)) = 0 then exit;
  if StrToInt2(copy(sSSN,1,3)) > 799 then exit;
  if StrToInt2(copy(sSSN,1,3)) = 0 then exit;
  if StrToInt2(copy(sSSN,1,3)) = 666 then exit;
  Result := true;
end;

function ReadTabField(sLine : string; FieldNum : byte): string;

var n,nTab : integer;

begin
  nTab := 0;
  Result := '';

  for n := 1 to Length(sLine) do
  begin
    if sLine[n] = #9 then
    begin
      inc(nTab);
      if nTab = FieldNum then exit;
      Result := '';
    end
    else Result := Result + sLine[n];
  end;
end;

function PrettyMS(MilliSecs : comp) : string;

var dt : TDateTime;

begin
  dt := MilliSecs / MSecsPerSec / SecsPerDay;
  Result := Format('%dD%s',[Trunc(dt),FormatDateTime('hh:nn:ss.z',Frac(dt))]);

  if copy(Result,1,2) = '0D' then
    Result := copy(Result,3,14);

  if pos('.',Result) > 0 then
    Result := copy(Result,1,pos('.',Result) - 1);

  if copy(Result,1,3) = '00:' then
    Result := copy(Result,4,5);

  if copy(Result,2,1) = ':' then
    Result := '0' + Result;
end;

function YN(sYN : string) : boolean;
begin
  Result := lowercase(sYN) = 'y';
end;

function YN(b : boolean) : string;
begin
  if b then Result := 'Y' else Result := 'N';
end;

// need win7 fix
procedure Associate(cMyExt,cMyFileType,cMyDescription,ExeName : string; IcoIndex: integer; DoUpdate: boolean = true);

var Reg : TRegistry;

begin
  try
    Reg := TRegistry.Create;

    try
      Reg.RootKey := HKEY_CLASSES_ROOT;
      Reg.OpenKey(cMyExt,true);
      Reg.WriteString('',cMyFileType);
      Reg.CloseKey;
      Reg.OpenKey(cMyFileType,True);
      Reg.WriteString('',cMyDescription);
      Reg.CloseKey;
      Reg.OpenKey(cMyFileType + '\DefaultIcon',true);
      Reg.WriteString('',ExeName + ',' + IntToStr(IcoIndex));
      Reg.CloseKey;
      Reg.OpenKey(cMyFileType + '\Shell\Open',true);
      Reg.WriteString('','&Open');
      Reg.CloseKey;
      Reg.OpenKey(cMyFileType + '\Shell\Open\Command',true);
      Reg.WriteString('','"' + ExeName + '" "%1"');
      Reg.CloseKey;

      if DoUpdate then
        SHChangeNotify(SHCNE_ASSOCCHANGED,SHCNF_IDLIST,nil,nil);
    finally
      Reg.Free;
    end;
  except
    Windows.MessageBox(0,pchar('Failed to associate ' + cMyExt + ' files.' ),nil,MB_OK);
  end;
end;

procedure UnAssociate(cExt,cFileType : string);

var Reg : TRegistry;

begin
  Reg := TRegistry.Create;

  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    Reg.DeleteKey(cExt);
    Reg.DeleteKey(cFileType);
    SHChangeNotify(SHCNE_ASSOCCHANGED,SHCNF_IDLIST,nil,nil);
  finally
    Reg.Free;
  end;
end;

function FinalBS(sPath : string) : string;
begin
  if copy(sPath,Length(sPath),1) <> '\' then
    Result := sPath + '\'
  else
    Result := sPath;
end;

function NoFinalBS(sPath : string) : string;
begin
  if copy(sPath,Length(sPath),1) = '\' then
    Result := copy(sPath,1,length(sPath) - 1)
  else
    Result := sPath;
end;

function DirectoryEmpty(const Dir : string) : boolean;

var sr : TSearchRec;

begin
  try
    Result := (FindFirst(Dir + '\*.*',
     faAnyFile,sr) = 0) AND
     (FindNext(sr) = 0) AND
     (FindNext(sr) <> 0);
  finally
    SysUtils.FindClose(sr);
  end;
end;

function StripVol(sFile : string) : string;
begin
  if pos(':',sFile) = 0 then
  begin
    Result := copy(copy(sFile,3,999),
     pos('\',copy(sFile,3,999)),254);

    Result := copy(copy(Result,2,999),
     pos('\',copy(Result,2,999)),254);
  end
  else Result := copy(sFile,3,254);
end;

function StrToReal(sNum : string) : extended;

var e : integer;
    n : extended;

begin
  try
    val(sNum,n,e);
  except
    n := 0;
  end;

  if e <> 0 then n := 0;
  Result := n;
end;

function XMLStr(s : string) : string;

var n : integer;

begin
  Result := '';

  for n := 1 to length(s) do
  begin
    if s[n] = '&' then
      Result := Result + '&amp;'
    else if s[n] = '<' then
      Result := Result + '&lt;'
    else if s[n] = '>' then
      Result := Result + '&gt;'
    else if s[n] = #39 then
      Result := Result + '&apos;'
    else if s[n] = '"' then
      Result := Result + '&quot;'
    else
      Result := Result + s[n];
  end;
end;

function UnXMLStr(s : string) : string;

var n : integer;

begin
  Result := s;

  while pos('&amp;',Result) > 0 do
  begin
    n := pos('&amp;',Result);
    system.Delete(Result,n + 1,4);
  end;

  while pos('&lt;',Result) > 0 do
  begin
    n := pos('&lt;',Result);
    Result[n] := '<';
    system.Delete(Result,n + 1,3);
  end;

  while pos('&gt;',Result) > 0 do
  begin
    n := pos('&gt;',Result);
    Result[n] := '>';
    system.Delete(Result,n + 1,3);
  end;

  while pos('&apos;',Result) > 0 do
  begin
    n := pos('&apos;',Result);
    Result[n] := #39;
    system.Delete(Result,n + 1,5);
  end;

  while pos('&#39;',Result) > 0 do
  begin
    n := pos('&#39;',Result);
    Result[n] := #39;
    system.Delete(Result,n + 1,4);
  end;

  while pos('&#34;',Result) > 0 do
  begin
    n := pos('&#34;',Result);
    Result[n] := #39;
    system.Delete(Result,n + 1,4);
  end;

  while pos('&#62;',Result) > 0 do
  begin
    n := pos('&#62;',Result);
    Result[n] := '>';
    system.Delete(Result,n + 1,4);
  end;

  while pos('&#60;',Result) > 0 do
  begin
    n := pos('&#60;',Result);
    Result[n] := '<';
    system.Delete(Result,n + 1,4);
  end;

  while pos('&quot;',Result) > 0 do
  begin
    n := pos('&quot;',Result);
    Result[n] := '"';
    system.Delete(Result,n + 1,5);
  end;

  while pos('&nbsp;',Result) > 0 do
    system.Delete(Result,pos('&nbsp;',Result),6);
end;

function URLStr(s : string) : string;

var n : integer;

begin
  Result := '';

  for n := 1 to length(s) do
  begin
    if s[n] = ' ' then
      Result := Result + '+'
    else
      Result := Result + s[n];
  end;
end;

function StripTags(s : string) : string;

var n     : integer;
    sKeep : string;
    bSkip : boolean;

begin
  sKeep := '';
  bSkip := false;

  for n := 1 to Length(s) do
  begin
    if s[n] = '<' then bSkip := true
    else if s[n] = '>' then bSkip := false
    else if not bSkip then sKeep := sKeep + s[n];
  end;

  Result := UnXMLStr(sKeep);
end;

function Confirm(App,Prompt : string) : boolean;
begin // MessageDlg not thread-safe
  Result := Windows.MessageBox(0,pchar(Prompt),
   pchar(App),MB_YESNO) = IDYES;
end;

{$I+}
function CopyFile(FileFrom,FileTo : string) : boolean;

var ToF,FromF : file;
    NumRead,NumWritten : integer;
    Buffer : array[1..2048] of byte;

begin
  Result := true;
  AssignFile(FromF,FileFrom);
  AssignFile(ToF,FileTo);

  try
    Reset(FromF,1);
    Rewrite(ToF,1);

    repeat
      BlockRead(FromF,Buffer,SizeOf(Buffer),NumRead);
      BlockWrite(ToF,Buffer,NumRead,NumWritten);
    until (NumRead = 0) or (NumWritten <> NumRead);
  except
    Result := false;
  end;

  try CloseFile(FromF); except end;
  CloseFile(ToF);
end;

function StrToSecs(s : string) : longword;

var sSecs,sMins,sHours : string;

begin
  Result := 0;
  if trim(s) = '' then exit;
  sSecs := copy(s,Length(s) - 1,2);

  if Length(s) > 5 then
  begin
    sHours := copy(s,1,pos(':',s) - 1);
    sMins := copy(s,pos(':',s) + 1,2);
    if copy(sMins,2,1) = ':' then sMins := sMins[1];
  end
  else
  begin
    sHours := '';
    sMins := copy(s,1,pos(':',s) - 1);
  end;

  Result := StrToInt2(sSecs) +
   (StrToInt2(sMins) * 60) +
   ((StrToInt2(sHours) * 60) * 60);
end;

function SecsToStr(n : longword) : string;
begin
  Result := PrettyMS(n * 1000);
end;

{$I+}
procedure DebugStr(s : string);
begin
  AddFileText(c_Debug,Rep(15,'-') + ' ' +
   TimeStr(Now) + ' ' + Rep(15,'-') + CRLF + s);
end;

function AddFileText(sFile,s : string) : boolean;

var txt : textfile;

begin
  Result := true;
  AssignFile(txt,sFile);

  try
    if FileExists(sFile) then
      Append(txt)
    else
      Rewrite(txt);

    WriteLn(txt,s);
  except
    Result := false;
  end;

  CloseFile(txt);
end;

// bExact = true = faster
function DelFileText(sFile,sLine : string; bExact : boolean) : boolean;

var sl : TStringList;
    n,j : integer;

begin
  Result := true;
  if not FileExists(sFile) then exit;
  sl := TStringList.Create;
  sl.Sorted := bExact;

  try
    sl.LoadFromFile(sFile);

    if not bExact then
    begin
      n := -1;
      sLine := lowercase(sLine);

      for j := 0 to sl.Count - 1 do
      begin
        if pos(sLine,lowercase(sl[j])) > 0 then
        begin
          n := j;
          break;
        end;
      end;
    end
    else n := sl.IndexOf(sLine);

    if n > -1 then
    begin
      sl.Delete(n);
      sl.SaveToFile(sFile);
    end;
  except
    Result := false;
  end;
end;

function StrUntil(s,ss : string) : string;

var nPos : integer;

begin
  nPos := pos(ss,s);
  if nPos = 0 then nPos := Length(s) + 1;

  if s = ss then
    Result := ''
  else
    Result := copy(s,1,nPos - 1);
end;

function StrAfter(s,ss : string) : string;

var nPos : integer;

begin
  nPos := pos(ss,s);

  if s = ss then
    Result := ''
  else
    Result := copy(s,nPos + Length(ss),Length(s));
end;

function InStrSet(s,sset : string) : boolean;
begin
  if s = '' then
  begin
    Result := false;
    exit;
  end;

  s := s + ','; sset := sset + ',';
  Result := pos(lowercase(s),lowercase(sset)) > 0;
end;

function InRange(n,lo,hi : comp) : boolean;
begin
  Result := (n >= lo) and (n <= hi);
end;

function HTMLStr(s : string) : string;

var n : integer;

begin
  for n := 1 to Length(s) do
  begin
    if s[n] = #13 then s := copy(s,1,n - 1) +
     '<br>' + copy(s,n + 1,Length(s));
  end;

  Result := s;
end;

function DelEnd(s,EndingWith : string) : string;

var sEnd : string;

begin
  Result := s;
  if pos(EndingWith,s) = 0 then exit;

  sEnd := copy(s,Length(s) - (Length(EndingWith) - 1),
   Length(s));

  if EndingWith = sEnd then
    System.Delete(Result,Length(s) -
     (Length(sEnd) - 1),Length(sEnd));
end;

function DateStr(dt : TDateTime) : string;
begin
  Result := FormatDateTime('yyyymmdd',Now);
end;

function TimeStr(dt : TDateTime) : string;
begin
  Result := FormatDateTime('yyyymmdd hh:mm:ss',Now);
end;

function InnerTrim(s : string) : string;

var n : integer;

begin
  if Length(s) < 2 then
  begin
    Result := s;
    exit;
  end
  else Result := '';

  for n := Length(s) downto 2 do
  begin
    if (CharInSet(s[n],CharSet(', '))) and
    (CharInSet(s[n - 1],CharSet(', '))) then
      Delete(s,n,1)
    else
      Result := s[n] + Result;
  end;

  Result := s[1] + Result;
end;

function Jumble(s : string) : string;

var n,j : integer;
    c : char;

begin
  for n := 1 to (Length(s)) do
  begin
    j := Random(Length(s)) + 1;
    c := s[n];
    s[n] := s[j];
    s[j] := c;
  end;

  Result := s;
end;

function FatStr(s : string) : string;

var n : integer;

begin
  Result := '';

  if (pos(' ',s) = 0) and
   (pos(#10,s) = 0) and
   (pos(#13,s) = 0) then
  begin
    Result := s;
    exit;
  end;

  for n := 1 to Length(s) do
  begin
    if s[n] = #0 then
    else if s[n] = #13 then
      Result := Result + '<_CR>'
    else if s[n] = #10 then
      Result := Result + '<_LF>'
    else if s[n] = #32 then
      Result := Result + '<_SP>'
    else
      Result := Result + s[n];
  end;
end;

function DietStr(s : string) : string;

var n : integer;

begin
  n := 0;
  Result := '';

  while n <= Length(s) do
  begin
    inc(n);

    if copy(s,n,5) = '<_CR>' then
    begin
      inc(n,4);
      Result := Result + #13;
    end
    else if copy(s,n,5) = '<_LF>' then
    begin
      inc(n,4);
      Result := Result + #10;
    end
    else if copy(s,n,5) = '<_SP>' then
    begin
      inc(n,4);
      Result := Result + #32;
    end
    else if s[n] <> #0 then Result := Result + s[n];
  end;
end;

function ProperCase(s : string) : string;

var n : integer;

begin
  Result := '';

  for n := 1 to Length(s) do
  begin
    if (n = 1) or (CharInSet(s[n - 1],CharSet(' -'))) then
      Result := Result + ansiuppercase(copy(s,n,1))
    else
      Result := Result + s[n];
  end;
end;

// expects 'yyyymmdd hh:mm:ss' [TimeStr() func]
// returns minutes elapsed since TimeStr
function GetElapsed(TimeStr : string) : cardinal;

var y,m,d,h,min,s : word;
    dt : TDateTime;

begin
  try
    y := StrToInt2(copy(TimeStr,1,4));
    m := StrToInt2(copy(TimeStr,5,2));
    d := StrToInt2(copy(TimeStr,7,2));
    h := StrToInt2(copy(TimeStr,10,2));
    min := StrToInt2(copy(TimeStr,13,2));
    s := StrToInt2(copy(TimeStr,16,2));
    dt := EncodeDateTime(y,m,d,h,min,s,0);
    Result := Round((Now - dt) * 14400);
  except on e : exception do
    raise e;
  end;
end;

procedure FreeObjStrs(sl : TStrings);

var n : integer;

begin
  try
    for n := sl.Count - 1 downto 0 do
      if sl.Objects[n] <> nil then
        TObjStr(sl.Objects[n]).Free;
  except
  end;

  sl.Clear;
end;

function FilesExist(Spec : string) : boolean;

var sr : TSearchRec;

begin
  Result := FindFirst(Spec,faArchive,sr) = 0;
  SysUtils.FindClose(sr);
end;

function StripExt(s : string) : string;

var n : integer;
    b : boolean;

begin
  b := false;

  for n := Length(s) downto 1 do
  begin
    if s[n] = '.' then
    begin
      b := true;
      Result := copy(s,1,n - 1);
      break;
    end;
  end;

  if not b then Result := s;
end;

function LastDir(sPathOrFile : string) : string;

var n : integer;

begin
  sPathOrFile := NoFinalBS(sPathOrFile);

  if copy(sPathOrFile,2,1) = ':' then
    System.Delete(sPathOrFile,1,2);

  for n := Length(sPathOrFile) downto 1 do
  begin
    if copy(sPathOrFile,n,1) = '\' then
    begin
      Result := copy(sPathOrFile,n + 1,Length(sPathOrFile));
      break;
    end;
  end;
end;

function CharSet(s : string) : TSysCharSet;

var n : integer;

begin
  Result := [];

  for n := 1 to Length(s) do
    Include(Result,ANSIChar(s[n]));
end;

function SetStr(ssets : string) : string;

var n,nSet : integer;
    c1,c2 : string;
    sl : TStringList;

begin
  sl := TStringList.Create;

  try
    sl.CommaText := ssets;
    Result := '';

    for nSet := 0 to sl.Count - 1 do
    begin
      if Length(sl[nSet]) > 1 then
      begin
        c1 := copy(sl[nSet],1,1);
        c2 := copy(sl[nSet],4,1);

        for n := Ord(c1[1]) to Ord(c2[1]) do
          Result := Result + Chr(n);
      end
      else Result := Result + sl[nSet];
    end;
  finally
    sl.Free;
  end;
end;

procedure SaveControls(AParent : TWinControl; slVars : TStringList);

var i,j : integer;
    AWinControl : TWinControl;

begin
  with AParent do
  begin
    if copy(ClassName,1,4) = 'Tfrm' then
    begin
      slVars.Add(Name + '_Left=' + IntToStr(Left));
      slVars.Add(Name + '_Top=' + IntToStr(Top));
      slVars.Add(Name + '_Width=' + IntToStr(Width));
      slVars.Add(Name + '_Height=' + IntToStr(Height));
      slVars.Add(Name + '_Max=' + YN(TForm(AParent).WindowState = wsMaximized));
    end;

    for i := 0 to ControlCount - 1 do
    begin
      if Controls[i].ClassName = 'TListView' then
      begin
        for j := 0 to TListView(Controls[i]).Columns.Count - 1 do
          slVars.Add(AParent.Name + '.'+ TListView(
           Controls[i]).Name + '_' + IntToStr(j) +
           '=' + IntToStr(TListView(Controls[i]).
           Columns[j].Width));
      end;

      if Controls[i].ClassName = 'TComboBox' then
      begin
        for j := 0 to TComboBox(Controls[i]).Items.Count - 1 do
          slVars.Add(AParent.Name + '.'+ TComboBox(
           Controls[i]).Name + '_' + IntToStr(j) +
           '=' + FatStr(TComboBox(Controls[i]).Items[j] +
           '_is_' + ComboData(TComboBox(Controls[i]))));

        slVars.Add(AParent.Name + '.'+ TComboBox(
         Controls[i]).Name + '_Idx=' + IntToStr(
         TComboBox(Controls[i]).ItemIndex));
      end;

      if Controls[i].ClassName = 'TEdit' then
        slVars.Add(AParent.Name + '.' +
         Controls[i].Name + '=' +
         FatStr(TEdit(Controls[i]).Text));

      if Controls[i].ClassName = 'TCheckBox' then
        slVars.Add(AParent.Name + '.' +
         Controls[i].Name + '=' +
         YN(TCheckbox(Controls[i]).Checked));

      if Controls[i] is TWinControl then
      begin
        AWinControl := TWinControl(Controls[i]);

        if AWinControl.ControlCount > 0 then
          SaveControls(AWinControl,slVars);
      end;
    end;
  end;
end;

procedure SaveMenu(m : TMenuItem; v : TStringList);

var i : integer;

begin
  if m.Checked then
  begin
    v.Add(m.Name + '=Y');
  end;

  for i := 0 to m.Count - 1 do
  begin
    if m.Items[i].Checked then
      v.Add(m.Items[i].Name + '=Y')
    else if m.Items[i].Count > 0 then
      SaveMenu(m.Items[i],v);
  end;
end;

procedure SaveApp(App : TApplication);

var n : integer;
    slVars : TStringList;

begin
  slVars := TStringList.Create;

  try
    for n := 0 to Screen.FormCount - 1 do
      SaveControls(Screen.Forms[n],slVars);

    if Screen.Forms[0].Menu <> nil then
    begin
      for n := 0 to Screen.Forms[0].Menu.Items.Count - 1 do
        SaveMenu(Screen.Forms[0].Menu.Items[n],slVars);
    end;

    slVars.SaveToFile(GetDataPath +
     SafeName(App.Title) + '\' +
     SafeName(App.Title) + '.ini');
  finally
    slVars.Free;
  end;
end;

procedure LoadControls(AParent : TWinControl; slVars : TStringList);

var i,j : integer;
    s,k,v : string;
    AWinControl : TWinControl;

begin
  with AParent do
  begin
    if copy(ClassName,1,4) = 'Tfrm' then
    begin
      s := slVars.Values[Name + '_Left'];
      if s <> '' then Left := StrToInt2(s);
      s := slVars.Values[Name + '_Top'];
      if s <> '' then Top := StrToInt2(s);
      s := slVars.Values[Name + '_Height'];
      if s <> '' then Height := StrToInt2(s);
      s := slVars.Values[Name + '_Width'];
      if s <> '' then Width := StrToInt2(s);
      s := slVars.Values[Name + '_Max'];
      if s = 'Y' then TForm(AParent).WindowState := wsMaximized;
    end;

    for i := 0 to ControlCount - 1 do
    begin
      if Controls[i].ClassName = 'TListView' then
      begin
        for j := 0 to TListView(Controls[i]).Columns.Count - 1 do
        begin
          s := slVars.Values[AParent.Name + '.' + Controls[i].Name + '_' + IntToStr(j)];
          if s <> '' then TListView(Controls[i]).Columns[j].Width := StrToInt2(s);
        end;
      end;

      if Controls[i].ClassName = 'TComboBox' then
      begin
        s := 'x';
        j := -1;

        while s <> '' do
        begin
          inc(j);

          s := DietStr(slVars.Values[AParent.Name + '.' +
           TComboBox(Controls[i]).Name + '_' +
           IntToStr(j)]);

          if s <> '' then
          begin
            if pos('_is_',s) > 0 then
            begin
              k := StrUntil(s,'_is_');
              v := StrAfter(s,'_is_');

              if TComboBox(Controls[i]).Items.IndexOf(k) = -1 then
                TComboBox(Controls[i]).Items.AddObject(
                 k,TObjStr.Create(v));
            end
            else if TComboBox(Controls[i]).Items.IndexOf(s) = -1 then
              TComboBox(Controls[i]).Items.Add(s);
          end;
        end;

        s := slVars.Values[AParent.Name + '.' +
         TComboBox(Controls[i]).Name + '_Idx'];

        if s <> '' then
          TComboBox(Controls[i]).ItemIndex := StrToInt2(s);
      end;

      if Controls[i].ClassName = 'TEdit' then
      begin
        s := slVars.Values[AParent.Name + '.' + Controls[i].Name];
        if s <> '' then TEdit(Controls[i]).Text := DietStr(s);
      end;

      if Controls[i].ClassName = 'TCheckBox' then
      begin
        s := slVars.Values[AParent.Name + '.' + Controls[i].Name];
        TCheckbox(Controls[i]).Checked := s = 'Y';
      end;

      if Controls[i] is TWinControl then
      begin
        AWinControl := TWinControl(Controls[i]);

        if AWinControl.ControlCount > 0 then
          LoadControls(AWinControl,slVars);
      end;
    end;
  end;
end;

procedure LoadMenu(m : TMenuItem; v : TStringList);

var i : integer;

begin
  for i := 0 to m.Count - 1 do
    m.Items[i].Checked := YN(v.Values[m.Items[i].Name]);
end;

procedure CenterForm(f : TForm);
begin
  f.Left := (Screen.Width div 2) - (f.Width div 2);
  f.Top := (Screen.Height div 2) - (f.Height div 2);

  if (f.Left < 0) or (f.Top < 0) then
  begin
    f.Left := 0;
    f.Width := Screen.Width;
    f.Top := 0;
    f.Height := Screen.Height;
  end;
end;

procedure LoadApp(App : TApplication);

var n : integer;
    slVars : TStringList;
    s : string;

begin
  s := GetDataPath + SafeName(App.Title) + '\' +
   SafeName(App.Title) + '.ini';

  if not FileExists(s) then
  begin
    for n := 0 to Screen.FormCount - 1 do
      CenterForm(Screen.Forms[n]);

    exit;
  end;

  slVars := TStringList.Create;

  try
    slVars.LoadFromFile(s);

    if Screen.Forms[0].Menu <> nil then
    begin
      for n := 0 to Screen.Forms[0].Menu.Items.Count - 1 do
        LoadMenu(Screen.Forms[0].Menu.Items[n],slVars);
    end;

    for n := 0 to Screen.FormCount - 1 do
      LoadControls(Screen.Forms[n],slVars);
  finally
    slVars.Free;
  end;
end;

procedure slAdd(sl : TStringList; k,v : string);

var n : integer;
    b : boolean;

begin
  b := false;

  for n := 0 to sl.Count - 1 do
  begin
    if KeyOf(sl[n]) = k then
    begin
      b := true;
      sl.ValueFromIndex[n] := v;
      break;
    end;
  end;

  if not b then sl.Add(k + '=' + v);
end;

procedure AddAppVar(App,k,v : string);

var s : string;
    sl : TStringList;

begin
  s := GetDataPath + SafeName(App) + '\' + SafeName(App) + '.ini';
  sl := TStringList.Create;

  try
    if FileExists(s) then sl.LoadFromFile(s);
    slAdd(sl,k,v);
    sl.Sort;
    sl.SaveToFile(s);
  finally
    sl.Free;
  end;
end;

function GetAppVar(App,k : string) : string;

var slVars : TStringList;
    s : string;

begin
  Result := '';
  s := GetDataPath + SafeName(App) + '\' + SafeName(App) + '.ini';
  if not FileExists(s) then exit;
  slVars := TStringList.Create;

  try
    slVars.LoadFromFile(s);
    Result := slVars.Values[k];
  finally
    slVars.Free;
  end;
end;

function RTFToStr(red : TRichEdit) : string;

var ss : TStringStream;

begin
  ss := TStringStream.Create('');
  red.Lines.SaveToStream(ss);
  Result := copy(ss.DataString,1,Length(ss.DataString) - 1);
  ss.Free;
end;

function StrToStream(s : string) : TStringStream;
begin
  Result := TStringStream.Create(s);
  Result.Position := 0;
end;

function RTFToStream(red : TRichEdit) : TMemoryStream;
begin
  Result := TMemoryStream.Create;
  red.Lines.SaveToStream(Result);
  Result.Position := 0;
end;

procedure CopyRTF(redFrom,redTo : TRichEdit);

var s : TMemoryStream;

begin
  s := TMemoryStream.Create;

  try
    redFrom.Lines.SaveToStream(s);
    s.Position := 0;
    redTo.Lines.LoadFromStream(s);
  finally
    s.Free;
  end;
end;

procedure StrToRTF(sRTF : string; var red : TRichEdit; Append : boolean);

var ss : TStringStream;

begin
  ss := TStringStream.Create(sRTF);
  ss.Position := 0;

  try
    if Append then
      red.Lines.Append(ss.DataString)
    else
      red.Lines.LoadFromStream(ss);
  finally
    ss.Free;
  end;
end;

function MSToStr(ms : TMemoryStream) : string;

var ss : TStringStream;

begin
  ms.Position := 0;
  ss := TStringStream.Create('');
  ss.LoadFromStream(ms);
  Result := ss.DataString; // no final #0 here
  ss.Free;
end;

procedure AppendRed(const src,trg : TRichEdit);

var es : TEditStream;
    ms : TMemoryStream;

function EditStreamReader(dwCookie : DWORD; pBuff : Pointer; cb : LongInt; pcb : PLongInt) : DWORD; stdcall;
begin
  Result := $0000;

  try
    pcb^ := TStream(dwCookie).Read(pBuff^,cb);
  except
    Result := $FFFF;
  end;
end;

begin
  trg.Lines.BeginUpdate;
  ms := TMemoryStream.Create;

  try
    src.Lines.SaveToStream(ms);
    ms.Position := 0;
    trg.MaxLength := trg.MaxLength + ms.Size;
    es.dwCookie := DWORD(ms);
    es.dwError := $0000;
    es.pfnCallback := @EditStreamReader;
    trg.Perform(EM_STREAMIN,SFF_SELECTION or SF_RTF or SFF_PLAINRTF,LPARAM(@es));

    if es.dwError <> $0000 then
      raise Exception.Create('Error appending RTF data.');
  finally
    ms.Free;
    trg.Lines.EndUpdate;
  end;
end;

function FinalDir(sPath : string) : string;

var n : integer;

begin
  Result := '';
  sPath := NoFinalBS(sPath);

  for n := Length(sPath) downto 1 do
  begin
    if sPath[n] = '\' then
      break
    else
      Result := sPath[n] + Result;
  end;
end;

// can't maintain in string form...
function Crypt(s : string) : string;

var i : integer;

begin
  Result := s; exit;

  for i := 1 to Length(s) do
    Result[i] := Char(Byte(s[i]) xor $AA);
end;

function GetVersion(EXE : string) : string;

var VerInfoSize : DWORD;
    VerInfo : Pointer;
    VerValueSize : DWORD;
    VerValue : PVSFixedFileInfo;
    Dummy : DWORD;

begin
  Result := '';
  if not FileExists(EXE) then exit;
  VerInfo := nil;
  VerInfoSize := GetFileVersionInfoSize(PChar(EXE),Dummy);

  try
    GetMem(VerInfo,VerInfoSize);
    GetFileVersionInfo(PChar(EXE),0,VerInfoSize,VerInfo);
    VerQueryValue(VerInfo,'\',Pointer(VerValue),VerValueSize);

    with VerValue^ do
    begin
      Result := IntToStr(dwFileVersionMS shr 16);
      Result := Result + '.' + IntToStr(dwFileVersionMS and $FFFF);
      Result := Result + '.' + IntToStr(dwFileVersionLS shr 16);
      Result := Result + '.' + IntToStr(dwFileVersionLS and $FFFF);
    end;
  finally
    FreeMem(VerInfo,VerInfoSize);
  end;
end;

// currently removes all ' and " [leave as default]
// ideally remove innermost pairs to outward
// with option to remove most-outer set only
function NoQuotes(s : string; Mode : integer) : string;
begin
  Result := s;

  if (pos(#39,s) = 0) and (pos('"',s) = 0) then
  begin
    exit;
  end;

  if Mode = 0 then
    Result := Strip(Result,#39 + '"')
  else if Mode = 1 then // outer-only
  ;
end;

function GetWindowsDir : string;

var dir : string;

begin
  SetLength(dir,144);

  if GetWindowsDirectory(PChar(dir),144) <> 0 then
  begin
    SetLength(dir,StrLen(PChar(dir)));
    Result := dir + '\';
  end
  else Result := 'c:\windows\';
end;

function FileStr(sFile : string) : string;

var sl : TStringList;

begin
  Result := '';
  sl := TStringList.Create;

  try
    sl.LoadFromFile(sFile);
    Result := trim(sl.Text);{strip final CRLF}
  finally
    sl.Free;
  end;
end;

(*
procedure TfrmMain.URL_OnDownloadProgress;
begin
  ProgressBar1.Max:= ProgressMax;
  ProgressBar1.Position:= Progress;
end;
*)

procedure GetURL(sFile,sURL : string);
begin
  SysUtils.DeleteFile(sFile);

  with TDownloadURL.Create(nil) do
  begin
    try
      URL := sURL;
      FileName := sFile;
      // OnDownloadProgress := URL_OnDownloadProgress;
      ExecuteTarget(nil);
    except
    end;

    Free;
  end;
end;

function CloseFormClass(FormClass : string) : boolean;

var h : THandle;

begin
  Result := true;

  repeat
    h := FindWindow(PChar(FormClass),nil);
    if h > 0 then PostMessage(h,WM_CLOSE,0,0);
  until h = 0;
end;

function GetDataPath : string;

var Path : array [0..MAX_PATH] of char;

begin
  if SUCCEEDED(SHGetFolderPath(0,0,0,0,@Path[0])) then
    Result := Path
  else
    Result := '';

  while CharCount(Result,'\') > 2 do
    Delete(Result,Length(Result),1);

  if Result = '' then
    Result := HDir
  else
    Result := Result + '\My Documents\';
end;

function BrowseDialogCallBack(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): integer stdcall;

var wa,rect : TRect;
    dialogPT : TPoint;

begin
  //center in work area
  if uMsg = BFFM_INITIALIZED then
  begin
    wa := Screen.WorkAreaRect;
    GetWindowRect(Wnd, Rect);
    dialogPT.X := ((wa.Right-wa.Left) div 2) -
                  ((rect.Right-rect.Left) div 2);
    dialogPT.Y := ((wa.Bottom-wa.Top) div 2) -
                  ((rect.Bottom-rect.Top) div 2);
    MoveWindow(Wnd,dialogPT.X,dialogPT.Y,
     Rect.Right - Rect.Left,Rect.Bottom - Rect.Top,true);
    {set browse directory}
    SendMessage(wnd,BFFM_SETSELECTIONA,Longint(true),lpdata);
  end;

  Result := 0;
end; (*BrowseDialogCallBack*)

function BrowseDialog(const Title: string; const Flag: integer): string;

var lpItemID : PItemIDList;
    BrowseInfo : TBrowseInfo;
    DisplayName : array[0..MAX_PATH] of char;
    TempPath : array[0..MAX_PATH] of char;

begin
  Result := '';
  FillChar(BrowseInfo,sizeof(TBrowseInfo),#0);

  with BrowseInfo do
  begin
    hwndOwner := Application.Handle;
    pszDisplayName := @DisplayName;
    lpszTitle := PChar(Title);
    //lParam := Longint(PChar(StartDir)); useless
    ulFlags := Flag;
    lpfn := BrowseDialogCallBack;
  end;

  lpItemID := SHBrowseForFolder(BrowseInfo);

  if lpItemId <> nil then
  begin
    SHGetPathFromIDList(lpItemID,TempPath);
    Result := TempPath;
    GlobalFreePtr(lpItemID);
  end;
end;

function GetDirectory(Title : string) : string;
begin
  if Title = '' then Title := 'Select a folder';
  Result := BrowseDialog(Title,BIF_RETURNONLYFSDIRS);
end;

function GotNet : boolean;
begin
  try
    GetURL(HDir + '_tmp','http://www.google.com');
    Result := FileExists(HDir + '_tmp');
    SysUtils.DeleteFile(HDir + '_tmp');
  except
    Result := false;
  end;
end;

function GetCurrentUserName : string;

const cnMaxUserNameLen = 254;

var sUserName : string;
    dwUserNameLen : DWord;

begin
  dwUserNameLen := cnMaxUserNameLen - 1;
  SetLength(sUserName,cnMaxUserNameLen);
  GetUserName(PChar(sUserName),dwUserNameLen);
  SetLength(sUserName,dwUserNameLen);
  Result := sUserName;
end;

function KeyOf(kvstr : string) : string;
begin
  Result := StrUntil(kvstr,'=');
end;

function ValOf(kvstr : string) : string;
begin
  Result := StrAfter(kvstr,'=');
end;

function FileSpec(s : string) : boolean;
begin
  Result := (pos('*',s) > 0) or (pos('?',s) > 0);
end;

function FileSizeText(nBytes : comp) : string;
begin // skip the 1024 math
  if nBytes < 0 then nBytes := 0;

  if InRange(nBytes,0,1000) then
    Result := CommaStr(FloatToStr(nBytes)) + ' bytes'
  else if InRange(nBytes,1001,999999) then
    Result := CommaStr(FloatToStrF(nBytes / 1000,ffFixed,3,1)) + ' kb'
  else if InRange(nBytes,1000000,999999999) then
    Result := CommaStr(FloatToStrF((nBytes / 1000) / 1000,ffFixed,3,1)) + ' mb'
  else if InRange(nBytes,1000000000,999999999999) then
    Result := CommaStr(FloatToStrF(((nBytes / 1000) / 1000) / 1000,ffFixed,3,1)) + ' gb'
  else if InRange(nBytes,1000000000000,999999999999999) then
    Result := CommaStr(FloatToStrF((((nBytes / 1000) / 1000) / 1000) / 1000,ffFixed,3,1)) + ' tb'
  else Result := '1+ xb';
end;

procedure StrToBuff(s : string; var aBuff : array of char);

var n : integer;

begin
  FillChar(aBuff,SizeOf(aBuff),#0);

  for n := 1 to length(s) do
    aBuff[n - 1] := s[n];
end;

function SetFileDate(f : string; dt: TDateTime): string;

var iResult : Integer;

begin
  Result := '';
  iResult := FileSetDate(f,DateTimeToFileDate(dt));
  if iResult <> 0 then Result := SysErrorMessage(iResult);
end;

function Recycle(sFile : string) : boolean;

var fos : TSHFileOpStruct;

begin
  FillChar(fos,SizeOf(fos),0);

  with fos do
  begin
    wFunc := FO_DELETE;
    pFrom := PChar(sFile);
    fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_SILENT;
  end;

  Result := (ShFileOperation(fos) = 0);
end;

procedure DosExec(Cmd : string);
begin
  // cmd ex: "copy file1.txt file2.txt"
  ShellExecute(0,'open',PChar('command.com'),
   PChar('/c ' + Cmd),nil,SW_SHOW);
end;

function GetCPLList : TStringList;

var CPLFileMask : String;
    SearchRec : TSearchRec;
    SystemPath: array[0..MAX_PATH + 1] of char;

begin
  Result := TStringList.Create;
  GetSystemDirectory(SystemPath,MAX_PATH);
  CPLFileMask := IncludeTrailingPathDelimiter(SystemPath) + '*.CPL';

  if FindFirst(CPLFileMask,faAnyFile - faDirectory,SearchRec) = 0 then
  begin
    repeat
      Result.Add(SearchRec.Name);
    until FindNext(SearchRec) <> 0;

    SysUtils.FindClose(SearchRec);
  end;
end;

// call like: RunCPL('Main.cpl,Mouse');
procedure RunCPL(sFile,sName : string);
begin
  ShellExecute(0,PChar('open'),PChar('rundll32.exe'),
   PChar('shell32.dll,Control_RunDLL ' +
   PChar(sFile + ',' + sName)),nil,SW_NORMAL);
end;

function InParams(sParam : string) : boolean;

var n : integer;

begin
  Result := false;
  if ParamCount = 0 then exit;

  for n := 1 to ParamCount do
  begin
    if lowercase(sParam) = lowercase(ParamStr(n)) then
    begin
      Result := true;
      break;
    end;
  end;
end;

procedure SaveWinPos(frm : TForm; sFile : string);

var sl : TStringList;

begin
  sl := TStringList.Create;

  try
    if FileExists(sFile) then sl.LoadFromFile(sFile);
    slAdd(sl,frm.Name + '.Top',IntToStr(frm.Top));
    slAdd(sl,frm.Name + '.Left',IntToStr(frm.Left));
    slAdd(sl,frm.Name + '.Width',IntToStr(frm.Width));
    slAdd(sl,frm.Name + '.Height',IntToStr(frm.Height));
    slAdd(sl,frm.Name + '.Max',YN(frm.WindowState = wsMaximized));
    sl.Sort;
    sl.SaveToFile(sFile);
  finally
    sl.Free;
  end;
end;

procedure LoadWinPos(frm : TForm; sFile : string);

var sl : TStringList;

begin
  if not FileExists(sFile) then
  begin
    CenterForm(frm);
    exit;
  end;

  sl := TStringList.Create;

  try
    sl.LoadFromFile(sFile);

    if sl.Values[frm.Name + '.Left'] <> '' then
    begin
      frm.Left := StrToInt2(sl.Values[frm.Name + '.Left']);
      if frm.Left >= Screen.Width then frm.Left := 0;
      frm.Top := StrToInt2(sl.Values[frm.Name + '.Top']);
      if frm.Top >= Screen.Height then frm.Top := 0;
      frm.Width := StrToInt2(sl.Values[frm.Name + '.Width']);
      frm.Height := StrToInt2(sl.Values[frm.Name + '.Height']);
      if sl.Values[frm.Name + '.Max'] = 'Y' then frm.WindowState := wsMaximized;
    end
    else CenterForm(frm);
  finally
    sl.Free;
  end;
end;

procedure DelEmpty(sRoot : string);

{$I+}
procedure DelEmptyProcess(DirName : string);

var sr : TSearchRec;
    f  : integer;

begin
  try
    if not DirectoryExists(DirName) then exit;
    ChDir(DirName);
  except
    exit;
  end;

  try
    f := FindFirst('*.*',faDirectory,sr);
  except on e : exception do
    begin
      try SysUtils.FindClose(sr); except end;
      exit;
    end;
  end;

  while f = 0 do
  begin
    if (sr.name <> '.') AND (sr.name <> '..') AND
      ((sr.attr AND faDirectory) <> 0) then
    begin
      if DirName[length(DirName)] = '\' then
        DelEmptyProcess(DirName + sr.Name)
      else
        DelEmptyProcess(DirName + '\' + sr.Name);

      try
        ChDir(DirName);
      except
        begin
          try SysUtils.FindClose(sr); except end;
          exit;
        end;
      end;
    end;

    try
      f := FindNext(sr);
    except on e : exception do
      begin
        try SysUtils.FindClose(sr); except end;
        exit;
      end;
    end;
  end;

  try SysUtils.FindClose(sr); except end;

  if length(DirName) > 3 then
  begin
    if DirectoryEmpty(DirName) then
    begin
      try // to be somewhere else
        ChDir('c:\');
      except
      end;

      try
        RmDir(DirName);
      except
      end;
    end;
  end;
end;

begin // DelEmpty()
  DelEmptyProcess(sRoot);
end;

{$I+}
procedure MkDirs(sRoot : string);

var n : integer;
    s : string;

procedure MkDir2;
begin
  try
    if not DirectoryExists(NoFinalBS(s)) then
      MkDir(NoFinalBS(s));
  except
    raise Exception.Create('MkDir error: ' + NoFinalBS(s));
  end;
end;

begin // MkDirs
  s := '';

  for n := 1 to length(sRoot) do
  begin
    if sRoot[n] = '\' then
    begin
      MkDir2;
      s := s + '\';
    end
    else s := s + sRoot[n];
  end;

  MkDir2;
end;

procedure SetRegistryData(RootKey: HKEY; Key,Value : string; RegDataType: TRegDataType; Data: variant);

var Reg : TRegistry;
    s : string;

begin
  Reg := TRegistry.Create(KEY_WRITE);

  try
    Reg.RootKey := RootKey;

    if Reg.OpenKey(Key,True) then
    begin
      try
        if RegDataType = rdUnknown then
          RegDataType := Reg.GetDataType(Value);

        if RegDataType = rdString then
          Reg.WriteString(Value, Data)
        else if RegDataType = rdExpandString then
          Reg.WriteExpandString(Value, Data)
        else if RegDataType = rdInteger then
          Reg.WriteInteger(Value, Data)
        else if RegDataType = rdBinary then
        begin
          s := Data;
          Reg.WriteBinaryData(Value,PChar(s)^,Length(s));
        end
        else raise Exception.Create(SysErrorMessage(ERROR_CANTWRITE));
      except
        Reg.CloseKey;
        raise;
      end;

      Reg.CloseKey;
    end
    else raise Exception.Create(SysErrorMessage(GetLastError));
  finally
    Reg.Free;
  end;
end;

procedure SetWallpaper(const Filename : TFilename; Tiled: boolean);

var sTiled : string;

begin
  if Filename <> '' then
  begin
    if Tiled then sTiled := '1' else sTiled := '0';

    SetRegistryData(HKEY_CURRENT_USER,
     '\Control Panel\Desktop','TileWallpaper',rdString,
     sTiled);
  end;

  SystemParametersInfo(SPI_SETDESKWALLPAPER,0,
   Pointer(Filename),SPIF_UPDATEINIFILE);
end;

procedure AddHist(cmb : TComboBox; s : string);
begin
  if (cmb.Items.Count > 0) and
   (s = cmb.Items[0]) then
    exit;

  if cmb.Items.IndexOf(s) > -1 then
    cmb.Items.Delete(cmb.ItemIndex);

  if cmb.Items.Count >= 99 then
    cmb.Items.Delete(cmb.Items.Count - 1);

  cmb.Items.Insert(0,s);
  cmb.Items.SaveToFile(HDir + SafeName(cmb.Name) + '.hst');
end;

function ReplaceStr(s,old,new : string) : string;

var n : integer;

begin
  Result := s;

  while pos(lowercase(old),lowercase(Result)) > 0 do
  begin
    n := pos(lowercase(old),lowercase(Result));
    Result := copy(Result,1,n - 1) + new + copy(Result,n + Length(old),999);
  end;
end;

procedure PopCombo(cmb : TComboBox; Name,Data : string);
begin
  cmb.Items.AddObject(Name,TObjStr.Create(Data));
end;

procedure SetCombo(cmb : TComboBox; Data : string);

var n : integer;

begin
  cmb.ItemIndex := -1;

  for n := 0 to cmb.Items.Count - 1 do
  begin
    if (cmb.Items.Objects[n] <> nil) and
     (Data = TObjStr(cmb.Items.Objects[n]).s) then
    begin
      cmb.ItemIndex := n;
      break;
    end;
  end;
end;

function ComboData(cmb : TComboBox) : string;
begin
  Result := '-1';
  if (cmb.ItemIndex = -1) or (cmb.Items.Objects[cmb.ItemIndex] = nil) then exit;
  Result := TObjStr(cmb.Items.Objects[cmb.ItemIndex]).s;
end;

function ListBoxData(lst : TListBox) : string;
begin
  Result := '-1';
  if lst.ItemIndex = -1 then exit;
  if lst.Items.Objects[lst.ItemIndex] = nil then exit;

  try
    Result := TObjStr(lst.Items.Objects[lst.ItemIndex]).s;
  except
  end;
end;

function DelimitedList(List,Delim : string) : TStringList;

var n : integer;

begin
  Result := TStringList.Create;

  while pos(Delim,List) > 0 do
  begin
    n := pos(Delim,List);
    Result.Add(copy(List,1,n - 1));
    List := copy(List,n + 1,999);
  end;

  if trim(List) <> '' then Result.Add(List);
end;

function FreeSpace(DrvLetter : char; var nFree,nSize : int64) : boolean;

var d : integer;
    s : string[2];

begin
  Result := false;
  s := DrvLetter;
  s := uppercase(s);
  if not (s[1] in ['A'..'Z']) then exit;
  d := Ord(s[1]) - 64;
  nFree := DiskFree(d);
  nSize := DiskSize(d);
end;

function ReplaceChar(s : string; old,new : char) : string;

var n : integer;

begin
  Result := '';

  for n := 1 to Length(s) do
  begin
    if s[n] = old then
      Result := Result + new
    else
      Result := Result + s[n];
  end;
end;

begin
  Randomize;
  dtUptime := Now;
  HDir := ExtractFilePath(ParamStr(0));
end.
