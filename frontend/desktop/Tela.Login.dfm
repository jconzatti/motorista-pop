object TelaLogin: TTelaLogin
  Left = 0
  Top = 0
  Caption = 'Login'
  ClientHeight = 201
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    434
    201)
  PixelsPerInch = 96
  TextHeight = 13
  object LbEmail: TLabel
    Left = 32
    Top = 53
    Width = 54
    Height = 19
    Margins.Top = 16
    Caption = 'e-mail'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object LbNovoAqui: TLabel
    Left = 32
    Top = 91
    Width = 144
    Height = 19
    Margins.Top = 16
    Caption = #201' novo por aqui?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object EdEmail: TEdit
    Left = 92
    Top = 50
    Width = 237
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
  end
  object BtnEntrar: TButton
    Left = 335
    Top = 50
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Entrar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = BtnEntrarClick
  end
  object BtnCriarConta: TButton
    Left = 182
    Top = 89
    Width = 120
    Height = 25
    Caption = 'Inscreva-se'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
end
