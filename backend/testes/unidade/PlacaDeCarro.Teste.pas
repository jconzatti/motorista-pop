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
      [TestCase('Deve criar placa de carro v�lida', 'AAA0000')]
      [TestCase('Deve criar placa de carro v�lida', 'AAA0B00')]
      [TestCase('Deve criar placa de carro v�lida', 'aaa0000')]
      [TestCase('Deve criar placa de carro v�lida', 'aaa0b00')]
      [TestCase('Deve criar placa de carro v�lida', 'AAA-0000')]
      [TestCase('Deve criar placa de carro v�lida', 'aaa-0000')]
      procedure DeveCriarPlacaDeCarroValida(const pValor: String);
      [Test]
      [TestCase('N�o pode criar placa de carro inv�lida', 'AAA000')]
      [TestCase('N�o pode criar placa de carro inv�lida', 'Jo�o')]
      [TestCase('N�o pode criar placa de carro inv�lida', '000-5151')]
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
      'Placa de carro inv�lida!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TPlacaDeCarroTeste);
end.
