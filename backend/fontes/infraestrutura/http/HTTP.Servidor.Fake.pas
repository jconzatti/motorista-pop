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
      procedure Registrar(pMetodo: TMetodoHTTP; pURL : String; pCallback: TCallbackServidorHTTP); override;
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
  pCallback: TCallbackServidorHTTP);
begin
   inherited;
   case pMetodo of
      mGET:  FRegistoRotaGET.AddOrSetValue(pURL.ToLower, pCallback);
      mPOST: FRegistoRotaPost.AddOrSetValue(pURL.ToLower, pCallback);
   end;
end;

function TServidorHTTPFake.Invocar(pMetodo: TMetodoHTTP; pURL : String; pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
var lCallback: TCallbackServidorHTTP;
begin
   Result := nil;
   lCallback := nil;
   case pMetodo of
      mGET: FRegistoRotaGET.TryGetValue(pURL.ToLower, lCallback);
      mPOST: FRegistoRotaPost.TryGetValue(pURL.ToLower, lCallback);
   end;
   if Assigned(lCallback) then
      Result := lCallback(pParametros, pConteudo);
end;

end.
