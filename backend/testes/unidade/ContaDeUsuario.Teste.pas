unit ContaDeUsuario.Teste;

interface

uses
   System.SysUtils,
   System.DateUtils,
   ContaDeUsuario,
   DUnitX.TestFramework;

type
   [TestFixture]
   TContaDeUsuarioTeste = class
   public
      [Test]
      procedure DeveCriarUmaContaDeUsuarioComoPassageiro;
   end;

implementation

procedure TContaDeUsuarioTeste.DeveCriarUmaContaDeUsuarioComoPassageiro;
//var lContaDeUsuario : TContaDeUsuario;
begin
//   lContaDeUsuario := TContaDeUsuario.CriarPassageiro('João da Silva',
//                                                      'joao.silva@mail.com',
//                                                      '761.765.681-53');
//   try
//      Assert.IsNotEmpty(lContaDeUsuario.ID);
//      Assert.AreEqual('João da Silva', lContaDeUsuario.Nome.Valor);
//      Assert.AreEqual('joao.silva@mail.com', lContaDeUsuario.Email.Valor);
//      Assert.AreEqual('761.765.681-53', lContaDeUsuario.CPF.Valor);
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
   TDUnitX.RegisterTestFixture(TContaDeUsuarioTeste);
end.
