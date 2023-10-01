unit ContaDeUsuario.Gateway.HTTP.Teste;

interface

uses
   System.SysUtils,
   HTTP.Cliente,
   HTTP.Cliente.Padrao,
   ContaDeUsuario.Gateway,
   ContaDeUsuario.Gateway.HTTP,
   DUnitX.TestFramework;

type
   [TestFixture]
   TGatewayContaDeUsuarioHTTPTeste = class
   private
      FClienteHTTP : TClienteHTTP;
      FGatewayContaDeUsuario: TGatewayContaDeUsuario;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure DeveRegistrarUmUsuario;
      [Test]
      procedure NaoPodeRegistrarUsuarioComDadoInvalido;
      [Test]
      procedure DeveObterUmUsuarioPorID;
      [Test]
      procedure DeveDispararUmaExcecaoAoObterUsuarioPorIDVazio;
      [Test]
      procedure NaoPodeObterUsuarioPorIDInvalido;
      [Test]
      procedure DeveRealizarLogin;
      [Test]
      procedure DeveDispararUmaExcecaoAoRealizarLoginSemEmail;
      [Test]
      procedure NaoPodeRealizarLoginComEmailInvalido;
   end;

implementation


{ TGatewayContaDeUsuarioHTTPTeste }

procedure TGatewayContaDeUsuarioHTTPTeste.Inicializar;
begin
   FClienteHTTP := TClienteHTTPPadrao.Create;
   FGatewayContaDeUsuario := TGatewayContaDeUsuarioHTTP.Create(FClienteHTTP);
end;

procedure TGatewayContaDeUsuarioHTTPTeste.Finalizar;
begin
   FGatewayContaDeUsuario.Destroy;
   FClienteHTTP.Destroy;
end;

procedure TGatewayContaDeUsuarioHTTPTeste.DeveRegistrarUmUsuario;
var lEntradaDaContaDeUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lIDDaContaDeUsuario: string;
begin
   lEntradaDaContaDeUsuario.Nome  := 'John Doe';
   lEntradaDaContaDeUsuario.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeUsuario.CPF   := '958.187.055-52';
   lEntradaDaContaDeUsuario.Passageiro := True;
   lEntradaDaContaDeUsuario.Motorista  := False;
   lIDDaContaDeUsuario := FGatewayContaDeUsuario.InscreverUsuario(lEntradaDaContaDeUsuario);
   Assert.IsNotEmpty(lIDDaContaDeUsuario);
end;

procedure TGatewayContaDeUsuarioHTTPTeste.NaoPodeRegistrarUsuarioComDadoInvalido;
var lEntradaDaContaDeUsuario: TDadoEntradaInscricaoContaDeUsuario;
begin
   lEntradaDaContaDeUsuario.Nome  := 'John';
   lEntradaDaContaDeUsuario.Email := 'john.doe.com';
   lEntradaDaContaDeUsuario.CPF   := '958.187.055-51';
   lEntradaDaContaDeUsuario.Passageiro := True;
   lEntradaDaContaDeUsuario.Motorista  := False;
   Assert.WillRaise(
      procedure
      begin
         FGatewayContaDeUsuario.InscreverUsuario(lEntradaDaContaDeUsuario);
      end,
      Exception
   );
end;

procedure TGatewayContaDeUsuarioHTTPTeste.DeveObterUmUsuarioPorID;
var lEntradaDaContaDeUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lIDDaContaDeUsuario: string;
    lSaidaContaDeUsuario: TDadoSaidaObtencaoPorIDContaDeUsuario;
begin
   lEntradaDaContaDeUsuario.Nome  := 'John Doe';
   lEntradaDaContaDeUsuario.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeUsuario.CPF   := '95818705552';
   lEntradaDaContaDeUsuario.Passageiro := True;
   lEntradaDaContaDeUsuario.Motorista  := False;
   lIDDaContaDeUsuario := FGatewayContaDeUsuario.InscreverUsuario(lEntradaDaContaDeUsuario);
   lSaidaContaDeUsuario := FGatewayContaDeUsuario.ObterPorID(lIDDaContaDeUsuario);
   Assert.AreEqual(lEntradaDaContaDeUsuario.Nome, lSaidaContaDeUsuario.Nome);
   Assert.AreEqual(lEntradaDaContaDeUsuario.CPF, lSaidaContaDeUsuario.CPF);
   Assert.AreEqual(lEntradaDaContaDeUsuario.Email, lSaidaContaDeUsuario.Email);
   Assert.AreEqual(lEntradaDaContaDeUsuario.PlacaDoCarro, lSaidaContaDeUsuario.PlacaDoCarro);
   Assert.AreEqual(lEntradaDaContaDeUsuario.Passageiro, lSaidaContaDeUsuario.Passageiro);
   Assert.AreEqual(lEntradaDaContaDeUsuario.Motorista, lSaidaContaDeUsuario.Motorista);
end;

procedure TGatewayContaDeUsuarioHTTPTeste.DeveDispararUmaExcecaoAoObterUsuarioPorIDVazio;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         FGatewayContaDeUsuario.ObterPorID('')
      end,
      EArgumentException,
      'ID de usuário não informado!'
   );
end;

procedure TGatewayContaDeUsuarioHTTPTeste.NaoPodeObterUsuarioPorIDInvalido;
begin
   Assert.WillRaise(
      procedure
      begin
         FGatewayContaDeUsuario.ObterPorID('1234567890')
      end,
      Exception
   );
end;

procedure TGatewayContaDeUsuarioHTTPTeste.DeveRealizarLogin;
var lEntradaDaContaDeUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lIDDaContaDeUsuario: string;
begin
   lEntradaDaContaDeUsuario.Nome  := 'John Doe';
   lEntradaDaContaDeUsuario.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeUsuario.CPF   := '95818705552';
   lEntradaDaContaDeUsuario.Passageiro := True;
   lEntradaDaContaDeUsuario.Motorista  := False;
   lIDDaContaDeUsuario := FGatewayContaDeUsuario.InscreverUsuario(lEntradaDaContaDeUsuario);
   Assert.AreEqual(lIDDaContaDeUsuario, FGatewayContaDeUsuario.RealizarLogin(lEntradaDaContaDeUsuario.Email));
end;

procedure TGatewayContaDeUsuarioHTTPTeste.NaoPodeRealizarLoginComEmailInvalido;
begin
   Assert.WillRaise(
      procedure
      begin
         FGatewayContaDeUsuario.RealizarLogin('john.doe.com')
      end,
      Exception
   );
end;

procedure TGatewayContaDeUsuarioHTTPTeste.DeveDispararUmaExcecaoAoRealizarLoginSemEmail;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         FGatewayContaDeUsuario.RealizarLogin('')
      end,
      EArgumentException,
      'e-mail não informado!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TGatewayContaDeUsuarioHTTPTeste);
end.
