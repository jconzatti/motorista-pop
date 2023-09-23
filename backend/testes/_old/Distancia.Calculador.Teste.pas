unit Distancia.Calculador.Teste;

interface

uses
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
var lCalculadorDistancia: TCalculadorDistancia;
    lDistanciaEmKM: Double;
begin
   lCalculadorDistancia := TCalculadorDistancia.Create;
   try
      lDistanciaEmKM := lCalculadorDistancia.Calcular(-26.878982142930248, -49.08432093077141,
                                                      -26.880315198704235, -49.08605063741393);
      Assert.AreEqual(0.227, lDistanciaEmKM);
   finally
      lCalculadorDistancia.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TCalculadorDistanciaTeste);
end.
