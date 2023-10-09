unit ObterCorridas.Teste;

interface

uses
   System.SysUtils,
   ContaDeUsuario.Repositorio,
   ContaDeUsuario.Repositorio.Fake,
   InscreverUsuario,
   Corrida.Repositorio,
   Corrida.Repositorio.Fake,
   SolicitarCorrida,
   ObterCorridas,
   DUnitX.TestFramework;

type
   [TestFixture]
   TObterCorridasTeste = class
   private
      FRepositorioCorrida: TRepositorioCorrida;
      FSolicitarCorrida: TSolicitarCorrida;
      FRepositorioContaDeUsuario: TRepositorioContaDEUsuario;
      FInscreverUsuario: TInscreverUsuario;
      FObterCorridas: TObterCorridas;
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
   FObterCorridas := TObterCorridas.Create(FRepositorioCorrida, FRepositorioContaDeUsuario);
end;

procedure TObterCorridasTeste.Finalizar;
begin
   FInscreverUsuario.Destroy;
   FSolicitarCorrida.Destroy;
   FRepositorioContaDeUsuario.Destroy;
   FRepositorioCorrida.Destroy;
   FObterCorridas.Destroy;
end;

procedure TObterCorridasTeste.DeveObterCorridaAtivaDoPassageiro;
var lEntradaInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoUsuario: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
    lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
    lEntradaObtencaoCorridas: TDadoEntradaObtencaoCorridas;
    lSaidaObtencaoCorridas: TDadoSaidaObtencaoCorridas;
begin
   lEntradaInscricaoUsuario.Nome       := 'John Doe';
   lEntradaInscricaoUsuario.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoUsuario.CPF        := '95818705552';
   lEntradaInscricaoUsuario.Passageiro := True;
   lEntradaInscricaoUsuario.Motorista  := False;
   lSaidaInscricaoUsuario := FInscreverUsuario.Executar(lEntradaInscricaoUsuario);

   lEntradaSolicitacaoCorrida.IDDoPassageiro := lSaidaInscricaoUsuario.IDDoUsuario;
   lEntradaSolicitacaoCorrida.De.Latitude     := -26.877291364885657;
   lEntradaSolicitacaoCorrida.De.Longitude    := -49.08225874081267;
   lEntradaSolicitacaoCorrida.Para.Latitude   := -26.863202471813185;
   lEntradaSolicitacaoCorrida.Para.Longitude  := -49.072482819584245;
   lSaidaSolicitacaoCorrida := FSolicitarCorrida.Executar(lEntradaSolicitacaoCorrida);

   lEntradaObtencaoCorridas.IDDoUsuario := lEntradaSolicitacaoCorrida.IDDoPassageiro;
   lEntradaObtencaoCorridas.ListaDeStatus := ['requested'];
   lSaidaObtencaoCorridas := FObterCorridas.Executar(lEntradaObtencaoCorridas);
   Assert.AreEqual<Integer>(1, Length(lSaidaObtencaoCorridas));
   Assert.AreEqual(lEntradaObtencaoCorridas.IDDoUsuario, lSaidaObtencaoCorridas[0].Passageiro.ID);
   Assert.AreEqual(lEntradaInscricaoUsuario.Nome, lSaidaObtencaoCorridas[0].Passageiro.Nome);
   Assert.AreEqual(lEntradaInscricaoUsuario.CPF, lSaidaObtencaoCorridas[0].Passageiro.CPF);
   Assert.AreEqual(lEntradaInscricaoUsuario.Email, lSaidaObtencaoCorridas[0].Passageiro.Email);
   Assert.IsEmpty(lSaidaObtencaoCorridas[0].Motorista.ID);
   Assert.AreEqual('requested', lSaidaObtencaoCorridas[0].Status);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.De.Latitude, lSaidaObtencaoCorridas[0].Origem.Latitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.De.Longitude, lSaidaObtencaoCorridas[0].Origem.Longitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.Para.Latitude, lSaidaObtencaoCorridas[0].Destino.Latitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.Para.Longitude, lSaidaObtencaoCorridas[0].Destino.Longitude);
end;

initialization
   TDUnitX.RegisterTestFixture(TObterCorridasTeste);
end.
