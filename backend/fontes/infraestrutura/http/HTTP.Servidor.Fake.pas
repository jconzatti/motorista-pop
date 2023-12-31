unit HTTP.Servidor.Fake;

interface

uses
   System.SysUtils,
   System.Generics.Collections,
   HTTP.Servidor;

type
   TServidorHTTPFake = class(TServidorHTTP)
   private
      FRegistoRotaGET: TDictionary<String,TCallbackServidorHTTP>;
      FRegistoRotaPost: TDictionary<String,TCallbackServidorHTTP>;
   public
      constructor Create;
      destructor Destroy; override;
      procedure Iniciar(pPorta: Integer); override;
      procedure Registrar(pMetodo: TMetodoHTTP; pURL : String; pCallback: TCallbackServidorHTTP; pAutorizacaoHTTP: TAutorizacaoHTTP = TAutorizacaoHTTP.Nenhuma); override;
      function Invocar(pMetodo: TMetodoHTTP; pURL : String; pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
   end;

implementation

{ TServidorHTTPFake }

constructor TServidorHTTPFake.Create;
begin
   FRegistoRotaGET  := TDictionary<String,TCallbackServidorHTTP>.Create;
   FRegistoRotaPost := TDictionary<String,TCallbackServidorHTTP>.Create;
end;

destructor TServidorHTTPFake.Destroy;
begin
   FRegistoRotaPost.Destroy;
   FRegistoRotaGET.Destroy;
   inherited;
end;

procedure TServidorHTTPFake.Iniciar(pPorta: Integer);
begin
   inherited;
   Writeln(Format('Servidor Fake executando na porta %d', [pPorta]));
end;

procedure TServidorHTTPFake.Registrar(pMetodo: TMetodoHTTP; pURL: String;
  pCallback: TCallbackServidorHTTP; pAutorizacaoHTTP: TAutorizacaoHTTP);
begin
   inherited;
   case pMetodo of
      TMetodoHTTP.GET:  FRegistoRotaGET.AddOrSetValue(pURL.ToLower, pCallback);
      TMetodoHTTP.POST: FRegistoRotaPost.AddOrSetValue(pURL.ToLower, pCallback);
   end;
end;

function TServidorHTTPFake.Invocar(pMetodo: TMetodoHTTP; pURL : String; pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
var lCallback: TCallbackServidorHTTP;
begin
   lCallback := nil;
   case pMetodo of
      TMetodoHTTP.GET: FRegistoRotaGET.TryGetValue(pURL.ToLower, lCallback);
      TMetodoHTTP.POST: FRegistoRotaPost.TryGetValue(pURL.ToLower, lCallback);
   end;
   if Assigned(lCallback) then
      Result := lCallback(pParametros, pConteudo)
   else
      Result := TResultadoHTTP.Create(404);
end;

end.
