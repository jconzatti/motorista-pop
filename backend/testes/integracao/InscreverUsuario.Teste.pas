unit InscreverUsuario.Teste;

interface

uses
   System.SysUtils,
   System.DateUtils,
   InscreverUsuario,
   DUnitX.TestFramework;

type
   [TestFixture]
   TInscreverUsuarioTeste = class
//   private
//      FRepositorioContaUsuario: TRepositorioContaUsuario;
//      FInscreverUsuario: TInscreverUsuario;
//      FObterContaDeUsuario: TObterContaDeUsuario;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure DeveInscreverUmPassageiro;
   end;

implementation

procedure TInscreverUsuarioTeste.Inicializar;
begin
//   FRepositorioContaUsuario := TRepositorioContaUsuarioFake.Create;
//   FInscreverUsuario := TInscreverUsuario.Create(FRepositorioContaUsuario);
//   FObterContaDeUsuario := TObterContaDeUsuario.Create(FRepositorioContaUsuario);
end;

procedure TInscreverUsuarioTeste.Finalizar;
begin
//   FObterContaDeUsuario.Destroy;
//   FInscreverUsuario.Destroy;
//   FRepositorioContaUsuario.Destroy;
end;

procedure TInscreverUsuarioTeste.DeveInscreverUmPassageiro;
//var lContaDeUsuario : TContaDeUsuario;
//    lIDDoUsuario: String;
//    lEntradaDaContaDeUsuario: TDadoEntradaInscricaoContaUsuario;
begin
//   lEntradaDaContaDeUsuario.Nome  := 'John Doe';
//   lEntradaDaContaDeUsuario.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
//   lEntradaDaContaDeUsuario.CPF   := '958.187.055-52';
//   lEntradaDaContaDeUsuario.Passageiro := True;
//   lEntradaDaContaDeUsuario.Motorista  := False;
//   lIDDoUsuario := FInscreverUsuario.Executar(lEntradaDaContaDeUsuario);
//   lContaDeUsuario := FObterContaDeUsuario.Executar(lIDDoUsuario);
//   try
//      Assert.AreEqual(lIDDoUsuario, lContaDeUsuario.ID);
//      Assert.AreEqual(lEntradaDaContaDeUsuario.Nome, lContaDeUsuario.Nome);
//      Assert.AreEqual(lEntradaDaContaDeUsuario.Email, lContaDeUsuario.Email);
//      Assert.AreEqual(lEntradaDaContaDeUsuario.CPF, lContaDeUsuario.CPF);
//      Assert.IsTrue(lContaDeUsuario.Passageiro);
//      Assert.IsFalse(lContaDeUsuario.Motorista);
//      Assert.IsEmpty(lContaDeUsuario.PlacaDoCarro);
//      Assert.IsFalse(lContaDeUsuario.Verificada);
//      Assert.IsNotEmpty(lContaDeUsuario.CodigoDeVerificacao);
//      Assert.AreEqual(Date, DateOf(lContaDeUsuario.Data));
//   finally
//      lContaDeUsuario.Destroy;
//   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TInscreverUsuarioTeste);
end.
