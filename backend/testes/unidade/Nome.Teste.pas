unit Nome.Teste;

interface

uses
   Nome,
   DUnitX.TestFramework;

type
   [TestFixture]
   TNomeTeste = class(TObject)
   public
      [Test]
      [TestCase('Nome e Sobrenome', 'Jhoni Conzatti')]
      [TestCase('Nome, nome do meio e Sobrenome', 'Tha�s De Lima Silva Conzatti')]
      [TestCase('Nome e Sobrenome em caixa alta', 'JHONI CONZATTI')]
      [TestCase('Nome, nome do meio e Sobrenome em caixa alta', 'THA�S DE LIM�ES CONCEI��O')]
      procedure DeveCriarUmNomeValido(pNome: String);
      [Test]
      [TestCase('Nome sem Sobrenome', 'Jhoni')]
      [TestCase('Nome com n�meros', 'John Wick 4')]
      [TestCase('Nome com n�meros', '1234 5678')]
      [TestCase('Nome com n�meros', 'John Wick 1234')]
      [TestCase('Nome com s�mbolos', 'J@conzatti Insta_gram')]
      [TestCase('Nome iniciado com m�nuscula', 'jhoni Conzatti')]
      [TestCase('Sobrenome iniciado com m�nuscula', 'Jhoni conzatti')]
      [TestCase('Nome com letras ao contr�rio', 'jHONI Conzatti')]
      procedure NaoPodeCriarUmNomeInvalido(pNome: String);
   end;

implementation

procedure TNomeTeste.DeveCriarUmNomeValido(pNome: String);
var lNome : TNome;
begin
   lNome := TNome.Create(pNome);
   try
      Assert.AreEqual<String>(pNome, lNome.Valor);
   finally
      lNome.Destroy;
   end;
end;

procedure TNomeTeste.NaoPodeCriarUmNomeInvalido(pNome: String);
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TNome.Create(pNome);
      end,
      ENomeInvalido,
      'Nome inv�lido!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TNomeTeste);
end.
