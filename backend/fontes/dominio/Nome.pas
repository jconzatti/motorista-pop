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
      raise ENomeInvalido.Create('Nome inv�lido!');
   FValor := pValor;
end;

function TNome.TemNomeESobrenomeIniciadosComLetraMaiuscula(pValor: String): Boolean;
begin
   Result := TRegEx.IsMatch(pValor, '^[A-Z�������������][a-z�������������]+(\s[A-Z�������������][a-z�������������]+)+$');
end;

function TNome.TemNomeESobrenomeEmCaixaAlta(pValor: String): Boolean;
begin
   Result := TRegEx.IsMatch(pValor, '^[A-Z�������������]+(\s[A-Z�������������]+)+$');
end;

end.
