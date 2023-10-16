unit ContaDeUsuario.Repositorio.Teste;

interface

uses
   System.SysUtils,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   Email,
   UUID,
   DUnitX.TestFramework;

type
   TRepositorioContaDeUsuarioTeste = class abstract
   protected
      FRepositorioContaDeUsuario: TRepositorioContaDeUsuario;
   public
      [Setup]
      procedure Inicializar; virtual; abstract;
      [TearDown]
      procedure Finalizar; virtual; abstract;
      [Test]
      procedure DeveSalvarUmaContaDeUsuarioEObterPorID;
      [Test]
      procedure DeveSalvarUmaContaDeUsuarioEObterPorEmail;
      [Test]
      procedure DeveDispararErroSeTentarObterUmaContaDeUsuarioPorEmailNaoCadastrado;
      [Test]
      procedure DeveDispararErroSeTentarObterUmaContaDeUsuarioPorIDNaoCadastrado;
   end;

implementation

{ TRepositorioContaDeUsuarioTeste }

procedure TRepositorioContaDeUsuarioTeste.DeveSalvarUmaContaDeUsuarioEObterPorEmail;
var lContaDeUsuario: TContaDeUsuario;
    lEmail: TEMail;
begin
   lEmail := TEmail.Create(Format('john.doe.%d@gmail.com', [Random(100000000)]));
   try
      lContaDeUsuario := TContaDeUsuario.CriarPassageiro('John Doe', lEmail.Valor, '958.187.055-52', 'S3nh@F0rte');
      try
         FRepositorioContaDeUsuario.Salvar(lContaDeUsuario);
      finally
         lContaDeUsuario.Destroy;
      end;
      lContaDeUsuario := FRepositorioContaDeUsuario.ObterPorEmail(lEmail);
      try
         Assert.IsNotEmpty(lContaDeUsuario.ID);
         Assert.AreEqual('John Doe', lContaDeUsuario.Nome);
         Assert.AreEqual(lEmail.Valor, lContaDeUsuario.Email);
         Assert.AreEqual('95818705552', lContaDeUsuario.CPF);
         Assert.IsTrue(lContaDeUsuario.Passageiro);
      finally
         lContaDeUsuario.Destroy;
      end;
   finally
      lEmail.Destroy;
   end;
end;

procedure TRepositorioContaDeUsuarioTeste.DeveSalvarUmaContaDeUsuarioEObterPorID;
var lContaDeUsuario: TContaDeUsuario;
    lIDDoUsuario: String;
    lID: TUUID;
begin
   lContaDeUsuario := TContaDeUsuario.CriarPassageiro('John Doe', Format('john.doe.%d@gmail.com', [Random(100000000)]), '958.187.055-52', 'S3nh@F0rte');
   try
      FRepositorioContaDeUsuario.Salvar(lContaDeUsuario);
      lIDDoUsuario := lContaDeUsuario.ID;
   finally
      lContaDeUsuario.Destroy;
   end;
   lID := TUUID.Create(lIDDoUsuario);
   try
      lContaDeUsuario := FRepositorioContaDeUsuario.ObterPorID(lID);
      try
         Assert.AreEqual(lID.Valor, lContaDeUsuario.ID);
         Assert.AreEqual('John Doe', lContaDeUsuario.Nome);
         Assert.AreEqual('95818705552', lContaDeUsuario.CPF);
         Assert.IsTrue(lContaDeUsuario.Passageiro);
      finally
         lContaDeUsuario.Destroy;
      end;
   finally
      lID.Destroy;
   end;
end;

procedure TRepositorioContaDeUsuarioTeste.DeveDispararErroSeTentarObterUmaContaDeUsuarioPorEmailNaoCadastrado;
var lEmail: TEMail;
begin
   lEmail := TEmail.Create('usuario.nao.cadastrado@mail.com');
   try
      Assert.WillRaise(
         procedure
         begin
            FRepositorioContaDeUsuario.ObterPorEmail(lEmail);
         end,
         ERepositorioContaDeUsuarioNaoEncontrada
      );
   finally
      lEmail.Destroy;
   end;
end;

procedure TRepositorioContaDeUsuarioTeste.DeveDispararErroSeTentarObterUmaContaDeUsuarioPorIDNaoCadastrado;
var lID: TUUID;
begin
   lID := TUUID.Create(TUUID.Gerar);
   try
      Assert.WillRaise(
         procedure
         begin
            FRepositorioContaDeUsuario.ObterPorID(lID);
         end,
         ERepositorioContaDeUsuarioNaoEncontrada
      );
   finally
      lID.Destroy;
   end;
end;

end.
