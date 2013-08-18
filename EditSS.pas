unit EditSS;

interface

uses Windows,Messages,SysUtils,Variants,Classes,
     Graphics,Controls,Forms,Dialogs,StdCtrls,Spin,
     ExtCtrls;

type TfrmEditSS = class(TForm)
       edtDelay: TSpinEdit;
       lblDelay: TLabel;
       lblRepeat: TLabel;
       edtRepeat: TSpinEdit;
       lblSync: TLabel;
       edtSync: TEdit;
       dlgFont: TFontDialog;
       lblImg: TLabel;
       edtImg: TEdit;
       lblOther: TLabel;
       edtOther: TEdit;
       cmdAudioLen: TButton;
       cmdDDivALen: TButton;
       pnlCmd: TPanel;
       cmdOk: TButton;
       cmdCancel: TButton;
       lblCap: TLabel;
       edtCaption: TEdit;
       cmdFont: TButton;
       procedure edtSyncDblClick(Sender: TObject);
       procedure edtImgDblClick(Sender: TObject);
       procedure cmdOkClick(Sender: TObject);
       procedure cmdCancelClick(Sender: TObject);
       procedure FormActivate(Sender: TObject);
       procedure FormKeyPress(Sender: TObject; var Key: Char);
       procedure edtOtherDblClick(Sender: TObject);
       procedure cmdAudioLenClick(Sender: TObject);
       procedure cmdDDivALenClick(Sender: TObject);
       procedure cmdFontClick(Sender: TObject);
     private
     public
       RetVal : integer;
       FontName : string;
     end;

var frmEditSS : TfrmEditSS;

implementation

{$R *.dfm}

uses VPAExt,Main;

procedure TfrmEditSS.FormActivate(Sender: TObject);
begin
  dlgFont.Font.Name := FontName;
  cmdFont.Hint := FontName;
  edtCaption.SetFocus;
end;

procedure TfrmEditSS.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Esc then cmdCancelClick(Self);
  if Key = #13 then cmdOkClick(Self);
end;

procedure TfrmEditSS.cmdCancelClick(Sender: TObject);
begin
  RetVal := rvCancel;
  Close;
end;

procedure TfrmEditSS.cmdOkClick(Sender: TObject);
begin
  RetVal := rvOk;
  Close;
end;

procedure TfrmEditSS.edtImgDblClick(Sender: TObject);
begin
  with frmMain do
  begin
    dlgOpen.FilterIndex := fsAny;
    dlgOpen.Filter := '*.jpg';

    if dlgOpen.Execute then
      edtImg.Text := dlgOpen.Filename;
  end;
end;

procedure TfrmEditSS.edtOtherDblClick(Sender: TObject);
begin
  with frmMain do
  begin
    dlgOpen.FilterIndex := fsAny;

    if dlgOpen.Execute then
      edtOther.Text := dlgOpen.Filename;
  end;
end;

procedure TfrmEditSS.edtSyncDblClick(Sender: TObject);
begin
  with frmMain do
  begin
    dlgOpen.FilterIndex := fsAudio;

    if dlgOpen.Execute then
      edtSync.Text := dlgOpen.Filename;
  end;
end;

procedure TfrmEditSS.cmdAudioLenClick(Sender: TObject);
begin
  if FileExists(edtSync.Text) then
    edtDelay.Value := frmMain.AudioLen(edtSync.Text) div 1000;
end;

procedure TfrmEditSS.cmdDDivALenClick(Sender: TObject);

var len : dword;

begin
  if not FileExists(edtSync.Text) then exit;
  len := frmMain.AudioLen(edtSync.Text) div 1000;

  if len > 0 then
    edtRepeat.Value := edtDelay.Value div len;
end;

procedure TfrmEditSS.cmdFontClick(Sender: TObject);
begin
  if dlgFont.Execute then FontName := dlgFont.Font.Name;
  cmdFont.Hint := FontName;
end;

end.
