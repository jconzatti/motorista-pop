unit Distancia.Calculador;

interface

uses
   System.Math;

type
   TCalculadorDistancia = class
   public
      function Calcular(pDeLatitude, pDeLongitude: Double;
                        pParaLatitude, pParaLongitude: Double): Double;
   end;

implementation

{ TCalculadorDistancia }

function TCalculadorDistancia.Calcular(pDeLatitude, pDeLongitude, pParaLatitude,
  pParaLongitude: Double): Double;
var
   lLatitudeDeOrigemEmRadiano: Double;
   lLatitudeDeDestinoEmRadiano: Double;
   lVariacaoDeLongitude: Double;
   lVariacaoDeLongitudeEmRadiano: Double;
begin
   Result := 0;
   if (pDeLatitude <> pParaLatitude)
   or (pDeLongitude <> pParaLongitude) then
   begin
      lLatitudeDeOrigemEmRadiano    := (PI * pDeLatitude) / 180;
      lLatitudeDeDestinoEmRadiano   := (PI * pParaLatitude) / 180;
      lVariacaoDeLongitude          := pDeLongitude - pParaLongitude;
      lVariacaoDeLongitudeEmRadiano := (PI * lVariacaoDeLongitude) / 180;
      Result := Sin(lLatitudeDeOrigemEmRadiano) *
                Sin(lLatitudeDeDestinoEmRadiano) +
                Cos(lLatitudeDeOrigemEmRadiano) *
                Cos(lLatitudeDeDestinoEmRadiano) *
                Cos(lVariacaoDeLongitudeEmRadiano);
      if Result > 1 then
         Result := 1;
      Result := ArcCos(Result);
      Result := (Result * 180) / PI;
      Result := Result * 60 * 1.1515;
      Result := RoundTo(Result * 1.609344, -3);
   end;
end;

end.
