unit Corrida.Servico.Teste;

interface

uses
   System.Math,
   System.SysUtils,
   System.DateUtils,
   ContaUsuario.DAO,
   ContaUsuario.DAO.Fake,
   ContaUsuario.Servico,
   Corrida.DAO,
   Corrida.DAO.Fake,
   Posicao.DAO,
   Posicao.DAO.Fake,
   Corrida.Servico,
   DUnitX.TestFramework;

type
   [TestFixture]
   TServicoCorridaTeste = class
   private
      FDAOContaUsuario : TDAOContaUsuarioFake;
      FDAOCorrida : TDAOCorridaFake;
      FDAOPosicao : TDAOPosicaoFake;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure PassageiroDeveSolicitarCorrida;
      [Test]
      procedure MotoristaNaoPodeSolicitarCorrida;
      [Test]
      procedure PassageiroComCorridasAtivasNaoPodeSolicitarNovaCorrida;
      [Test]
      procedure MotoristaDeveAceitarCorrida;
      [Test]
      procedure PassageiroNaoPodeAceitarCorrida;
      [Test]
      procedure MotoristaNaoPodeAceitarCorridaNaoSolicitada;
      [Test]
      procedure MotoristaComCorridasAtivasNaoPodeAceitarNovaCorrida;
      [Test]
      procedure MotoristaDeveIniciarCorrida;
      [Test]
      procedure MotoristaNaoPodeIniciarCorridaNaoAceita;
      [Test]
      procedure MotoristaDeveFinalizarCorrida;
      [Test]
      procedure MotoristaNaoPodeFinalizarCorridaNaoIniciada;
      [Test]
      procedure SistemaDeveAtualizarAPosicaoDeUmCorrida;
      [Test]
      procedure SistemaNaoPodeAtualizarAPosicaoDeUmCorridaNaoIniciada;
      [Test]
      procedure MotoristaDeveFinalizarCorridaComDistanciaPercorridaETarifa;
   end;

implementation


{ TServicoCorridaTeste }

procedure TServicoCorridaTeste.Inicializar;
begin
   FDAOContaUsuario := TDAOContaUsuarioFake.Create;
   FDAOCorrida := TDAOCorridaFake.Create;
   FDAOPosicao := TDAOPosicaoFake.Create;
end;

procedure TServicoCorridaTeste.Finalizar;
begin
   FDAOPosicao.Destroy;
   FDAOCorrida.Destroy;
   FDAOContaUsuario.Destroy;
end;

procedure TServicoCorridaTeste.PassageiroDeveSolicitarCorrida;
var lEntradaDaContaDeUsuario: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
    lIDDoPassageiro: string;
    lEntradaDaSolicitacaoDeCorrida: TDadoSolicitacaoCorrida;
    lServicoCorrida: TServicoCorrida;
    lIDDaCorrida: string;
    lCorrida: TDadoCorrida;
begin
   lEntradaDaContaDeUsuario.Nome  := 'John Doe';
   lEntradaDaContaDeUsuario.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeUsuario.CPF   := '958.187.055-52';
   lEntradaDaContaDeUsuario.Passageiro := True;
   lEntradaDaContaDeUsuario.Motorista  := False;
   lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
   try
      lIDDoPassageiro := lServicoContaUsuario.Inscrever(lEntradaDaContaDeUsuario);
   finally
      lServicoContaUsuario.Destroy;
   end;

   lEntradaDaSolicitacaoDeCorrida.IDDoPassageiro := lIDDoPassageiro;
   lEntradaDaSolicitacaoDeCorrida.DeLatitude     := -26.877291364885657;
   lEntradaDaSolicitacaoDeCorrida.DeLongitude    := -49.08225874081267;
   lEntradaDaSolicitacaoDeCorrida.ParaLatitude   := -26.863202471813185;
   lEntradaDaSolicitacaoDeCorrida.ParaLongitude  := -49.072482819584245;
   lServicoCorrida := TServicoCorrida.Create(FDAOContaUsuario, FDAOCorrida, FDAOPosicao);
   try
      lIDDaCorrida := lServicoCorrida.Solicitar(lEntradaDaSolicitacaoDeCorrida);
      lCorrida := lServicoCorrida.Obter(lIDDaCorrida);
      Assert.IsNotEmpty(lCorrida.ID);
      Assert.AreEqual('requested', lCorrida.Status);
      Assert.AreEqual(Date, DateOf(lCorrida.Data));
   finally
      lServicoCorrida.Destroy;
   end;
end;

procedure TServicoCorridaTeste.MotoristaNaoPodeSolicitarCorrida;
var lEntradaDaContaDeUsuario: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
    lIDDoUsuario: string;
    lEntradaDaSolicitacaoDeCorrida: TDadoSolicitacaoCorrida;
    lServicoCorrida: TServicoCorrida;
begin
   lEntradaDaContaDeUsuario.Nome  := 'John Doe';
   lEntradaDaContaDeUsuario.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeUsuario.CPF   := '958.187.055-52';
   lEntradaDaContaDeUsuario.PlacaDoCarro := 'AAA9999';
   lEntradaDaContaDeUsuario.Passageiro := False;
   lEntradaDaContaDeUsuario.Motorista  := True;
   lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
   try
      lIDDoUsuario := lServicoContaUsuario.Inscrever(lEntradaDaContaDeUsuario);
   finally
      lServicoContaUsuario.Destroy;
   end;

   lEntradaDaSolicitacaoDeCorrida.IDDoPassageiro := lIDDoUsuario;
   lEntradaDaSolicitacaoDeCorrida.DeLatitude     := -26.877291364885657;
   lEntradaDaSolicitacaoDeCorrida.DeLongitude    := -49.08225874081267;
   lEntradaDaSolicitacaoDeCorrida.ParaLatitude   := -26.863202471813185;
   lEntradaDaSolicitacaoDeCorrida.ParaLongitude  := -49.072482819584245;

   Assert.WillRaiseWithMessage(
      procedure
      begin
         lServicoCorrida := TServicoCorrida.Create(FDAOContaUsuario, FDAOCorrida, FDAOPosicao);
         try
            lServicoCorrida.Solicitar(lEntradaDaSolicitacaoDeCorrida);
         finally
            lServicoCorrida.Destroy;
         end;
      end,
      EArgumentException,
      'Conta de usuário não pertence a um passageiro!'
   );
end;

procedure TServicoCorridaTeste.PassageiroComCorridasAtivasNaoPodeSolicitarNovaCorrida;
var lEntradaDaContaDeUsuario: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
    lIDDoPassageiro: string;
    lEntradaDaSolicitacaoDeCorrida: TDadoSolicitacaoCorrida;
    lServicoCorrida: TServicoCorrida;
begin
   lEntradaDaContaDeUsuario.Nome  := 'John Doe';
   lEntradaDaContaDeUsuario.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeUsuario.CPF   := '958.187.055-52';
   lEntradaDaContaDeUsuario.Passageiro := True;
   lEntradaDaContaDeUsuario.Motorista  := False;
   lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
   try
      lIDDoPassageiro := lServicoContaUsuario.Inscrever(lEntradaDaContaDeUsuario);
   finally
      lServicoContaUsuario.Destroy;
   end;

   lEntradaDaSolicitacaoDeCorrida.IDDoPassageiro := lIDDoPassageiro;
   lEntradaDaSolicitacaoDeCorrida.DeLatitude     := -26.877291364885657;
   lEntradaDaSolicitacaoDeCorrida.DeLongitude    := -49.08225874081267;
   lEntradaDaSolicitacaoDeCorrida.ParaLatitude   := -26.863202471813185;
   lEntradaDaSolicitacaoDeCorrida.ParaLongitude  := -49.072482819584245;

   Assert.WillRaiseWithMessage(
      procedure
      begin
         lServicoCorrida := TServicoCorrida.Create(FDAOContaUsuario, FDAOCorrida, FDAOPosicao);
         try
            lServicoCorrida.Solicitar(lEntradaDaSolicitacaoDeCorrida);
            lServicoCorrida.Solicitar(lEntradaDaSolicitacaoDeCorrida);
         finally
            lServicoCorrida.Destroy;
         end;
      end,
      EArgumentException,
      'Passageiro possui corridas ativas!'
   );
end;

procedure TServicoCorridaTeste.MotoristaDeveAceitarCorrida;
var lEntradaDaContaDePassageiro, lEntradaDaContaDeMotorista: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
    lIDDoPassageiro, lIDDoMotorista: string;
    lEntradaDaSolicitacaoDeCorrida: TDadoSolicitacaoCorrida;
    lServicoCorrida: TServicoCorrida;
    lIDDaCorrida: string;
    lCorrida: TDadoCorrida;
begin
   lEntradaDaContaDePassageiro.Nome  := 'John Doe';
   lEntradaDaContaDePassageiro.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDePassageiro.CPF   := '958.187.055-52';
   lEntradaDaContaDePassageiro.Passageiro := True;
   lEntradaDaContaDePassageiro.Motorista  := False;

   lEntradaDaContaDeMotorista.Nome  := 'Mary Weber';
   lEntradaDaContaDeMotorista.Email := Format('mary.weber.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeMotorista.CPF   := '01234567890';
   lEntradaDaContaDeMotorista.PlacaDoCarro := 'AAB0000';
   lEntradaDaContaDeMotorista.Passageiro := False;
   lEntradaDaContaDeMotorista.Motorista  := True;
   lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
   try
      lIDDoPassageiro := lServicoContaUsuario.Inscrever(lEntradaDaContaDePassageiro);
      lIDDoMotorista  := lServicoContaUsuario.Inscrever(lEntradaDaContaDeMotorista);
   finally
      lServicoContaUsuario.Destroy;
   end;

   lEntradaDaSolicitacaoDeCorrida.IDDoPassageiro := lIDDoPassageiro;
   lEntradaDaSolicitacaoDeCorrida.DeLatitude     := -26.877291364885657;
   lEntradaDaSolicitacaoDeCorrida.DeLongitude    := -49.08225874081267;
   lEntradaDaSolicitacaoDeCorrida.ParaLatitude   := -26.863202471813185;
   lEntradaDaSolicitacaoDeCorrida.ParaLongitude  := -49.072482819584245;
   lServicoCorrida := TServicoCorrida.Create(FDAOContaUsuario, FDAOCorrida, FDAOPosicao);
   try
      lIDDaCorrida := lServicoCorrida.Solicitar(lEntradaDaSolicitacaoDeCorrida);
      lServicoCorrida.Aceitar(lIDDaCorrida, lIDDoMotorista);
      lCorrida := lServicoCorrida.Obter(lIDDaCorrida);
      Assert.AreEqual(lIDDaCorrida, lCorrida.ID);
      Assert.AreEqual('accepted', lCorrida.Status);
      Assert.AreEqual(lIDDoMotorista, lCorrida.IDDoMotorista);
   finally
      lServicoCorrida.Destroy;
   end;
end;

procedure TServicoCorridaTeste.PassageiroNaoPodeAceitarCorrida;
var lEntradaDaContaDePassageiro: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
    lIDDoPassageiro: string;
    lEntradaDaSolicitacaoDeCorrida: TDadoSolicitacaoCorrida;
    lServicoCorrida: TServicoCorrida;
    lIDDaCorrida: string;
begin
   lEntradaDaContaDePassageiro.Nome  := 'John Doe';
   lEntradaDaContaDePassageiro.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDePassageiro.CPF   := '958.187.055-52';
   lEntradaDaContaDePassageiro.Passageiro := True;
   lEntradaDaContaDePassageiro.Motorista  := False;
   lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
   try
      lIDDoPassageiro := lServicoContaUsuario.Inscrever(lEntradaDaContaDePassageiro);
   finally
      lServicoContaUsuario.Destroy;
   end;

   lEntradaDaSolicitacaoDeCorrida.IDDoPassageiro := lIDDoPassageiro;
   lEntradaDaSolicitacaoDeCorrida.DeLatitude     := -26.877291364885657;
   lEntradaDaSolicitacaoDeCorrida.DeLongitude    := -49.08225874081267;
   lEntradaDaSolicitacaoDeCorrida.ParaLatitude   := -26.863202471813185;
   lEntradaDaSolicitacaoDeCorrida.ParaLongitude  := -49.072482819584245;

   Assert.WillRaiseWithMessage(
      procedure
      begin
         lServicoCorrida := TServicoCorrida.Create(FDAOContaUsuario, FDAOCorrida, FDAOPosicao);
         try
            lIDDaCorrida := lServicoCorrida.Solicitar(lEntradaDaSolicitacaoDeCorrida);
            lServicoCorrida.Aceitar(lIDDaCorrida, lIDDoPassageiro);
         finally
            lServicoCorrida.Destroy;
         end;
      end,
      EArgumentException,
      'Conta de usuário não pertence a um motorista!'
   );
end;

procedure TServicoCorridaTeste.MotoristaNaoPodeAceitarCorridaNaoSolicitada;
var lEntradaDaContaDePassageiro, lEntradaDaContaDeMotorista: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
    lIDDoPassageiro, lIDDoMotorista: string;
    lEntradaDaSolicitacaoDeCorrida: TDadoSolicitacaoCorrida;
    lServicoCorrida: TServicoCorrida;
    lIDDaCorrida: string;
begin
   lEntradaDaContaDePassageiro.Nome  := 'John Doe';
   lEntradaDaContaDePassageiro.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDePassageiro.CPF   := '958.187.055-52';
   lEntradaDaContaDePassageiro.Passageiro := True;
   lEntradaDaContaDePassageiro.Motorista  := False;

   lEntradaDaContaDeMotorista.Nome  := 'Mary Weber';
   lEntradaDaContaDeMotorista.Email := Format('mary.weber.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeMotorista.CPF   := '01234567890';
   lEntradaDaContaDeMotorista.PlacaDoCarro := 'AAB0000';
   lEntradaDaContaDeMotorista.Passageiro := False;
   lEntradaDaContaDeMotorista.Motorista  := True;
   lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
   try
      lIDDoPassageiro := lServicoContaUsuario.Inscrever(lEntradaDaContaDePassageiro);
      lIDDoMotorista  := lServicoContaUsuario.Inscrever(lEntradaDaContaDeMotorista);
   finally
      lServicoContaUsuario.Destroy;
   end;

   lEntradaDaSolicitacaoDeCorrida.IDDoPassageiro := lIDDoPassageiro;
   lEntradaDaSolicitacaoDeCorrida.DeLatitude     := -26.877291364885657;
   lEntradaDaSolicitacaoDeCorrida.DeLongitude    := -49.08225874081267;
   lEntradaDaSolicitacaoDeCorrida.ParaLatitude   := -26.863202471813185;
   lEntradaDaSolicitacaoDeCorrida.ParaLongitude  := -49.072482819584245;

   Assert.WillRaiseWithMessage(
      procedure
      begin
         lServicoCorrida := TServicoCorrida.Create(FDAOContaUsuario, FDAOCorrida, FDAOPosicao);
         try
            lIDDaCorrida := lServicoCorrida.Solicitar(lEntradaDaSolicitacaoDeCorrida);
            lServicoCorrida.Aceitar(lIDDaCorrida, lIDDoMotorista);
            lServicoCorrida.Aceitar(lIDDaCorrida, lIDDoMotorista);
         finally
            lServicoCorrida.Destroy;
         end;
      end,
      EArgumentException,
      'Corrida não solicitada!'
   );
end;

procedure TServicoCorridaTeste.MotoristaComCorridasAtivasNaoPodeAceitarNovaCorrida;
var lEntradaDaContaDePassageiro1, lEntradaDaContaDePassageiro2, lEntradaDaContaDeMotorista: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
    lIDDoPassageiro1, lIDDoPassageiro2, lIDDoMotorista: string;
    lEntradaDaSolicitacaoDeCorrida1, lEntradaDaSolicitacaoDeCorrida2: TDadoSolicitacaoCorrida;
    lServicoCorrida: TServicoCorrida;
    lIDDaCorrida1, lIDDaCorrida2: string;
begin
   lEntradaDaContaDePassageiro1.Nome  := 'John Doe';
   lEntradaDaContaDePassageiro1.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDePassageiro1.CPF   := '958.187.055-52';
   lEntradaDaContaDePassageiro1.Passageiro := True;
   lEntradaDaContaDePassageiro1.Motorista  := False;

   lEntradaDaContaDePassageiro2.Nome  := 'Walter White';
   lEntradaDaContaDePassageiro2.Email := Format('walter.white.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDePassageiro2.CPF   := '147.864.110-00';
   lEntradaDaContaDePassageiro2.Passageiro := True;
   lEntradaDaContaDePassageiro2.Motorista  := False;

   lEntradaDaContaDeMotorista.Nome  := 'Mary Weber';
   lEntradaDaContaDeMotorista.Email := Format('mary.weber.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeMotorista.CPF   := '01234567890';
   lEntradaDaContaDeMotorista.PlacaDoCarro := 'AAB0000';
   lEntradaDaContaDeMotorista.Passageiro := False;
   lEntradaDaContaDeMotorista.Motorista  := True;
   lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
   try
      lIDDoPassageiro1 := lServicoContaUsuario.Inscrever(lEntradaDaContaDePassageiro1);
      lIDDoPassageiro2 := lServicoContaUsuario.Inscrever(lEntradaDaContaDePassageiro2);
      lIDDoMotorista   := lServicoContaUsuario.Inscrever(lEntradaDaContaDeMotorista);
   finally
      lServicoContaUsuario.Destroy;
   end;

   lEntradaDaSolicitacaoDeCorrida1.IDDoPassageiro := lIDDoPassageiro1;
   lEntradaDaSolicitacaoDeCorrida1.DeLatitude     := -26.877291364885657;
   lEntradaDaSolicitacaoDeCorrida1.DeLongitude    := -49.08225874081267;
   lEntradaDaSolicitacaoDeCorrida1.ParaLatitude   := -26.863202471813185;
   lEntradaDaSolicitacaoDeCorrida1.ParaLongitude  := -49.072482819584245;

   lEntradaDaSolicitacaoDeCorrida2.IDDoPassageiro := lIDDoPassageiro2;
   lEntradaDaSolicitacaoDeCorrida2.DeLatitude     := -26.890588459859114;
   lEntradaDaSolicitacaoDeCorrida2.DeLongitude    := -49.089839437485466;
   lEntradaDaSolicitacaoDeCorrida2.ParaLatitude   := -26.877291364885657;
   lEntradaDaSolicitacaoDeCorrida2.ParaLongitude  := -49.08225874081267;

   Assert.WillRaiseWithMessage(
      procedure
      begin
         lServicoCorrida := TServicoCorrida.Create(FDAOContaUsuario, FDAOCorrida, FDAOPosicao);
         try
            lIDDaCorrida1 := lServicoCorrida.Solicitar(lEntradaDaSolicitacaoDeCorrida1);
            lIDDaCorrida2 := lServicoCorrida.Solicitar(lEntradaDaSolicitacaoDeCorrida2);
            lServicoCorrida.Aceitar(lIDDaCorrida1, lIDDoMotorista);
            lServicoCorrida.Aceitar(lIDDaCorrida2, lIDDoMotorista);
         finally
            lServicoCorrida.Destroy;
         end;
      end,
      EArgumentException,
      'Motorista possui corridas ativas!'
   );
end;

procedure TServicoCorridaTeste.MotoristaDeveIniciarCorrida;
var lEntradaDaContaDePassageiro, lEntradaDaContaDeMotorista: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
    lIDDoPassageiro, lIDDoMotorista: string;
    lEntradaDaSolicitacaoDeCorrida: TDadoSolicitacaoCorrida;
    lServicoCorrida: TServicoCorrida;
    lIDDaCorrida: string;
    lCorrida: TDadoCorrida;
begin
   lEntradaDaContaDePassageiro.Nome  := 'John Doe';
   lEntradaDaContaDePassageiro.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDePassageiro.CPF   := '958.187.055-52';
   lEntradaDaContaDePassageiro.Passageiro := True;
   lEntradaDaContaDePassageiro.Motorista  := False;

   lEntradaDaContaDeMotorista.Nome  := 'Mary Weber';
   lEntradaDaContaDeMotorista.Email := Format('mary.weber.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeMotorista.CPF   := '01234567890';
   lEntradaDaContaDeMotorista.PlacaDoCarro := 'AAB0000';
   lEntradaDaContaDeMotorista.Passageiro := False;
   lEntradaDaContaDeMotorista.Motorista  := True;
   lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
   try
      lIDDoPassageiro := lServicoContaUsuario.Inscrever(lEntradaDaContaDePassageiro);
      lIDDoMotorista  := lServicoContaUsuario.Inscrever(lEntradaDaContaDeMotorista);
   finally
      lServicoContaUsuario.Destroy;
   end;

   lEntradaDaSolicitacaoDeCorrida.IDDoPassageiro := lIDDoPassageiro;
   lEntradaDaSolicitacaoDeCorrida.DeLatitude     := -26.877291364885657;
   lEntradaDaSolicitacaoDeCorrida.DeLongitude    := -49.08225874081267;
   lEntradaDaSolicitacaoDeCorrida.ParaLatitude   := -26.863202471813185;
   lEntradaDaSolicitacaoDeCorrida.ParaLongitude  := -49.072482819584245;
   lServicoCorrida := TServicoCorrida.Create(FDAOContaUsuario, FDAOCorrida, FDAOPosicao);
   try
      lIDDaCorrida := lServicoCorrida.Solicitar(lEntradaDaSolicitacaoDeCorrida);
      lServicoCorrida.Aceitar(lIDDaCorrida, lIDDoMotorista);
      lServicoCorrida.Iniciar(lIDDaCorrida);
      lCorrida := lServicoCorrida.Obter(lIDDaCorrida);
      Assert.AreEqual(lIDDaCorrida, lCorrida.ID);
      Assert.AreEqual('in_progress', lCorrida.Status);
      Assert.AreEqual(lIDDoMotorista, lCorrida.IDDoMotorista);
   finally
      lServicoCorrida.Destroy;
   end;
end;

procedure TServicoCorridaTeste.MotoristaNaoPodeIniciarCorridaNaoAceita;
var lEntradaDaContaDePassageiro, lEntradaDaContaDeMotorista: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
    lIDDoPassageiro, lIDDoMotorista: string;
    lEntradaDaSolicitacaoDeCorrida: TDadoSolicitacaoCorrida;
    lServicoCorrida: TServicoCorrida;
    lIDDaCorrida: string;
begin
   lEntradaDaContaDePassageiro.Nome  := 'John Doe';
   lEntradaDaContaDePassageiro.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDePassageiro.CPF   := '958.187.055-52';
   lEntradaDaContaDePassageiro.Passageiro := True;
   lEntradaDaContaDePassageiro.Motorista  := False;

   lEntradaDaContaDeMotorista.Nome  := 'Mary Weber';
   lEntradaDaContaDeMotorista.Email := Format('mary.weber.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeMotorista.CPF   := '01234567890';
   lEntradaDaContaDeMotorista.PlacaDoCarro := 'AAB0000';
   lEntradaDaContaDeMotorista.Passageiro := False;
   lEntradaDaContaDeMotorista.Motorista  := True;
   lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
   try
      lIDDoPassageiro := lServicoContaUsuario.Inscrever(lEntradaDaContaDePassageiro);
      lIDDoMotorista  := lServicoContaUsuario.Inscrever(lEntradaDaContaDeMotorista);
   finally
      lServicoContaUsuario.Destroy;
   end;

   lEntradaDaSolicitacaoDeCorrida.IDDoPassageiro := lIDDoPassageiro;
   lEntradaDaSolicitacaoDeCorrida.DeLatitude     := -26.877291364885657;
   lEntradaDaSolicitacaoDeCorrida.DeLongitude    := -49.08225874081267;
   lEntradaDaSolicitacaoDeCorrida.ParaLatitude   := -26.863202471813185;
   lEntradaDaSolicitacaoDeCorrida.ParaLongitude  := -49.072482819584245;

   Assert.WillRaiseWithMessage(
      procedure
      begin
         lServicoCorrida := TServicoCorrida.Create(FDAOContaUsuario, FDAOCorrida, FDAOPosicao);
         try
            lIDDaCorrida := lServicoCorrida.Solicitar(lEntradaDaSolicitacaoDeCorrida);
            lServicoCorrida.Aceitar(lIDDaCorrida, lIDDoMotorista);
            lServicoCorrida.Iniciar(lIDDaCorrida);
            lServicoCorrida.Iniciar(lIDDaCorrida);
         finally
            lServicoCorrida.Destroy;
         end;
      end,
      EArgumentException,
      'Corrida não aceita!'
   );
end;

procedure TServicoCorridaTeste.MotoristaDeveFinalizarCorrida;
var lEntradaDaContaDePassageiro, lEntradaDaContaDeMotorista: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
    lIDDoPassageiro, lIDDoMotorista: string;
    lEntradaDaSolicitacaoDeCorrida: TDadoSolicitacaoCorrida;
    lServicoCorrida: TServicoCorrida;
    lIDDaCorrida: string;
    lCorrida: TDadoCorrida;
begin
   lEntradaDaContaDePassageiro.Nome  := 'John Doe';
   lEntradaDaContaDePassageiro.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDePassageiro.CPF   := '958.187.055-52';
   lEntradaDaContaDePassageiro.Passageiro := True;
   lEntradaDaContaDePassageiro.Motorista  := False;

   lEntradaDaContaDeMotorista.Nome  := 'Mary Weber';
   lEntradaDaContaDeMotorista.Email := Format('mary.weber.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeMotorista.CPF   := '01234567890';
   lEntradaDaContaDeMotorista.PlacaDoCarro := 'AAB0000';
   lEntradaDaContaDeMotorista.Passageiro := False;
   lEntradaDaContaDeMotorista.Motorista  := True;
   lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
   try
      lIDDoPassageiro := lServicoContaUsuario.Inscrever(lEntradaDaContaDePassageiro);
      lIDDoMotorista  := lServicoContaUsuario.Inscrever(lEntradaDaContaDeMotorista);
   finally
      lServicoContaUsuario.Destroy;
   end;

   lEntradaDaSolicitacaoDeCorrida.IDDoPassageiro := lIDDoPassageiro;
   lEntradaDaSolicitacaoDeCorrida.DeLatitude     := -26.877291364885657;
   lEntradaDaSolicitacaoDeCorrida.DeLongitude    := -49.08225874081267;
   lEntradaDaSolicitacaoDeCorrida.ParaLatitude   := -26.863202471813185;
   lEntradaDaSolicitacaoDeCorrida.ParaLongitude  := -49.072482819584245;
   lServicoCorrida := TServicoCorrida.Create(FDAOContaUsuario, FDAOCorrida, FDAOPosicao);
   try
      lIDDaCorrida := lServicoCorrida.Solicitar(lEntradaDaSolicitacaoDeCorrida);
      lServicoCorrida.Aceitar(lIDDaCorrida, lIDDoMotorista);
      lServicoCorrida.Iniciar(lIDDaCorrida);
      lServicoCorrida.Finalizar(lIDDaCorrida);
      lCorrida := lServicoCorrida.Obter(lIDDaCorrida);
      Assert.AreEqual(lIDDaCorrida, lCorrida.ID);
      Assert.AreEqual('completed', lCorrida.Status);
      Assert.AreEqual(lIDDoMotorista, lCorrida.IDDoMotorista);
   finally
      lServicoCorrida.Destroy;
   end;
end;

procedure TServicoCorridaTeste.MotoristaNaoPodeFinalizarCorridaNaoIniciada;
var lEntradaDaContaDePassageiro, lEntradaDaContaDeMotorista: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
    lIDDoPassageiro, lIDDoMotorista: string;
    lEntradaDaSolicitacaoDeCorrida: TDadoSolicitacaoCorrida;
    lServicoCorrida: TServicoCorrida;
    lIDDaCorrida: string;
begin
   lEntradaDaContaDePassageiro.Nome  := 'John Doe';
   lEntradaDaContaDePassageiro.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDePassageiro.CPF   := '958.187.055-52';
   lEntradaDaContaDePassageiro.Passageiro := True;
   lEntradaDaContaDePassageiro.Motorista  := False;

   lEntradaDaContaDeMotorista.Nome  := 'Mary Weber';
   lEntradaDaContaDeMotorista.Email := Format('mary.weber.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeMotorista.CPF   := '01234567890';
   lEntradaDaContaDeMotorista.PlacaDoCarro := 'AAB0000';
   lEntradaDaContaDeMotorista.Passageiro := False;
   lEntradaDaContaDeMotorista.Motorista  := True;
   lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
   try
      lIDDoPassageiro := lServicoContaUsuario.Inscrever(lEntradaDaContaDePassageiro);
      lIDDoMotorista  := lServicoContaUsuario.Inscrever(lEntradaDaContaDeMotorista);
   finally
      lServicoContaUsuario.Destroy;
   end;

   lEntradaDaSolicitacaoDeCorrida.IDDoPassageiro := lIDDoPassageiro;
   lEntradaDaSolicitacaoDeCorrida.DeLatitude     := -26.877291364885657;
   lEntradaDaSolicitacaoDeCorrida.DeLongitude    := -49.08225874081267;
   lEntradaDaSolicitacaoDeCorrida.ParaLatitude   := -26.863202471813185;
   lEntradaDaSolicitacaoDeCorrida.ParaLongitude  := -49.072482819584245;

   Assert.WillRaiseWithMessage(
      procedure
      begin
         lServicoCorrida := TServicoCorrida.Create(FDAOContaUsuario, FDAOCorrida, FDAOPosicao);
         try
            lIDDaCorrida := lServicoCorrida.Solicitar(lEntradaDaSolicitacaoDeCorrida);
            lServicoCorrida.Aceitar(lIDDaCorrida, lIDDoMotorista);
            lServicoCorrida.Finalizar(lIDDaCorrida);
         finally
            lServicoCorrida.Destroy;
         end;
      end,
      EArgumentException,
      'Corrida não iniciada!'
   );
end;

procedure TServicoCorridaTeste.SistemaDeveAtualizarAPosicaoDeUmCorrida;
var lEntradaDaContaDePassageiro, lEntradaDaContaDeMotorista: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
    lIDDoPassageiro, lIDDoMotorista: string;
    lEntradaDaSolicitacaoDeCorrida: TDadoSolicitacaoCorrida;
    lServicoCorrida: TServicoCorrida;
    lIDDaCorrida: string;
    lListaDePosicoesDaCorrida: TListaDePosicoes;
begin
   lEntradaDaContaDePassageiro.Nome  := 'John Doe';
   lEntradaDaContaDePassageiro.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDePassageiro.CPF   := '958.187.055-52';
   lEntradaDaContaDePassageiro.Passageiro := True;
   lEntradaDaContaDePassageiro.Motorista  := False;

   lEntradaDaContaDeMotorista.Nome  := 'Mary Weber';
   lEntradaDaContaDeMotorista.Email := Format('mary.weber.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeMotorista.CPF   := '01234567890';
   lEntradaDaContaDeMotorista.PlacaDoCarro := 'AAB0000';
   lEntradaDaContaDeMotorista.Passageiro := False;
   lEntradaDaContaDeMotorista.Motorista  := True;
   lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
   try
      lIDDoPassageiro := lServicoContaUsuario.Inscrever(lEntradaDaContaDePassageiro);
      lIDDoMotorista  := lServicoContaUsuario.Inscrever(lEntradaDaContaDeMotorista);
   finally
      lServicoContaUsuario.Destroy;
   end;

   lEntradaDaSolicitacaoDeCorrida.IDDoPassageiro := lIDDoPassageiro;
   lEntradaDaSolicitacaoDeCorrida.DeLatitude     := -26.877291364885657;
   lEntradaDaSolicitacaoDeCorrida.DeLongitude    := -49.08225874081267;
   lEntradaDaSolicitacaoDeCorrida.ParaLatitude   := -26.863202471813185;
   lEntradaDaSolicitacaoDeCorrida.ParaLongitude  := -49.072482819584245;
   lServicoCorrida := TServicoCorrida.Create(FDAOContaUsuario, FDAOCorrida, FDAOPosicao);
   try
      lIDDaCorrida := lServicoCorrida.Solicitar(lEntradaDaSolicitacaoDeCorrida);
      lServicoCorrida.Aceitar(lIDDaCorrida, lIDDoMotorista);
      lServicoCorrida.Iniciar(lIDDaCorrida);
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.877291364885657, -49.08225874081267, StrToDateTimeDef('17/09/2023 10:00:00', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.8773716281549, -49.08203741452999, StrToDateTimeDef('17/09/2023 10:00:10', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.877635537605425, -49.08208293312585, StrToDateTimeDef('17/09/2023 10:00:20', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.878860340067302, -49.08370642971138, StrToDateTimeDef('17/09/2023 10:00:30', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.878982142930248, -49.08432093077141, StrToDateTimeDef('17/09/2023 10:00:40', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.880315198704235, -49.08605063741393, StrToDateTimeDef('17/09/2023 10:00:50', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.881201638277044, -49.08570924794706, StrToDateTimeDef('17/09/2023 10:01:00', Now));
      lListaDePosicoesDaCorrida := FDAOPosicao.ObterListaDePosicoesDaCorrida(lIDDaCorrida);
      try
         Assert.AreEqual(7, lListaDePosicoesDaCorrida.Count);
      finally
         lListaDePosicoesDaCorrida.Destroy;
      end;
   finally
      lServicoCorrida.Destroy;
   end;
end;

procedure TServicoCorridaTeste.SistemaNaoPodeAtualizarAPosicaoDeUmCorridaNaoIniciada;
var lEntradaDaContaDePassageiro, lEntradaDaContaDeMotorista: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
    lIDDoPassageiro, lIDDoMotorista: string;
    lEntradaDaSolicitacaoDeCorrida: TDadoSolicitacaoCorrida;
    lServicoCorrida: TServicoCorrida;
    lIDDaCorrida: string;
begin
   lEntradaDaContaDePassageiro.Nome  := 'John Doe';
   lEntradaDaContaDePassageiro.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDePassageiro.CPF   := '958.187.055-52';
   lEntradaDaContaDePassageiro.Passageiro := True;
   lEntradaDaContaDePassageiro.Motorista  := False;

   lEntradaDaContaDeMotorista.Nome  := 'Mary Weber';
   lEntradaDaContaDeMotorista.Email := Format('mary.weber.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeMotorista.CPF   := '01234567890';
   lEntradaDaContaDeMotorista.PlacaDoCarro := 'AAB0000';
   lEntradaDaContaDeMotorista.Passageiro := False;
   lEntradaDaContaDeMotorista.Motorista  := True;
   lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
   try
      lIDDoPassageiro := lServicoContaUsuario.Inscrever(lEntradaDaContaDePassageiro);
      lIDDoMotorista  := lServicoContaUsuario.Inscrever(lEntradaDaContaDeMotorista);
   finally
      lServicoContaUsuario.Destroy;
   end;

   lEntradaDaSolicitacaoDeCorrida.IDDoPassageiro := lIDDoPassageiro;
   lEntradaDaSolicitacaoDeCorrida.DeLatitude     := -26.877291364885657;
   lEntradaDaSolicitacaoDeCorrida.DeLongitude    := -49.08225874081267;
   lEntradaDaSolicitacaoDeCorrida.ParaLatitude   := -26.863202471813185;
   lEntradaDaSolicitacaoDeCorrida.ParaLongitude  := -49.072482819584245;

   Assert.WillRaiseWithMessage(
      procedure
      begin
         lServicoCorrida := TServicoCorrida.Create(FDAOContaUsuario, FDAOCorrida, FDAOPosicao);
         try
            lIDDaCorrida := lServicoCorrida.Solicitar(lEntradaDaSolicitacaoDeCorrida);
            lServicoCorrida.Aceitar(lIDDaCorrida, lIDDoMotorista);
            lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.877291364885657, -49.08225874081267, Now);
         finally
            lServicoCorrida.Destroy;
         end;
      end,
      EArgumentException,
      'Corrida não iniciada!'
   );
end;

procedure TServicoCorridaTeste.MotoristaDeveFinalizarCorridaComDistanciaPercorridaETarifa;
var lEntradaDaContaDePassageiro, lEntradaDaContaDeMotorista: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
    lIDDoPassageiro, lIDDoMotorista: string;
    lEntradaDaSolicitacaoDeCorrida: TDadoSolicitacaoCorrida;
    lServicoCorrida: TServicoCorrida;
    lIDDaCorrida: string;
    lCorrida: TDadoCorrida;
begin
   lEntradaDaContaDePassageiro.Nome  := 'John Doe';
   lEntradaDaContaDePassageiro.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDePassageiro.CPF   := '958.187.055-52';
   lEntradaDaContaDePassageiro.Passageiro := True;
   lEntradaDaContaDePassageiro.Motorista  := False;

   lEntradaDaContaDeMotorista.Nome  := 'Mary Weber';
   lEntradaDaContaDeMotorista.Email := Format('mary.weber.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeMotorista.CPF   := '01234567890';
   lEntradaDaContaDeMotorista.PlacaDoCarro := 'AAB0000';
   lEntradaDaContaDeMotorista.Passageiro := False;
   lEntradaDaContaDeMotorista.Motorista  := True;
   lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
   try
      lIDDoPassageiro := lServicoContaUsuario.Inscrever(lEntradaDaContaDePassageiro);
      lIDDoMotorista  := lServicoContaUsuario.Inscrever(lEntradaDaContaDeMotorista);
   finally
      lServicoContaUsuario.Destroy;
   end;

   lEntradaDaSolicitacaoDeCorrida.IDDoPassageiro := lIDDoPassageiro;
   lEntradaDaSolicitacaoDeCorrida.DeLatitude     := -26.877291364885657;
   lEntradaDaSolicitacaoDeCorrida.DeLongitude    := -49.08225874081267;
   lEntradaDaSolicitacaoDeCorrida.ParaLatitude   := -26.863202471813185;
   lEntradaDaSolicitacaoDeCorrida.ParaLongitude  := -49.072482819584245;
   lServicoCorrida := TServicoCorrida.Create(FDAOContaUsuario, FDAOCorrida, FDAOPosicao);
   try
      lIDDaCorrida := lServicoCorrida.Solicitar(lEntradaDaSolicitacaoDeCorrida);
      lServicoCorrida.Aceitar(lIDDaCorrida, lIDDoMotorista);
      lServicoCorrida.Iniciar(lIDDaCorrida);
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.877291364885657, -49.08225874081267, StrToDateTimeDef('17/09/2023 10:00:00', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.8773716281549, -49.08203741452999, StrToDateTimeDef('17/09/2023 10:00:10', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.877635537605425, -49.08208293312585, StrToDateTimeDef('17/09/2023 10:00:20', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.878860340067302, -49.08370642971138, StrToDateTimeDef('17/09/2023 10:00:30', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.878982142930248, -49.08432093077141, StrToDateTimeDef('17/09/2023 10:00:40', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.880315198704235, -49.08605063741393, StrToDateTimeDef('17/09/2023 10:00:50', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.881201638277044, -49.08570924794706, StrToDateTimeDef('17/09/2023 10:01:00', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.877493432607338, -49.08182499441314, StrToDateTimeDef('17/09/2023 10:01:20', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.877148319656143, -49.081991895926194, StrToDateTimeDef('17/09/2023 10:01:30', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.876146809542394, -49.08127118482514, StrToDateTimeDef('17/09/2023 10:01:40', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.876153576520533, -49.08071737522416, StrToDateTimeDef('17/09/2023 10:01:50', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.875821993534213, -49.080133219910685, StrToDateTimeDef('17/09/2023 10:02:00', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.875713721326143, -49.07891180424182, StrToDateTimeDef('17/09/2023 10:02:10', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.876072372611887, -49.0782138524387, StrToDateTimeDef('17/09/2023 10:02:20', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.875957333638965, -49.07759935138251, StrToDateTimeDef('17/09/2023 10:02:30', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.874495651839144, -49.076264139220825, StrToDateTimeDef('17/09/2023 10:02:40', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.87403548884849, -49.075679983907335, StrToDateTimeDef('17/09/2023 10:02:50', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.87438061126827, -49.074162697359256, StrToDateTimeDef('17/09/2023 10:03:00', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.874407679644793, -49.073836480733206, StrToDateTimeDef('17/09/2023 10:03:10', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.873710666783616, -49.07222815701297, StrToDateTimeDef('17/09/2023 10:03:20', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.872912141888, -49.070619833268104, StrToDateTimeDef('17/09/2023 10:03:30', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.87009695830931, -49.07272127512185, StrToDateTimeDef('17/09/2023 10:03:40', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.868405107555443, -49.07266817009335, StrToDateTimeDef('17/09/2023 10:03:50', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.86494011820015, -49.071128124252766, StrToDateTimeDef('17/09/2023 10:04:00', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.863275261336934, -49.07074880261742, StrToDateTimeDef('17/09/2023 10:04:10', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.863085763884705, -49.0715984830734, StrToDateTimeDef('17/09/2023 10:04:20', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.862808284899742, -49.0723798856356, StrToDateTimeDef('17/09/2023 10:04:30', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.86321487182394, -49.072580310501266, StrToDateTimeDef('17/09/2023 10:04:40', Now));
      lServicoCorrida.AtualizarPosicao(lIDDaCorrida, -26.863202471813185, -49.072482819584245, StrToDateTimeDef('17/09/2023 10:04:50', Now));
      lServicoCorrida.Finalizar(lIDDaCorrida);
      lCorrida := lServicoCorrida.Obter(lIDDaCorrida);
      Assert.AreEqual(lIDDaCorrida, lCorrida.ID);
      Assert.AreEqual('completed', lCorrida.Status);
      Assert.AreEqual(lIDDoMotorista, lCorrida.IDDoMotorista);
      Assert.AreEqual(4.014, lCorrida.Distancia);
      Assert.AreEqual(8.43, lCorrida.Tarifa);
   finally
      lServicoCorrida.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TServicoCorridaTeste);
end.
