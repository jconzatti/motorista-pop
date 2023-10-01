unit Corrida.Gateway.HTTP;

interface

uses
   System.SysUtils,
   System.JSON,
   JSON.Conversor,
   HTTP.Cliente,
   Corrida.Gateway;

type
   TGatewayCorridaHTTP = class(TGatewayCorrida)
   private
      FClienteHTTP : TClienteHTTP;
      FConversorJSON : TConversorJSON;
   public
      constructor Create(pClienteHTTP: TClienteHTTP); reintroduce;
      destructor Destroy; override;
      function SolicitarCorrida(pDadoSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida): String; override;
   end;

implementation

{ TGatewayCorridaHTTP }

constructor TGatewayCorridaHTTP.Create(pClienteHTTP: TClienteHTTP);
begin
   FConversorJSON := TConversorJSON.Create;
   FClienteHTTP := pClienteHTTP;
end;

destructor TGatewayCorridaHTTP.Destroy;
begin
   FConversorJSON.Destroy;
   inherited;
end;

function TGatewayCorridaHTTP.SolicitarCorrida(pDadoSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida): String;
var lJSONSolicitacaoCorrida: TJSONValue;
    lRespostaHTTP: TRespostaHTTP;
begin
   lJSONSolicitacaoCorrida := FConversorJSON.ConverterParaJSON<TDadoEntradaSolicitacaoCorrida>(pDadoSolicitacaoCorrida);
   try
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
