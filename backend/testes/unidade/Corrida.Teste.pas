unit Corrida.Teste;

interface

uses
   System.SysUtils,
   System.DateUtils,
   Corrida,
   Corrida.Status,
   DUnitX.TestFramework;

type
   [TestFixture]
   TCorridaTeste = class
   public
      [Test]
      procedure DeveCriarUmaCorrida;
      [Test]
      procedure DeveRestaurarUmaCorrida;
   end;

implementation


{ TCorridaTeste }

procedure TCorridaTeste.DeveCriarUmaCorrida;
var lCorrida: TCorrida;
begin
   lCorrida := TCorrida.Criar('3da32233e4d0404687de6d96d345410e', 0, 10, 90, 80);
   try
      Assert.IsNotEmpty(lCorrida.ID);
      Assert.AreEqual('3da32233e4d0404687de6d96d345410e', lCorrida.IDDoPassageiro);
      Assert.IsEmpty(lCorrida.IDDoMotorista);
      Assert.AreEqual<TStatusCorrida>(TStatusCorrida.Solicitada, lCorrida.Status);
      Assert.AreEqual<Double>(0, lCorrida.Tarifa);
      Assert.AreEqual<Double>(0, lCorrida.Distancia);
      Assert.AreEqual<Double>(0, lCorrida.De.Latitude);
      Assert.AreEqual<Double>(10, lCorrida.De.Longitude);
      Assert.AreEqual<Double>(90, lCorrida.Para.Latitude);
      Assert.AreEqual<Double>(80, lCorrida.Para.Longitude);
      Assert.AreEqual<TDate>(Date, DateOf(lCorrida.Data));
   finally
      lCorrida.Destroy;
   end;
end;

procedure TCorridaTeste.DeveRestaurarUmaCorrida;
var lCorrida: TCorrida;
begin
   lCorrida := TCorrida.Restaurar('3da32233e4d0404687de6d96d345410a',
                                  '3da32233e4d0404687de6d96d345410b',
                                  '3da32233e4d0404687de6d96d345410c',
                                  TStatusCorrida.Finalizada,
                                  30, 63, 0, 10, 90, 80, Now);
   try
      Assert.AreEqual('3da32233e4d0404687de6d96d345410a', lCorrida.ID);
      Assert.AreEqual('3da32233e4d0404687de6d96d345410b', lCorrida.IDDoPassageiro);
      Assert.AreEqual('3da32233e4d0404687de6d96d345410c', lCorrida.IDDoMotorista);
      Assert.AreEqual<TStatusCorrida>(TStatusCorrida.Finalizada, lCorrida.Status);
      Assert.AreEqual<Double>(30, lCorrida.Tarifa);
      Assert.AreEqual<Double>(63, lCorrida.Distancia);
      Assert.AreEqual<Double>(0, lCorrida.De.Latitude);
      Assert.AreEqual<Double>(10, lCorrida.De.Longitude);
      Assert.AreEqual<Double>(90, lCorrida.Para.Latitude);
      Assert.AreEqual<Double>(80, lCorrida.Para.Longitude);
      Assert.AreEqual<TDate>(Date, DateOf(lCorrida.Data));
   finally
      lCorrida.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TCorridaTeste);
end.
