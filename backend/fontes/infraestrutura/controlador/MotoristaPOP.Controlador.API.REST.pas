unit MotoristaPOP.Controlador.API.REST;

interface

uses
   System.SysUtils,
   System.JSON,
   JSON.Conversor,
   HTTP.Servidor,
   InscreverUsuario,
   ObterContaDeUsuario,
   RealizarLogin,
   SolicitarCorrida,
   ObterCorridaAtivaDoUsuario;

type
   TControladorMotoristaPOPAPIREST = class
   private
      FConversorJSON: TConversorJSON;
      FServidorHTTP: TServidorHTTP;
      FInscreverUsuario: TInscreverUsuario;
      FObterContaDeUsuario: TObterContaDeUsuario;
      FRealizarLogin: TRealizarLogin;
      FSolicitarCorrida: TSolicitarCorrida;
      FObterCorridaAtivaDoUsuario: TObterCorridaAtivaDoUsuario;
      function ExecutarObterContaDeUsuario(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarObterCorridaAtivaDoUsuario(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarInscreverUsuario(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarRealizarLogin(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarSolicitarCorrida(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      procedure RegistrarRotasDaAPI;
   public
      constructor Create(pServidorHTTP: TServidorHTTP;
                         pInscreverUsuario: TInscreverUsuario;
                         pObterContaDeUsuario: TObterContaDeUsuario;
                         pRealizarLogin: TRealizarLogin;
                         pSolicitarCorrida: TSolicitarCorrida;
                         pObterCorridaAtivaDoUsuario: TObterCorridaAtivaDoUsuario); reintroduce;
      destructor Destroy; override;
   end;

implementation

{ TControladorMotoristaPOPAPIREST }

constructor TControladorMotoristaPOPAPIREST.Create(pServidorHTTP: TServidorHTTP;
                                                   pInscreverUsuario: TInscreverUsuario;
                                                   pObterContaDeUsuario: TObterContaDeUsuario;
                                                   pRealizarLogin: TRealizarLogin;
                                                   pSolicitarCorrida: TSolicitarCorrida;
                                                   pObterCorridaAtivaDoUsuario: TObterCorridaAtivaDoUsuario);
begin
   FConversorJSON := TConversorJSON.Create;

   FServidorHTTP        := pServidorHTTP;
   FInscreverUsuario    := pInscreverUsuario;
   FObterContaDeUsuario := pObterContaDeUsuario;
   FRealizarLogin       := pRealizarLogin;
   FSolicitarCorrida    := pSolicitarCorrida;
   FObterCorridaAtivaDoUsuario := pObterCorridaAtivaDoUsuario;
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
   FServidorHTTP.Executar(mGET, '/usuario/:id/corrida_ativa', ExecutarObterCorridaAtivaDoUsuario);
   FServidorHTTP.Executar(mPOST, '/login/:email', ExecutarRealizarLogin);
   FServidorHTTP.Executar(mPOST, '/corrida/solicitar', ExecutarSolicitarCorrida);
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

function TControladorMotoristaPOPAPIREST.ExecutarObterCorridaAtivaDoUsuario(
  pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
var
   lSaidaObtencaoCorridaAtiva : TDadoSaidaObtencaoCorridaAtiva;
   lJSONSaidaObtencaoCorridaAtiva: TJSONValue;
begin
   try
      lSaidaObtencaoCorridaAtiva     := FObterCorridaAtivaDoUsuario.Executar(pParametros.Items['id']);
      lJSONSaidaObtencaoCorridaAtiva := FConversorJSON.ConverterParaJSON<TDadoSaidaObtencaoCorridaAtiva>(lSaidaObtencaoCorridaAtiva);
      Result := TResultadoHTTP.Create(lJSONSaidaObtencaoCorridaAtiva);
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

function TControladorMotoristaPOPAPIREST.ExecutarSolicitarCorrida(
  pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
var
   lEntradaSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida;
   lSaidaSolicitacaoCorrida: TDadoSaidaSolicitacaoCorrida;
   lJSONSaidaSolicitacaoCorrida: TJSONValue;
begin
   try
      lEntradaSolicitacaoCorrida := FConversorJSON.ConverterParaObjeto<TDadoEntradaSolicitacaoCorrida>(pConteudo);
      lSaidaSolicitacaoCorrida   := FSolicitarCorrida.Executar(lEntradaSolicitacaoCorrida);
      lJSONSaidaSolicitacaoCorrida := FConversorJSON.ConverterParaJSON<TDadoSaidaSolicitacaoCorrida>(lSaidaSolicitacaoCorrida);
      Result := TResultadoHTTP.Create(lJSONSaidaSolicitacaoCorrida);
   except
      on E: Exception do
         Result := TResultadoHTTP.Create(E);
   end;
end;

end.
