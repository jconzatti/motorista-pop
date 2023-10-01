unit Coordenada.Teste;

interface

uses
   Coordenada,
   DUnitX.TestFramework;

type
   [TestFixture]
   TCoordenadaTeste = class
   public
      [Test]
      [TestCase('Latitude e longitude mínimas', '-90,-180')]
      [TestCase('Latitude e longitude máximas', '90,180')]
      [TestCase('Latitude e longitude zeradas', '0,0')]
      procedure DeveCriarUmaCoordenada(pLatitude, pLongitude: Double);
      [Test]
      [TestCase('Latitude inferior a mínima', '-91')]
      [TestCase('Latitude superior a máxima', '91')]
      procedure NaoPodeCriarCoordenadaComLatitudeInvalida(pLatitude: Double);
      [Test]
      [TestCase('Longitude inferior a mínima', '-181')]
      [TestCase('Longitude superior a máxima', '181')]
      procedure NaoPodeCriarCoordenadaComLongitudeInvalida(pLongitude: Double);
   end;

implementation


{ TCoordenadaTeste }

procedure TCoordenadaTeste.DeveCriarUmaCoordenada(pLatitude,
  pLongitude: Double);
var lCoordenada: TCoordenada;
begin
   lCoordenada := TCoordenada.Create(pLatitude, pLongitude);
   try
      Assert.AreEqual(pLatitude, lCoordenada.Latitude);
      Assert.AreEqual(pLongitude, lCoordenada.Longitude);
   finally
      lCoordenada.Destroy;
   end;
end;

procedure TCoordenadaTeste.NaoPodeCriarCoordenadaComLatitudeInvalida(
  pLatitude: Double);
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TCoordenada.Create(pLatitude, 0)
      end,
      ECoordenadaInvalida,
      'Latitude da coordenada inválida!'
   );
end;

procedure TCoordenadaTeste.NaoPodeCriarCoordenadaComLongitudeInvalida(
  pLongitude: Double);
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TCoordenada.Create(0, pLongitude)
      end,
      ECoordenadaInvalida,
      'Longitude da coordenada inválida!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TCoordenadaTeste);
end.
