unit InscreverUsuario.Teste;

interface

uses
   System.SysUtils,
   System.DateUtils,
   ContaDeUsuario.Repositorio,
   ContaDeUsuario.Repositorio.Fake,
   InscreverUsuario,
   ObterContaDeUsuario,
   DUnitX.TestFramework;

type
   [TestFixture]
   TInscreverUsuarioTeste = class
   private
      FRepositorioContaDeUsuario: TRepositorioContaDEUsuario;
      FInscreverUsuario: TInscreverUsuario;
      FObterContaDeUsuario: TObterContaDeUsuario;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure DeveInscreverUmPassageiro;
      [Test]
      procedure DeveInscreverUmMotorista;
      [Test]
      procedure NaoPodeCriarContaDeUsuarioComEmailJaExistente;
   end;

implementation

procedure TInscreverUsuarioTeste.Inicializar;
begin
   FRepositorioContaDeUsuario := TRepositorioContaDeUsuarioFake.Create;
   FInscreverUsuario := TInscreverUsuario.Create(FRepositorioContaDeUsuario);
   FObterContaDeUsuario := TObterContaDeUsuario.Create(FRepositorioContaDeUsuario);
end;

procedure TInscreverUsuarioTeste.Finalizar;
begin
   FObterContaDeUsuario.Destroy;
   FInscreverUsuario.Destroy;
   FRepositorioContaDeUsuario.Destroy;
end;

procedure TInscreverUsuarioTeste.DeveInscreverUmPassageiro;
var lEntradaInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoUsuario: TDadoSaidaInscricaoContaDeUsuario;
    lSaidaObtencaoUsuario: TDadoSaidaObtencaoContaDeUsuario;
begin
   lEntradaInscricaoUsuario.Nome         := 'John Doe';
   lEntradaInscricaoUsuario.Email        := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoUsuario.CPF          := '958.187.055-52';
   lEntradaInscricaoUsuario.Passageiro   := True;
   lEntradaInscricaoUsuario.Motorista    := False;
   lSaidaInscricaoUsuario := FInscreverUsuario.Executar(lEntradaInscricaoUsuario);

   lSaidaObtencaoUsuario := FObterContaDeUsuario.Executar(lSaidaInscricaoUsuario.IDDoUsuario);
   Assert.AreEqual(lSaidaInscricaoUsuario.IDDoUsuario, lSaidaObtencaoUsuario.ID);
   Assert.AreEqual('John Doe', lSaidaObtencaoUsuario.Nome);
   Assert.AreEqual(lEntradaInscricaoUsuario.Email, lSaidaObtencaoUsuario.Email);
   Assert.AreEqual('95818705552', lSaidaObtencaoUsuario.CPF);
   Assert.IsTrue(lSaidaObtencaoUsuario.Passageiro);
   Assert.IsFalse(lSaidaObtencaoUsuario.Motorista);
   Assert.IsEmpty(lSaidaObtencaoUsuario.PlacaDoCarro);
   Assert.AreEqual(Date, DateOf(lSaidaObtencaoUsuario.Data));
end;

procedure TInscreverUsuarioTeste.DeveInscreverUmMotorista;
var lEntradaInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoUsuario: TDadoSaidaInscricaoContaDeUsuario;
    lSaidaObtencaoUsuario: TDadoSaidaObtencaoContaDeUsuario;
begin
   lEntradaInscricaoUsuario.Nome         := 'John Doe';
   lEntradaInscricaoUsuario.Email        := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoUsuario.CPF          := '958.187.055-52';
   lEntradaInscricaoUsuario.Passageiro   := False;
   lEntradaInscricaoUsuario.Motorista    := True;
   lEntradaInscricaoUsuario.PlacaDoCarro := 'zzz-9999';
   lSaidaInscricaoUsuario := FInscreverUsuario.Executar(lEntradaInscricaoUsuario);

   lSaidaObtencaoUsuario := FObterContaDeUsuario.Executar(lSaidaInscricaoUsuario.IDDoUsuario);
   Assert.AreEqual(lSaidaInscricaoUsuario.IDDoUsuario, lSaidaObtencaoUsuario.ID);
   Assert.AreEqual('John Doe', lSaidaObtencaoUsuario.Nome);
   Assert.AreEqual(lEntradaInscricaoUsuario.Email, lSaidaObtencaoUsuario.Email);
   Assert.AreEqual('95818705552', lSaidaObtencaoUsuario.CPF);
   Assert.IsFalse(lSaidaObtencaoUsuario.Passageiro);
   Assert.IsTrue(lSaidaObtencaoUsuario.Motorista);
   Assert.AreEqual('ZZZ9999', lSaidaObtencaoUsuario.PlacaDoCarro);
   Assert.AreEqual(Date, DateOf(lSaidaObtencaoUsuario.Data));
end;

procedure TInscreverUsuarioTeste.NaoPodeCriarContaDeUsuarioComEmailJaExistente;
var lEntradaInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
begin
   lEntradaInscricaoUsuario.Nome       := 'John Doe';
   lEntradaInscricaoUsuario.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoUsuario.CPF        := '958.187.055-52';
   lEntradaInscricaoUsuario.Passageiro := True;
   lEntradaInscricaoUsuario.Motorista  := False;
   FInscreverUsuario.Executar(lEntradaInscricaoUsuario);
   Assert.WillRaise(
      procedure
      begin
         FInscreverUsuario.Executar(lEntradaInscricaoUsuario);
      end,
      EContaDeUsuarioJaExiste
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TInscreverUsuarioTeste);
end.
