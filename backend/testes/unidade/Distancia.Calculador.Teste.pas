unit Distancia.Calculador.Teste;

interface

uses
   Coordenada,
   Distancia.Calculador,
   DUnitX.TestFramework;

type
   [TestFixture]
   TCalculadorDistanciaTeste = class
   public
      [Test]
      procedure DeveCalcularUmaDistanciaEmQuilometrosEntreDuasCoordenadas;
   end;

implementation

procedure TCalculadorDistanciaTeste.DeveCalcularUmaDistanciaEmQuilometrosEntreDuasCoordenadas;
var lDistanciaEmKM: Double;
    lOrigem, lDestino : TCoordenada;
begin
   lOrigem  := TCoordenada.Create(-26.878982142930248, -49.08432093077141);
   lDestino := TCoordenada.Create(-26.880315198704235, -49.08605063741393);
   try
      lDistanciaEmKM := TCalculadorDistancia.Calcular(lOrigem, lDestino);
      Assert.AreEqual(0.227, lDistanciaEmKM);
   finally
      lDestino.Destroy;
      lOrigem.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TCalculadorDistanciaTeste);
end.
