unit MotoristaPOP.Controlador.API.REST.Teste;

interface

uses
   System.SysUtils,
   System.Generics.Collections,
   System.JSON,
   HTTP.Servidor,
   HTTP.Servidor.Fake,
   Corrida.Repositorio,
   Corrida.Repositorio.Fake,
   ContaDeUsuario.Repositorio,
   ContaDeUsuario.Repositorio.Fake,
   SolicitarCorrida,
   InscreverUsuario,
   ObterContaDeUsuario,
   RealizarLogin,
   ObterCorridas,
   MotoristaPOP.Controlador.API.REST,
   DUnitX.TestFramework;

type
   [TestFixture]
   TControladorMotoristaPOPAPIRESTTeste = class
   private
      FServidorHTTP: TServidorHTTPFake;
      FInscreverUsuario: TInscreverUsuario;
      FObterContaDeUsuario: TObterContaDeUsuario;
      FObterCorridas: TObterCorridas;
      FRealizarLogin: TRealizarLogin;
      FSolicitarCorrida: TSolicitarCorrida;
      FRepositorioContaDeUsuario: TRepositorioContaDeUsuario;
      FRepositorioCorrida: TRepositorioCorrida;
      FControladorMotoristaPOPAPIREST: TControladorMotoristaPOPAPIREST;
      function CriarContaDePassageiro(pEmail: String): TResultadoHTTP;
      function SolicitarUmaCorrida(pIDDoPassageiro: String): TResultadoHTTP;
      function ObterCooredenadasEmJSON(pLatitude, pLongitude: Double): TJSONObject;
      function ObterContaDeUsuario(pIDDoUsuario: String): TResultadoHTTP;
      function RealizarLogin(pEmail: String): TResultadoHTTP;
      function ObterCorridasDoUsuario(pIDDoUsuario, pListaStatus: String): TResultadoHTTP;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure NaoPodeCriarUmaContaDeUsuarioComCorpoEmFormatoJSONInvalido;
      [Test]
      procedure DeveCriarUmaContaDeUsuario;
      [Test]
      procedure NaoDeveCriarUmaContaDeUsuarioComEmailInvalido;
      [Test]
      procedure DeveObterUmaContaDeUsuario;
      [Test]
      procedure NaoPodeObterUmaContaDeUsuarioSemInformarOID;
      [Test]
      procedure DeveRealizarLogin;
      [Test]
      procedure NaoPodeRealizarLoginSemInformarOEMail;
      [Test]
      procedure DeveObterTodasCorridasDoUsuario;
      [Test]
      procedure DeveObterCorridasSolicitadasEFinalizadasDoUsuario;
      [Test]
      procedure NaoPodeObterCorridasDoUsuarioSemInformarOIDDoUsuario;
      [Test]
      procedure NaoPodeObterCorridasDoUsuarioInformandoUmStatusInvalido;
      [Test]
      procedure PassageiroDeveSolicitarUmaCorrida;
      [Test]
      procedure NaoPodeSolicitarUmaCorridaSemIDDoPassageiro;
   end;

implementation


{ TControladorMotoristaPOPAPIRESTTeste }

procedure TControladorMotoristaPOPAPIRESTTeste.Inicializar;
begin
   FRepositorioContaDeUsuario := TRepositorioContaDeUsuarioFake.Create;
   FRepositorioCorrida        := TRepositorioCorridaFake.Create;
   FInscreverUsuario          := TInscreverUsuario.Create(FRepositorioContaDeUsuario);
   FObterContaDeUsuario       := TObterContaDeUsuario.Create(FRepositorioContaDeUsuario);
   FRealizarLogin             := TRealizarLogin.Create(FRepositorioContaDeUsuario);
   FSolicitarCorrida          := TSolicitarCorrida.Create(FRepositorioCorrida, FRepositorioContaDeUsuario);
   FObterCorridas             := TObterCorridas.Create(FRepositorioCorrida, FRepositorioContaDeUsuario);
   FServidorHTTP              := TServidorHTTPFake.Create;
   FControladorMotoristaPOPAPIREST := TControladorMotoristaPOPAPIREST.Create(FServidorHTTP,
                                                                             FInscreverUsuario,
                                                                             FObterContaDeUsuario,
                                                                             FRealizarLogin,
                                                                             FSolicitarCorrida,
                                                                             FObterCorridas);
end;

procedure TControladorMotoristaPOPAPIRESTTeste.Finalizar;
begin
   FControladorMotoristaPOPAPIREST.Destroy;
   FServidorHTTP.Destroy;
   FRealizarLogin.Destroy;
   FObterCorridas.Destroy;
   FObterContaDeUsuario.Destroy;
   FInscreverUsuario.Destroy;
   FRepositorioCorrida.Destroy;
   FRepositorioContaDeUsuario.Destroy;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.NaoPodeCriarUmaContaDeUsuarioComCorpoEmFormatoJSONInvalido;
var lResultado: TResultadoHTTP;
    lParametros: TParametroHTTP;
begin
   lParametros := TParametroHTTP.Create;
   try
      lResultado := FServidorHTTP.Invocar(mPOST, '/usuario', lParametros, '["invalid", "json", "object"]');
      try
         Assert.IsTrue(Assigned(lResultado));
         Assert.AreEqual<Integer>(500, lResultado.CodigoDeRespostaHTTP);
         Assert.Contains(lResultado.JSON.ToJSON, '"Tipo":"EConversaoJSONComErro"');
      finally
         lResultado.Destroy;
      end;
   finally
      lParametros.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.DeveCriarUmaContaDeUsuario;
var lResultado: TResultadoHTTP;
begin
   lResultado := CriarContaDePassageiro(Format('john.doe.%d@gmail.com', [Random(100000000)]));
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(201, lResultado.CodigoDeRespostaHTTP);
      Assert.IsNotEmpty(lResultado.JSON.ToJSON);
      Assert.IsNotEmpty(lResultado.JSON.GetValue<string>('IDDoUsuario'));
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.NaoDeveCriarUmaContaDeUsuarioComEmailInvalido;
var lResultado: TResultadoHTTP;
begin
   lResultado := CriarContaDePassageiro(Format('john.doe.%d.com', [Random(100000000)]));
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(400, lResultado.CodigoDeRespostaHTTP);
      Assert.Contains(lResultado.JSON.ToJSON, '"Tipo":"EEmailInvalido"');
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.DeveObterUmaContaDeUsuario;
var lResultado: TResultadoHTTP;
    lEmail, lIDDoUsuario: String;
begin
   lEmail := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lResultado := CriarContaDePassageiro(lEmail);
   try
      lIDDoUsuario := lResultado.JSON.GetValue<string>('IDDoUsuario');
   finally
      lResultado.Destroy;
   end;

   lResultado := ObterContaDeUsuario(lIDDoUsuario);
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(200, lResultado.CodigoDeRespostaHTTP);
      Assert.IsNotEmpty(lResultado.JSON.ToJSON);
      Assert.AreEqual(lEmail, lResultado.JSON.GetValue<string>('Email'));
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.NaoPodeObterUmaContaDeUsuarioSemInformarOID;
var lResultado: TResultadoHTTP;
begin
   lResultado := ObterContaDeUsuario('');
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(400, lResultado.CodigoDeRespostaHTTP);
      Assert.Contains(lResultado.JSON.ToJSON, '"Tipo":"EUUIDInvalido"');
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.DeveRealizarLogin;
var lResultado: TResultadoHTTP;
    lEmail, lIDDoUsuario: String;
begin
   lEmail := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lResultado := CriarContaDePassageiro(lEmail);
   try
      lIDDoUsuario := lResultado.JSON.GetValue<string>('IDDoUsuario');
   finally
      lResultado.Destroy;
   end;

   lResultado := RealizarLogin(lEmail);
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(200, lResultado.CodigoDeRespostaHTTP);
      Assert.IsNotEmpty(lResultado.JSON.ToJSON);
      Assert.AreEqual(lIDDoUsuario, lResultado.JSON.GetValue<string>('IDDoUsuario'));
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.NaoPodeRealizarLoginSemInformarOEMail;
var lResultado: TResultadoHTTP;
begin
   lResultado := RealizarLogin('');
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(400, lResultado.CodigoDeRespostaHTTP);
      Assert.Contains(lResultado.JSON.ToJSON, '"Tipo":"EEmailInvalido"');
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.DeveObterTodasCorridasDoUsuario;
var lResultado: TResultadoHTTP;
    lIDDoPassageiro, lIDDaCorrida: String;
begin
   lResultado := CriarContaDePassageiro(Format('john.doe.%d@gmail.com', [Random(100000000)]));
   try
      lIDDoPassageiro := lResultado.JSON.GetValue<string>('IDDoUsuario');
   finally
      lResultado.Destroy;
   end;

   lResultado := SolicitarUmaCorrida(lIDDoPassageiro);
   try
      lIDDaCorrida := lResultado.JSON.GetValue<string>('IDDaCorrida');
   finally
      lResultado.Destroy;
   end;

   lResultado := ObterCorridasDoUsuario(lIDDoPassageiro, '');
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(200, lResultado.CodigoDeRespostaHTTP);
      Assert.IsNotEmpty(lResultado.JSON.ToJSON);
      Assert.AreEqual<Integer>(1, TJSONArray(lResultado.JSON).Count);
      Assert.AreEqual(lIDDaCorrida, TJSONArray(lResultado.JSON).Items[0].GetValue<string>('ID'));
      Assert.AreEqual(lIDDoPassageiro, TJSONArray(lResultado.JSON).Items[0].GetValue<TJSONObject>('Passageiro').GetValue<String>('ID'));
      Assert.AreEqual('null', TJSONArray(lResultado.JSON).Items[0].GetValue<TJSONNull>('Motorista').Value);
      Assert.AreEqual('requested', TJSONArray(lResultado.JSON).Items[0].GetValue<string>('Status'));
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.DeveObterCorridasSolicitadasEFinalizadasDoUsuario;
var lResultado: TResultadoHTTP;
    lIDDoPassageiro, lIDDaCorrida: String;
begin
   lResultado := CriarContaDePassageiro(Format('john.doe.%d@gmail.com', [Random(100000000)]));
   try
      lIDDoPassageiro := lResultado.JSON.GetValue<string>('IDDoUsuario');
   finally
      lResultado.Destroy;
   end;

   lResultado := SolicitarUmaCorrida(lIDDoPassageiro);
   try
      lIDDaCorrida := lResultado.JSON.GetValue<string>('IDDaCorrida');
   finally
      lResultado.Destroy;
   end;

   lResultado := ObterCorridasDoUsuario(lIDDoPassageiro, 'requested,completed');
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(200, lResultado.CodigoDeRespostaHTTP);
      Assert.IsNotEmpty(lResultado.JSON.ToJSON);
      Assert.AreEqual<Integer>(1, TJSONArray(lResultado.JSON).Count);
      Assert.AreEqual(lIDDaCorrida, TJSONArray(lResultado.JSON).Items[0].GetValue<string>('ID'));
      Assert.AreEqual(lIDDoPassageiro, TJSONArray(lResultado.JSON).Items[0].GetValue<TJSONObject>('Passageiro').GetValue<String>('ID'));
      Assert.AreEqual('null', TJSONArray(lResultado.JSON).Items[0].GetValue<TJSONNull>('Motorista').Value);
      Assert.AreEqual('requested', TJSONArray(lResultado.JSON).Items[0].GetValue<string>('Status'));
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.NaoPodeObterCorridasDoUsuarioSemInformarOIDDoUsuario;
var lResultado: TResultadoHTTP;
begin
   lResultado := ObterCorridasDoUsuario('', 'requested,completed');
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(400, lResultado.CodigoDeRespostaHTTP);
      Assert.Contains(lResultado.JSON.ToJSON, '"Tipo":"EUUIDInvalido"');
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.NaoPodeObterCorridasDoUsuarioInformandoUmStatusInvalido;
var lResultado: TResultadoHTTP;
    lIDDoPassageiro, lIDDaCorrida: String;
begin
   lResultado := CriarContaDePassageiro(Format('john.doe.%d@gmail.com', [Random(100000000)]));
   try
      lIDDoPassageiro := lResultado.JSON.GetValue<string>('IDDoUsuario');
   finally
      lResultado.Destroy;
   end;

   lResultado := SolicitarUmaCorrida(lIDDoPassageiro);
   try
      lIDDaCorrida := lResultado.JSON.GetValue<string>('IDDaCorrida');
   finally
      lResultado.Destroy;
   end;

   lResultado := ObterCorridasDoUsuario(lIDDoPassageiro, 'invalid,completed');
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(400, lResultado.CodigoDeRespostaHTTP);
      Assert.Contains(lResultado.JSON.ToJSON, '"Tipo":"EStatusCorridaInvalido"');
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.PassageiroDeveSolicitarUmaCorrida;
var lResultado: TResultadoHTTP;
    lIDDoPassageiro: String;
begin
   lResultado := CriarContaDePassageiro(Format('john.doe.%d@gmail.com', [Random(100000000)]));
   try
      lIDDoPassageiro := lResultado.JSON.GetValue<string>('IDDoUsuario');
   finally
      lResultado.Destroy;
   end;

   lResultado := SolicitarUmaCorrida(lIDDoPassageiro);
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(200, lResultado.CodigoDeRespostaHTTP);
      Assert.IsNotEmpty(lResultado.JSON.ToJSON);
      Assert.IsNotEmpty(lResultado.JSON.GetValue<string>('IDDaCorrida'));
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.NaoPodeSolicitarUmaCorridaSemIDDoPassageiro;
var lResultado: TResultadoHTTP;
begin
   lResultado := SolicitarUmaCorrida('');
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(400, lResultado.CodigoDeRespostaHTTP);
      Assert.Contains(lResultado.JSON.ToJSON, '"Tipo":"EUUIDInvalido"');
   finally
      lResultado.Destroy;
   end;
end;

function TControladorMotoristaPOPAPIRESTTeste.SolicitarUmaCorrida(pIDDoPassageiro: String): TResultadoHTTP;
var lJSONSolicitacaoCorrida: TJSONObject;
    lParametros : TParametroHTTP;
begin
   lParametros := TParametroHTTP.Create;
   lJSONSolicitacaoCorrida := TJSONObject.Create;
   try
      lJSONSolicitacaoCorrida.AddPair('IDDoPassageiro', pIDDoPassageiro);
      lJSONSolicitacaoCorrida.AddPair('De', ObterCooredenadasEmJSON(-46,-26));
      lJSONSolicitacaoCorrida.AddPair('Para', ObterCooredenadasEmJSON(-45,-25));
      Result := FServidorHTTP.Invocar(mPOST, '/corrida/solicitar', lParametros, lJSONSolicitacaoCorrida.ToJSON);
   finally
      lJSONSolicitacaoCorrida.Destroy;
      lParametros.Destroy;
   end;
end;

function TControladorMotoristaPOPAPIRESTTeste.ObterCooredenadasEmJSON(pLatitude,
  pLongitude: Double): TJSONObject;
begin
   Result := TJSONObject.Create;
   try
      Result.AddPair('Latitude', TJSONNumber.Create(pLatitude));
      Result.AddPair('Longitude', TJSONNumber.Create(pLongitude));
   except
      Result.Destroy;
      raise;
   end;
end;

function TControladorMotoristaPOPAPIRESTTeste.ObterCorridasDoUsuario(pIDDoUsuario, pListaStatus: String): TResultadoHTTP;
var lParametros: TParametroHTTP;
begin
   lParametros := TParametroHTTP.Create;
   try
      lParametros.Add('id', pIDDoUsuario);
      if not pListaStatus.IsEmpty then
         lParametros.Add('status', pListaStatus);
      Result := FServidorHTTP.Invocar(mGET, '/usuario/:id/corrida', lParametros, '');
   finally
      lParametros.Destroy;
   end;
end;

function TControladorMotoristaPOPAPIRESTTeste.CriarContaDePassageiro(pEmail: String): TResultadoHTTP;
var lJSONPassaeiro: TJSONObject;
    lParametros: TParametroHTTP;
begin
   lParametros := TParametroHTTP.Create;
   lJSONPassaeiro := TJSONObject.Create;
   try
      lJSONPassaeiro.AddPair('nome', 'John Doe');
      lJSONPassaeiro.AddPair('email', pEmail);
      lJSONPassaeiro.AddPair('cpf', '958.187.055-52');
      lJSONPassaeiro.AddPair('passageiro', TJSONBool.Create(True));
      lJSONPassaeiro.AddPair('motorista', TJSONBool.Create(False));
      Result := FServidorHTTP.Invocar(mPOST, '/usuario', lParametros, lJSONPassaeiro.ToJSON);
   finally
      lJSONPassaeiro.Destroy;
      lParametros.Destroy;
   end;
end;

function TControladorMotoristaPOPAPIRESTTeste.ObterContaDeUsuario(pIDDoUsuario: String): TResultadoHTTP;
var lParametros: TParametroHTTP;
begin
   lParametros := TParametroHTTP.Create;
   try
      lParametros.Add('id', pIDDoUsuario);
      Result := FServidorHTTP.Invocar(mGET, '/usuario/:id', lParametros, '');
   finally
      lParametros.Destroy;
   end;
end;

function TControladorMotoristaPOPAPIRESTTeste.RealizarLogin(
  pEmail: String): TResultadoHTTP;
var lParametros: TParametroHTTP;
begin
   lParametros := TParametroHTTP.Create;
   try
      lParametros.Add('email', pEmail);
      Result := FServidorHTTP.Invocar(mPOST, '/login/:email', lParametros, '');
   finally
      lParametros.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TControladorMotoristaPOPAPIRESTTeste);
end.
