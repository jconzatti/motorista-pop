unit Email;

interface

uses
   System.SysUtils,
   System.RegularExpressions;

type
   EEmailInvalido = class(EArgumentException);

   TEmail = class
   private
      FValor: String;
   public
      constructor Create(pValor: String); reintroduce;
      property Valor : String read FValor;
   end;

implementation

{ TEmail }

constructor TEmail.Create(pValor: String);
begin
   pValor := pValor.ToLower;
   if not TRegEx.IsMatch(pValor, '^[a-z][a-z0-9_]+(\.[a-z0-9_]+)*@[a-z][a-z0-9]+(\.[a-z0-9]+)+$') then
      raise EEmailInvalido.Create('e-mail inválido!');
   FValor := pValor;
end;

end.
