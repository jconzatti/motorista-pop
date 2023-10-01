unit Tela.Login;

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
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Sessao.Usuario.Logado,
  ContaDeUsuario.Gateway,
  Tela.Usuario.Inscricao;

type
  TTelaLogin = class(TForm)
    LbEmail: TLabel;
    EdEmail: TEdit;
    BtnEntrar: TButton;
    LbNovoAqui: TLabel;
    BtnCriarConta: TButton;
    procedure BtnEntrarClick(Sender: TObject);
    procedure EdEmailKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnCriarContaClick(Sender: TObject);
  private
    { Private declarations }
    FGatewayContaDeUsuario: TGatewayContaDeUsuario;
    procedure RegistrarUsuarioLogadoNaSessao;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; pGatewayContaDeUsuario: TGatewayContaDeUsuario); reintroduce;
  end;

implementation

{$R *.dfm}

constructor TTelaLogin.Create(AOwner: TComponent; pGatewayContaDeUsuario: TGatewayContaDeUsuario);
begin
   inherited Create(AOwner);
   FGatewayContaDeUsuario := pGatewayContaDeUsuario;
end;

procedure TTelaLogin.EdEmailKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_RETURN then
      BtnEntrar.Click;
end;

procedure TTelaLogin.BtnCriarContaClick(Sender: TObject);
var
   lTelaInscricaoUsuario : TTelaInscricaoUsuario;
begin
   lTelaInscricaoUsuario := TTelaInscricaoUsuario.Create(Self, FGatewayContaDeUsuario);
   try
      lTelaInscricaoUsuario.ShowModal;
      if not TSessaoUsuarioLogado.ID.IsEmpty then
         Close;
   finally
      lTelaInscricaoUsuario.Destroy;
   end;
end;

procedure TTelaLogin.BtnEntrarClick(Sender: TObject);
begin
   RegistrarUsuarioLogadoNaSessao;
   Close;
end;

procedure TTelaLogin.RegistrarUsuarioLogadoNaSessao;
var
   lIDDoUsuario : String;
begin
   try
      lIDDoUsuario := FGatewayContaDeUsuario.RealizarLogin(EdEmail.Text);
      TSessaoUsuarioLogado.Registrar(lIDDoUsuario);
   except
      if Self.Visible and EdEmail.CanFocus then
         EdEmail.SetFocus;
      raise;
   end;
end;

end.
