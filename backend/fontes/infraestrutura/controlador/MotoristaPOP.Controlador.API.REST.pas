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
   ObterCorridas;

type
   TControladorMotoristaPOPAPIREST = class
   private
      FConversorJSON: TConversorJSON;
      FServidorHTTP: TServidorHTTP;
      FInscreverUsuario: TInscreverUsuario;
      FObterContaDeUsuario: TObterContaDeUsuario;
      FRealizarLogin: TRealizarLogin;
      FSolicitarCorrida: TSolicitarCorrida;
      FObterCorridas: TObterCorridas;
      function ExecutarObterContaDeUsuario(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarObterCorridasDoUsuario(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
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
                         pObterCorridas: TObterCorridas); reintroduce;
      destructor Destroy; override;
   end;

implementation

{ TControladorMotoristaPOPAPIREST }

constructor TControladorMotoristaPOPAPIREST.Create(pServidorHTTP: TServidorHTTP;
                                                   pInscreverUsuario: TInscreverUsuario;
                                                   pObterContaDeUsuario: TObterContaDeUsuario;
                                                   pRealizarLogin: TRealizarLogin;
                                                   pSolicitarCorrida: TSolicitarCorrida;
                                                   pObterCorridas: TObterCorridas);
begin
   FConversorJSON := TConversorJSON.Create;

   FServidorHTTP        := pServidorHTTP;
   FInscreverUsuario    := pInscreverUsuario;
   FObterContaDeUsuario := pObterContaDeUsuario;
   FRealizarLogin       := pRealizarLogin;
   FSolicitarCorrida    := pSolicitarCorrida;
   FObterCorridas       := pObterCorridas;
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
   FServidorHTTP.Registrar(mPOST, '/usuario', ExecutarInscreverUsuario);
   FServidorHTTP.Registrar(mGET, '/usuario/:id', ExecutarObterContaDeUsuario);
   FServidorHTTP.Registrar(mGET, '/usuario/:id/corrida', ExecutarObterCorridasDoUsuario);
   FServidorHTTP.Registrar(mPOST, '/login/:email', ExecutarRealizarLogin);
   FServidorHTTP.Registrar(mPOST, '/corrida/solicitar', ExecutarSolicitarCorrida);
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

function TControladorMotoristaPOPAPIREST.ExecutarObterCorridasDoUsuario(
  pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
var
   lEntradaObtencaoCorridas : TDadoEntradaObtencaoCorridas;
   lSaidaObtencaoCorridas : TDadoSaidaObtencaoCorridas;
   lJSONSaidaObtencaoCorridas: TJSONValue;
begin
   try
      lEntradaObtencaoCorridas.IDDoUsuario := pParametros.Items['id'];
      if pParametros.ContainsKey('status') then
         lEntradaObtencaoCorridas.ListaDeStatus := pParametros.Items['status'].Split([',']);
      lSaidaObtencaoCorridas     := FObterCorridas.Executar(lEntradaObtencaoCorridas);
      lJSONSaidaObtencaoCorridas := FConversorJSON.ConverterParaJSON<TDadoSaidaObtencaoCorridas>(lSaidaObtencaoCorridas);
      Result := TResultadoHTTP.Create(lJSONSaidaObtencaoCorridas);
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
