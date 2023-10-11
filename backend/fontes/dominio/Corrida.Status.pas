unit Corrida.Status;

interface

uses
   System.SysUtils;

type
   EStatusCorridaInvalido = class(EArgumentException);
   EStatusCorridaTransicaoInvalida = class(EArgumentException);
   {$SCOPEDENUMS ON}
   TStatusCorrida = (Solicitada, Aceita, Iniciada, Finalizada, Cancelada);
   {$SCOPEDENUMS OFF}
   TStatusCorridaHelper = record helper for TStatusCorrida
   public
      function Valor: String;
      function TransicaoPara(pNovoStatus: TStatusCorrida): TStatusCorrida;
      class function Status(pValor: String): TStatusCorrida; static;
   end;
   TConjuntoDeStatusCorrida = set of TStatusCorrida;

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

function TStatusCorridaHelper.TransicaoPara(pNovoStatus: TStatusCorrida): TStatusCorrida;
begin
   case Self of
      TStatusCorrida.Solicitada:
      begin
         case pNovoStatus of
            TStatusCorrida.Solicitada: raise EStatusCorridaTransicaoInvalida.Create('Corrida já está solicitada. Não pode ser solicitada novamente!');
            TStatusCorrida.Iniciada: raise EStatusCorridaTransicaoInvalida.Create('Corrida está solicitada. Não pode ser iniciada! Primeiro deve ser aceita por um motorista!');
            TStatusCorrida.Finalizada: raise EStatusCorridaTransicaoInvalida.Create('Corrida está solicitada. Não pode ser finalizada! Primeiro deve ser aceita e depois iniciada por um motorista!');
         end;
      end;
      TStatusCorrida.Aceita:
      begin
         case pNovoStatus of
            TStatusCorrida.Solicitada: raise EStatusCorridaTransicaoInvalida.Create('Corrida foi aceita por um motorista. Não pode ser solicitada novamente!');
            TStatusCorrida.Aceita: raise EStatusCorridaTransicaoInvalida.Create('Corrida foi aceita por um motorista. Não pode ser aceita por um motorista novamente!');
            TStatusCorrida.Finalizada: raise EStatusCorridaTransicaoInvalida.Create('Corrida foi aceita por um motorista. Não pode ser finalizada! Primeiro deve ser iniciada pelo motorista!');
         end;
      end;
      TStatusCorrida.Iniciada:
      begin
         case pNovoStatus of
            TStatusCorrida.Solicitada: raise EStatusCorridaTransicaoInvalida.Create('Corrida já iniciada pelo motorista. Não pode ser solicitada novamente!');
            TStatusCorrida.Aceita: raise EStatusCorridaTransicaoInvalida.Create('Corrida já iniciada pelo motorista. Não pode ser aceita por um motorista novamente!');
            TStatusCorrida.Iniciada: raise EStatusCorridaTransicaoInvalida.Create('Corrida já iniciada pelo motorista. Não pode ser iniciada por um motorista novamente!');
         end;
      end;
      TStatusCorrida.Finalizada:
      begin
         case pNovoStatus of
            TStatusCorrida.Solicitada: raise EStatusCorridaTransicaoInvalida.Create('Corrida já finalizada pelo motorista. Não pode ser solicitada novamente!');
            TStatusCorrida.Aceita: raise EStatusCorridaTransicaoInvalida.Create('Corrida já finalizada pelo motorista. Não pode ser aceita por um motorista novamente!');
            TStatusCorrida.Iniciada: raise EStatusCorridaTransicaoInvalida.Create('Corrida já finalizada pelo motorista. Não pode ser iniciada por um motorista novamente!');
            TStatusCorrida.Finalizada: raise EStatusCorridaTransicaoInvalida.Create('Corrida já finalizada pelo motorista. Não pode ser finalizada por um motorista novamente!');
            TStatusCorrida.Cancelada: raise EStatusCorridaTransicaoInvalida.Create('Corrida já finalizada pelo motorista. Não pode ser cancelada!');
         end;
      end;
      TStatusCorrida.Cancelada:
      begin
         case pNovoStatus of
            TStatusCorrida.Solicitada: raise EStatusCorridaTransicaoInvalida.Create('Corrida cancelada. Não pode ser solicitada novamente!');
            TStatusCorrida.Aceita: raise EStatusCorridaTransicaoInvalida.Create('Corrida cancelada. Não pode ser aceita por um motorista!');
            TStatusCorrida.Iniciada: raise EStatusCorridaTransicaoInvalida.Create('Corrida cancelada. Não pode ser iniciada por um motorista!');
            TStatusCorrida.Finalizada: raise EStatusCorridaTransicaoInvalida.Create('Corrida cancelada. Não pode ser finalizada por um motorista!');
            TStatusCorrida.Cancelada: raise EStatusCorridaTransicaoInvalida.Create('Corrida já cancelada. Não pode ser cancelada novamente!');
         end;
      end;
   end;
   Result := pNovoStatus;
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
      raise EStatusCorridaInvalido.Create(Format('Valor "%s" para Status da corrida inválido!', [pValor]));
end;

end.
