unit ObterContaDeUsuario.Teste;

interface

uses
   System.SysUtils,
   System.DateUtils,
   Repositorio.Fabrica,
   Repositorio.Fabrica.Fake,
   InscreverUsuario,
   ObterContaDeUsuario,
   DUnitX.TestFramework;

type
   [TestFixture]
   TObterContaDeUsuarioTeste = class
   private
      FFabricaRepositorio: TFabricaRepositorio;
      FInscreverUsuario: TInscreverUsuario;
      FObterContaDeUsuario: TObterContaDeUsuario;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure DeveObterUmaContaDeUsuario;
   end;

implementation


{ TObterContaDeUsuarioTeste }

procedure TObterContaDeUsuarioTeste.Inicializar;
begin
   FFabricaRepositorio := TFabricaRepositorioFake.Create;
   FInscreverUsuario := TInscreverUsuario.Create(FFabricaRepositorio);
   FObterContaDeUsuario := TObterContaDeUsuario.Create(FFabricaRepositorio);
end;

procedure TObterContaDeUsuarioTeste.Finalizar;
begin
   FObterContaDeUsuario.Destroy;
   FInscreverUsuario.Destroy;
   FFabricaRepositorio.Destroy;
end;

procedure TObterContaDeUsuarioTeste.DeveObterUmaContaDeUsuario;
var lEntradaInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoUsuario: TDadoSaidaInscricaoContaDeUsuario;
    lSaidaObtencaoUsuario: TDadoSaidaObtencaoContaDeUsuario;
begin
   lEntradaInscricaoUsuario.Nome         := 'John Doe';
   lEntradaInscricaoUsuario.Email        := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoUsuario.CPF          := '958.187.055-52';
   lEntradaInscricaoUsuario.Passageiro   := False;
   lEntradaInscricaoUsuario.Motorista    := True;
   lEntradaInscricaoUsuario.PlacaDoCarro := 'ZZZ9A88';
   lEntradaInscricaoUsuario.Senha        := 'S3nh@F0rte';
   lSaidaInscricaoUsuario := FInscreverUsuario.Executar(lEntradaInscricaoUsuario);

   lSaidaObtencaoUsuario := FObterContaDeUsuario.Executar(lSaidaInscricaoUsuario.IDDoUsuario);
   Assert.AreEqual(lSaidaInscricaoUsuario.IDDoUsuario, lSaidaObtencaoUsuario.ID);
   Assert.AreEqual('John Doe', lSaidaObtencaoUsuario.Nome);
   Assert.AreEqual(lEntradaInscricaoUsuario.Email, lSaidaObtencaoUsuario.Email);
   Assert.AreEqual('95818705552', lSaidaObtencaoUsuario.CPF);
   Assert.IsFalse(lSaidaObtencaoUsuario.Passageiro);
   Assert.IsTrue(lSaidaObtencaoUsuario.Motorista);
   Assert.AreEqual('ZZZ9A88', lSaidaObtencaoUsuario.PlacaDoCarro);
   Assert.AreEqual(Date, DateOf(lSaidaObtencaoUsuario.Data));
end;

initialization
   TDUnitX.RegisterTestFixture(TObterContaDeUsuarioTeste);
end.
