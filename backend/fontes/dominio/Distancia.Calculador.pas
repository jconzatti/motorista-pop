unit Distancia.Calculador;

interface

uses
   System.Math,
   Coordenada;

type
   TCalculadorDistancia = class
   public
      class function Calcular(pOrigem, pDestino: TCoordenada): Double;
   end;

implementation

{ TCalculadorDistancia }

class function TCalculadorDistancia.Calcular(pOrigem, pDestino: TCoordenada): Double;
var
   lLatitudeDeOrigemEmRadiano: Double;
   lLatitudeDeDestinoEmRadiano: Double;
   lVariacaoDeLongitude: Double;
   lVariacaoDeLongitudeEmRadiano: Double;
begin
   Result := 0;
   if (pOrigem.Latitude <> pDestino.Latitude)
   or (pOrigem.Longitude <> pDestino.Longitude) then
   begin
      lLatitudeDeOrigemEmRadiano    := (PI * pOrigem.Latitude) / 180;
      lLatitudeDeDestinoEmRadiano   := (PI * pDestino.Latitude) / 180;
      lVariacaoDeLongitude          := pOrigem.Longitude - pDestino.Longitude;
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
