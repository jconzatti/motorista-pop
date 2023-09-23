unit Email.Teste;

interface

uses
   System.SysUtils,
   Email,
   DUnitX.TestFramework;

type
   [TestFixture]
   TEmailTeste = class
   public
      [Test]
      [TestCase('Deve criar um email válido', 'joao.silva@mail.com')]
      [TestCase('Deve criar um email válido', 'joao_silva@mail.com')]
      [TestCase('Deve criar um email válido', 'joaosilva@mail.com')]
      [TestCase('Deve criar um email válido', 'JOAO@MAIL.COM')]
      [TestCase('Deve criar um email válido', 'john.doe.12345678@gmail.com')]
      procedure DeveCriarEmailValido(const pValor: String);
      [Test]
      [TestCase('Não pode criar um email inválido', '.silva@mail.com')]
      [TestCase('Não pode criar um email inválido', 'joao.silva@mail')]
      [TestCase('Não pode criar um email inválido', 'joao.silva')]
      [TestCase('Não pode criar um email inválido', 'joaosilva')]
      procedure NaoPodeCriarEmailInvalido(const pValor: String);
   end;

implementation

{ TEmailTeste }

procedure TEmailTeste.DeveCriarEmailValido(const pValor: String);
var lEmail : TEmail;
begin
   lEmail := TEmail.Create(pValor);
   try
      Assert.AreEqual<String>(pValor.ToLower, lEmail.Valor);
   finally
      lEmail.Destroy;
   end;
end;

procedure TEmailTeste.NaoPodeCriarEmailInvalido(const pValor: String);
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TEmail.Create(pValor);
      end,
      EEmailInvalido,
      'e-mail inválido!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TEmailTeste);
end.
