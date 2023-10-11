unit AtualizarPosicao.Teste;

interface

uses
   System.SysUtils,
   Repositorio.Fabrica,
   Repositorio.Fabrica.Fake,
   InscreverUsuario,
   SolicitarCorrida,
   AceitarCorrida,
   IniciarCorrida,
   AtualizarPosicao,
   Posicao.Repositorio,
   Posicao,
   UUID,
   DUnitX.TestFramework;

type
   [TestFixture]
   TAtualizarPosicaoTeste = class
   private
      FFabricaRepositorio: TFabricaRepositorio;
      FSolicitarCorrida: TSolicitarCorrida;
      FAceitarCorrida: TAceitarCorrida;
      FIniciarCorrida: TIniciarCorrida;
      FAtualizarPosicao: TAtualizarPosicao;
      FInscreverUsuario: TInscreverUsuario;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure SistemaDeveAtualizarAPosicaoDeUmCorrida;
      [Test]
      procedure SistemaNaoPodeAtualizarAPosicaoDeUmCorridaNaoIniciada;
   end;

implementation


{ TAtualizarPosicaoTeste }

procedure TAtualizarPosicaoTeste.Inicializar;
begin
   FFabricaRepositorio := TFabricaRepositorioFake.Create;
   FSolicitarCorrida := TSolicitarCorrida.Create(FFabricaRepositorio);
   FAceitarCorrida := TAceitarCorrida.Create(FFabricaRepositorio);
   FIniciarCorrida := TIniciarCorrida.Create(FFabricaRepositorio);
   FAtualizarPosicao := TAtualizarPosicao.Create(FFabricaRepositorio);
   FInscreverUsuario := TInscreverUsuario.Create(FFabricaRepositorio);
end;

procedure TAtualizarPosicaoTeste.Finalizar;
begin
   FInscreverUsuario.Destroy;
   FAtualizarPosicao.Destroy;
   FIniciarCorrida.Destroy;
   FAceitarCorrida.Destroy;
   FSolicitarCorrida.Destroy;
   FFabricaRepositorio.Destroy;
end;

procedure TAtualizarPosicaoTeste.SistemaDeveAtualizarAPosicaoDeUmCorrida;
var lEntradaInscricaoPassageiro: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoPassageiro: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
    lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
    lEntradaInscricaoMotorista: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoMotorista: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaAceiteCorrida: TDadoEntradaAceiteCorrida;
    lEntradaInicioCorrida: TDadoEntradaInicioCorrida;
    lEntradaAtualizacaoPosicao: TDadoEntradaAtualizacaoPosicao;
    lRepositorioPosicao: TRepositorioPosicao;
    lListaDePosicoes: TListaDePosicoes;
    lIDCorrida: TUUID;
begin
   lEntradaInscricaoPassageiro.Nome       := 'John Doe';
   lEntradaInscricaoPassageiro.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoPassageiro.CPF        := '95818705552';
   lEntradaInscricaoPassageiro.Passageiro := True;
   lEntradaInscricaoPassageiro.Motorista  := False;
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
   lSaidaInscricaoMotorista := FInscreverUsuario.Executar(lEntradaInscricaoMotorista);

   lEntradaAceiteCorrida.IDDoMotorista := lSaidaInscricaoMotorista.IDDoUsuario;
   lEntradaAceiteCorrida.IDDaCorrida   := lSaidaSolicitacaoCorrida.IDDaCorrida;
   FAceitarCorrida.Executar(lEntradaAceiteCorrida);

   lEntradaInicioCorrida.IDDoMotorista := lEntradaAceiteCorrida.IDDoMotorista;
   lEntradaInicioCorrida.IDDaCorrida   := lSaidaSolicitacaoCorrida.IDDaCorrida;
   FIniciarCorrida.Executar(lEntradaInicioCorrida);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.877291364885657;
   lEntradaAtualizacaoPosicao.Longitude   := -49.08225874081267;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:00:00', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.8773716281549;
   lEntradaAtualizacaoPosicao.Longitude   := -49.08203741452999;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:00:10', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.877635537605425;
   lEntradaAtualizacaoPosicao.Longitude   := -49.08208293312585;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:00:20', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.878860340067302;
   lEntradaAtualizacaoPosicao.Longitude   := -49.08370642971138;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:00:30', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.878982142930248;
   lEntradaAtualizacaoPosicao.Longitude   := -49.08432093077141;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:00:40', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.880315198704235;
   lEntradaAtualizacaoPosicao.Longitude   := -49.08605063741393;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:00:50', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.881201638277044;
   lEntradaAtualizacaoPosicao.Longitude   := -49.08570924794706;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:01:00', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lIDCorrida := TUUID.Create(lSaidaSolicitacaoCorrida.IDDaCorrida);
   try
      lRepositorioPosicao := FFabricaRepositorio.CriarRepositorioPosicao;
      try
         lListaDePosicoes := lRepositorioPosicao.ObterListaDePosicoesDaCorrida(lIDCorrida);
         try
            Assert.AreEqual(7, lListaDePosicoes.Count);
            Assert.IsNotEmpty(lListaDePosicoes.Items[4].ID);
            Assert.AreEqual(lSaidaSolicitacaoCorrida.IDDaCorrida, lListaDePosicoes.Items[4].IDDaCorrida);
            Assert.AreEqual(-26.878982142930248, lListaDePosicoes.Items[4].Coordenada.Latitude);
            Assert.AreEqual(-49.08432093077141, lListaDePosicoes.Items[4].Coordenada.Longitude);
            Assert.AreEqual(StrToDateTimeDef('17/09/2023 10:00:40', Now), lListaDePosicoes.Items[4].Data);
         finally
            lListaDePosicoes.Destroy;
         end;
      finally
         lRepositorioPosicao.Destroy;
      end;
   finally
      lIDCorrida.Destroy;
   end;
end;

procedure TAtualizarPosicaoTeste.SistemaNaoPodeAtualizarAPosicaoDeUmCorridaNaoIniciada;
var lEntradaInscricaoPassageiro: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoPassageiro: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
    lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
    lEntradaAtualizacaoPosicao: TDadoEntradaAtualizacaoPosicao;
begin
   lEntradaInscricaoPassageiro.Nome       := 'John Doe';
   lEntradaInscricaoPassageiro.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoPassageiro.CPF        := '95818705552';
   lEntradaInscricaoPassageiro.Passageiro := True;
   lEntradaInscricaoPassageiro.Motorista  := False;
   lSaidaInscricaoPassageiro := FInscreverUsuario.Executar(lEntradaInscricaoPassageiro);

   lEntradaSolicitacaoCorrida.IDDoPassageiro := lSaidaInscricaoPassageiro.IDDoUsuario;
   lEntradaSolicitacaoCorrida.De.Latitude     := -26.877291364885657;
   lEntradaSolicitacaoCorrida.De.Longitude    := -49.08225874081267;
   lEntradaSolicitacaoCorrida.Para.Latitude   := -26.863202471813185;
   lEntradaSolicitacaoCorrida.Para.Longitude  := -49.072482819584245;
   lSaidaSolicitacaoCorrida := FSolicitarCorrida.Executar(lEntradaSolicitacaoCorrida);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.877291364885657;
   lEntradaAtualizacaoPosicao.Longitude   := -49.08225874081267;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:00:00', Now);
   Assert.WillRaiseWithMessage(
      procedure
      begin
         FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);
      end,
      EAtualizacaoPosicaoCorridaNaoIniciada,
      'Posição da corrida não pode ser atualizada, pois a corrida não foi iniciada pelo motorista!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TAtualizarPosicaoTeste);
end.
