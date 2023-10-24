unit HTTP.Servidor.Horse;

interface

uses
   System.Classes,
   System.SysUtils,
   System.Generics.Collections,
   System.JSON,
   HTTP.Servidor,
   Token.Gerador,
   Horse,
   Horse.Jhonson,
   Horse.BasicAuthentication,
   Horse.JWT;

type
   TServidorHTTPHorse = class(TServidorHTTP)
   private
      FRotasSemAutorizacaoComToken: TList<String>;
      FRotasSemAutorizacaoBasica: TList<String>;
      FEmailLogin: String;
      FSenhaLogin: String;
      procedure AoIniciarServidor;
      procedure RegistrarPost(pURL : String; pCallback: TCallbackServidorHTTP);
      procedure RegistrarGet(pURL : String; pCallback: TCallbackServidorHTTP);
      procedure InvocarCallback(Req: THorseRequest; Res: THorseResponse; pCallback: TCallbackServidorHTTP);
   public
      constructor Create;
      destructor Destroy; override;
      procedure Iniciar(pPorta: Integer); override;
      procedure Registrar(pMetodo: TMetodoHTTP; pURL : String; pCallback: TCallbackServidorHTTP; pAutorizacaoHTTP: TAutorizacaoHTTP = TAutorizacaoHTTP.Nenhuma); override;
   end;

implementation

{ TServidorHTTPHorse }

constructor TServidorHTTPHorse.Create;
begin
   inherited;
   FRotasSemAutorizacaoComToken := TList<String>.Create;
   FRotasSemAutorizacaoBasica := TList<String>.Create;
end;

destructor TServidorHTTPHorse.Destroy;
begin
   FRotasSemAutorizacaoBasica.Destroy;
   FRotasSemAutorizacaoComToken.Destroy;
   inherited;
end;

procedure TServidorHTTPHorse.Registrar(pMetodo: TMetodoHTTP; pURL: String;
  pCallback: TCallbackServidorHTTP; pAutorizacaoHTTP: TAutorizacaoHTTP);
begin
   inherited;
   if pAutorizacaoHTTP <> TAutorizacaoHTTP.Basica then
      FRotasSemAutorizacaoBasica.Add(pURL);
   if pAutorizacaoHTTP <> TAutorizacaoHTTP.Token then
      FRotasSemAutorizacaoComToken.Add(pURL);
   case pMetodo of
      TMetodoHTTP.GET:  RegistrarGet(pURL, pCallback);
      TMetodoHTTP.POST: RegistrarPost(pURL, pCallback);
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
      if not FEmailLogin.IsEmpty then
      begin
         lParametros.Add('email', FEmailLogin);
         lParametros.Add('senha', FSenhaLogin);
      end;
      lResultadoHTTP := pCallback(lParametros, Req.Body);
      try
         Res.Status(lResultadoHTTP.CodigoDeRespostaHTTP);
         Res.Send<TJSONValue>(lResultadoHTTP.JSON)
      finally
         lResultadoHTTP.Destroy;
      end;
      FEmailLogin := '';
      FSenhaLogin := '';
   finally
      lParametros.Destroy;
   end;
end;

procedure TServidorHTTPHorse.Iniciar(pPorta: Integer);
begin
   inherited;
   THorse.Use(Jhonson);
   THorse.Use(HorseBasicAuthentication(
      function(const AUsername, APassword: string): Boolean
      begin
         FEmailLogin := AUsername;
         FSenhaLogin := APassword;
         Result := True;
      end,
      THorseBasicAuthenticationConfig.New.SkipRoutes(FRotasSemAutorizacaoBasica.ToArray)));
   THorse.Use(HorseJWT(TGeradorToken.Segredo, THorseJWTConfig.New.SkipRoutes(FRotasSemAutorizacaoComToken.ToArray)));
   THorse.Listen(pPorta, AoIniciarServidor);
end;

procedure TServidorHTTPHorse.AoIniciarServidor;
begin
   Writeln(Format('Servidor executando em %s:%d', [THorse.Host, THorse.Port]));
   Readln;
end;

end.
