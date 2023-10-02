unit Frame.Dado.Corrida;

interface

uses
   Winapi.Windows,
   Winapi.Messages,
   System.SysUtils,
   System.Variants,
   System.Classes,
   Vcl.Graphics,
   Vcl.Controls,
   Vcl.Forms,
   Vcl.Dialogs,
   Vcl.StdCtrls,
   Sessao.Usuario.Logado,
   Corrida.Gateway;

type
   TFrameDadoCorrida = class(TFrame)
      LbRotuloPassageiro: TLabel;
      LbNomePassageiro: TLabel;
      LbRotuloMotorista: TLabel;
      LbNomeMotorista: TLabel;
      LbRotuloStatus: TLabel;
      LbStatusCorrida: TLabel;
      LbRotuloDestino: TLabel;
      LbRotuloDestinoLatitude: TLabel;
      LbRotuloDestinoLongitude: TLabel;
      LbDestinoLatitude: TLabel;
      LbDestinoLongitude: TLabel;
      LbTitulo: TLabel;
   private
      FGatewayCorrida: TGatewayCorrida;
      FThread: TThread;
      procedure CarregarDadosDaCorridaAtiva;
      procedure AtualizarDadosDaCorrida(pSaidaObtencaoCorridaAtiva: TDadoSaidaObtencaoCorridaAtiva);
      procedure AoTerminarThread(Sender: TObject);
   public
      constructor Create(AOwner: TComponent; pGatewayCorrida: TGatewayCorrida); reintroduce;
      destructor Destroy; override;
   end;

implementation

{$R *.dfm}

{ TFrameDadoCorrida }

constructor TFrameDadoCorrida.Create(AOwner: TComponent;
  pGatewayCorrida: TGatewayCorrida);
begin
   inherited Create(AOwner);
   if AOwner is TWinControl then
      Parent := TWinControl(AOwner);
   FGatewayCorrida := pGatewayCorrida;

   FThread := TThread.CreateAnonymousThread(CarregarDadosDaCorridaAtiva);
   FThread.FreeOnTerminate := False;
   FThread.OnTerminate := AoTerminarThread;
   FThread.Start;
end;

destructor TFrameDadoCorrida.Destroy;
begin
   if Assigned(FThread) then
   begin
      FThread.Terminate;
      FThread.WaitFor;
      FThread.Destroy;
   end;
   inherited;
end;

procedure TFrameDadoCorrida.AoTerminarThread(Sender: TObject);
begin
   if Assigned(FThread.FatalException) then
      Exception(FThread.FatalException).Message;
end;

procedure TFrameDadoCorrida.AtualizarDadosDaCorrida(pSaidaObtencaoCorridaAtiva: TDadoSaidaObtencaoCorridaAtiva);
begin
   LbTitulo.Caption           := FormatDateTime('nn:ss', Now);
   LbNomePassageiro.Caption   := pSaidaObtencaoCorridaAtiva.Passageiro;
   LbNomeMotorista.Caption    := pSaidaObtencaoCorridaAtiva.Motorista;
   LbStatusCorrida.Caption    := pSaidaObtencaoCorridaAtiva.Status;
   LbDestinoLatitude.Caption  := FormatFloat('##0.00#############', pSaidaObtencaoCorridaAtiva.Destino.Latitude);
   LbDestinoLongitude.Caption := FormatFloat('##0.00#############', pSaidaObtencaoCorridaAtiva.Destino.Longitude);
end;

procedure TFrameDadoCorrida.CarregarDadosDaCorridaAtiva;
var
   lSaidaObtencaoCorridaAtiva: TDadoSaidaObtencaoCorridaAtiva;
   lIteracao: Integer;
begin
   lIteracao := 0;
   while not FThread.CheckTerminated do
   begin
      if lIteracao mod 20 = 0 then
      begin
         lSaidaObtencaoCorridaAtiva := FGatewayCorrida.ObterCorridaAtiva(TSessaoUsuarioLogado.ID);
         TThread.Synchronize(
            TThread.CurrentThread,
            procedure
            begin
               AtualizarDadosDaCorrida(lSaidaObtencaoCorridaAtiva)
            end
         );
      end;
      Inc(lIteracao);
      TThread.Sleep(500);
   end;
end;

end.
