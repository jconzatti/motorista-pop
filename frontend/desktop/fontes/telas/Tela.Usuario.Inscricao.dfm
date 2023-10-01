object TelaInscricaoUsuario: TTelaInscricaoUsuario
  Left = 0
  Top = 0
  Caption = 'Inscri'#231#227'o de usu'#225'rio'
  ClientHeight = 411
  ClientWidth = 584
  Color = clBtnFace
  Constraints.MinHeight = 395
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    584
    411)
  PixelsPerInch = 96
  TextHeight = 13
  object LbEmail: TLabel
    Left = 20
    Top = 77
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
  object LbNome: TLabel
    Left = 20
    Top = 10
    Width = 36
    Height = 19
    Margins.Top = 16
    Caption = 'Nome'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object LbCPF: TLabel
    Left = 20
    Top = 146
    Width = 27
    Height = 19
    Margins.Top = 16
    Caption = 'CPF'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object LbPlacaDoCarro: TLabel
    Left = 20
    Top = 290
    Width = 126
    Height = 19
    Margins.Top = 16
    Caption = 'Placa do Carro'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object EdEmail: TEdit
    Left = 20
    Top = 102
    Width = 545
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
    TabOrder = 1
    ExplicitWidth = 445
  end
  object EdNome: TEdit
    Left = 20
    Top = 35
    Width = 545
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
    ExplicitWidth = 445
  end
  object CkBxPassageiro: TCheckBox
    Left = 20
    Top = 216
    Width = 200
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Perfil de passageiro'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 3
  end
  object CkBxMotorista: TCheckBox
    Left = 20
    Top = 256
    Width = 200
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Perfil de motorista'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 4
    OnClick = CkBxMotoristaClick
  end
  object MkEdCPF: TMaskEdit
    Left = 20
    Top = 171
    Width = 199
    Height = 25
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    EditMask = '999.999.999-99;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    MaxLength = 14
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    Text = '   .   .   -  '
  end
  object MkEdPlacaDoCarro: TMaskEdit
    Left = 20
    Top = 315
    Width = 193
    Height = 25
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    EditMask = '>lll-9999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    MaxLength = 8
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 5
    Text = '   -    '
  end
  object BtnInscrever: TButton
    Left = 465
    Top = 370
    Width = 100
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Inscrever'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = BtnInscreverClick
    ExplicitLeft = 365
    ExplicitTop = 315
  end
end
