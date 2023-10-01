unit Tela.Usuario.Inscricao.Teste;

interface

uses
   System.SysUtils,
   Sessao.Usuario.Logado,
   HTTP.Cliente.Padrao,
   ContaDeUsuario.Gateway,
   ContaDeUsuario.Gateway.HTTP,
   Tela.Usuario.Inscricao,
   DUnitX.TestFramework;

type
   [TestFixture]
   TTelaInscricaoUsuarioTeste = class
   private
      FClienteHTTP: TClienteHTTPPadrao;
      FGatewayContaDeUsuario: TGatewayContaDeUsuarioHTTP;
      FTelaInscricaoUsuario : TTelaInscricaoUsuario;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure DeveInscreverUmUsuario;
   end;

implementation


{ TTelaInscricaoUsuarioTeste }

procedure TTelaInscricaoUsuarioTeste.Inicializar;
begin
   FClienteHTTP := TClienteHTTPPadrao.Create;
   FGatewayContaDeUsuario := TGatewayContaDeUsuarioHTTP.Create(FClienteHTTP);
   FTelaInscricaoUsuario := TTelaInscricaoUsuario.Create(nil, FGatewayContaDeUsuario);
end;

procedure TTelaInscricaoUsuarioTeste.Finalizar;
begin
   FTelaInscricaoUsuario.Destroy;
   FGatewayContaDeUsuario.Destroy;
   FClienteHTTP.Destroy;
end;

procedure TTelaInscricaoUsuarioTeste.DeveInscreverUmUsuario;
begin
   TSessaoUsuarioLogado.Registrar('');
   FTelaInscricaoUsuario.EdNome.Text            := 'John Doe';
   FTelaInscricaoUsuario.EdEmail.Text           := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   FTelaInscricaoUsuario.MkEdCPF.Text           := '958.187.055-52';
   FTelaInscricaoUsuario.CkBxPassageiro.Checked := False;
   FTelaInscricaoUsuario.CkBxMotorista.Checked  := True;
   FTelaInscricaoUsuario.MkEdPlacaDoCarro.Text  := 'AAA-0000';
   FTelaInscricaoUsuario.BtnInscrever.Click;
   Assert.IsNotEmpty(TSessaoUsuarioLogado.ID);
end;

initialization
   TDUnitX.RegisterTestFixture(TTelaInscricaoUsuarioTeste);
end.
