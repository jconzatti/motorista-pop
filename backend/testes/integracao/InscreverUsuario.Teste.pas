unit InscreverUsuario.Teste;

interface

uses
   System.SysUtils,
   System.DateUtils,
   InscreverUsuario,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   ContaDeUsuario.Repositorio.Fake,
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
    lIDDoUsuario: String;
    lInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lUUID: TUUID;
begin
   lInscricaoUsuario.Nome       := 'John Doe';
   lInscricaoUsuario.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lInscricaoUsuario.CPF        := '958.187.055-52';
   lInscricaoUsuario.Passageiro := True;
   lInscricaoUsuario.Motorista  := False;
   lIDDoUsuario := FInscreverUsuario.Executar(lInscricaoUsuario);
   lUUID := TUUID.Create(lIDDoUsuario);
   try
      lContaDeUsuario := FRepositorioContaDeUsuario.ObterPorID(lUUID);
      try
         Assert.AreEqual(lUUID.Valor, lContaDeUsuario.ID);
         Assert.AreEqual(lInscricaoUsuario.Nome, lContaDeUsuario.Nome);
         Assert.AreEqual(lInscricaoUsuario.Email, lContaDeUsuario.Email);
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
    lIDDoUsuario: String;
    lInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
    lUUID: TUUID;
begin
   lInscricaoUsuario.Nome       := 'John Doe';
   lInscricaoUsuario.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lInscricaoUsuario.CPF        := '958.187.055-52';
   lInscricaoUsuario.Passageiro := False;
   lInscricaoUsuario.Motorista  := True;
   lInscricaoUsuario.PlacaDoCarro := 'zzz-9999';
   lIDDoUsuario := FInscreverUsuario.Executar(lInscricaoUsuario);
   lUUID := TUUID.Create(lIDDoUsuario);
   try
      lContaDeUsuario := FRepositorioContaDeUsuario.ObterPorID(lUUID);
      try
         Assert.AreEqual(lUUID.Valor, lContaDeUsuario.ID);
         Assert.AreEqual(lInscricaoUsuario.Nome, lContaDeUsuario.Nome);
         Assert.AreEqual(lInscricaoUsuario.Email, lContaDeUsuario.Email);
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
var lInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
begin
   lInscricaoUsuario.Nome       := 'John Doe';
   lInscricaoUsuario.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lInscricaoUsuario.CPF        := '958.187.055-52';
   lInscricaoUsuario.Passageiro := True;
   lInscricaoUsuario.Motorista  := False;
   FInscreverUsuario.Executar(lInscricaoUsuario);
   Assert.WillRaise(
      procedure
      begin
         FInscreverUsuario.Executar(lInscricaoUsuario);
      end,
      EContaDeUsuarioJaExiste
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TInscreverUsuarioTeste);
end.
