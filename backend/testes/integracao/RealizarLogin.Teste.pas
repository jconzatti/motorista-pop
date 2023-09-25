unit RealizarLogin.Teste;

interface

uses
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   ContaDeUsuario.Repositorio.Fake,
   RealizarLogin,
   DUnitX.TestFramework;

type
   [TestFixture]
   RealizarLoginTeste = class
   private
      FRepositorioContaDeUsuario: TRepositorioContaDeUsuario;
      FRealizarLogin: TRealizarLogin;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure DeverRealizarLoginComEmailDoUsuario;
   end;

implementation


{ RealizarLoginTeste }

procedure RealizarLoginTeste.Inicializar;
begin
   FRepositorioContaDeUsuario := TRepositorioContaDeUsuarioFake.Create;
   FRealizarLogin := TRealizarLogin.Create(FRepositorioContaDeUsuario);
end;

procedure RealizarLoginTeste.Finalizar;
begin
   FRealizarLogin.Destroy;
   FRepositorioContaDeUsuario.Destroy;
end;

procedure RealizarLoginTeste.DeverRealizarLoginComEmailDoUsuario;
var lContaDeUsuario: TContaDeUsuario;
    lIDDaContaDeUsuario: String;
    lSaidaRealizacaoLogin: TDadoSaidaRealizacaoLogin;
begin
   lContaDeUsuario := TContaDeUsuario.Criar('John Doe',
                                            'john.doe.forlogin@mail.com',
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

   lSaidaRealizacaoLogin := FRealizarLogin.Executar('john.doe.forlogin@mail.com');
   Assert.AreEqual(lIDDaContaDeUsuario, lSaidaRealizacaoLogin.IDDoUsuario);
end;

initialization
   TDUnitX.RegisterTestFixture(RealizarLoginTeste);
end.
