unit ObterCorridaAtivaDoUsuario.Teste;

interface

uses
   System.SysUtils,
   ContaDeUsuario.Repositorio,
   ContaDeUsuario.Repositorio.Fake,
   InscreverUsuario,
   Corrida.Repositorio,
   Corrida.Repositorio.Fake,
   SolicitarCorrida,
   Corrida,
   ObterCorridaAtivaDoUsuario,
   DUnitX.TestFramework;

type
   [TestFixture]
   TObterCorridasTeste = class
   private
      FRepositorioCorrida: TRepositorioCorrida;
      FSolicitarCorrida: TSolicitarCorrida;
      FRepositorioContaDeUsuario: TRepositorioContaDEUsuario;
      FInscreverUsuario: TInscreverUsuario;
      FObterCorridaAtivaDoUsuario: TObterCorridaAtivaDoUsuario;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure DeveObterCorridaAtivaDoPassageiro;
   end;

implementation


{ TObterCorridasTeste }

procedure TObterCorridasTeste.Inicializar;
begin
   FRepositorioCorrida := TRepositorioCorridaFake.Create;
   FRepositorioContaDeUsuario := TRepositorioContaDeUsuarioFake.Create;
   FSolicitarCorrida := TSolicitarCorrida.Create(FRepositorioCorrida, FRepositorioContaDeUsuario);
   FInscreverUsuario := TInscreverUsuario.Create(FRepositorioContaDeUsuario);
   FObterCorridaAtivaDoUsuario := TObterCorridaAtivaDoUsuario.Create(FRepositorioCorrida, FRepositorioContaDeUsuario);
end;

procedure TObterCorridasTeste.Finalizar;
begin
   FInscreverUsuario.Destroy;
   FSolicitarCorrida.Destroy;
   FRepositorioContaDeUsuario.Destroy;
   FRepositorioCorrida.Destroy;
   FObterCorridaAtivaDoUsuario.Destroy;
end;

procedure TObterCorridasTeste.DeveObterCorridaAtivaDoPassageiro;
var lEntradaInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoUsuario: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
    lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
    lSaidaObtencaoCorridaAtiva: TDadoSaidaObtencaoCorridaAtiva;
begin
   lEntradaInscricaoUsuario.Nome       := 'John Doe';
   lEntradaInscricaoUsuario.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoUsuario.CPF        := '958.187.055-52';
   lEntradaInscricaoUsuario.Passageiro := True;
   lEntradaInscricaoUsuario.Motorista  := False;
   lSaidaInscricaoUsuario := FInscreverUsuario.Executar(lEntradaInscricaoUsuario);

   lEntradaSolicitacaoCorrida.IDDoPassageiro := lSaidaInscricaoUsuario.IDDoUsuario;
   lEntradaSolicitacaoCorrida.De.Latitude     := -26.877291364885657;
   lEntradaSolicitacaoCorrida.De.Longitude    := -49.08225874081267;
   lEntradaSolicitacaoCorrida.Para.Latitude   := -26.863202471813185;
   lEntradaSolicitacaoCorrida.Para.Longitude  := -49.072482819584245;
   lSaidaSolicitacaoCorrida := FSolicitarCorrida.Executar(lEntradaSolicitacaoCorrida);

   lSaidaObtencaoCorridaAtiva := FObterCorridaAtivaDoUsuario.Executar(lEntradaSolicitacaoCorrida.IDDoPassageiro);
   Assert.AreEqual(lEntradaInscricaoUsuario.Nome, lSaidaObtencaoCorridaAtiva.Passageiro);
   Assert.IsEmpty(lSaidaObtencaoCorridaAtiva.Motorista);
   Assert.AreEqual('requested', lSaidaObtencaoCorridaAtiva.Status);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.Para.Latitude, lSaidaObtencaoCorridaAtiva.Destino.Latitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.Para.Longitude, lSaidaObtencaoCorridaAtiva.Destino.Longitude);
end;

initialization
   TDUnitX.RegisterTestFixture(TObterCorridasTeste);
end.
