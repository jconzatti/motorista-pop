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
  Sessao.Usuario.Logado,
  HTTP.Cliente,
  HTTP.Cliente.Padrao,
  ContaDeUsuario.Gateway,
  ContaDeUsuario.Gateway.HTTP,
  Corrida.Gateway,
  Corrida.Gateway.HTTP;

type
  TTelaPrincipal = class(TForm)
    LbBoasVindas: TLabel;
    GridPanel: TGridPanel;
    PanelMenu: TPanel;
    GridPanelMenu: TGridPanel;
    BtnSolicitarCorrida: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnSolicitarCorridaClick(Sender: TObject);
  private
    { Private declarations }
    FClienteHTTP: TClienteHTTP;
    FGatewayContaDeUsuario: TGatewayContaDeUsuario;
    FGatewayCorrida: TGatewayCorrida;
    function RealizarLogin: Boolean;
    procedure CarregarBoasVindas;
    procedure SolicitarCorrida;
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

procedure TTelaPrincipal.SolicitarCorrida;
var
   lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
begin
   lEntradaSolicitacaoCorrida.IDDoPassageiro := TSessaoUsuarioLogado.ID;
   lEntradaSolicitacaoCorrida.De.Latitude     := -26.877291364885657;
   lEntradaSolicitacaoCorrida.De.Longitude    := -49.08225874081267;
   lEntradaSolicitacaoCorrida.Para.Latitude   := -26.863202471813185;
   lEntradaSolicitacaoCorrida.Para.Longitude  := -49.072482819584245;
   FGatewayCorrida.SolicitarCorrida(lEntradaSolicitacaoCorrida);
   MessageDlg('Corrida solicitada com sucesso!',mtInformation,[mbOk], 0);
end;

procedure TTelaPrincipal.BtnSolicitarCorridaClick(Sender: TObject);
begin
   SolicitarCorrida;
end;

procedure TTelaPrincipal.CarregarBoasVindas;
var lUsuario: TDadoSaidaObtencaoPorIDContaDeUsuario;
begin
   lUsuario := FGatewayContaDeUsuario.ObterPorID(TSessaoUsuarioLogado.ID);
   LbBoasVindas.Caption := Format('Olá %s', [lUsuario.Nome]);
end;

end.
