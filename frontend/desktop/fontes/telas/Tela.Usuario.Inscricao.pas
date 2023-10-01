unit Tela.Usuario.Inscricao;

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
  Vcl.Mask,
  Sessao.Usuario.Logado,
  ContaDeUsuario.Gateway;

type
  TTelaInscricaoUsuario = class(TForm)
    LbEmail: TLabel;
    EdEmail: TEdit;
    LbNome: TLabel;
    EdNome: TEdit;
    LbCPF: TLabel;
    LbPlacaDoCarro: TLabel;
    CkBxPassageiro: TCheckBox;
    CkBxMotorista: TCheckBox;
    MkEdCPF: TMaskEdit;
    MkEdPlacaDoCarro: TMaskEdit;
    BtnInscrever: TButton;
    procedure BtnInscreverClick(Sender: TObject);
    procedure CkBxMotoristaClick(Sender: TObject);
  private
    { Private declarations }
    FGatewayContaDeUsuario: TGatewayContaDeUsuario;
    procedure InscreverUsuarioERegistrarNaSessao;
    procedure ConfigurarLeiauteParaPerfilDeUsuario(pMotorista: Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; pGatewayContaDeUsuario: TGatewayContaDeUsuario); reintroduce;
  end;

implementation

{$R *.dfm}

{ TTelaInscricaoUsuario }

constructor TTelaInscricaoUsuario.Create(AOwner: TComponent;
  pGatewayContaDeUsuario: TGatewayContaDeUsuario);
begin
   inherited Create(AOwner);
   FGatewayContaDeUsuario := pGatewayContaDeUsuario;
   ConfigurarLeiauteParaPerfilDeUsuario(False);
end;

procedure TTelaInscricaoUsuario.BtnInscreverClick(Sender: TObject);
begin
   InscreverUsuarioERegistrarNaSessao;
   Close;
end;

procedure TTelaInscricaoUsuario.InscreverUsuarioERegistrarNaSessao;
var
   lUsuario: TDadoEntradaInscricaoContaDeUsuario;
   lIDDoUsuario : String;
begin
   lUsuario.Nome       := EdNome.Text;
   lUsuario.Email      := EdEmail.Text;
   lUsuario.CPF        := MkEdCPF.Text;
   lUsuario.Passageiro := CkBxPassageiro.Checked;
   lUsuario.Motorista  := CkBxMotorista.Checked;
   if lUsuario.Motorista then
      lUsuario.PlacaDoCarro := MkEdPlacaDoCarro.Text;
   lIDDoUsuario := FGatewayContaDeUsuario.InscreverUsuario(lUsuario);
   TSessaoUsuarioLogado.Registrar(lIDDoUsuario);
end;

procedure TTelaInscricaoUsuario.CkBxMotoristaClick(Sender: TObject);
begin
   ConfigurarLeiauteParaPerfilDeUsuario(CkBxMotorista.Checked);
end;

procedure TTelaInscricaoUsuario.ConfigurarLeiauteParaPerfilDeUsuario(
  pMotorista: Boolean);
begin
   LbPlacaDoCarro.Visible   := pMotorista;
   MkEdPlacaDoCarro.Visible := pMotorista;
end;

end.
