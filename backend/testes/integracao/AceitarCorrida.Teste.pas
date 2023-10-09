unit AceitarCorrida.Teste;

interface

uses
   System.SysUtils,
   ContaDeUsuario.Repositorio,
   ContaDeUsuario.Repositorio.Fake,
   InscreverUsuario,
   Corrida.Repositorio,
   Corrida.Repositorio.Fake,
   SolicitarCorrida,
   AceitarCorrida,
   DUnitX.TestFramework;

type
   [TestFixture]
   TAceitarCorridaTeste = class
   private
      FRepositorioCorrida: TRepositorioCorrida;
      FSolicitarCorrida: TSolicitarCorrida;
      FAceitarCorrida: TAceitarCorrida;
      FRepositorioContaDeUsuario: TRepositorioContaDeUsuario;
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
   FRepositorioCorrida := TRepositorioCorridaFake.Create;
   FRepositorioContaDeUsuario := TRepositorioContaDeUsuarioFake.Create;
   FSolicitarCorrida := TSolicitarCorrida.Create(FRepositorioCorrida, FRepositorioContaDeUsuario);
   FAceitarCorrida := TAceitarCorrida.Create(FRepositorioCorrida, FRepositorioContaDeUsuario);
   FInscreverUsuario := TInscreverUsuario.Create(FRepositorioContaDeUsuario);
end;

procedure TAceitarCorridaTeste.Finalizar;
begin
   FInscreverUsuario.Destroy;
   FAceitarCorrida.Destroy;
   FSolicitarCorrida.Destroy;
   FRepositorioContaDeUsuario.Destroy;
   FRepositorioCorrida.Destroy;
end;

procedure TAceitarCorridaTeste.MotoristaDeveAceitarCorrida;
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
end;

procedure TAceitarCorridaTeste.MotoristaNaoPodeAceitarCorridaNaoSolicitada;
begin

end;

procedure TAceitarCorridaTeste.PassageiroNaoPodeAceitarCorrida;
begin

end;

procedure TAceitarCorridaTeste.MotoristaComCorridaAceitaNaoPodeAceitarNovaCorrida;
begin

end;

initialization
   TDUnitX.RegisterTestFixture(TAceitarCorridaTeste);
end.
