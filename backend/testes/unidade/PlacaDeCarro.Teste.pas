unit PlacaDeCarro.Teste;

interface

uses
   System.SysUtils,
   PlacaDeCarro,
   DUnitX.TestFramework;

type
   [TestFixture]
   TPlacaDeCarroTeste = class
   public
      [Test]
      [TestCase('Deve criar placa de carro válida', 'AAA0000')]
      [TestCase('Deve criar placa de carro válida', 'AAA0B00')]
      [TestCase('Deve criar placa de carro válida', 'aaa0000')]
      [TestCase('Deve criar placa de carro válida', 'aaa0b00')]
      [TestCase('Deve criar placa de carro válida', 'AAA-0000')]
      [TestCase('Deve criar placa de carro válida', 'aaa-0000')]
      procedure DeveCriarPlacaDeCarroValida(const pValor: String);
      [Test]
      [TestCase('Não pode criar placa de carro inválida', 'AAA000')]
      [TestCase('Não pode criar placa de carro inválida', 'João')]
      [TestCase('Não pode criar placa de carro inválida', '000-5151')]
      procedure NaoPodeCriarPlacaDeCarroInvalida(const pValor: String);
   end;

implementation


{ TPlacaDeCarroTeste }

procedure TPlacaDeCarroTeste.DeveCriarPlacaDeCarroValida(const pValor: String);
var lPlacaDeCarro : TPlacaDeCarro;
begin
   lPlacaDeCarro := TPlacaDeCarro.Create(pValor);
   try
      Assert.AreEqual<String>(pValor.ToUpper.Replace('-', ''), lPlacaDeCarro.Valor);
   finally
      lPlacaDeCarro.Destroy;
   end;
end;

procedure TPlacaDeCarroTeste.NaoPodeCriarPlacaDeCarroInvalida(const pValor: String);
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TPlacaDeCarro.Create(pValor);
      end,
      EPlacaDeCarroInvalida,
      'Placa de carro inválida!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TPlacaDeCarroTeste);
end.
