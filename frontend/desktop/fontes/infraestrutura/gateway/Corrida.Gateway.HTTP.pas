unit Corrida.Gateway.HTTP;

interface

uses
   System.SysUtils,
   System.JSON,
   System.Generics.Collections,
   HTTP.Cliente,
   Corrida.Gateway;

type
   TGatewayCorridaHTTP = class(TGatewayCorrida)
   private
      FClienteHTTP : TClienteHTTP;
      function ObterStatusDaCorrida(pStatus: String): String;
   public
      constructor Create(pClienteHTTP: TClienteHTTP); reintroduce;
      function SolicitarCorrida(pDadoSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida): String; override;
      function ObterCorridaAtiva(pIDDoUsuario: String): TDadoSaidaObtencaoCorridaAtiva; override;
   end;

implementation

{ TGatewayCorridaHTTP }

constructor TGatewayCorridaHTTP.Create(pClienteHTTP: TClienteHTTP);
begin
   FClienteHTTP := pClienteHTTP;
end;

function TGatewayCorridaHTTP.ObterCorridaAtiva(pIDDoUsuario: String): TDadoSaidaObtencaoCorridaAtiva;
var lJSONCorrida: TJSONValue;
    lRespostaHTTP: TRespostaHTTP;
begin
   lRespostaHTTP := FClienteHTTP.Get(Format('http://localhost:9000/usuario/%s/corrida_ativa', [pIDDoUsuario]));
   lJSONCorrida := TJSONObject.ParseJSONValue(lRespostaHTTP.Dado);
   try
      if lRespostaHTTP.CodigoDeRespostaHTTP <> 200 then
         raise Exception.Create(lJSONCorrida.GetValue<string>('Erro'));
      Result.Motorista    := lJSONCorrida.GetValue<string>('Motorista');
      Result.Passageiro   := lJSONCorrida.GetValue<string>('Passageiro');
      Result.Status       := ObterStatusDaCorrida(lJSONCorrida.GetValue<string>('Status'));
      Result.Destino.Latitude  := lJSONCorrida.GetValue<TJSONObject>('Destino').GetValue<Double>('Latitude');
      Result.Destino.Longitude := lJSONCorrida.GetValue<TJSONObject>('Destino').GetValue<Double>('Longitude');
   finally
      lJSONCorrida.Destroy;
   end;
end;

function TGatewayCorridaHTTP.ObterStatusDaCorrida(pStatus: String): String;
begin
   Result := pStatus;
   if pStatus.ToLower.Equals('requested') then
      Result := 'Procurando motorista'
   else if pStatus.ToLower.Equals('accepted') then
      Result := 'O motorista está indo até você'
   else if pStatus.ToLower.Equals('in_progress') then
      Result := 'Vocé está a caminho do seu destino. Boa viagem!'
   else if pStatus.ToLower.Equals('completed') then
      Result := 'Sua corrida terminou!'
   else if pStatus.ToLower.Equals('canceled') then
      Result := 'Sua corrida foi cancelada!'
end;

function TGatewayCorridaHTTP.SolicitarCorrida(pDadoSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida): String;
var lJSONSolicitacaoCorrida: TJSONValue;
    lJSONCoordenadaOrigem, lJSONCoordenadaDestino: TJSONObject;
    lRespostaHTTP: TRespostaHTTP;
begin
   lJSONSolicitacaoCorrida := TJSONObject.Create;
   try
      TJSONObject(lJSONSolicitacaoCorrida).AddPair('IDDoPassageiro', pDadoSolicitacaoCorrida.IDDoPassageiro);
      lJSONCoordenadaOrigem := TJSONObject.Create;
      lJSONCoordenadaOrigem.AddPair('Latitude', TJSONNumber.Create(pDadoSolicitacaoCorrida.De.Latitude));
      lJSONCoordenadaOrigem.AddPair('Longitude', TJSONNumber.Create(pDadoSolicitacaoCorrida.De.Longitude));
      TJSONObject(lJSONSolicitacaoCorrida).AddPair('De', lJSONCoordenadaOrigem);
      lJSONCoordenadaDestino := TJSONObject.Create;
      lJSONCoordenadaDestino.AddPair('Latitude', TJSONNumber.Create(pDadoSolicitacaoCorrida.De.Latitude));
      lJSONCoordenadaDestino.AddPair('Longitude', TJSONNumber.Create(pDadoSolicitacaoCorrida.De.Longitude));
      TJSONObject(lJSONSolicitacaoCorrida).AddPair('Para', lJSONCoordenadaDestino);
      lRespostaHTTP := FClienteHTTP.Post('http://localhost:9000/corrida/solicitar', lJSONSolicitacaoCorrida.ToJSON);
   finally
      lJSONSolicitacaoCorrida.Destroy;
   end;
   lJSONSolicitacaoCorrida := TJSONObject.ParseJSONValue(lRespostaHTTP.Dado);
   try
      if lRespostaHTTP.CodigoDeRespostaHTTP <> 200 then
         raise Exception.Create(lJSONSolicitacaoCorrida.GetValue<string>('Erro'));
      Result := lJSONSolicitacaoCorrida.GetValue<string>('IDDaCorrida');
   finally
      lJSONSolicitacaoCorrida.Destroy;
   end;
end;

end.
