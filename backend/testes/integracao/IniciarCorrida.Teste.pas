unit IniciarCorrida.Teste;

interface

uses
   System.SysUtils,
   Repositorio.Fabrica,
   Repositorio.Fabrica.Fake,
   InscreverUsuario,
   SolicitarCorrida,
   AceitarCorrida,
   IniciarCorrida,
   ObterCorrida,
   Corrida,
   Corrida.Status,
   DUnitX.TestFramework;

type
   [TestFixture]
   TIniciarCorridaTeste = class
   private
      FFabricaRepositorio: TFabricaRepositorio;
      FSolicitarCorrida: TSolicitarCorrida;
      FAceitarCorrida: TAceitarCorrida;
      FIniciarCorrida: TIniciarCorrida;
      FObterCorrida: TObterCorrida;
      FInscreverUsuario: TInscreverUsuario;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure MotoristaDeveIniciarCorrida;
      [Test]
      procedure PassageiroNaoPodeIniciarCorrida;
      [Test]
      procedure MotoristaNaoPodeIniciarCorridaNaoAceita;
      [Test]
      procedure MotoristaComCorridaIniciadaNaoPodeAceitarNovaCorrida;
      [Test]
      procedure MotoristaNaoPodeAceitarCorridaAceitaPorOutroMotorista;
   end;

implementation

{ TIniciarCorridaTeste }

procedure TIniciarCorridaTeste.Inicializar;
begin
   FFabricaRepositorio := TFabricaRepositorioFake.Create;
   FSolicitarCorrida := TSolicitarCorrida.Create(FFabricaRepositorio);
   FAceitarCorrida := TAceitarCorrida.Create(FFabricaRepositorio);
   FIniciarCorrida := TIniciarCorrida.Create(FFabricaRepositorio);
   FObterCorrida := TObterCorrida.Create(FFabricaRepositorio);
   FInscreverUsuario := TInscreverUsuario.Create(FFabricaRepositorio);
end;

procedure TIniciarCorridaTeste.Finalizar;
begin
   FInscreverUsuario.Destroy;
   FObterCorrida.Destroy;
   FIniciarCorrida.Destroy;
   FAceitarCorrida.Destroy;
   FSolicitarCorrida.Destroy;
   FFabricaRepositorio.Destroy;
end;

procedure TIniciarCorridaTeste.MotoristaDeveIniciarCorrida;
var lEntradaInscricaoPassageiro: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoPassageiro: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
    lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
    lEntradaInscricaoMotorista: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoMotorista: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaAceiteCorrida: TDadoEntradaAceiteCorrida;
    lEntradaInicioCorrida: TDadoEntradaInicioCorrida;
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
   Assert.AreEqual('in_progress', lSaidaObtencaoCorrida.Status);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.De.Latitude, lSaidaObtencaoCorrida.Origem.Latitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.De.Longitude, lSaidaObtencaoCorrida.Origem.Longitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.Para.Latitude, lSaidaObtencaoCorrida.Destino.Latitude);
   Assert.AreEqual(lEntradaSolicitacaoCorrida.Para.Longitude, lSaidaObtencaoCorrida.Destino.Longitude);
end;

procedure TIniciarCorridaTeste.PassageiroNaoPodeIniciarCorrida;
var lEntradaInscricaoPassageiro: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoPassageiro: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
    lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
    lEntradaInscricaoMotorista: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoMotorista: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaAceiteCorrida: TDadoEntradaAceiteCorrida;
    lEntradaInicioCorrida: TDadoEntradaInicioCorrida;
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

   lEntradaInicioCorrida.IDDoMotorista := lEntradaSolicitacaoCorrida.IDDoPassageiro;
   lEntradaInicioCorrida.IDDaCorrida   := lSaidaSolicitacaoCorrida.IDDaCorrida;
   Assert.WillRaiseWithMessage(
      procedure
      begin
         FIniciarCorrida.Executar(lEntradaInicioCorrida);
      end,
      EInicioCorridaUsuarioNaoEhMotorista,
      'Conta de usuário não pertence a um motorista! Somente motoristas podem iniciar corridas!'
   );
end;

procedure TIniciarCorridaTeste.MotoristaNaoPodeIniciarCorridaNaoAceita;
var lEntradaInscricaoPassageiro: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoPassageiro: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
    lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
    lEntradaInscricaoMotorista: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoMotorista: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaInicioCorrida: TDadoEntradaInicioCorrida;
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

   lEntradaInicioCorrida.IDDoMotorista := lSaidaInscricaoMotorista.IDDoUsuario;
   lEntradaInicioCorrida.IDDaCorrida   := lSaidaSolicitacaoCorrida.IDDaCorrida;
   Assert.WillRaiseWithMessage(
      procedure
      begin
         FIniciarCorrida.Executar(lEntradaInicioCorrida);
      end,
      EStatusCorridaTransicaoInvalida,
      'Corrida está solicitada. Não pode ser iniciada! Primeiro deve ser aceita por um motorista!'
   );
end;

procedure TIniciarCorridaTeste.MotoristaComCorridaIniciadaNaoPodeAceitarNovaCorrida;
var lEntradaInscricaoPassageiro: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoPassageiro: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
    lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
    lEntradaInscricaoMotorista: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoMotorista: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaAceiteCorrida: TDadoEntradaAceiteCorrida;
    lEntradaInicioCorrida: TDadoEntradaInicioCorrida;
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

   lEntradaInicioCorrida.IDDoMotorista := lSaidaInscricaoMotorista.IDDoUsuario;
   lEntradaInicioCorrida.IDDaCorrida   := lSaidaSolicitacaoCorrida.IDDaCorrida;
   FIniciarCorrida.Executar(lEntradaInicioCorrida);
   Assert.WillRaiseWithMessage(
      procedure
      begin
         FIniciarCorrida.Executar(lEntradaInicioCorrida);
      end,
      EStatusCorridaTransicaoInvalida,
      'Corrida já iniciada pelo motorista. Não pode ser iniciada por um motorista novamente!'
   );
end;

procedure TIniciarCorridaTeste.MotoristaNaoPodeAceitarCorridaAceitaPorOutroMotorista;
var lEntradaInscricaoPassageiro: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoPassageiro: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
    lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
    lEntradaInscricaoMotorista1: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoMotorista1: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaAceiteCorrida: TDadoEntradaAceiteCorrida;
    lEntradaInscricaoMotorista2: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoMotorista2: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaInicioCorrida: TDadoEntradaInicioCorrida;
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

   lEntradaInscricaoMotorista1.Nome       := 'Vera Root';
   lEntradaInscricaoMotorista1.Email      := Format('vera.root.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoMotorista1.CPF        := '77550596000';
   lEntradaInscricaoMotorista1.Passageiro := False;
   lEntradaInscricaoMotorista1.Motorista  := True;
   lEntradaInscricaoMotorista1.PlacaDoCarro := 'ABC1234';
   lEntradaInscricaoMotorista1.Senha      := 'S3nh@F0rte';
   lSaidaInscricaoMotorista1 := FInscreverUsuario.Executar(lEntradaInscricaoMotorista1);

   lEntradaAceiteCorrida.IDDoMotorista := lSaidaInscricaoMotorista1.IDDoUsuario;
   lEntradaAceiteCorrida.IDDaCorrida   := lSaidaSolicitacaoCorrida.IDDaCorrida;
   FAceitarCorrida.Executar(lEntradaAceiteCorrida);

   lEntradaInscricaoMotorista2.Nome       := 'Otis Newmann';
   lEntradaInscricaoMotorista2.Email      := Format('otis.newmann.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoMotorista2.CPF        := '524.082.580-73';
   lEntradaInscricaoMotorista2.Passageiro := False;
   lEntradaInscricaoMotorista2.Motorista  := True;
   lEntradaInscricaoMotorista2.PlacaDoCarro := 'XJF1H34';
   lEntradaInscricaoMotorista2.Senha      := 'S3nh@F0rte';
   lSaidaInscricaoMotorista2 := FInscreverUsuario.Executar(lEntradaInscricaoMotorista2);

   lEntradaInicioCorrida.IDDoMotorista := lSaidaInscricaoMotorista2.IDDoUsuario;
   lEntradaInicioCorrida.IDDaCorrida   := lSaidaSolicitacaoCorrida.IDDaCorrida;
   Assert.WillRaiseWithMessage(
      procedure
      begin
         FIniciarCorrida.Executar(lEntradaInicioCorrida);
      end,
      ECorridaOutroMotorista,
      'Corrida já aceita por outro motorista!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TIniciarCorridaTeste);
end.
