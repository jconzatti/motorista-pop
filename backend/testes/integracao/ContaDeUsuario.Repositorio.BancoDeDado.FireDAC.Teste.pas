unit ContaDeUsuario.Repositorio.BancoDeDado.FireDAC.Teste;

interface

uses
   System.SysUtils,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   ContaDeUsuario.Repositorio.BancoDeDado,
   BancoDeDado.Conexao,
   BancoDeDado.Conexao.FireDAC,
   Email,
   UUID,
   DUnitX.TestFramework;

type
   [TestFixture]
   TRepositorioContaDeUsuarioBancoDeDadoFireDACTeste = class
   private
      FConexaoBancoDeDado: TConexaoBancoDeDado;
      FRepositorioContaDeUsuario: TRepositorioContaDeUsuario;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
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

{ TRepositorioContaDeUsuarioBancoDeDadoFireDACTeste }

procedure TRepositorioContaDeUsuarioBancoDeDadoFireDACTeste.Inicializar;
begin
   FConexaoBancoDeDado := TConexaoBancoDeDadoFireDAC.Create;
   FRepositorioContaDeUsuario := TRepositorioContaDeUsuarioBancoDeDado.Create(FConexaoBancoDeDado);
end;

procedure TRepositorioContaDeUsuarioBancoDeDadoFireDACTeste.Finalizar;
begin
   FRepositorioContaDeUsuario.Destroy;
   FConexaoBancoDeDado.Destroy;
end;

procedure TRepositorioContaDeUsuarioBancoDeDadoFireDACTeste.DeveSalvarUmaContaDeUsuarioEObterPorEmail;
var lContaDeUsuario: TContaDeUsuario;
    lEmail: TEMail;
begin
   lEmail := TEmail.Create(Format('john.doe.%d@gmail.com', [Random(100000000)]));
   try
      lContaDeUsuario := TContaDeUsuario.CriarPassageiro('John Doe', lEmail.Valor, '958.187.055-52');
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

procedure TRepositorioContaDeUsuarioBancoDeDadoFireDACTeste.DeveSalvarUmaContaDeUsuarioEObterPorID;
var lContaDeUsuario: TContaDeUsuario;
    lIDDoUsuario: String;
    lID: TUUID;
begin
   lContaDeUsuario := TContaDeUsuario.CriarPassageiro('John Doe', Format('john.doe.%d@gmail.com', [Random(100000000)]), '958.187.055-52');
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

procedure TRepositorioContaDeUsuarioBancoDeDadoFireDACTeste.DeveDispararErroSeTentarObterUmaContaDeUsuarioPorEmailNaoCadastrado;
var lEmail: TEMail;
begin
   lEmail := TEmail.Create('usuario.nao.cadastrado@mail.com');
   try
      Assert.WillRaise(
         procedure
         begin
            FRepositorioContaDeUsuario.ObterPorEmail(lEmail);
         end,
         EContaDeUsuarioNaoEncontrada
      );
   finally
      lEmail.Destroy;
   end;
end;

procedure TRepositorioContaDeUsuarioBancoDeDadoFireDACTeste.DeveDispararErroSeTentarObterUmaContaDeUsuarioPorIDNaoCadastrado;
var lID: TUUID;
begin
   lID := TUUID.Create('630d48cf6a02442e922bfe16440b36a5');
   try
      Assert.WillRaise(
         procedure
         begin
            FRepositorioContaDeUsuario.ObterPorID(lID);
         end,
         EContaDeUsuarioNaoEncontrada
      );
   finally
      lID.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TRepositorioContaDeUsuarioBancoDeDadoFireDACTeste);
end.
