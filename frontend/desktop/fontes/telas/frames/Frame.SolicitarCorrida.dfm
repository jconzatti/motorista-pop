object FrameSolicitarCorrida: TFrameSolicitarCorrida
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  Align = alClient
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clTeal
  Font.Height = -16
  Font.Name = 'Consolas'
  Font.Style = [fsBold]
  ParentCtl3D = False
  ParentFont = False
  TabOrder = 0
  object LbTitulo: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 304
    Height = 22
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = 'SOLICITAR CORRIDA'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -19
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 170
  end
  object GridPanel: TGridPanel
    Left = 0
    Top = 30
    Width = 320
    Height = 210
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = BtnSolicitarCorrida
        Row = 2
      end>
    RowCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 50.000000000000000000
      end>
    TabOrder = 0
    object BtnSolicitarCorrida: TButton
      AlignWithMargins = True
      Left = 112
      Top = 168
      Width = 200
      Height = 34
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Caption = 'Solicitar Corrida'
      DoubleBuffered = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -19
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
