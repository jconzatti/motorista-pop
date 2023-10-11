unit ObterCorrida.Teste;

interface

uses
   System.SysUtils,
   Repositorio.Fabrica,
   Repositorio.Fabrica.Fake,
   Corrida.Repositorio,
   InscreverUsuario,
   SolicitarCorrida,
   ObterCorrida,
   UUID,
   DUnitX.TestFramework;

type
   [TestFixture]
   TObterCorridaTeste = class
      FFabricaRepositorio: TFabricaRepositorio;
      FSolicitarCorrida: TSolicitarCorrida;
      FInscreverUsuario: TInscreverUsuario;
      FObterCorrida: TObterCorrida;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure DeveObterCorrida;
      [Test]
      procedure DeveDispararErroAoObterCorridaPorIDNaoEncontrado;
   end;

implementation


{ TObterCorridaTeste }

procedure TObterCorridaTeste.Inicializar;
begin
   FFabricaRepositorio := TFabricaRepositorioFake.Create;
   FSolicitarCorrida := TSolicitarCorrida.Create(FFabricaRepositorio);
   FInscreverUsuario := TInscreverUsuario.Create(FFabricaRepositorio);
   FObterCorrida := TObterCorrida.Create(FFabricaRepositorio);
end;

procedure TObterCorridaTeste.Finalizar;
begin
   FObterCorrida.Destroy;
   FInscreverUsuario.Destroy;
   FSolicitarCorrida.Destroy;
   FFabricaRepositorio.Destroy;
end;

procedure TObterCorridaTeste.DeveObterCorrida;
var lEntradaInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoUsuario: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
    lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
    lSaidaObtencaoCorrida: TDadoSaidaObtencaoCorrida;
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

   lSaidaObtencaoCorrida := FObterCorrida.Executar(lSaidaSolicitacaoCorrida.IDDaCorrida);
   Assert.AreEqual(lSaidaSolicitacaoCorrida.IDDaCorrida, lSaidaObtencaoCorrida.ID);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.IDDoPassageiro, lSaidaObtencaoCorrida.Passageiro.ID);
   Assert.AreEqual(lEntradaInscricaoUsuario.Nome, lSaidaObtencaoCorrida.Passageiro.Nome);
   Assert.AreEqual(lEntradaInscricaoUsuario.CPF, lSaidaObtencaoCorrida.Passageiro.CPF);
   Assert.AreEqual(lEntradaInscricaoUsuario.Email, lSaidaObtencaoCorrida.Passageiro.Email);
   Assert.IsEmpty(lSaidaObtencaoCorrida.Motorista.ID);
   Assert.AreEqual('requested', lSaidaObtencaoCorrida.Status);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.De.Latitude, lSaidaObtencaoCorrida.Origem.Latitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.De.Longitude, lSaidaObtencaoCorrida.Origem.Longitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.Para.Latitude, lSaidaObtencaoCorrida.Destino.Latitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.Para.Longitude, lSaidaObtencaoCorrida.Destino.Longitude);
end;

procedure TObterCorridaTeste.DeveDispararErroAoObterCorridaPorIDNaoEncontrado;
var
   lIDDaCorrida: String;
begin
   lIDDaCorrida := TUUID.Gerar;
   Assert.WillRaiseWithMessage(
      procedure
      begin
         FObterCorrida.Executar(lIDDaCorrida)
      end,
      ERepositorioCorridaNaoEncontrada,
      Format('Corrida com ID %s não encontada!', [lIDDaCorrida])
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TObterCorridaTeste);
end.
