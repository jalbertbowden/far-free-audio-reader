unit Voice;

interface

uses Windows,Messages,SysUtils,Variants,Classes,Graphics,
     Controls,Forms,Dialogs,StdCtrls,ExtCtrls,Spin,
     SpeechLib_TLB,OleServer;

type TfrmVoice = class(TForm)
       lblVolume: TLabel;
       lblRate: TLabel;
       edtVolume: TSpinEdit;
       edtRate: TSpinEdit;
       pnlCmd: TPanel;
       cmdOk: TButton;
       cmdCancel: TButton;
       lblVoice: TLabel;
       cmdTest: TButton;
       cmbVoice: TComboBox;
       SpVoice: TSpVoice;
       procedure FormActivate(Sender: TObject);
       procedure cmdOkClick(Sender: TObject);
       procedure cmdCancelClick(Sender: TObject);
       procedure FormCreate(Sender: TObject);
    procedure cmbVoiceChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmdTestClick(Sender: TObject);
     private
     public
       RetVal : integer;
     end;

var frmVoice : TfrmVoice;

implementation

{$R *.dfm}

uses VPAExt,Main;

procedure TfrmVoice.FormCreate(Sender: TObject);

var n : integer;
    soToken : ISpeechObjectToken;
    soTokens : ISpeechObjectTokens;

begin
  SpVoice.EventInterests := SVEAllEvents;
  soTokens := SpVoice.GetVoices('','');

  for n := 0 to soTokens.Count - 1 do
  begin
    soToken := soTokens.Item(n);
    cmbVoice.Items.AddObject(soToken.GetDescription(0),TObject(soToken));
    soToken._AddRef;
  end;

  if cmbVoice.Items.Count > 0 then
  begin
    cmbVoice.ItemIndex := 0;
    cmbVoice.OnChange(cmbVoice);
  end;

  edtRate.Value := SpVoice.Rate;
  edtVolume.Value := SpVoice.Volume;
end;

procedure TfrmVoice.FormDestroy(Sender: TObject);

//var n : integer;

begin
//  for n := 0 to cmbVoice.Items.Count - 1 do
//    ISpeechObjectToken(Pointer(cmbVoice.Items.Objects[n]))._Release;
end;

procedure TfrmVoice.FormActivate(Sender: TObject);
begin
  cmbVoice.SetFocus;
end;

procedure TfrmVoice.cmbVoiceChange(Sender: TObject);

var soToken : ISpeechObjectToken;

begin
  soToken := ISpeechObjectToken(Pointer(cmbVoice.Items.
   Objects[cmbVoice.ItemIndex]));

  SpVoice.Voice := soToken;
end;

procedure TfrmVoice.cmdCancelClick(Sender: TObject);
begin
  RetVal := rvCancel;
  Close;
end;

procedure TfrmVoice.cmdOkClick(Sender: TObject);
begin
  RetVal := rvOk;
  Close;
end;

procedure TfrmVoice.cmdTestClick(Sender: TObject);
begin
  SpVoice.Speak('The quick brown fox jumped over the lazy dog.',0);
end;

end.
