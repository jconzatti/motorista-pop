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
      [TestCase('Deve criar um email v�lido', 'joao.silva@mail.com')]
      [TestCase('Deve criar um email v�lido', 'joao_silva@mail.com')]
      [TestCase('Deve criar um email v�lido', 'joaosilva@mail.com')]
      [TestCase('Deve criar um email v�lido', 'JOAO@MAIL.COM')]
      [TestCase('Deve criar um email v�lido', 'john.doe.12345678@gmail.com')]
      procedure DeveCriarEmailValido(const pValor: String);
      [Test]
      [TestCase('N�o pode criar um email inv�lido', '.silva@mail.com')]
      [TestCase('N�o pode criar um email inv�lido', 'joao.silva@mail')]
      [TestCase('N�o pode criar um email inv�lido', 'joao.silva')]
      [TestCase('N�o pode criar um email inv�lido', 'joaosilva')]
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
      'e-mail inv�lido!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TEmailTeste);
end.
