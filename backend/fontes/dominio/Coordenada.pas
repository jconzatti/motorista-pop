unit Coordenada;

interface

uses
   System.SysUtils,
   System.Math;

type
   ECoordenadaInvalida = class(EArgumentException);

   TCoordenada = class
   private
      FLatitude: Double;
      FLongitude: Double;
      const LATITUDE_MINIMA: Double = -90;
      const LATITUDE_MAXIMA: Double = 90;
      const LONGITUDE_MINIMA: Double = -180;
      const LONGITUDE_MAXIMA: Double = 180;
   public
      constructor Create(pLatitude, pLongitude: Double);
      property Latitude: Double read FLatitude;
      property Longitude: Double read FLongitude;
   end;

implementation

{ TCoordenada }

constructor TCoordenada.Create(pLatitude, pLongitude: Double);
begin
   if not InRange(pLatitude, LATITUDE_MINIMA, LATITUDE_MAXIMA) then
      raise ECoordenadaInvalida.Create('Latitude da coordenada inválida!');
   if not InRange(pLongitude, LONGITUDE_MINIMA, LONGITUDE_MAXIMA) then
      raise ECoordenadaInvalida.Create('Longitude da coordenada inválida!');
   FLatitude := pLatitude;
   FLongitude := pLongitude;
end;

end.
