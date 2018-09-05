object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 568
  ClientWidth = 1100
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object MemoResp: TMemo
    Left = 89
    Top = 8
    Width = 1000
    Height = 552
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object btnSend: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 1
    OnClick = btnSendClick
  end
end
