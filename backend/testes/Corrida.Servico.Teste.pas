unit Corrida.Servico.Teste;

interface

uses
   System.Math,
   System.SysUtils,
   System.DateUtils,
   ContaUsuario.Servico,
   Corrida.Servico,
   DUnitX.TestFramework;

type
   [TestFixture]
   TServicoCorridaTeste = class
   public
      [Test]
      procedure PassageiroDeveSolicitarCorrida;
      [Test]
      procedure MotoristaNaoPodeSolicitarCorrida;
      [Test]
      procedure PassageiroComCorridasNaoConcluidasNaoPodeSolicitarNovaCorrida;
      [Test]
      procedure MotoristaDeveAceitarCorrida;
      [Test]
      procedure PassageiroNaoPodeAceitarCorrida;
      [Test]
      procedure MotoristaNaoPodeAceitarCorridaNaoSolicitada;
   end;

implementation


{ TServicoCorridaTeste }

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
   lServicoContaUsuario := TServicoContaUsuario.Create;
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
   lServicoCorrida := TServicoCorrida.Create;
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
   lServicoContaUsuario := TServicoContaUsuario.Create;
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
         lServicoCorrida := TServicoCorrida.Create;
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

procedure TServicoCorridaTeste.PassageiroComCorridasNaoConcluidasNaoPodeSolicitarNovaCorrida;
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
   lServicoContaUsuario := TServicoContaUsuario.Create;
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
   lServicoCorrida := TServicoCorrida.Create;
   try
      lServicoCorrida.Solicitar(lEntradaDaSolicitacaoDeCorrida);
   finally
      lServicoCorrida.Destroy;
   end;

   Assert.WillRaiseWithMessage(
      procedure
      begin
         lServicoCorrida := TServicoCorrida.Create;
         try
            lServicoCorrida.Solicitar(lEntradaDaSolicitacaoDeCorrida);
         finally
            lServicoCorrida.Destroy;
         end;
      end,
      EArgumentException,
      'Passageiro possui corridas não concluídas!'
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
   lServicoContaUsuario := TServicoContaUsuario.Create;
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
   lServicoCorrida := TServicoCorrida.Create;
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
   lServicoContaUsuario := TServicoContaUsuario.Create;
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
         lServicoCorrida := TServicoCorrida.Create;
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
   lServicoContaUsuario := TServicoContaUsuario.Create;
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
         lServicoCorrida := TServicoCorrida.Create;
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

initialization
   TDUnitX.RegisterTestFixture(TServicoCorridaTeste);
end.
