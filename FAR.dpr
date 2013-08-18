program FAR;

uses
  Forms,
  Windows,
  SysUtils,
  VPAExt in '..\VPAExt.pas',
  ID3v1Library in 'ID3v1Library.pas',
  MMDevApi in 'MMDevApi.pas',
  Splash in 'Splash.pas' {frmSplash},
  Main in 'Main.pas' {frmMain},
  EditSS in 'EditSS.pas' {frmEditSS},
  EditSB in 'EditSB.pas' {frmSB},
  Voice in 'Voice.pas' {frmVoice};

{$R *.res}

var Mutex : THandle;
    hWind : HWND;
    n : integer;

begin
  Mutex := CreateMutex(nil,true,PWideChar('farfarfaraufderautobahn'));

  if Mutex <> 0 then
  begin
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      CloseHandle(Mutex);
      hWind := 0;

      repeat
        hWind := Windows.FindWindowEx(0,hWind,'TApplication','FAR');
      until (hWind <> Application.Handle);

      if hWind <> 0 then
      begin
        Windows.ShowWindow(hWind,SW_SHOWNORMAL);
        Windows.SetForegroundWindow(hWind);
      end;

      for n := 1 to ParamCount do
        AddFileText(HDir + 'FARQ' + UniqueID + '.que',ParamStr(n));

      Halt;
    end
  end;

  if ParamCount > 0 then
  begin
    frmSplash := TfrmSplash.Create(Application);
    frmSplash.Show;
  end
  else frmSplash := nil;

  Application.Initialize;
  if frmSplash <> nil then frmSplash.Update;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'FAR';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmEditSS, frmEditSS);
  Application.CreateForm(TfrmSB, frmSB);
  Application.CreateForm(TfrmVoice, frmVoice);
  Application.Run;
end.
