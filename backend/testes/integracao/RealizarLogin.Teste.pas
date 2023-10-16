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
   TRealizarLoginTeste = class
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


{ TRealizarLoginTeste }

procedure TRealizarLoginTeste.Inicializar;
begin
   FFabricaRepositorio := TFabricaRepositorioFake.Create;
   FInscreverUsuario := TInscreverUsuario.Create(FFabricaRepositorio);
   FRealizarLogin := TRealizarLogin.Create(FFabricaRepositorio);
end;

procedure TRealizarLoginTeste.Finalizar;
begin
   FRealizarLogin.Destroy;
   FInscreverUsuario.Destroy;
   FFabricaRepositorio.Destroy;
end;

procedure TRealizarLoginTeste.DeverRealizarLoginComEmailDoUsuario;
var lEntradaInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoUsuario: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaRealizacaoLogin: TDadoEntradaRealizacaoLogin;
    lSaidaRealizacaoLogin: TDadoSaidaRealizacaoLogin;
begin
   lEntradaInscricaoUsuario.Nome         := 'John Doe';
   lEntradaInscricaoUsuario.Email        := 'john.doe.forlogin@mail.com';
   lEntradaInscricaoUsuario.CPF          := '958.187.055-52';
   lEntradaInscricaoUsuario.Passageiro   := False;
   lEntradaInscricaoUsuario.Motorista    := True;
   lEntradaInscricaoUsuario.PlacaDoCarro := 'ZZZ9A88';
   lEntradaInscricaoUsuario.Senha        := 'S3nh@F0rte';
   lSaidaInscricaoUsuario := FInscreverUsuario.Executar(lEntradaInscricaoUsuario);

   lEntradaRealizacaoLogin.Email := lEntradaInscricaoUsuario.Email;
   lEntradaRealizacaoLogin.Senha := lEntradaInscricaoUsuario.Senha;
   lSaidaRealizacaoLogin := FRealizarLogin.Executar(lEntradaRealizacaoLogin);
   Assert.AreEqual(lSaidaInscricaoUsuario.IDDoUsuario, lSaidaRealizacaoLogin.IDDoUsuario);
end;

initialization
   TDUnitX.RegisterTestFixture(TRealizarLoginTeste);
end.
