unit CPF.Validador;

interface

uses
   System.SysUtils,
   System.RegularExpressions;

type
   TValidadorCPF = class
   private
      type TDigito = 0..9;
      const EXPRESSAO_REGULAR_CPF = '^(\d{3}\.\d{3}\.\d{3}\-\d{2})|(\d{11})$';
      function Limpar(pCPF: String): String;
      function ValidarFormato(pCPF: String): Boolean;
      function ComprimentoValido(pCPF: String): Boolean;
      function TodosOsDigitosSaoIguais(pCPF: String): Boolean;
      function CalcularDigito(pCPF: String): TDigito;
   public
      function Validar(pCPF: String): Boolean;
   end;

implementation

{ TValidadorCPF }

function TValidadorCPF.Validar(pCPF: String): Boolean;
var
   lCPFCalculado: String;
   lDigito: TDigito;
begin
   Result := ValidarFormato(pCPF);

   if Result then
   begin
      pCPF := Limpar(pCPF);
      Result := ComprimentoValido(pCPF);
   end;

   if Result then
      Result := not TodosOsDigitosSaoIguais(pCPF);

   if Result then
   begin
      lCPFCalculado := pCPF.Substring(0,9);
      lDigito := CalcularDigito(lCPFCalculado);
      lCPFCalculado := lCPFCalculado + IntToStr(lDigito);
      lDigito := CalcularDigito(lCPFCalculado);
      lCPFCalculado := lCPFCalculado + IntToStr(lDigito);
      Result := pCPF.Equals(lCPFCalculado);
   end;
end;

function TValidadorCPF.ValidarFormato(pCPF: String): Boolean;
begin
   Result := TRegEx.IsMatch(pCPF, EXPRESSAO_REGULAR_CPF);
end;

function TValidadorCPF.Limpar(pCPF: String): String;
begin
   Result := pCPF.Replace('.', '', [rfReplaceAll]).Replace('-', '', [rfReplaceAll]);
end;

function TValidadorCPF.ComprimentoValido(pCPF: String): Boolean;
begin
   Result := pCPF.Length = 11;
end;

function TValidadorCPF.TodosOsDigitosSaoIguais(pCPF: String): Boolean;
var lDigito: Char;
begin
   Result := True;
   for lDigito in pCPF.ToCharArray(1, pCPF.Length - 1) do
   begin
      if lDigito <> pCPF.Chars[0] then
      begin
         Result := False;
         Break
      end;
   end;
end;

function TValidadorCPF.CalcularDigito(pCPF: String): TDigito;
var lSoma, I, lComprimento: Integer;
begin
   lSoma := 0;
   lComprimento := pCPF.Length;
   for I := 0 to lComprimento - 1 do
      lSoma := lSoma + StrToIntDef(pCPF.Chars[I], 0) * (lComprimento + 1 - I);
   Result := 11 - (lSoma mod 11);
   if Result >= 10 then
      Result := 0;
end;

end.
