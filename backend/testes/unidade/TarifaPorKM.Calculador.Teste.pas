unit TarifaPorKM.Calculador.Teste;

interface

uses
   System.SysUtils,
   TarifaPorKM.Calculador,
   DUnitX.TestFramework;

type
   [TestFixture]
   TCalculadorTarifaPorKMTeste = class
   public
      [Test]
      procedure DeveCalcularTarifaPadraoPorKM;
      [Test]
      procedure DeveCalcularTarifaNoturnaPorKM;
   end;

implementation


{ TCalculadorTarifaPorKMTeste }

procedure TCalculadorTarifaPorKMTeste.DeveCalcularTarifaPadraoPorKM;
var lCalculadorTarifaPorKM: TCalculadorTarifaPorKM;
begin
   lCalculadorTarifaPorKM := TFabricaCalculadorTarifaPorKM.Criar(StrToDateTimeDef('10/10/2023 10:00:00', 0));
   try
      Assert.AreEqual(2.1, lCalculadorTarifaPorKM.Obter);
   finally
      lCalculadorTarifaPorKM.Destroy;
   end;
end;

procedure TCalculadorTarifaPorKMTeste.DeveCalcularTarifaNoturnaPorKM;
var lCalculadorTarifaPorKM: TCalculadorTarifaPorKM;
begin
   lCalculadorTarifaPorKM := TFabricaCalculadorTarifaPorKM.Criar(StrToDateTimeDef('10/10/2023 00:00:00', 0));
   try
      Assert.AreEqual(5.0, lCalculadorTarifaPorKM.Obter);
   finally
      lCalculadorTarifaPorKM.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TCalculadorTarifaPorKMTeste);
end.
