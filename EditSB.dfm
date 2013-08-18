object frmSB: TfrmSB
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Sound Bite'
  ClientHeight = 261
  ClientWidth = 606
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
  object lblAudio: TLabel
    Left = 24
    Top = 16
    Width = 115
    Height = 33
    Caption = '&Audio File'
    FocusControl = edtAudio
  end
  object lblDelay: TLabel
    Left = 24
    Top = 120
    Width = 99
    Height = 33
    Caption = '&StartPos'
    FocusControl = edtStart
  end
  object lblDur: TLabel
    Left = 200
    Top = 120
    Width = 102
    Height = 33
    Caption = '&Duration'
    FocusControl = edtDur
  end
  object edtAudio: TEdit
    Left = 24
    Top = 56
    Width = 562
    Height = 41
    Hint = 'Double-click to browse'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnDblClick = edtAudioDblClick
  end
  object edtStart: TSpinEdit
    Left = 24
    Top = 160
    Width = 129
    Height = 44
    Hint = 'seconds'
    MaxLength = 4
    MaxValue = 9999
    MinValue = 0
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Value = 0
  end
  object edtDur: TSpinEdit
    Left = 200
    Top = 159
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
  object pnlCmd: TPanel
    Left = 0
    Top = 220
    Width = 606
    Height = 41
    Align = alBottom
    TabOrder = 4
    ExplicitLeft = -38
    ExplicitTop = 326
    ExplicitWidth = 883
    object cmdOk: TButton
      Left = 369
      Top = 1
      Width = 118
      Height = 39
      Align = alRight
      Caption = 'Ok'
      Default = True
      TabOrder = 0
      OnClick = cmdOkClick
      ExplicitLeft = 646
    end
    object cmdCancel: TButton
      Left = 487
      Top = 1
      Width = 118
      Height = 39
      Align = alRight
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = cmdCancelClick
      ExplicitLeft = 764
    end
  end
  object cmdTest: TButton
    Left = 468
    Top = 161
    Width = 118
    Height = 39
    Caption = '&Test'
    TabOrder = 3
    OnClick = cmdTestClick
  end
  object tmr: TTimer
    Enabled = False
    Interval = 1100
    OnTimer = tmrTimer
    Left = 384
    Top = 128
  end
end
