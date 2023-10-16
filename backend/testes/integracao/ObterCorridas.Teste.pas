unit ObterCorridas.Teste;

interface

uses
   System.SysUtils,
   Repositorio.Fabrica,
   Repositorio.Fabrica.Fake,
   Corrida.Repositorio,
   InscreverUsuario,
   SolicitarCorrida,
   AceitarCorrida,
   ObterCorridas,
   DUnitX.TestFramework;

type
   [TestFixture]
   TObterCorridasTeste = class
   private
      FFabricaRepositorio: TFabricaRepositorio;
      FSolicitarCorrida: TSolicitarCorrida;
      FAceitarCorrida: TAceitarCorrida;
      FInscreverUsuario: TInscreverUsuario;
      FObterCorridas: TObterCorridas;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure DeveObterCorridaAtivaDoPassageiro;
      [Test]
      procedure DeveObterCorridaAtivaDoMotorista;
      [Test]
      procedure DeveDispararErroAoObterCorridasDeUsuarioSemCorridas;
   end;

implementation


{ TObterCorridasTeste }

procedure TObterCorridasTeste.Inicializar;
begin
   FFabricaRepositorio := TFabricaRepositorioFake.Create;
   FSolicitarCorrida := TSolicitarCorrida.Create(FFabricaRepositorio);
   FAceitarCorrida := TAceitarCorrida.Create(FFabricaRepositorio);
   FInscreverUsuario := TInscreverUsuario.Create(FFabricaRepositorio);
   FObterCorridas := TObterCorridas.Create(FFabricaRepositorio);
end;

procedure TObterCorridasTeste.Finalizar;
begin
   FObterCorridas.Destroy;
   FInscreverUsuario.Destroy;
   FAceitarCorrida.Destroy;
   FSolicitarCorrida.Destroy;
   FFabricaRepositorio.Destroy;
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
   lEntradaInscricaoUsuario.Senha      := 'S3nh@F0rte';
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

procedure TObterCorridasTeste.DeveObterCorridaAtivaDoMotorista;
var lEntradaInscricaoPassageiro: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoPassageiro: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
    lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
    lEntradaInscricaoMotorista: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoMotorista: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaAceiteCorrida: TDadoEntradaAceiteCorrida;
    lEntradaObtencaoCorridas: TDadoEntradaObtencaoCorridas;
    lSaidaObtencaoCorridas: TDadoSaidaObtencaoCorridas;
begin
   lEntradaInscricaoPassageiro.Nome       := 'John Doe';
   lEntradaInscricaoPassageiro.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoPassageiro.CPF        := '95818705552';
   lEntradaInscricaoPassageiro.Passageiro := True;
   lEntradaInscricaoPassageiro.Motorista  := False;
   lEntradaInscricaoPassageiro.Senha      := 'S3nh@F0rte';
   lSaidaInscricaoPassageiro := FInscreverUsuario.Executar(lEntradaInscricaoPassageiro);

   lEntradaSolicitacaoCorrida.IDDoPassageiro := lSaidaInscricaoPassageiro.IDDoUsuario;
   lEntradaSolicitacaoCorrida.De.Latitude     := -26.877291364885657;
   lEntradaSolicitacaoCorrida.De.Longitude    := -49.08225874081267;
   lEntradaSolicitacaoCorrida.Para.Latitude   := -26.863202471813185;
   lEntradaSolicitacaoCorrida.Para.Longitude  := -49.072482819584245;
   lSaidaSolicitacaoCorrida := FSolicitarCorrida.Executar(lEntradaSolicitacaoCorrida);

   lEntradaInscricaoMotorista.Nome       := 'Vera Root';
   lEntradaInscricaoMotorista.Email      := Format('vera.root.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoMotorista.CPF        := '77550596000';
   lEntradaInscricaoMotorista.Passageiro := False;
   lEntradaInscricaoMotorista.Motorista  := True;
   lEntradaInscricaoMotorista.PlacaDoCarro := 'ABC1234';
   lEntradaInscricaoMotorista.Senha      := 'S3nh@F0rte';
   lSaidaInscricaoMotorista := FInscreverUsuario.Executar(lEntradaInscricaoMotorista);

   lEntradaAceiteCorrida.IDDoMotorista := lSaidaInscricaoMotorista.IDDoUsuario;
   lEntradaAceiteCorrida.IDDaCorrida   := lSaidaSolicitacaoCorrida.IDDaCorrida;
   FAceitarCorrida.Executar(lEntradaAceiteCorrida);

   lEntradaObtencaoCorridas.IDDoUsuario := lEntradaAceiteCorrida.IDDoMotorista;
   lEntradaObtencaoCorridas.ListaDeStatus := ['accepted'];
   lSaidaObtencaoCorridas := FObterCorridas.Executar(lEntradaObtencaoCorridas);
   Assert.AreEqual<Integer>(1, Length(lSaidaObtencaoCorridas));
   Assert.AreEqual(lSaidaInscricaoPassageiro.IDDoUsuario, lSaidaObtencaoCorridas[0].Passageiro.ID);
   Assert.AreEqual(lEntradaInscricaoPassageiro.Nome, lSaidaObtencaoCorridas[0].Passageiro.Nome);
   Assert.AreEqual(lEntradaInscricaoPassageiro.CPF, lSaidaObtencaoCorridas[0].Passageiro.CPF);
   Assert.AreEqual(lEntradaInscricaoPassageiro.Email, lSaidaObtencaoCorridas[0].Passageiro.Email);
   Assert.AreEqual(lEntradaAceiteCorrida.IDDoMotorista, lSaidaObtencaoCorridas[0].Motorista.ID);
   Assert.AreEqual(lEntradaInscricaoMotorista.Nome, lSaidaObtencaoCorridas[0].Motorista.Nome);
   Assert.AreEqual(lEntradaInscricaoMotorista.CPF, lSaidaObtencaoCorridas[0].Motorista.CPF);
   Assert.AreEqual(lEntradaInscricaoMotorista.Email, lSaidaObtencaoCorridas[0].Motorista.Email);
   Assert.AreEqual(lEntradaInscricaoMotorista.PlacaDoCarro, lSaidaObtencaoCorridas[0].Motorista.PlacaDoCarro);
   Assert.AreEqual('accepted', lSaidaObtencaoCorridas[0].Status);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.De.Latitude, lSaidaObtencaoCorridas[0].Origem.Latitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.De.Longitude, lSaidaObtencaoCorridas[0].Origem.Longitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.Para.Latitude, lSaidaObtencaoCorridas[0].Destino.Latitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.Para.Longitude, lSaidaObtencaoCorridas[0].Destino.Longitude);
end;

procedure TObterCorridasTeste.DeveDispararErroAoObterCorridasDeUsuarioSemCorridas;
var lEntradaInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoUsuario: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaObtencaoCorridas: TDadoEntradaObtencaoCorridas;
begin
   lEntradaInscricaoUsuario.Nome       := 'John Doe';
   lEntradaInscricaoUsuario.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoUsuario.CPF        := '95818705552';
   lEntradaInscricaoUsuario.Passageiro := True;
   lEntradaInscricaoUsuario.Motorista  := False;
   lEntradaInscricaoUsuario.Senha      := 'S3nh@F0rte';
   lSaidaInscricaoUsuario := FInscreverUsuario.Executar(lEntradaInscricaoUsuario);

   lEntradaObtencaoCorridas.IDDoUsuario := lSaidaInscricaoUsuario.IDDoUsuario;
   lEntradaObtencaoCorridas.ListaDeStatus := ['requested'];
   Assert.WillRaiseWithMessage(
      procedure
      begin
         FObterCorridas.Executar(lEntradaObtencaoCorridas);
      end,
      ERepositorioCorridaNaoEncontrada,
      'Nenhuma corrida encontrada!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TObterCorridasTeste);
end.
