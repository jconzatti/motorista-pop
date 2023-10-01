unit SolicitarCorrida.Teste;

interface

uses
   System.SysUtils,
   ContaDeUsuario.Repositorio,
   ContaDeUsuario.Repositorio.Fake,
   InscreverUsuario,
   Corrida.Repositorio,
   Corrida.Repositorio.Fake,
   SolicitarCorrida,
   DUnitX.TestFramework;

type
   [TestFixture]
   TSolicitarCorridaTeste = class
   private
      FRepositorioCorrida: TRepositorioCorrida;
      FSolicitarCorrida: TSolicitarCorrida;
      FRepositorioContaDeUsuario: TRepositorioContaDEUsuario;
      FInscreverUsuario: TInscreverUsuario;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure PassageiroDeveSolicitarUmaCorrida;
      [Test]
      procedure MotoristaNaoPodeSolicitarUmaCorrida;
      [Test]
      procedure PassageiroComCorridaSolicitadaNaoPodeSolicitarUmaNovaCorrida;
   end;

implementation


{ TSolicitarCorridaTeste }

procedure TSolicitarCorridaTeste.Inicializar;
begin
   FRepositorioCorrida := TRepositorioCorridaFake.Create;
   FRepositorioContaDeUsuario := TRepositorioContaDeUsuarioFake.Create;
   FSolicitarCorrida := TSolicitarCorrida.Create(FRepositorioCorrida, FRepositorioContaDeUsuario);
   FInscreverUsuario := TInscreverUsuario.Create(FRepositorioContaDeUsuario);
end;

procedure TSolicitarCorridaTeste.Finalizar;
begin
   FInscreverUsuario.Destroy;
   FSolicitarCorrida.Destroy;
   FRepositorioContaDeUsuario.Destroy;
   FRepositorioCorrida.Destroy;
end;

procedure TSolicitarCorridaTeste.PassageiroDeveSolicitarUmaCorrida;
var lEntradaInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoUsuario: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
    lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
begin
   lEntradaInscricaoUsuario.Nome       := 'John Doe';
   lEntradaInscricaoUsuario.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoUsuario.CPF        := '958.187.055-52';
   lEntradaInscricaoUsuario.Passageiro := True;
   lEntradaInscricaoUsuario.Motorista  := False;
   lSaidaInscricaoUsuario := FInscreverUsuario.Executar(lEntradaInscricaoUsuario);

   lEntradaSolicitacaoCorrida.IDDoPassageiro := lSaidaInscricaoUsuario.IDDoUsuario;
   lEntradaSolicitacaoCorrida.De.Latitude     := -26.877291364885657;
   lEntradaSolicitacaoCorrida.De.Longitude    := -49.08225874081267;
   lEntradaSolicitacaoCorrida.Para.Latitude   := -26.863202471813185;
   lEntradaSolicitacaoCorrida.Para.Longitude  := -49.072482819584245;
   lSaidaSolicitacaoCorrida := FSolicitarCorrida.Executar(lEntradaSolicitacaoCorrida);
   Assert.IsNotEmpty(lSaidaSolicitacaoCorrida.IDDaCorrida);
end;

procedure TSolicitarCorridaTeste.MotoristaNaoPodeSolicitarUmaCorrida;
var lEntradaInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoUsuario: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
begin
   lEntradaInscricaoUsuario.Nome         := 'John Doe';
   lEntradaInscricaoUsuario.Email        := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoUsuario.CPF          := '958.187.055-52';
   lEntradaInscricaoUsuario.Passageiro   := False;
   lEntradaInscricaoUsuario.Motorista    := True;
   lEntradaInscricaoUsuario.PlacaDoCarro := 'ACF-5576';
   lSaidaInscricaoUsuario := FInscreverUsuario.Executar(lEntradaInscricaoUsuario);

   lEntradaSolicitacaoCorrida.IDDoPassageiro := lSaidaInscricaoUsuario.IDDoUsuario;
   lEntradaSolicitacaoCorrida.De.Latitude     := -26.877291364885657;
   lEntradaSolicitacaoCorrida.De.Longitude    := -49.08225874081267;
   lEntradaSolicitacaoCorrida.Para.Latitude   := -26.863202471813185;
   lEntradaSolicitacaoCorrida.Para.Longitude  := -49.072482819584245;
   Assert.WillRaiseWithMessage(
      procedure
      begin
         FSolicitarCorrida.Executar(lEntradaSolicitacaoCorrida);
      end,
      EContaDeUsuarioNaoEhPassageiro,
      'Conta de usuário não pertence a um passageiro!'
   );
end;

procedure TSolicitarCorridaTeste.PassageiroComCorridaSolicitadaNaoPodeSolicitarUmaNovaCorrida;
var lEntradaInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoUsuario: TDadoSaidaInscricaoContaDeUsuario;
    lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
begin
   lEntradaInscricaoUsuario.Nome       := 'John Doe';
   lEntradaInscricaoUsuario.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoUsuario.CPF        := '958.187.055-52';
   lEntradaInscricaoUsuario.Passageiro := True;
   lEntradaInscricaoUsuario.Motorista  := False;
   lSaidaInscricaoUsuario := FInscreverUsuario.Executar(lEntradaInscricaoUsuario);

   lEntradaSolicitacaoCorrida.IDDoPassageiro := lSaidaInscricaoUsuario.IDDoUsuario;
   lEntradaSolicitacaoCorrida.De.Latitude     := -26.877291364885657;
   lEntradaSolicitacaoCorrida.De.Longitude    := -49.08225874081267;
   lEntradaSolicitacaoCorrida.Para.Latitude   := -26.863202471813185;
   lEntradaSolicitacaoCorrida.Para.Longitude  := -49.072482819584245;
   FSolicitarCorrida.Executar(lEntradaSolicitacaoCorrida);
   Assert.WillRaiseWithMessage(
      procedure
      begin
         FSolicitarCorrida.Executar(lEntradaSolicitacaoCorrida);
      end,
      EPassageiroJaPossuiCorridaAtiva,
      'Passageiro possui corridas ativas!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TSolicitarCorridaTeste);
end.
