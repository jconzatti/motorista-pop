unit Tela.Principal;

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
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Tela.Login,
  Frame.SolicitarCorrida,
  Frame.Dado.Corrida,
  Sessao.Usuario.Logado,
  HTTP.Cliente,
  HTTP.Cliente.Padrao,
  ContaDeUsuario.Gateway,
  ContaDeUsuario.Gateway.HTTP,
  Corrida.Gateway,
  Corrida.Gateway.HTTP;

type
  TTelaPrincipal = class(TForm)
    GridPanelCabecalho: TGridPanel;
    BtnHistoricoCorrida: TButton;
    LbBoasVindas: TLabel;
    Panel: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FClienteHTTP: TClienteHTTP;
    FGatewayContaDeUsuario: TGatewayContaDeUsuario;
    FGatewayCorrida: TGatewayCorrida;
    FFrameSolicitarCorrida: TFrameSolicitarCorrida;
    FFrameDadoCorrida: TFrameDadoCorrida;
    function RealizarLogin: Boolean;
    procedure CarregarBoasVindas;
  public
    { Public declarations }
  end;

var
  TelaPrincipal: TTelaPrincipal;

implementation

{$R *.dfm}

procedure TTelaPrincipal.FormCreate(Sender: TObject);
begin
   FClienteHTTP := TClienteHTTPPadrao.Create;
   FGatewayContaDeUsuario := TGatewayContaDeUsuarioHTTP.Create(FClienteHTTP);
   FGatewayCorrida := TGatewayCorridaHTTP.Create(FClienteHTTP);
end;

procedure TTelaPrincipal.FormDestroy(Sender: TObject);
begin
   FGatewayCorrida.Destroy;
   FGatewayContaDeUsuario.Destroy;
   FClienteHTTP.Destroy;
end;

procedure TTelaPrincipal.FormShow(Sender: TObject);
begin
   if RealizarLogin then
   begin
      CarregarBoasVindas;
      try
         FFrameDadoCorrida := TFrameDadoCorrida.Create(Panel, FGatewayCorrida);
      except
         FFrameSolicitarCorrida := TFrameSolicitarCorrida.Create(Panel, FGatewayCorrida);
      end;
   end else
   begin
      Application.Terminate;
   end;
end;

function TTelaPrincipal.RealizarLogin: Boolean;
var lTelaLogin: TTelaLogin;
begin
   lTelaLogin:= TTelaLogin.Create(Self, FGatewayContaDeUsuario);
   try
      lTelaLogin.ShowModal;
   finally
      lTelaLogin.Destroy;
   end;
   Result := not TSessaoUsuarioLogado.ID.IsEmpty;
end;

procedure TTelaPrincipal.CarregarBoasVindas;
var lUsuario: TDadoSaidaObtencaoPorIDContaDeUsuario;
begin
   lUsuario := FGatewayContaDeUsuario.ObterPorID(TSessaoUsuarioLogado.ID);
   LbBoasVindas.Caption := Format('Olá %s', [lUsuario.Nome]);
end;

end.
