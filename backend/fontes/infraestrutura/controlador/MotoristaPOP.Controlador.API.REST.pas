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
   AceitarCorrida,
   IniciarCorrida,
   ObterCorridas,
   ObterCorrida;

type
   TControladorMotoristaPOPAPIREST = class
   private
      FConversorJSON: TConversorJSON;
      FServidorHTTP: TServidorHTTP;
      FInscreverUsuario: TInscreverUsuario;
      FObterContaDeUsuario: TObterContaDeUsuario;
      FRealizarLogin: TRealizarLogin;
      FSolicitarCorrida: TSolicitarCorrida;
      FAceitarCorrida: TAceitarCorrida;
      FIniciarCorrida: TIniciarCorrida;
      FObterCorridas: TObterCorridas;
      FObterCorrida: TObterCorrida;
      function ExecutarObterContaDeUsuario(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarObterCorridasDoUsuario(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarInscreverUsuario(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarRealizarLogin(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarSolicitarCorrida(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarAceitarCorrida(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarIniciarCorrida(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarObterCorrida(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      procedure RegistrarRotasDaAPI;
   public
      constructor Create(pServidorHTTP: TServidorHTTP;
                         pInscreverUsuario: TInscreverUsuario;
                         pObterContaDeUsuario: TObterContaDeUsuario;
                         pRealizarLogin: TRealizarLogin;
                         pSolicitarCorrida: TSolicitarCorrida;
                         pAceitarCorrida: TAceitarCorrida;
                         pIniciarCorrida: TIniciarCorrida;
                         pObterCorridas: TObterCorridas;
                         pObterCorrida: TObterCorrida); reintroduce;
      destructor Destroy; override;
   end;

implementation

{ TControladorMotoristaPOPAPIREST }

constructor TControladorMotoristaPOPAPIREST.Create(pServidorHTTP: TServidorHTTP;
                         pInscreverUsuario: TInscreverUsuario;
                         pObterContaDeUsuario: TObterContaDeUsuario;
                         pRealizarLogin: TRealizarLogin;
                         pSolicitarCorrida: TSolicitarCorrida;
                         pAceitarCorrida: TAceitarCorrida;
                         pIniciarCorrida: TIniciarCorrida;
                         pObterCorridas: TObterCorridas;
                         pObterCorrida: TObterCorrida);
begin
   FConversorJSON := TConversorJSON.Create;

   FServidorHTTP        := pServidorHTTP;
   FInscreverUsuario    := pInscreverUsuario;
   FObterContaDeUsuario := pObterContaDeUsuario;
   FRealizarLogin       := pRealizarLogin;
   FSolicitarCorrida    := pSolicitarCorrida;
   FAceitarCorrida      := pAceitarCorrida;
   FIniciarCorrida      := pIniciarCorrida;
   FObterCorridas       := pObterCorridas;
   FObterCorrida        := pObterCorrida;
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
   FServidorHTTP.Registrar(mGET, '/corrida/:id', ExecutarObterCorrida);
   FServidorHTTP.Registrar(mPOST, '/corrida/solicitar', ExecutarSolicitarCorrida);
   FServidorHTTP.Registrar(mPOST, '/corrida/:id/aceitar', ExecutarAceitarCorrida);
   FServidorHTTP.Registrar(mPOST, '/corrida/:id/iniciar', ExecutarIniciarCorrida);
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

function TControladorMotoristaPOPAPIREST.ExecutarAceitarCorrida(
  pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
var
   lEntradaAceiteCorrida: TDadoEntradaAceiteCorrida;
   lJSONSaidaAceiteCorrida: TJSONValue;
begin
   try
      lEntradaAceiteCorrida := FConversorJSON.ConverterParaObjeto<TDadoEntradaAceiteCorrida>(pConteudo);
      lEntradaAceiteCorrida.IDDaCorrida := pParametros.Items['id'];
      FAceitarCorrida.Executar(lEntradaAceiteCorrida);
      Result := TResultadoHTTP.Create;
   except
      on E: Exception do
         Result := TResultadoHTTP.Create(E);
   end;
end;

function TControladorMotoristaPOPAPIREST.ExecutarIniciarCorrida(
  pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
var
   lEntradaInicioCorrida: TDadoEntradaInicioCorrida;
   lJSONSaidaAceiteCorrida: TJSONValue;
begin
   try
      lEntradaInicioCorrida := FConversorJSON.ConverterParaObjeto<TDadoEntradaInicioCorrida>(pConteudo);
      lEntradaInicioCorrida.IDDaCorrida := pParametros.Items['id'];
      FIniciarCorrida.Executar(lEntradaInicioCorrida);
      Result := TResultadoHTTP.Create;
   except
      on E: Exception do
         Result := TResultadoHTTP.Create(E);
   end;
end;

function TControladorMotoristaPOPAPIREST.ExecutarObterCorrida(
  pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
var
   lSaidaObtencaoCorrida : TDadoSaidaObtencaoCorrida;
   lJSONSaidaObtencaoCorrida: TJSONValue;
begin
   try
      lSaidaObtencaoCorrida     := FObterCorrida.Executar(pParametros.Items['id']);
      lJSONSaidaObtencaoCorrida := FConversorJSON.ConverterParaJSON<TDadoSaidaObtencaoCorrida>(lSaidaObtencaoCorrida);
      Result := TResultadoHTTP.Create(lJSONSaidaObtencaoCorrida);
   except
      on E: Exception do
         Result := TResultadoHTTP.Create(E);
   end;
end;

end.
