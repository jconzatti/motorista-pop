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
   AtualizarPosicao,
   FinalizarCorrida,
   ObterCorridas,
   ObterCorrida,
   CasoDeUso.Fabrica;

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
      FAtualizarPosicao: TAtualizarPosicao;
      FFinalizarCorrida: TFinalizarCorrida;
      FObterCorridas: TObterCorridas;
      FObterCorrida: TObterCorrida;
      function ExecutarObterContaDeUsuario(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarObterCorridasDoUsuario(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarInscreverUsuario(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarRealizarLogin(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarSolicitarCorrida(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarAceitarCorrida(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarIniciarCorrida(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarAtualizarPosicao(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarFinalizarCorrida(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarObterCorrida(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      procedure RegistrarRotasDaAPI;
   public
      constructor Create(pServidorHTTP: TServidorHTTP; pFabricaCasoDeUso: TFabricaCasoDeUso); reintroduce;
      destructor Destroy; override;
   end;

implementation

{ TControladorMotoristaPOPAPIREST }

constructor TControladorMotoristaPOPAPIREST.Create(pServidorHTTP: TServidorHTTP; pFabricaCasoDeUso: TFabricaCasoDeUso);
begin
   FConversorJSON := TConversorJSON.Create;

   FServidorHTTP        := pServidorHTTP;
   FInscreverUsuario    := pFabricaCasoDeUso.InscreverUsuario;
   FObterContaDeUsuario := pFabricaCasoDeUso.ObterContaDeUsuario;
   FRealizarLogin       := pFabricaCasoDeUso.RealizarLogin;
   FSolicitarCorrida    := pFabricaCasoDeUso.SolicitarCorrida;
   FAceitarCorrida      := pFabricaCasoDeUso.AceitarCorrida;
   FIniciarCorrida      := pFabricaCasoDeUso.IniciarCorrida;
   FAtualizarPosicao    := pFabricaCasoDeUso.AtualizarPosicao;
   FFinalizarCorrida    := pFabricaCasoDeUso.FinalizarCorrida;
   FObterCorridas       := pFabricaCasoDeUso.ObterCorridas;
   FObterCorrida        := pFabricaCasoDeUso.ObterCorrida;
   RegistrarRotasDaAPI;
   FServidorHTTP.Iniciar(9000);
end;

destructor TControladorMotoristaPOPAPIREST.Destroy;
begin
   FObterCorrida.Destroy;
   FObterCorridas.Destroy;
   FFinalizarCorrida.Destroy;
   FAtualizarPosicao.Destroy;
   FIniciarCorrida.Destroy;
   FAceitarCorrida.Destroy;
   FSolicitarCorrida.Destroy;
   FRealizarLogin.Destroy;
   FObterContaDeUsuario.Destroy;
   FInscreverUsuario.Destroy;
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
   FServidorHTTP.Registrar(mPOST, '/corrida/:id/atualizar_posicao', ExecutarAtualizarPosicao);
   FServidorHTTP.Registrar(mPOST, '/corrida/:id/finalizar', ExecutarFinalizarCorrida);
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
   lEntradaRealizacaoLogin : TDadoEntradaRealizacaoLogin;
   lSaidaRealizacaoLogin : TDadoSaidaRealizacaoLogin;
   lJSONSaidaRealizacaoLogin: TJSONValue;
begin
   try
      lEntradaRealizacaoLogin.Email := pParametros.Items['email'];
      lEntradaRealizacaoLogin.Senha := pParametros.Items['senha'];
      lSaidaRealizacaoLogin     := FRealizarLogin.Executar(lEntradaRealizacaoLogin);
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

function TControladorMotoristaPOPAPIREST.ExecutarAtualizarPosicao(
  pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
var
   lEntradaAtualizacaoPosicao: TDadoEntradaAtualizacaoPosicao;
begin
   try
      lEntradaAtualizacaoPosicao := FConversorJSON.ConverterParaObjeto<TDadoEntradaAtualizacaoPosicao>(pConteudo);
      lEntradaAtualizacaoPosicao.IDDaCorrida := pParametros.Items['id'];
      FAtualizarPosicao.Executar(lEntradaAtualizacaoPosicao);
      Result := TResultadoHTTP.Create;
   except
      on E: Exception do
         Result := TResultadoHTTP.Create(E);
   end;
end;

function TControladorMotoristaPOPAPIREST.ExecutarFinalizarCorrida(
  pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
var
   lEntradaFinalizacaoCorrida: TDadoEntradaFinalizacaoCorrida;
   lSaidaFinalizacaoCorrida: TDadoSaidaFinalizacaoCorrida;
   lJSONSaidaFinalizacaoCorrida: TJSONValue;
begin
   try
      lEntradaFinalizacaoCorrida := FConversorJSON.ConverterParaObjeto<TDadoEntradaFinalizacaoCorrida>(pConteudo);
      lEntradaFinalizacaoCorrida.IDDaCorrida := pParametros.Items['id'];
      lSaidaFinalizacaoCorrida := FFinalizarCorrida.Executar(lEntradaFinalizacaoCorrida);
      lJSONSaidaFinalizacaoCorrida := FConversorJSON.ConverterParaJSON<TDadoSaidaFinalizacaoCorrida>(lSaidaFinalizacaoCorrida);
      Result := TResultadoHTTP.Create(lJSONSaidaFinalizacaoCorrida);
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
