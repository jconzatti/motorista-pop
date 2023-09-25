unit ObterContaDeUsuario.Teste;

interface

uses
   System.SysUtils,
   System.DateUtils,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   ContaDeUsuario.Repositorio.Fake,
   ObterContaDeUsuario,
   DUnitX.TestFramework;

type
   [TestFixture]
   TObterContaDeUsuarioTeste = class
   private
      FRepositorioContaDeUsuario: TRepositorioContaDeUsuario;
      FObterContaDeUsuario: TObterContaDeUsuario;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure DeveObterUmaContaDeUsuario;
   end;

implementation


{ TObterContaDeUsuarioTeste }

procedure TObterContaDeUsuarioTeste.Inicializar;
begin
   FRepositorioContaDeUsuario := TRepositorioContaDeUsuarioFake.Create;
   FObterContaDeUsuario := TObterContaDeUsuario.Create(FRepositorioContaDeUsuario);
end;

procedure TObterContaDeUsuarioTeste.Finalizar;
begin
   FObterContaDeUsuario.Destroy;
   FRepositorioContaDeUsuario.Destroy;
end;

procedure TObterContaDeUsuarioTeste.DeveObterUmaContaDeUsuario;
var lContaDeUsuario: TContaDeUsuario;
    lIDDaContaDeUsuario: String;
    lSaidaObtencaoUsuario: TDadoSaidaObtencaoContaDeUsuario;
begin
   lContaDeUsuario := TContaDeUsuario.Criar('John Doe',
                                            'john.doe@mail.com',
                                            '958.187.055-52',
                                            False,
                                            True,
                                            'ZZZ9A88');
   try
      FRepositorioContaDeUsuario.Salvar(lContaDeUsuario);
      lIDDaContaDeUsuario := lContaDeUsuario.ID;
   finally
      lContaDeUsuario.Destroy;
   end;

   lSaidaObtencaoUsuario := FObterContaDeUsuario.Executar(lIDDaContaDeUsuario);
   Assert.AreEqual(lIDDaContaDeUsuario, lSaidaObtencaoUsuario.ID);
   Assert.AreEqual('John Doe', lSaidaObtencaoUsuario.Nome);
   Assert.AreEqual('john.doe@mail.com', lSaidaObtencaoUsuario.Email);
   Assert.AreEqual('95818705552', lSaidaObtencaoUsuario.CPF);
   Assert.IsFalse(lSaidaObtencaoUsuario.Passageiro);
   Assert.IsTrue(lSaidaObtencaoUsuario.Motorista);
   Assert.AreEqual('ZZZ9A88', lSaidaObtencaoUsuario.PlacaDoCarro);
   Assert.AreEqual(Date, DateOf(lSaidaObtencaoUsuario.Data));
end;

initialization
   TDUnitX.RegisterTestFixture(TObterContaDeUsuarioTeste);
end.
