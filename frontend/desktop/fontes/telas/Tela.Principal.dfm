object TelaPrincipal: TTelaPrincipal
  Left = 0
  Top = 0
  Caption = 'Motorista POP v. 1.0'
  ClientHeight = 561
  ClientWidth = 784
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LbBoasVindas: TLabel
    AlignWithMargins = True
    Left = 16
    Top = 16
    Width = 752
    Height = 23
    Margins.Left = 16
    Margins.Top = 16
    Margins.Right = 16
    Margins.Bottom = 0
    Align = alTop
    Alignment = taRightJustify
    Caption = 'Ol'#225' <Usu'#225'rio Da Silva>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -20
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = [seClient, seBorder]
    ExplicitLeft = 526
    ExplicitWidth = 242
  end
  object GridPanel: TGridPanel
    AlignWithMargins = True
    Left = 16
    Top = 55
    Width = 752
    Height = 490
    Margins.Left = 16
    Margins.Top = 16
    Margins.Right = 16
    Margins.Bottom = 16
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 180.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = PanelMenu
        Row = 0
      end>
    Ctl3D = False
    ParentCtl3D = False
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 0
    object PanelMenu: TPanel
      Left = 0
      Top = 0
      Width = 180
      Height = 490
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object GridPanelMenu: TGridPanel
        Left = 0
        Top = 0
        Width = 180
        Height = 490
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        ColumnCollection = <
          item
            Value = 100.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = BtnSolicitarCorrida
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
            SizeStyle = ssAbsolute
            Value = 50.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 50.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 50.000000000000000000
          end
          item
            Value = 100.000000000000000000
          end>
        TabOrder = 0
        object BtnSolicitarCorrida: TButton
          AlignWithMargins = True
          Left = 9
          Top = 9
          Width = 160
          Height = 42
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alClient
          Caption = 'Solicitar Corrida'
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
          OnClick = BtnSolicitarCorridaClick
        end
      end
    end
  end
end
