unit UUID;

interface

uses
   System.SysUtils,
   System.RegularExpressions;

type
   EUUIDInvalido = class(EArgumentException);

   TUUID = class
   private
      FValor: String;
   public
      class function Gerar: String;
      constructor Create(pValor: String); reintroduce;
      property Valor : String read FValor;
   end;

implementation

{ TUUID }

constructor TUUID.Create(pValor: String);
begin
   if not TRegEx.IsMatch(pValor, '^[a-f0-9]{32}$') then
      raise EUUIDInvalido.Create('UUID inválido!');
   FValor := pValor;
end;

class function TUUID.Gerar: String;
var lGUID: TGUID;
begin
   CreateGUID(lGUID);
   Result := lGUID.ToString.Replace('{','',[rfReplaceAll]).Replace('-','',[rfReplaceAll]).Replace('}','',[rfReplaceAll]).ToLower;
end;

end.
