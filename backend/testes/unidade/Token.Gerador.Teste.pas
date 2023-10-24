unit Token.Gerador.Teste;

interface

uses
   ContaDeUsuario,
   Token.Gerador,
   DUnitX.TestFramework;

type
   [TestFixture]
   TGeradorTokenTeste = class
   public
      [Test]
      procedure DeveGerarUmToken;
   end;

implementation


{ TGeradorTokenTeste }

procedure TGeradorTokenTeste.DeveGerarUmToken;
var
   lContaDeUsuario : TContaDeUsuario;
begin
   lContaDeUsuario := TContaDeUsuario.CriarPassageiro('João Da Silva',
                                                      'joao.silva@mail.com',
                                                      '761.765.681-53',
                                                      'S3nh@F0rte');
   try
      Assert.IsNotEmpty(TGeradorToken.Gerar(lContaDeUsuario));
      Assert.IsNotEmpty(TGeradorToken.Segredo);
   finally
      lContaDeUsuario.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TGeradorTokenTeste);

end.
