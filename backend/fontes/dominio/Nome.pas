unit Nome;

interface

uses
   System.SysUtils,
   System.RegularExpressions;

type
   ENomeInvalido = class(EArgumentException);

   TNome = class
   private
      FValor: String;
      function TemNomeESobrenomeIniciadosComLetraMaiuscula(pValor: String): Boolean;
      function TemNomeESobrenomeEmCaixaAlta(pValor: String): Boolean;
   public
      constructor Create(pValor: String); reintroduce;
      property Valor : String read FValor;
   end;

implementation

{ TNome }

constructor TNome.Create(pValor: String);
begin
   if  (not TemNomeESobrenomeIniciadosComLetraMaiuscula(pValor))
   and (not TemNomeESobrenomeEmCaixaAlta(pValor)) then
      raise ENomeInvalido.Create('Nome inválido!');
   FValor := pValor;
end;

function TNome.TemNomeESobrenomeIniciadosComLetraMaiuscula(pValor: String): Boolean;
begin
   Result := TRegEx.IsMatch(pValor, '^[A-ZÁÉÍÓÚÂÊÎÔÛÃÕÇ][a-záéíóúâêîôûãõç]+(\s[A-ZÁÉÍÓÚÂÊÎÔÛÃÕÇ][a-záéíóúâêîôûãõç]+)+$');
end;

function TNome.TemNomeESobrenomeEmCaixaAlta(pValor: String): Boolean;
begin
   Result := TRegEx.IsMatch(pValor, '^[A-ZÁÉÍÓÚÂÊÎÔÛÃÕÇ]+(\s[A-ZÁÉÍÓÚÂÊÎÔÛÃÕÇ]+)+$');
end;

end.
