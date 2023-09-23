unit CPF;

interface

uses
   System.SysUtils,
   System.RegularExpressions;

type
   ECPFInvalido = class(EArgumentException);

   TCPF = class
   private
      FValor: String;
      type TDigito = 0..9;
      const EXPRESSAO_REGULAR_CPF = '^(\d{3}\.\d{3}\.\d{3}\-\d{2})|(\d{11})$';
      function Limpar(pValor: String): String;
      procedure ValidarFormato(pValor: String);
      procedure ValidarTodosOsDigitosSaoIguais(pValor: String);
      procedure ValidarDigito(pValor: String);
      function CalcularDigito(pValor: String): TDigito;
   public
      constructor Create(pValor: String); reintroduce;
      property Valor : String read FValor;
   end;

implementation

{ TCPF }

constructor TCPF.Create(pValor: String);
begin
   ValidarFormato(pValor);
   pValor := Limpar(pValor);
   ValidarTodosOsDigitosSaoIguais(pValor);
   ValidarDigito(pValor);
   FValor := pValor;
end;

procedure TCPF.ValidarFormato(pValor: String);
begin
   if not TRegEx.IsMatch(pValor, EXPRESSAO_REGULAR_CPF) then
      raise ECPFInvalido.Create(Format('CPF "%s" com formato inválido! Use os formatos 999.999.999-99 ou 99999999999.', [pValor]));
end;

function TCPF.Limpar(pValor: String): String;
begin
   Result := pValor.Replace('.', '', [rfReplaceAll]).Replace('-', '', [rfReplaceAll]);
end;

procedure TCPF.ValidarTodosOsDigitosSaoIguais(pValor: String);
var lDigito: Char;
    lTodosOsDigitosSaoIguais: Boolean;
begin
   lTodosOsDigitosSaoIguais := True;
   for lDigito in pValor.ToCharArray(1, pValor.Length - 1) do
   begin
      if lDigito <> pValor.Chars[0] then
      begin
         lTodosOsDigitosSaoIguais := False;
         Break
      end;
   end;

   if lTodosOsDigitosSaoIguais then
      raise ECPFInvalido.Create('CPF inválido!');
end;

procedure TCPF.ValidarDigito(pValor: String);
var
   lCPFCalculado: String;
   lDigito: TDigito;
begin
   lCPFCalculado := pValor.Substring(0,9);
   lDigito := CalcularDigito(lCPFCalculado);
   lCPFCalculado := lCPFCalculado + IntToStr(lDigito);
   lDigito := CalcularDigito(lCPFCalculado);
   lCPFCalculado := lCPFCalculado + IntToStr(lDigito);
   if not pValor.Equals(lCPFCalculado) then
      raise ECPFInvalido.Create(Format('CPF "%s" com dígito inválido!', [pValor]));
end;

function TCPF.CalcularDigito(pValor: String): TDigito;
var lSoma, I, lComprimento: Integer;
begin
   lSoma := 0;
   lComprimento := pValor.Length;
   for I := 0 to lComprimento - 1 do
      lSoma := lSoma + StrToIntDef(pValor.Chars[I], 0) * (lComprimento + 1 - I);
   Result := 11 - (lSoma mod 11);
   if Result >= 10 then
      Result := 0;
end;

end.
