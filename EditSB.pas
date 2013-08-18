unit EditSB;

interface

uses Windows,Messages,SysUtils,Variants,Classes,Graphics,
     Controls,Forms,Dialogs,StdCtrls,ExtCtrls,Spin;

type TfrmSB = class(TForm)
       lblAudio: TLabel;
       edtAudio: TEdit;
       lblDelay: TLabel;
       edtStart: TSpinEdit;
       lblDur: TLabel;
       edtDur: TSpinEdit;
       pnlCmd: TPanel;
       cmdOk: TButton;
       cmdCancel: TButton;
       cmdTest: TButton;
       tmr: TTimer;
       procedure edtAudioDblClick(Sender: TObject);
       procedure FormActivate(Sender: TObject);
       procedure FormKeyPress(Sender: TObject; var Key: Char);
       procedure cmdOkClick(Sender: TObject);
       procedure cmdCancelClick(Sender: TObject);
       procedure cmdTestClick(Sender: TObject);
       procedure tmrTimer(Sender: TObject);
     private
       bMainTmr : boolean;
       nWait : integer;
     public
       RetVal : integer;
     end;

var frmSB : TfrmSB;

implementation

{$R *.dfm}

uses VPAExt,Main;

procedure TfrmSB.FormActivate(Sender: TObject);
begin
  cmdTest.Caption := '&Test';{if prev mperr}
  edtAudio.SetFocus;
end;

procedure TfrmSB.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Esc then cmdCancelClick(Self);
  if Key = #13 then cmdOkClick(Self);
end;

procedure TfrmSB.cmdCancelClick(Sender: TObject);
begin
  RetVal := rvCancel;
  Close;
end;

procedure TfrmSB.cmdOkClick(Sender: TObject);
begin
  RetVal := rvOk;
  Close;
end;

procedure TfrmSB.edtAudioDblClick(Sender: TObject);
begin
  with frmMain do
  begin
    dlgOpen.FilterIndex := fsAudio;

    if dlgOpen.Execute then
      edtAudio.Text := dlgOpen.Filename;
  end;
end;

procedure TfrmSB.cmdTestClick(Sender: TObject);
begin
  if (edtAudio.Text = '') or (edtDur.Value = 0) then exit;

  if cmdTest.Caption = 'S&top' then
  begin
    nWait := edtDur.Value;
    tmrTimer(Self);
    exit;
  end;

  cmdTest.Caption := 'S&top';

  with frmMain do
  begin
    nWait := 0;
    bMainTmr := tmrTrack.Enabled;
    tmrTrack.Enabled := false;
    Usurp(true);
    mp.Filename := edtAudio.Text;
    mp.Open;
    mp.Position := edtStart.Value * 1000;
    mp.Play;
    tmr.Enabled := true;
  end;
end;

procedure TfrmSB.tmrTimer(Sender: TObject);
begin
  inc(nWait);

  if nWait >= edtDur.Value then
  begin
    tmr.Enabled := false;
    frmMain.mp.Stop;
    cmdTest.Caption := '&Test';
    frmMain.Usurp(false);
    frmMain.tmrTrack.Enabled := bMainTmr;
  end;
end;

end.
