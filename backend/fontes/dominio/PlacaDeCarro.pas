unit PlacaDeCarro;

interface

uses
   System.SysUtils,
   System.RegularExpressions;

type
   EPlacaDeCarroInvalida = class(EArgumentException);

   TPlacaDeCarro = class
   private
      FValor: String;
   public
      constructor Create(pValor: String); reintroduce;
      property Valor : String read FValor;
   end;

implementation

{ TPlacaDeCarro }

constructor TPlacaDeCarro.Create(pValor: String);
begin
   pValor := pValor.ToUpper;
   if not TRegEx.IsMatch(pValor, '^([A-Z]{3}[0-9]{4})|([A-Z]{3}[0-9][A-Z][0-9]{2})|([A-Z]{3}\-[0-9]{4})$') then
      raise EPlacaDeCarroInvalida.Create('Placa de carro inválida!');
   pValor := pValor.Replace('-', '');
   FValor := pValor;
end;

end.
