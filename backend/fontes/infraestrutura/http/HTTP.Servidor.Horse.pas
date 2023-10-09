unit HTTP.Servidor.Horse;

interface

uses
   System.Classes,
   System.SysUtils,
   System.Generics.Collections,
   System.JSON,
   HTTP.Servidor,
   Horse,
   Horse.Jhonson;

type
   TServidorHTTPHorse = class(TServidorHTTP)
   private
      procedure AoIniciarServidor;
      procedure RegistrarPost(pURL : String; pCallback: TCallbackServidorHTTP);
      procedure RegistrarGet(pURL : String; pCallback: TCallbackServidorHTTP);
      procedure InvocarCallback(Req: THorseRequest; Res: THorseResponse; pCallback: TCallbackServidorHTTP);
   public
      constructor Create;
      procedure Iniciar(pPorta: Integer); override;
      procedure Registrar(pMetodo: TMetodoHTTP; pURL : String; pCallback: TCallbackServidorHTTP); override;
   end;

implementation

{ TServidorHTTPHorse }

constructor TServidorHTTPHorse.Create;
begin
   THorse.Use(Jhonson);
end;

procedure TServidorHTTPHorse.Registrar(pMetodo: TMetodoHTTP; pURL: String;
  pCallback: TCallbackServidorHTTP);
begin
   inherited;
   case pMetodo of
      mGET:  RegistrarGet(pURL, pCallback);
      mPOST: RegistrarPost(pURL, pCallback);
   end;
end;

procedure TServidorHTTPHorse.RegistrarGet(pURL: String;
  pCallback: TCallbackServidorHTTP);
begin
   inherited;
   THorse.Get(
      pURL,
      procedure (Req: THorseRequest; Res: THorseResponse)
      begin
         InvocarCallback(Req, Res, pCallback);
      end
   );
end;

procedure TServidorHTTPHorse.RegistrarPost(pURL: String;
  pCallback: TCallbackServidorHTTP);
begin
   inherited;
   THorse.Post(
      pURL,
      procedure (Req: THorseRequest; Res: THorseResponse)
      begin
         InvocarCallback(Req, Res, pCallback);
      end
   );
end;

procedure TServidorHTTPHorse.InvocarCallback(Req: THorseRequest;
  Res: THorseResponse; pCallback: TCallbackServidorHTTP);
var lParametros: TParametroHTTP;
    lParametro: TPair<String,String>;
    lResultadoHTTP: TResultadoHTTP;
begin
   inherited;
   lParametros := TParametroHTTP.Create;
   try
      for lParametro in Req.Params.ToArray do
         lParametros.Add(lParametro.Key, lParametro.Value);
      for lParametro in Req.Query.ToArray do
         lParametros.Add(lParametro.Key, lParametro.Value);
      lResultadoHTTP := pCallback(lParametros, Req.Body);
      try
         Res.Status(lResultadoHTTP.CodigoDeRespostaHTTP);
         Res.Send<TJSONValue>(lResultadoHTTP.JSON)
      finally
         lResultadoHTTP.Destroy;
      end;
   finally
      lParametros.Destroy;
   end;
end;

procedure TServidorHTTPHorse.Iniciar(pPorta: Integer);
begin
   inherited;
   THorse.Listen(pPorta, AoIniciarServidor);
end;

procedure TServidorHTTPHorse.AoIniciarServidor;
begin
   Writeln(Format('Servidor executando em %s:%d', [THorse.Host, THorse.Port]));
   Readln;
end;

end.
