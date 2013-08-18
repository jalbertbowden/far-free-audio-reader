unit Splash;

interface

uses Windows,Messages,SysUtils,Variants,Classes,
     Graphics,Controls,Forms,Dialogs,StdCtrls,
     ExtCtrls,jpeg;

type TfrmSplash = class(TForm)
       img: TImage;
       lblMsg: TLabel;
     private
     public
     end;

var frmSplash : TfrmSplash;

implementation

{$R *.dfm}

end.
