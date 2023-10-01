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
      [TestCase('Latitude e longitude m�nimas', '-90,-180')]
      [TestCase('Latitude e longitude m�ximas', '90,180')]
      [TestCase('Latitude e longitude zeradas', '0,0')]
      procedure DeveCriarUmaCoordenada(pLatitude, pLongitude: Double);
      [Test]
      [TestCase('Latitude inferior a m�nima', '-91')]
      [TestCase('Latitude superior a m�xima', '91')]
      procedure NaoPodeCriarCoordenadaComLatitudeInvalida(pLatitude: Double);
      [Test]
      [TestCase('Longitude inferior a m�nima', '-181')]
      [TestCase('Longitude superior a m�xima', '181')]
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
      'Latitude da coordenada inv�lida!'
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
      'Longitude da coordenada inv�lida!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TCoordenadaTeste);
end.
