unit Tela.Login.Teste;

interface

uses
   System.SysUtils,
   Tela.Login,
   Sessao.Usuario.Logado,
   HTTP.Cliente.Padrao,
   ContaDeUsuario.Gateway,
   ContaDeUsuario.Gateway.HTTP,
   DUnitX.TestFramework;

type
   [TestFixture]
   TTelaLoginTeste = class
   private
      FClienteHTTP: TClienteHTTPPadrao;
      FGatewayContaDeUsuario: TGatewayContaDeUsuarioHTTP;
      FTelaLogin : TTelaLogin;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure DeveRealizarLogin;
   end;

implementation


{ TUsuarioTeste }

procedure TTelaLoginTeste.Inicializar;
begin
   FClienteHTTP := TClienteHTTPPadrao.Create;
   FGatewayContaDeUsuario := TGatewayContaDeUsuarioHTTP.Create(FClienteHTTP);
   FTelaLogin := TTelaLogin.Create(nil, FGatewayContaDeUsuario);
end;

procedure TTelaLoginTeste.Finalizar;
begin
   FTelaLogin.Destroy;
   FGatewayContaDeUsuario.Destroy;
   FClienteHTTP.Destroy;
end;

procedure TTelaLoginTeste.DeveRealizarLogin;
var lEntradaDaContaDeUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lIDDaContaDeUsuario: string;
begin
   TSessaoUsuarioLogado.Registrar('');

   lEntradaDaContaDeUsuario.Nome  := 'John Doe';
   lEntradaDaContaDeUsuario.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeUsuario.CPF   := '958.187.055-52';
   lEntradaDaContaDeUsuario.Passageiro := True;
   lEntradaDaContaDeUsuario.Motorista  := False;
   lIDDaContaDeUsuario := FGatewayContaDeUsuario.InscreverUsuario(lEntradaDaContaDeUsuario);

   FTelaLogin.EdEmail.Text := lEntradaDaContaDeUsuario.Email;
   FTelaLogin.BtnEntrar.Click;
   Assert.IsNotEmpty(TSessaoUsuarioLogado.ID);
end;

initialization
   TDUnitX.RegisterTestFixture(TTelaLoginTeste);
end.
