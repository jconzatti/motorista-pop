unit AceitarCorrida.Teste;

interface

uses
   System.SysUtils,
   Repositorio.Fabrica,
   Repositorio.Fabrica.Fake,
   InscreverUsuario,
   SolicitarCorrida,
   AceitarCorrida,
   ObterCorrida,
   Corrida.Status,
   DUnitX.TestFramework;

type
   [TestFixture]
   TAceitarCorridaTeste = class
   private
      FFabricaRepositorio: TFabricaRepositorio;
      FSolicitarCorrida: TSolicitarCorrida;
      FAceitarCorrida: TAceitarCorrida;
      FObterCorrida: TObterCorrida;
      FInscreverUsuario: TInscreverUsuario;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure MotoristaDeveAceitarCorrida;
      [Test]
      procedure PassageiroNaoPodeAceitarCorrida;
      [Test]
      procedure MotoristaNaoPodeAceitarCorridaNaoSolicitada;
      [Test]
      procedure MotoristaComCorridaAceitaNaoPodeAceitarNovaCorrida;
   end;

implementation


{ TAceitarCorridaTeste }

procedure TAceitarCorridaTeste.Inicializar;
begin
   FFabricaRepositorio := TFabricaRepositorioFake.Create;
   FSolicitarCorrida := TSolicitarCorrida.Create(FFabricaRepositorio);
   FAceitarCorrida := TAceitarCorrida.Create(FFabricaRepositorio);
   FObterCorrida := TObterCorrida.Create(FFabricaRepositorio);
   FInscreverUsuario := TInscreverUsuario.Create(FFabricaRepositorio);
end;

procedure TAceitarCorridaTeste.Finalizar;
begin
   FInscreverUsuario.Destroy;
   FObterCorrida.Destroy;
   FAceitarCorrida.Destroy;
   FSolicitarCorrida.Destroy;
   FFabricaRepositorio.Destroy;
end;

procedure TAceitarCorridaTeste.MotoristaDeveAceitarCorrida;
var lEntradaInscricaoPassageiro: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoPassageiro: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
    lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
    lEntradaInscricaoMotorista: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoMotorista: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaAceiteCorrida: TDadoEntradaAceiteCorrida;
    lSaidaObtencaoCorrida: TDadoSaidaObtencaoCorrida;
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
   Assert.AreEqual('accepted', lSaidaObtencaoCorrida.Status);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.De.Latitude, lSaidaObtencaoCorrida.Origem.Latitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.De.Longitude, lSaidaObtencaoCorrida.Origem.Longitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.Para.Latitude, lSaidaObtencaoCorrida.Destino.Latitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.Para.Longitude, lSaidaObtencaoCorrida.Destino.Longitude);
end;

procedure TAceitarCorridaTeste.PassageiroNaoPodeAceitarCorrida;
var lEntradaInscricaoPassageiro: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoPassageiro: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
    lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
    lEntradaAceiteCorrida: TDadoEntradaAceiteCorrida;
begin
   lEntradaInscricaoPassageiro.Nome       := 'John Doe';
   lEntradaInscricaoPassageiro.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoPassageiro.CPF        := '958.187.055-52';
   lEntradaInscricaoPassageiro.Passageiro := True;
   lEntradaInscricaoPassageiro.Motorista  := False;
   lSaidaInscricaoPassageiro := FInscreverUsuario.Executar(lEntradaInscricaoPassageiro);

   lEntradaSolicitacaoCorrida.IDDoPassageiro := lSaidaInscricaoPassageiro.IDDoUsuario;
   lEntradaSolicitacaoCorrida.De.Latitude     := -26.877291364885657;
   lEntradaSolicitacaoCorrida.De.Longitude    := -49.08225874081267;
   lEntradaSolicitacaoCorrida.Para.Latitude   := -26.863202471813185;
   lEntradaSolicitacaoCorrida.Para.Longitude  := -49.072482819584245;
   lSaidaSolicitacaoCorrida := FSolicitarCorrida.Executar(lEntradaSolicitacaoCorrida);

   lEntradaAceiteCorrida.IDDoMotorista := lSaidaInscricaoPassageiro.IDDoUsuario;
   lEntradaAceiteCorrida.IDDaCorrida   := lSaidaSolicitacaoCorrida.IDDaCorrida;

   Assert.WillRaiseWithMessage(
      procedure
      begin
         FAceitarCorrida.Executar(lEntradaAceiteCorrida);
      end,
      EAceiteCorridaUsuarioNaoEhMotorista,
      'Conta de usuário não pertence a um motorista! Somente motoristas podem aceitar corridas!'
   );
end;

procedure TAceitarCorridaTeste.MotoristaNaoPodeAceitarCorridaNaoSolicitada;
var lEntradaInscricaoPassageiro: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoPassageiro: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
    lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
    lEntradaInscricaoMotorista1: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoMotorista1: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaAceiteCorrida1: TDadoEntradaAceiteCorrida;
    lEntradaInscricaoMotorista2: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoMotorista2: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaAceiteCorrida2: TDadoEntradaAceiteCorrida;
begin
   lEntradaInscricaoPassageiro.Nome       := 'John Doe';
   lEntradaInscricaoPassageiro.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoPassageiro.CPF        := '958.187.055-52';
   lEntradaInscricaoPassageiro.Passageiro := True;
   lEntradaInscricaoPassageiro.Motorista  := False;
   lSaidaInscricaoPassageiro := FInscreverUsuario.Executar(lEntradaInscricaoPassageiro);

   lEntradaSolicitacaoCorrida.IDDoPassageiro := lSaidaInscricaoPassageiro.IDDoUsuario;
   lEntradaSolicitacaoCorrida.De.Latitude     := -26.877291364885657;
   lEntradaSolicitacaoCorrida.De.Longitude    := -49.08225874081267;
   lEntradaSolicitacaoCorrida.Para.Latitude   := -26.863202471813185;
   lEntradaSolicitacaoCorrida.Para.Longitude  := -49.072482819584245;
   lSaidaSolicitacaoCorrida := FSolicitarCorrida.Executar(lEntradaSolicitacaoCorrida);

   lEntradaInscricaoMotorista1.Nome       := 'Vera Root';
   lEntradaInscricaoMotorista1.Email      := Format('vera.root.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoMotorista1.CPF        := '775.505.960-00';
   lEntradaInscricaoMotorista1.Passageiro := False;
   lEntradaInscricaoMotorista1.Motorista  := True;
   lEntradaInscricaoMotorista1.PlacaDoCarro := 'ABC1234';
   lSaidaInscricaoMotorista1 := FInscreverUsuario.Executar(lEntradaInscricaoMotorista1);

   lEntradaAceiteCorrida1.IDDoMotorista := lSaidaInscricaoMotorista1.IDDoUsuario;
   lEntradaAceiteCorrida1.IDDaCorrida   := lSaidaSolicitacaoCorrida.IDDaCorrida;
   FAceitarCorrida.Executar(lEntradaAceiteCorrida1);

   lEntradaInscricaoMotorista2.Nome       := 'Otis Newmann';
   lEntradaInscricaoMotorista2.Email      := Format('otis.newmann.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoMotorista2.CPF        := '524.082.580-73';
   lEntradaInscricaoMotorista2.Passageiro := False;
   lEntradaInscricaoMotorista2.Motorista  := True;
   lEntradaInscricaoMotorista2.PlacaDoCarro := 'XJF1H34';
   lSaidaInscricaoMotorista2 := FInscreverUsuario.Executar(lEntradaInscricaoMotorista2);

   lEntradaAceiteCorrida2.IDDoMotorista := lSaidaInscricaoMotorista2.IDDoUsuario;
   lEntradaAceiteCorrida2.IDDaCorrida   := lSaidaSolicitacaoCorrida.IDDaCorrida;

   Assert.WillRaiseWithMessage(
      procedure
      begin
         FAceitarCorrida.Executar(lEntradaAceiteCorrida2);
      end,
      EStatusCorridaTransicaoInvalida,
      'Corrida foi aceita por um motorista. Não pode ser aceita por um motorista novamente!'
   );
end;

procedure TAceitarCorridaTeste.MotoristaComCorridaAceitaNaoPodeAceitarNovaCorrida;
var lEntradaInscricaoPassageiro: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoPassageiro: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
    lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
    lEntradaInscricaoMotorista: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoMotorista: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaAceiteCorrida: TDadoEntradaAceiteCorrida;
begin
   lEntradaInscricaoPassageiro.Nome       := 'John Doe';
   lEntradaInscricaoPassageiro.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoPassageiro.CPF        := '958.187.055-52';
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
   lEntradaInscricaoMotorista.CPF        := '775.505.960-00';
   lEntradaInscricaoMotorista.Passageiro := False;
   lEntradaInscricaoMotorista.Motorista  := True;
   lEntradaInscricaoMotorista.PlacaDoCarro := 'ABC1234';
   lSaidaInscricaoMotorista := FInscreverUsuario.Executar(lEntradaInscricaoMotorista);

   lEntradaAceiteCorrida.IDDoMotorista := lSaidaInscricaoMotorista.IDDoUsuario;
   lEntradaAceiteCorrida.IDDaCorrida   := lSaidaSolicitacaoCorrida.IDDaCorrida;
   FAceitarCorrida.Executar(lEntradaAceiteCorrida);


   Assert.WillRaiseWithMessage(
      procedure
      begin
         FAceitarCorrida.Executar(lEntradaAceiteCorrida);
      end,
      EAceiteCorridaMotoristaJaPossuiCorridaAtiva,
      'Motorista possui corridas ativas! Não pode aceitar corridas!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TAceitarCorridaTeste);
end.
