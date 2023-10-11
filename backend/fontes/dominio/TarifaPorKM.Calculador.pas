unit TarifaPorKM.Calculador;

interface

uses
   System.DateUtils,
   System.Math;

type
   TCalculadorTarifaPorKM = class abstract
   public
      function Obter: Double; virtual; abstract;
   end;

   TCalculadorTarifaPorKMPadrao = class(TCalculadorTarifaPorKM)
   public
      function Obter: Double; override;
   end;

   TCalculadorTarifaPorKMNoturna = class(TCalculadorTarifaPorKM)
   public
      function Obter: Double; override;
   end;

   TFabricaCalculadorTarifaPorKM = class
   public
      class function Criar(pData: TDateTime): TCalculadorTarifaPorKM;
   end;

implementation

{ TFabricaCalculadorTarifaPorKM }

class function TFabricaCalculadorTarifaPorKM.Criar(pData: TDateTime): TCalculadorTarifaPorKM;
begin
   if InRange(HourOf(pData), 6, 22) then
      Result := TCalculadorTarifaPorKMPadrao.Create
   else
      Result := TCalculadorTarifaPorKMNoturna.Create;
end;

{ TCalculadorTarifaPorKMPadrao }

function TCalculadorTarifaPorKMPadrao.Obter: Double;
begin
   Result := 2.1;
end;

{ TCalculadorTarifaPorKMNoturna }

function TCalculadorTarifaPorKMNoturna.Obter: Double;
begin
   Result := 5;
end;

end.
