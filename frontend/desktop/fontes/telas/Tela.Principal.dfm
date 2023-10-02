object TelaPrincipal: TTelaPrincipal
  Left = 0
  Top = 0
  Caption = 'Motorista POP v. 1.0'
  ClientHeight = 387
  ClientWidth = 619
  Color = clWhite
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clTeal
  Font.Height = -16
  Font.Name = 'Consolas'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object GridPanelCabecalho: TGridPanel
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 603
    Height = 57
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 1
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = BtnHistoricoCorrida
        Row = 0
      end
      item
        Column = 1
        Control = LbBoasVindas
        Row = 0
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    ParentFont = False
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 0
    object BtnHistoricoCorrida: TButton
      AlignWithMargins = True
      Left = 9
      Top = 9
      Width = 144
      Height = 39
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alLeft
      Caption = 'Suas Corridas'
      DoubleBuffered = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -16
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 0
      WordWrap = True
      StyleElements = []
    end
    object LbBoasVindas: TLabel
      AlignWithMargins = True
      Left = 309
      Top = 17
      Width = 285
      Height = 23
      Margins.Left = 8
      Margins.Top = 16
      Margins.Right = 8
      Margins.Bottom = 16
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Ol'#225' <Usu'#225'rio Da Silva>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -20
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = [seClient, seBorder]
      ExplicitLeft = 352
      ExplicitWidth = 242
    end
  end
  object Panel: TPanel
    AlignWithMargins = True
    Left = 16
    Top = 73
    Width = 587
    Height = 298
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 16
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
  end
end
