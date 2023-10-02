unit Frame.SolicitarCorrida;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.UITypes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Sessao.Usuario.Logado,
  Corrida.Gateway,
  Frame.Coordenada;

type
   TFrameSolicitarCorrida = class(TFrame)
      LbTitulo: TLabel;
      GridPanel: TGridPanel;
      BtnSolicitarCorrida: TButton;
      procedure BtnSolicitarCorridaClick(Sender: TObject);
   private
      FGatewayCorrida: TGatewayCorrida;
      FFrameCoordenadaOrigem: TFrameCoordenada;
      FFrameCoordenadaDestino: TFrameCoordenada;
      procedure SolicitarCorrida;
   public
      constructor Create(AOwner: TComponent; pGatewayCorrida: TGatewayCorrida); reintroduce;
      destructor Destroy; override;
   end;

implementation

{$R *.dfm}

{ TFrameSolicitarCorrida }

constructor TFrameSolicitarCorrida.Create(AOwner: TComponent;
  pGatewayCorrida: TGatewayCorrida);
begin
   inherited Create(AOwner);
   if AOwner is TWinControl then
      Parent := TWinControl(AOwner);

   FGatewayCorrida := pGatewayCorrida;
   FFrameCoordenadaOrigem  := TFrameCoordenada.Create(GridPanel, 'Origem');
   FFrameCoordenadaOrigem.Name := 'FrameCoordenadaOrigem';
   FFrameCoordenadaDestino := TFrameCoordenada.Create(GridPanel, 'Destino');
   FFrameCoordenadaDestino.Name := 'FrameCoordenadaDestino';
   GridPanel.ControlCollection.AddControl(FFrameCoordenadaOrigem);
   GridPanel.ControlCollection.AddControl(FFrameCoordenadaDestino);
end;

destructor TFrameSolicitarCorrida.Destroy;
begin
   if Assigned(FFrameCoordenadaOrigem) then
      FFrameCoordenadaOrigem.Destroy;
   if Assigned(FFrameCoordenadaDestino) then
      FFrameCoordenadaDestino.Destroy;
   inherited;
end;

procedure TFrameSolicitarCorrida.BtnSolicitarCorridaClick(Sender: TObject);
begin
   try
      SolicitarCorrida;
   finally
      Self.Destroy;
   end;
end;

procedure TFrameSolicitarCorrida.SolicitarCorrida;
var
   lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
begin
   lEntradaSolicitacaoCorrida.IDDoPassageiro := TSessaoUsuarioLogado.ID;
   lEntradaSolicitacaoCorrida.De.Latitude     := FFrameCoordenadaOrigem.Latitude;
   lEntradaSolicitacaoCorrida.De.Longitude    := FFrameCoordenadaOrigem.Longitude;
   lEntradaSolicitacaoCorrida.Para.Latitude   := FFrameCoordenadaDestino.Latitude;
   lEntradaSolicitacaoCorrida.Para.Longitude  := FFrameCoordenadaDestino.Longitude;
   FGatewayCorrida.SolicitarCorrida(lEntradaSolicitacaoCorrida);
   MessageDlg('Corrida solicitada com sucesso!',mtInformation,[mbOk], 0);
end;

end.
