object frmEditSS: TfrmEditSS
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Edit'
  ClientHeight = 469
  ClientWidth = 874
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -27
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 240
  TextHeight = 33
  object lblDelay: TLabel
    Left = 600
    Top = 112
    Width = 65
    Height = 33
    Caption = '&Delay'
    FocusControl = edtDelay
  end
  object lblRepeat: TLabel
    Left = 600
    Top = 216
    Width = 83
    Height = 33
    Caption = '&Repeat'
    FocusControl = edtRepeat
  end
  object lblSync: TLabel
    Left = 16
    Top = 216
    Width = 130
    Height = 33
    Caption = '&Sync Audio'
    FocusControl = edtSync
  end
  object lblImg: TLabel
    Left = 16
    Top = 112
    Width = 124
    Height = 33
    Caption = '&Image File'
    FocusControl = edtImg
  end
  object lblOther: TLabel
    Left = 16
    Top = 328
    Width = 208
    Height = 33
    Caption = 'Sync &Other Media'
    FocusControl = edtOther
  end
  object lblCap: TLabel
    Left = 16
    Top = 9
    Width = 90
    Height = 33
    Caption = 'C&aption'
    FocusControl = edtCaption
  end
  object edtDelay: TSpinEdit
    Left = 600
    Top = 152
    Width = 121
    Height = 44
    Hint = 'seconds'
    MaxLength = 4
    MaxValue = 9999
    MinValue = 0
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    Value = 0
  end
  object edtRepeat: TSpinEdit
    Left = 600
    Top = 256
    Width = 121
    Height = 44
    Hint = '-1: repeat until next slide'
    MaxLength = 4
    MaxValue = 9999
    MinValue = -1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Value = 0
  end
  object edtSync: TEdit
    Left = 16
    Top = 256
    Width = 562
    Height = 41
    Hint = 'Double-click to browse'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnDblClick = edtSyncDblClick
  end
  object edtImg: TEdit
    Left = 16
    Top = 152
    Width = 562
    Height = 41
    Hint = 'Double-click to browse'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnDblClick = edtImgDblClick
  end
  object edtOther: TEdit
    Left = 16
    Top = 368
    Width = 838
    Height = 41
    Hint = 'Double-click to browse'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    OnDblClick = edtOtherDblClick
  end
  object cmdAudioLen: TButton
    Left = 736
    Top = 152
    Width = 118
    Height = 41
    Hint = 'set Delay to length in seconds of SyncAudio'
    Caption = 'alen'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = cmdAudioLenClick
  end
  object cmdDDivALen: TButton
    Left = 736
    Top = 256
    Width = 118
    Height = 41
    Hint = 'Repeat SyncAudio as often as fits within Delay'
    Caption = 'd / alen'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnClick = cmdDDivALenClick
  end
  object pnlCmd: TPanel
    Left = 0
    Top = 428
    Width = 874
    Height = 41
    Align = alBottom
    TabOrder = 8
    ExplicitLeft = 624
    ExplicitTop = 360
    ExplicitWidth = 185
    object cmdOk: TButton
      Left = 637
      Top = 1
      Width = 118
      Height = 39
      Align = alRight
      Caption = 'Ok'
      Default = True
      TabOrder = 0
      OnClick = cmdOkClick
      ExplicitLeft = 704
      ExplicitTop = 8
      ExplicitHeight = 41
    end
    object cmdCancel: TButton
      Left = 755
      Top = 1
      Width = 118
      Height = 39
      Align = alRight
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = cmdCancelClick
      ExplicitLeft = 976
      ExplicitTop = 0
      ExplicitHeight = 41
    end
  end
  object edtCaption: TEdit
    Left = 16
    Top = 49
    Width = 705
    Height = 41
    Hint = 'Double-click to browse'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object cmdFont: TButton
    Left = 736
    Top = 49
    Width = 118
    Height = 41
    Caption = '&Font'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    OnClick = cmdFontClick
  end
  object dlgFont: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [fdTrueTypeOnly, fdNoSizeSel, fdNoStyleSel, fdWysiwyg]
    Left = 664
    Top = 32
  end
end
