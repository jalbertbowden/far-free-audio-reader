object frmVoice: TfrmVoice
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Speech Properties'
  ClientHeight = 152
  ClientWidth = 673
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -27
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 240
  TextHeight = 33
  object lblVolume: TLabel
    Left = 304
    Top = 8
    Width = 89
    Height = 33
    Caption = 'Vo&lume'
    FocusControl = edtVolume
  end
  object lblRate: TLabel
    Left = 424
    Top = 8
    Width = 54
    Height = 33
    Caption = '&Rate'
    FocusControl = edtRate
  end
  object lblVoice: TLabel
    Left = 16
    Top = 8
    Width = 63
    Height = 33
    Caption = '&Voice'
    FocusControl = cmbVoice
  end
  object edtVolume: TSpinEdit
    Left = 304
    Top = 45
    Width = 89
    Height = 44
    Hint = 'Seconds to display slide'
    MaxLength = 3
    MaxValue = 100
    MinValue = 0
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Value = 100
  end
  object edtRate: TSpinEdit
    Left = 424
    Top = 45
    Width = 73
    Height = 44
    Hint = '-1: repeat until next slide'
    MaxLength = 1
    MaxValue = 5
    MinValue = 0
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    Value = 3
  end
  object pnlCmd: TPanel
    Left = 0
    Top = 111
    Width = 673
    Height = 41
    Align = alBottom
    TabOrder = 4
    ExplicitLeft = 624
    ExplicitTop = 360
    ExplicitWidth = 185
    object cmdOk: TButton
      Left = 436
      Top = 1
      Width = 118
      Height = 39
      Align = alRight
      Caption = 'Ok'
      Default = True
      TabOrder = 0
      OnClick = cmdOkClick
      ExplicitLeft = 637
    end
    object cmdCancel: TButton
      Left = 554
      Top = 1
      Width = 118
      Height = 39
      Align = alRight
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = cmdCancelClick
      ExplicitLeft = 755
    end
  end
  object cmdTest: TButton
    Left = 536
    Top = 45
    Width = 118
    Height = 41
    Caption = '&Test'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = cmdTestClick
  end
  object cmbVoice: TComboBox
    Left = 16
    Top = 48
    Width = 257
    Height = 41
    Style = csDropDownList
    Sorted = True
    TabOrder = 0
    OnChange = cmbVoiceChange
  end
  object SpVoice: TSpVoice
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 200
    Top = 16
  end
end
