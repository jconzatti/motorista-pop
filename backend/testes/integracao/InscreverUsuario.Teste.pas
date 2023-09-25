unit InscreverUsuario.Teste;

interface

uses
   System.SysUtils,
   System.DateUtils,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   ContaDeUsuario.Repositorio.Fake,
   InscreverUsuario,
   UUID,
   DUnitX.TestFramework;

type
   [TestFixture]
   TInscreverUsuarioTeste = class
   private
      FRepositorioContaDeUsuario: TRepositorioContaDEUsuario;
      FInscreverUsuario: TInscreverUsuario;
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
end;

procedure TInscreverUsuarioTeste.Finalizar;
begin
   FInscreverUsuario.Destroy;
   FRepositorioContaDeUsuario.Destroy;
end;

procedure TInscreverUsuarioTeste.DeveInscreverUmPassageiro;
var lContaDeUsuario : TContaDeUsuario;
    lEntradaInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoUsuario: TDadoSaidaInscricaoContaDeUsuario;
    lUUID: TUUID;
begin
   lEntradaInscricaoUsuario.Nome       := 'John Doe';
   lEntradaInscricaoUsuario.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoUsuario.CPF        := '958.187.055-52';
   lEntradaInscricaoUsuario.Passageiro := True;
   lEntradaInscricaoUsuario.Motorista  := False;
   lSaidaInscricaoUsuario := FInscreverUsuario.Executar(lEntradaInscricaoUsuario);
   lUUID := TUUID.Create(lSaidaInscricaoUsuario.IDDoUsuario);
   try
      lContaDeUsuario := FRepositorioContaDeUsuario.ObterPorID(lUUID);
      try
         Assert.AreEqual(lUUID.Valor, lContaDeUsuario.ID);
         Assert.AreEqual(lEntradaInscricaoUsuario.Nome, lContaDeUsuario.Nome);
         Assert.AreEqual(lEntradaInscricaoUsuario.Email, lContaDeUsuario.Email);
         Assert.AreEqual('95818705552', lContaDeUsuario.CPF);
         Assert.IsTrue(lContaDeUsuario.Passageiro);
         Assert.IsFalse(lContaDeUsuario.Motorista);
         Assert.IsEmpty(lContaDeUsuario.PlacaDoCarro);
         Assert.IsFalse(lContaDeUsuario.Verificada);
         Assert.IsNotEmpty(lContaDeUsuario.CodigoDeVerificacao);
         Assert.AreEqual(Date, DateOf(lContaDeUsuario.Data));
      finally
         lContaDeUsuario.Destroy;
      end;
   finally
      lUUID.Destroy;
   end;
end;

procedure TInscreverUsuarioTeste.DeveInscreverUmMotorista;
var lContaDeUsuario : TContaDeUsuario;
    lEntradaInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lSaidaInscricaoUsuario: TDadoSaidaInscricaoContaDeUsuario;
    lUUID: TUUID;
begin
   lEntradaInscricaoUsuario.Nome       := 'John Doe';
   lEntradaInscricaoUsuario.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaInscricaoUsuario.CPF        := '958.187.055-52';
   lEntradaInscricaoUsuario.Passageiro := False;
   lEntradaInscricaoUsuario.Motorista  := True;
   lEntradaInscricaoUsuario.PlacaDoCarro := 'zzz-9999';
   lSaidaInscricaoUsuario := FInscreverUsuario.Executar(lEntradaInscricaoUsuario);
   lUUID := TUUID.Create(lSaidaInscricaoUsuario.IDDoUsuario);
   try
      lContaDeUsuario := FRepositorioContaDeUsuario.ObterPorID(lUUID);
      try
         Assert.AreEqual(lUUID.Valor, lContaDeUsuario.ID);
         Assert.AreEqual(lEntradaInscricaoUsuario.Nome, lContaDeUsuario.Nome);
         Assert.AreEqual(lEntradaInscricaoUsuario.Email, lContaDeUsuario.Email);
         Assert.AreEqual('95818705552', lContaDeUsuario.CPF);
         Assert.IsFalse(lContaDeUsuario.Passageiro);
         Assert.IsTrue(lContaDeUsuario.Motorista);
         Assert.AreEqual('ZZZ9999', lContaDeUsuario.PlacaDoCarro);
         Assert.IsFalse(lContaDeUsuario.Verificada);
         Assert.IsNotEmpty(lContaDeUsuario.CodigoDeVerificacao);
         Assert.AreEqual(Date, DateOf(lContaDeUsuario.Data));
      finally
         lContaDeUsuario.Destroy;
      end;
   finally
      lUUID.Destroy;
   end;
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
