unit HTTP.Cliente.Padrao;

interface

uses
   System.Classes,
   System.Net.HTTPClient,
   HTTP.Cliente;

type
   TClienteHTTPPadrao = class(TClienteHTTP)
   private
      FHTTPClient : THTTPClient;
   public
      constructor Create;
      destructor Destroy; override;
      function Post(pURL, pDado: String): TRespostaHTTP; override;
      function Get(pURL: String): TRespostaHTTP; override;
   end;

implementation

{ TClienteHTTPPadrao }

constructor TClienteHTTPPadrao.Create;
begin
   FHTTPClient := THTTPClient.Create;
end;

destructor TClienteHTTPPadrao.Destroy;
begin
   FHTTPClient.Destroy;
   inherited;
end;

function TClienteHTTPPadrao.Get(pURL: String): TRespostaHTTP;
var lHTTPResposta: IHTTPResponse;
begin
   lHTTPResposta := FHTTPClient.Get(pURL);
   Result.Dado := lHTTPResposta.ContentAsString;
   Result.CodigoDeRespostaHTTP := lHTTPResposta.StatusCode;
end;

function TClienteHTTPPadrao.Post(pURL, pDado: String): TRespostaHTTP;
var lHTTPResposta: IHTTPResponse;
    lStream: TStringStream;
begin
   lStream := TStringStream.Create(pDado);
   try
      lStream.Position := 0;
      lHTTPResposta := FHTTPClient.Post(pURL, lStream);
      Result.Dado := lHTTPResposta.ContentAsString;
      Result.CodigoDeRespostaHTTP := lHTTPResposta.StatusCode;
   finally
      lStream.Destroy;
   end;
end;

end.
