unit SolicitarCorrida.Teste;

interface

uses
   System.SysUtils,
   Repositorio.Fabrica,
   Repositorio.Fabrica.Fake,
   InscreverUsuario,
   SolicitarCorrida,
   DUnitX.TestFramework;

type
   [TestFixture]
   TSolicitarCorridaTeste = class
   private
      FFabricaRepositorio: TFabricaRepositorio;
      FSolicitarCorrida: TSolicitarCorrida;
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
   FFabricaRepositorio := TFabricaRepositorioFake.Create;
   FSolicitarCorrida := TSolicitarCorrida.Create(FFabricaRepositorio);
   FInscreverUsuario := TInscreverUsuario.Create(FFabricaRepositorio);
end;

procedure TSolicitarCorridaTeste.Finalizar;
begin
   FInscreverUsuario.Destroy;
   FSolicitarCorrida.Destroy;
   FFabricaRepositorio.Destroy;
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
   lEntradaInscricaoUsuario.Senha      := 'S3nh@F0rte';
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
   lEntradaInscricaoUsuario.Senha        := 'S3nh@F0rte';
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
      ESolicitacaoCorridaUsuarioNaoEhPassageiro,
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
   lEntradaInscricaoUsuario.Senha      := 'S3nh@F0rte';
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
      ESolicitacaoCorridaPassageiroJaPossuiCorridaAtiva,
      'Passageiro possui corridas ativas!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TSolicitarCorridaTeste);
end.
