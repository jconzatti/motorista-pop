unit Senha.Teste;

interface

uses
   Senha,
   Hash.Gerador,
   DUnitX.TestFramework;

type
   [TestFixture]
   TSenhaTeste = class
   public
      [Test]
      procedure DeveCriarUmaSenhaForte;
      [Test]
      procedure NaoPodeCriarUmaSenhaFraca;
      [Test]
      procedure DeveRestaurarUmaSenha;
      [Test]
      procedure DeveValidarUmaSenha;
      [Test]
      procedure NaoPodeValidarUmaSenhaIncorreta;
   end;

implementation


{ TSenhaTeste }

procedure TSenhaTeste.DeveCriarUmaSenhaForte;
var lSenha: TSenha;
begin
   lSenha := TSenha.Criar('abc', 'S3nh@FórTxçÃo', TAlgoritimoHash.Nenhum);
   try
      Assert.AreEqual('abcS3nh@FórTxçÃo', lSenha.Valor);
   finally
      lSenha.Destroy;
   end;
end;

procedure TSenhaTeste.NaoPodeCriarUmaSenhaFraca;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TSenha.Criar('abc', 'senhafraca', TAlgoritimoHash.Nenhum);
      end,
      ESenhaPoliticaInvalida,
      'A senha deve ter no mínimo 8 caracteres, pelo menos uma letra MAIÚSCULA, pelo menos uma letra minúscula, pelo menos um dígito numérico e pelo menos um caractere especial!'
   );
end;

procedure TSenhaTeste.DeveRestaurarUmaSenha;
var lSenha: TSenha;
begin
   lSenha := TSenha.Restaurar('abc', 'abc123456', TAlgoritimoHash.Nenhum);
   try
      Assert.AreEqual('abc123456', lSenha.Valor);
   finally
      lSenha.Destroy;
   end;
end;

procedure TSenhaTeste.DeveValidarUmaSenha;
var lSenha: TSenha;
begin
   lSenha := TSenha.Restaurar('abc', 'abc123456', TAlgoritimoHash.Nenhum);
   try
      Assert.IsTrue(lSenha.Validar('123456'));
   finally
      lSenha.Destroy;
   end;
end;

procedure TSenhaTeste.NaoPodeValidarUmaSenhaIncorreta;
var lSenha: TSenha;
begin
   lSenha := TSenha.Restaurar('abc', 'abc123456', TAlgoritimoHash.Nenhum);
   try
      Assert.IsFalse(lSenha.Validar('123455'));
   finally
      lSenha.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TSenhaTeste);

end.
