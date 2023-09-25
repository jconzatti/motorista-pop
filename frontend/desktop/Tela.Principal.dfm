object TelaPrincipal: TTelaPrincipal
  Left = 0
  Top = 0
  Caption = 'Motorista POP v. 1.0'
  ClientHeight = 280
  ClientWidth = 470
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LbTelaPrincipal: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 16
    Width = 464
    Height = 23
    Margins.Top = 16
    Align = alTop
    Alignment = taCenter
    Caption = 'Tela principal'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -20
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = [seClient, seBorder]
    ExplicitWidth = 154
  end
end
