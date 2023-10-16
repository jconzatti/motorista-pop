unit FinalizarCorrida.Teste;

interface

uses
   System.SysUtils,
   System.DateUtils,
   System.Math,
   Repositorio.Fabrica,
   Repositorio.Fabrica.Fake,
   InscreverUsuario,
   SolicitarCorrida,
   AceitarCorrida,
   IniciarCorrida,
   AtualizarPosicao,
   FinalizarCorrida,
   ObterCorrida,
   Corrida,
   Corrida.Status,
   DUnitX.TestFramework;

type
   [TestFixture]
   TFinalizarCorridaTeste = class
   private
      FFabricaRepositorio: TFabricaRepositorio;
      FSolicitarCorrida: TSolicitarCorrida;
      FAceitarCorrida: TAceitarCorrida;
      FIniciarCorrida: TIniciarCorrida;
      FAtualizarPosicao: TAtualizarPosicao;
      FFinalizarCorrida: TFinalizarCorrida;
      FObterCorrida: TObterCorrida;
      FInscreverUsuario: TInscreverUsuario;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure MotoristaDeveFinalizarCorrida;
      [Test]
      procedure PassageiroNaoPodeFinalizarCorrida;
   end;

implementation


{ TFinalizarCorridaTeste }

procedure TFinalizarCorridaTeste.Inicializar;
begin
   FFabricaRepositorio := TFabricaRepositorioFake.Create;
   FSolicitarCorrida := TSolicitarCorrida.Create(FFabricaRepositorio);
   FAceitarCorrida := TAceitarCorrida.Create(FFabricaRepositorio);
   FIniciarCorrida := TIniciarCorrida.Create(FFabricaRepositorio);
   FAtualizarPosicao := TAtualizarPosicao.Create(FFabricaRepositorio);
   FFinalizarCorrida := TFinalizarCorrida.Create(FFabricaRepositorio);
   FObterCorrida := TObterCorrida.Create(FFabricaRepositorio);
   FInscreverUsuario := TInscreverUsuario.Create(FFabricaRepositorio);
end;

procedure TFinalizarCorridaTeste.Finalizar;
begin
   FInscreverUsuario.Destroy;
   FObterCorrida.Destroy;
   FFinalizarCorrida.Destroy;
   FAtualizarPosicao.Destroy;
   FIniciarCorrida.Destroy;
   FAceitarCorrida.Destroy;
   FSolicitarCorrida.Destroy;
   FFabricaRepositorio.Destroy;
end;

procedure TFinalizarCorridaTeste.MotoristaDeveFinalizarCorrida;
var lEntradaInscricaoPassageiro: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoPassageiro: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
    lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
    lEntradaInscricaoMotorista: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoMotorista: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaAceiteCorrida: TDadoEntradaAceiteCorrida;
    lEntradaInicioCorrida: TDadoEntradaInicioCorrida;
    lEntradaAtualizacaoPosicao: TDadoEntradaAtualizacaoPosicao;
    lEntradaFinalizacaoCorrida: TDadoEntradaFinalizacaoCorrida;
    lSaidaObtencaoCorrida: TDadoSaidaObtencaoCorrida;
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

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.877493432607338;
   lEntradaAtualizacaoPosicao.Longitude   := -49.08182499441314;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:01:20', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.877148319656143;
   lEntradaAtualizacaoPosicao.Longitude   := -49.081991895926194;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:01:30', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.876146809542394;
   lEntradaAtualizacaoPosicao.Longitude   := -49.08127118482514;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:01:40', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.876153576520533;
   lEntradaAtualizacaoPosicao.Longitude   := -49.08071737522416;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:01:50', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.875821993534213;
   lEntradaAtualizacaoPosicao.Longitude   := -49.080133219910685;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:02:00', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.875713721326143;
   lEntradaAtualizacaoPosicao.Longitude   := -49.07891180424182;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:02:10', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.876072372611887;
   lEntradaAtualizacaoPosicao.Longitude   := -49.0782138524387;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:02:20', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.875957333638965;
   lEntradaAtualizacaoPosicao.Longitude   := -49.07759935138251;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:02:30', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.874495651839144;
   lEntradaAtualizacaoPosicao.Longitude   := -49.076264139220825;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:02:40', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.87403548884849;
   lEntradaAtualizacaoPosicao.Longitude   := -49.075679983907335;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:02:50', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.87438061126827;
   lEntradaAtualizacaoPosicao.Longitude   := -49.074162697359256;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:03:00', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.874407679644793;
   lEntradaAtualizacaoPosicao.Longitude   := -49.073836480733206;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:03:10', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.873710666783616;
   lEntradaAtualizacaoPosicao.Longitude   := -49.07222815701297;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:03:20', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.872912141888;
   lEntradaAtualizacaoPosicao.Longitude   := -49.070619833268104;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:03:30', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.87009695830931;
   lEntradaAtualizacaoPosicao.Longitude   := -49.07272127512185;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:03:40', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.868405107555443;
   lEntradaAtualizacaoPosicao.Longitude   := -49.07266817009335;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:03:50', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.86494011820015;
   lEntradaAtualizacaoPosicao.Longitude   := -49.071128124252766;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:04:00', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.863275261336934;
   lEntradaAtualizacaoPosicao.Longitude   := -49.07074880261742;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:04:10', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.863085763884705;
   lEntradaAtualizacaoPosicao.Longitude   := -49.0715984830734;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:04:20', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.862808284899742;
   lEntradaAtualizacaoPosicao.Longitude   := -49.0723798856356;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:04:30', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.86321487182394;
   lEntradaAtualizacaoPosicao.Longitude   := -49.072580310501266;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:04:40', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.863202471813185;
   lEntradaAtualizacaoPosicao.Longitude   := -49.072482819584245;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:04:50', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaFinalizacaoCorrida.IDDoMotorista := lEntradaInicioCorrida.IDDoMotorista;
   lEntradaFinalizacaoCorrida.IDDaCorrida   := lSaidaSolicitacaoCorrida.IDDaCorrida;
   FFinalizarCorrida.Executar(lEntradaFinalizacaoCorrida);

   lSaidaObtencaoCorrida := FObterCorrida.Executar(lSaidaSolicitacaoCorrida.IDDaCorrida);
   Assert.AreEqual(lSaidaSolicitacaoCorrida.IDDaCorrida, lSaidaObtencaoCorrida.ID);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.IDDoPassageiro, lSaidaObtencaoCorrida.Passageiro.ID);
   Assert.AreEqual(lEntradaInscricaoPassageiro.Nome, lSaidaObtencaoCorrida.Passageiro.Nome);
   Assert.AreEqual(lEntradaInscricaoPassageiro.CPF, lSaidaObtencaoCorrida.Passageiro.CPF);
   Assert.AreEqual(lEntradaInscricaoPassageiro.Email, lSaidaObtencaoCorrida.Passageiro.Email);
   Assert.AreEqual(lEntradaAceiteCorrida.IDDoMotorista, lSaidaObtencaoCorrida.Motorista.ID);
   Assert.AreEqual(lEntradaInscricaoMotorista.Nome, lSaidaObtencaoCorrida.Motorista.Nome);
   Assert.AreEqual(lEntradaInscricaoMotorista.CPF, lSaidaObtencaoCorrida.Motorista.CPF);
   Assert.AreEqual(lEntradaInscricaoMotorista.Email, lSaidaObtencaoCorrida.Motorista.Email);
   Assert.AreEqual(lEntradaInscricaoMotorista.PlacaDoCarro, lSaidaObtencaoCorrida.Motorista.PlacaDoCarro);
   Assert.AreEqual('completed', lSaidaObtencaoCorrida.Status);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.De.Latitude, lSaidaObtencaoCorrida.Origem.Latitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.De.Longitude, lSaidaObtencaoCorrida.Origem.Longitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.Para.Latitude, lSaidaObtencaoCorrida.Destino.Latitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.Para.Longitude, lSaidaObtencaoCorrida.Destino.Longitude);
   Assert.AreEqual(4.014, lSaidaObtencaoCorrida.Distancia);
   if InRange(HourOf(lSaidaObtencaoCorrida.Data), 6, 22) then
      Assert.AreEqual(8.43, lSaidaObtencaoCorrida.Tarifa)
   else
      Assert.AreEqual(20.07, lSaidaObtencaoCorrida.Tarifa);
end;

procedure TFinalizarCorridaTeste.PassageiroNaoPodeFinalizarCorrida;
var lEntradaInscricaoPassageiro: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoPassageiro: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
    lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
    lEntradaInscricaoMotorista: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoMotorista: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaAceiteCorrida: TDadoEntradaAceiteCorrida;
    lEntradaInicioCorrida: TDadoEntradaInicioCorrida;
    lEntradaAtualizacaoPosicao: TDadoEntradaAtualizacaoPosicao;
    lEntradaFinalizacaoCorrida: TDadoEntradaFinalizacaoCorrida;
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

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.877493432607338;
   lEntradaAtualizacaoPosicao.Longitude   := -49.08182499441314;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:01:20', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.877148319656143;
   lEntradaAtualizacaoPosicao.Longitude   := -49.081991895926194;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:01:30', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.876146809542394;
   lEntradaAtualizacaoPosicao.Longitude   := -49.08127118482514;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:01:40', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.876153576520533;
   lEntradaAtualizacaoPosicao.Longitude   := -49.08071737522416;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:01:50', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.875821993534213;
   lEntradaAtualizacaoPosicao.Longitude   := -49.080133219910685;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:02:00', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.875713721326143;
   lEntradaAtualizacaoPosicao.Longitude   := -49.07891180424182;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:02:10', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.876072372611887;
   lEntradaAtualizacaoPosicao.Longitude   := -49.0782138524387;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:02:20', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.875957333638965;
   lEntradaAtualizacaoPosicao.Longitude   := -49.07759935138251;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:02:30', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.874495651839144;
   lEntradaAtualizacaoPosicao.Longitude   := -49.076264139220825;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:02:40', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.87403548884849;
   lEntradaAtualizacaoPosicao.Longitude   := -49.075679983907335;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:02:50', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.87438061126827;
   lEntradaAtualizacaoPosicao.Longitude   := -49.074162697359256;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:03:00', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.874407679644793;
   lEntradaAtualizacaoPosicao.Longitude   := -49.073836480733206;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:03:10', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.873710666783616;
   lEntradaAtualizacaoPosicao.Longitude   := -49.07222815701297;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:03:20', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.872912141888;
   lEntradaAtualizacaoPosicao.Longitude   := -49.070619833268104;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:03:30', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.87009695830931;
   lEntradaAtualizacaoPosicao.Longitude   := -49.07272127512185;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:03:40', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.868405107555443;
   lEntradaAtualizacaoPosicao.Longitude   := -49.07266817009335;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:03:50', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.86494011820015;
   lEntradaAtualizacaoPosicao.Longitude   := -49.071128124252766;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:04:00', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.863275261336934;
   lEntradaAtualizacaoPosicao.Longitude   := -49.07074880261742;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:04:10', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.863085763884705;
   lEntradaAtualizacaoPosicao.Longitude   := -49.0715984830734;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:04:20', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.862808284899742;
   lEntradaAtualizacaoPosicao.Longitude   := -49.0723798856356;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:04:30', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.86321487182394;
   lEntradaAtualizacaoPosicao.Longitude   := -49.072580310501266;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:04:40', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaAtualizacaoPosicao.IDDaCorrida := lSaidaSolicitacaoCorrida.IDDaCorrida;
   lEntradaAtualizacaoPosicao.Latitude    := -26.863202471813185;
   lEntradaAtualizacaoPosicao.Longitude   := -49.072482819584245;
   lEntradaAtualizacaoPosicao.Data        := StrToDateTimeDef('17/09/2023 10:04:50', Now);
   FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);

   lEntradaFinalizacaoCorrida.IDDoMotorista := lEntradaSolicitacaoCorrida.IDDoPassageiro;
   lEntradaFinalizacaoCorrida.IDDaCorrida   := lSaidaSolicitacaoCorrida.IDDaCorrida;
   Assert.WillRaiseWithMessage(
      procedure
      begin
         FFinalizarCorrida.Executar(lEntradaFinalizacaoCorrida);
      end,
      EFinalizacaoCorridaUsuarioNaoEhMotorista,
      'Conta de usuário não pertence a um motorista! Somente motoristas podem finalizar corridas!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TFinalizarCorridaTeste);

end.
