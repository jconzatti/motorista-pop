unit MotoristaPOP.Controlador.API.REST;

interface

uses
   System.SysUtils,
   System.JSON,
   JSON.Conversor,
   HTTP.Servidor,
   InscreverUsuario,
   ObterContaDeUsuario,
   RealizarLogin;

type
   TControladorMotoristaPOPAPIREST = class
   private
      FConversorJSON: TConversorJSON;
      FServidorHTTP: TServidorHTTP;
      FInscreverUsuario: TInscreverUsuario;
      FObterContaDeUsuario: TObterContaDeUsuario;
      FRealizarLogin: TRealizarLogin;
      function ExecutarObterContaDeUsuario(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarInscreverUsuario(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarRealizarLogin(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      procedure RegistrarRotasDaAPI;
   public
      constructor Create(pServidorHTTP: TServidorHTTP;
                         pInscreverUsuario: TInscreverUsuario;
                         pObterContaDeUsuario: TObterContaDeUsuario;
                         pRealizarLogin: TRealizarLogin); reintroduce;
      destructor Destroy; override;
   end;

implementation

{ TControladorMotoristaPOPAPIREST }

constructor TControladorMotoristaPOPAPIREST.Create(pServidorHTTP: TServidorHTTP;
                                                   pInscreverUsuario: TInscreverUsuario;
                                                   pObterContaDeUsuario: TObterContaDeUsuario;
                                                   pRealizarLogin: TRealizarLogin);
begin
   FConversorJSON := TConversorJSON.Create;

   FServidorHTTP        := pServidorHTTP;
   FInscreverUsuario    := pInscreverUsuario;
   FObterContaDeUsuario := pObterContaDeUsuario;
   FRealizarLogin       := pRealizarLogin;
   RegistrarRotasDaAPI;
   FServidorHTTP.Iniciar(9000);
end;

destructor TControladorMotoristaPOPAPIREST.Destroy;
begin
   FConversorJSON.Destroy;
   inherited;
end;

procedure TControladorMotoristaPOPAPIREST.RegistrarRotasDaAPI;
begin
   FServidorHTTP.Executar(mPOST, '/usuario', ExecutarInscreverUsuario);
   FServidorHTTP.Executar(mGET, '/usuario/:id', ExecutarObterContaDeUsuario);
   FServidorHTTP.Executar(mPOST, '/login/:email', ExecutarRealizarLogin);
end;

function TControladorMotoristaPOPAPIREST.ExecutarInscreverUsuario(
  pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
var
   lEntradaInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
   lSaidaInscricaoUsuario: TDadoSaidaInscricaoContaDeUsuario;
   lJSONSaidaInscricaoUsuario: TJSONValue;
begin
   try
      lEntradaInscricaoUsuario   := FConversorJSON.ConverterParaObjeto<TDadoEntradaInscricaoContaDeUsuario>(pConteudo);
      lSaidaInscricaoUsuario     := FInscreverUsuario.Executar(lEntradaInscricaoUsuario);
      lJSONSaidaInscricaoUsuario := FConversorJSON.ConverterParaJSON(lSaidaInscricaoUsuario);
      Result := TResultadoHTTP.Create(lJSONSaidaInscricaoUsuario, 201);
   except
      on E: Exception do
         Result := TResultadoHTTP.Create(E);
   end;
end;

function TControladorMotoristaPOPAPIREST.ExecutarObterContaDeUsuario(
  pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
var
   lSaidaObtencaoUsuario : TDadoSaidaObtencaoContaDeUsuario;
   lJSONSaidaObtencaoUsuario: TJSONValue;
begin
   try
      lSaidaObtencaoUsuario     := FObterContaDeUsuario.Executar(pParametros.Items['id']);
      lJSONSaidaObtencaoUsuario := FConversorJSON.ConverterParaJSON<TDadoSaidaObtencaoContaDeUsuario>(lSaidaObtencaoUsuario);
      Result := TResultadoHTTP.Create(lJSONSaidaObtencaoUsuario);
   except
      on E: Exception do
         Result := TResultadoHTTP.Create(E);
   end;
end;

function TControladorMotoristaPOPAPIREST.ExecutarRealizarLogin(
  pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
var
   lSaidaRealizacaoLogin : TDadoSaidaRealizacaoLogin;
   lJSONSaidaRealizacaoLogin: TJSONValue;
begin
   try
      lSaidaRealizacaoLogin     := FRealizarLogin.Executar(pParametros.Items['email']);
      lJSONSaidaRealizacaoLogin := FConversorJSON.ConverterParaJSON<TDadoSaidaRealizacaoLogin>(lSaidaRealizacaoLogin);
      Result := TResultadoHTTP.Create(lJSONSaidaRealizacaoLogin);
   except
      on E: Exception do
         Result := TResultadoHTTP.Create(E);
   end;
end;

end.
