object FrameCoordenada: TFrameCoordenada
  AlignWithMargins = True
  Left = 0
  Top = 0
  Width = 400
  Height = 85
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
    Width = 384
    Height = 19
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = 'T'#237'tulo de Coordenadas Geograficas'
    ExplicitLeft = 3
    ExplicitTop = 3
    ExplicitWidth = 297
  end
  object FlowPanel: TFlowPanel
    AlignWithMargins = True
    Left = 8
    Top = 30
    Width = 384
    Height = 47
    Margins.Left = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 16
    ExplicitTop = 42
    ExplicitWidth = 313
    ExplicitHeight = 143
    object PanelLatitude: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 180
      Height = 40
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      DesignSize = (
        180
        40)
      object LbLatitude: TLabel
        Left = 0
        Top = 0
        Width = 56
        Height = 15
        Caption = 'Latitude'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Consolas'
        Font.Style = [fsBold]
        ParentFont = False
        StyleElements = [seClient, seBorder]
      end
      object EdLatitude: TEdit
        Left = 0
        Top = 16
        Width = 180
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelInner = bvNone
        BevelOuter = bvNone
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Consolas'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        ExplicitWidth = 150
      end
    end
    object PanelLongitude: TPanel
      AlignWithMargins = True
      Left = 190
      Top = 4
      Width = 180
      Height = 40
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      DesignSize = (
        180
        40)
      object LbLongitude: TLabel
        Left = -1
        Top = -1
        Width = 63
        Height = 15
        Caption = 'Longitude'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -13
        Font.Name = 'Consolas'
        Font.Style = [fsBold]
        ParentFont = False
        StyleElements = [seClient, seBorder]
      end
      object EdLongitude: TEdit
        Left = 0
        Top = 16
        Width = 180
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BevelInner = bvNone
        BevelOuter = bvNone
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Consolas'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
      end
    end
  end
end
