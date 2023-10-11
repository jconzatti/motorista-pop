unit RealizarLogin.Teste;

interface

uses
   Repositorio.Fabrica,
   Repositorio.Fabrica.Fake,
   InscreverUsuario,
   RealizarLogin,
   DUnitX.TestFramework;

type
   [TestFixture]
   RealizarLoginTeste = class
   private
      FFabricaRepositorio: TFabricaRepositorio;
      FInscreverUsuario: TInscreverUsuario;
      FRealizarLogin: TRealizarLogin;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure DeverRealizarLoginComEmailDoUsuario;
   end;

implementation


{ RealizarLoginTeste }

procedure RealizarLoginTeste.Inicializar;
begin
   FFabricaRepositorio := TFabricaRepositorioFake.Create;
   FInscreverUsuario := TInscreverUsuario.Create(FFabricaRepositorio);
   FRealizarLogin := TRealizarLogin.Create(FFabricaRepositorio);
end;

procedure RealizarLoginTeste.Finalizar;
begin
   FRealizarLogin.Destroy;
   FInscreverUsuario.Destroy;
   FFabricaRepositorio.Destroy;
end;

procedure RealizarLoginTeste.DeverRealizarLoginComEmailDoUsuario;
var lEntradaInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoUsuario: TDadoSaidaInscricaoContaDeUsuario;
    lSaidaRealizacaoLogin: TDadoSaidaRealizacaoLogin;
begin
   lEntradaInscricaoUsuario.Nome         := 'John Doe';
   lEntradaInscricaoUsuario.Email        := 'john.doe.forlogin@mail.com';
   lEntradaInscricaoUsuario.CPF          := '958.187.055-52';
   lEntradaInscricaoUsuario.Passageiro   := False;
   lEntradaInscricaoUsuario.Motorista    := True;
   lEntradaInscricaoUsuario.PlacaDoCarro := 'ZZZ9A88';
   lSaidaInscricaoUsuario := FInscreverUsuario.Executar(lEntradaInscricaoUsuario);

   lSaidaRealizacaoLogin := FRealizarLogin.Executar('john.doe.forlogin@mail.com');
   Assert.AreEqual(lSaidaInscricaoUsuario.IDDoUsuario, lSaidaRealizacaoLogin.IDDoUsuario);
end;

initialization
   TDUnitX.RegisterTestFixture(RealizarLoginTeste);
end.
