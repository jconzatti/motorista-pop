unit Corrida.Status;

interface

uses
   System.SysUtils;

type
   EStatusCorridaInvalido = class(EArgumentException);
   {$SCOPEDENUMS ON}
   TStatusCorrida = (Solicitada, Aceita, Iniciada, Finalizada, Cancelada);
   {$SCOPEDENUMS OFF}
   TStatusCorridaHelper = record helper for TStatusCorrida
   public
      function Valor: String;
      class function Status(pValor: String): TStatusCorrida; static;
   end;

implementation

{ TStatusCorridaHelper }

function TStatusCorridaHelper.Valor: String;
begin
   case Self of
      TStatusCorrida.Solicitada: Result := 'requested';
      TStatusCorrida.Aceita: Result := 'accepted';
      TStatusCorrida.Iniciada: Result := 'in_progress';
      TStatusCorrida.Finalizada: Result := 'completed';
      TStatusCorrida.Cancelada: Result := 'canceled';
   end;
end;

class function TStatusCorridaHelper.Status(pValor: String): TStatusCorrida;
begin
   pValor := pValor.ToLower;
   if pValor.Equals('requested') then
      Result := TStatusCorrida.Solicitada
   else
   if pValor.Equals('accepted') then
      Result := TStatusCorrida.Aceita
   else
   if pValor.Equals('in_progress') then
      Result := TStatusCorrida.Iniciada
   else
   if pValor.Equals('completed') then
      Result := TStatusCorrida.Finalizada
   else
   if pValor.Equals('canceled') then
      Result := TStatusCorrida.Cancelada
   else
      raise EStatusCorridaInvalido.Create('Valor do Status da corrida inválido!');
end;

end.
