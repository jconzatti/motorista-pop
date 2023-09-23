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
    lObtencaoUsuario: TDadoSaidaObtencaoContaDeUsuario;
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

   lObtencaoUsuario := FObterContaDeUsuario.Executar(lIDDaContaDeUsuario);
   Assert.AreEqual(lIDDaContaDeUsuario, lObtencaoUsuario.ID);
   Assert.AreEqual('John Doe', lObtencaoUsuario.Nome);
   Assert.AreEqual('john.doe@mail.com', lObtencaoUsuario.Email);
   Assert.AreEqual('95818705552', lObtencaoUsuario.CPF);
   Assert.IsFalse(lObtencaoUsuario.Passageiro);
   Assert.IsTrue(lObtencaoUsuario.Motorista);
   Assert.AreEqual('ZZZ9A88', lObtencaoUsuario.PlacaDoCarro);
   Assert.AreEqual(Date, DateOf(lObtencaoUsuario.Data));
end;

initialization
   TDUnitX.RegisterTestFixture(TObterContaDeUsuarioTeste);
end.
