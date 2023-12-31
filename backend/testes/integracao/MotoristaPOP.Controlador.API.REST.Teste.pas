unit MotoristaPOP.Controlador.API.REST.Teste;

interface

uses
   System.SysUtils,
   System.Generics.Collections,
   System.JSON,
   System.DateUtils,
   HTTP.Servidor,
   HTTP.Servidor.Fake,
   Repositorio.Fabrica,
   Repositorio.Fabrica.Fake,
   CasoDeUso.Fabrica,
   MotoristaPOP.Controlador.API.REST,
   DUnitX.TestFramework;

type
   [TestFixture]
   TControladorMotoristaPOPAPIRESTTeste = class
   private
      FServidorHTTP: TServidorHTTPFake;
      FFabricaCasoDeUso: TFabricaCasoDeUso;
      FFabricaRepositorio: TFabricaRepositorio;
      FControladorMotoristaPOPAPIREST: TControladorMotoristaPOPAPIREST;
      function CriarContaDePassageiro(pEmail: String): TResultadoHTTP;
      function CriarContaDeMotorista(pEmail: String): TResultadoHTTP;
      function SolicitarUmaCorrida(pIDDoPassageiro: String): TResultadoHTTP;
      function AceitarUmaCorrida(pIDDoMotorista, pIDDaCorrida: String): TResultadoHTTP;
      function IniciarUmaCorrida(pIDDoMotorista, pIDDaCorrida: String): TResultadoHTTP;
      function AtualizarPosicaoDaCorrida(pIDDaCorrida: String): TResultadoHTTP;
      function FinalizarUmaCorrida(pIDDoMotorista, pIDDaCorrida: String): TResultadoHTTP;
      function ObterCooredenadasEmJSON(pLatitude, pLongitude: Double): TJSONObject;
      function ObterContaDeUsuario(pIDDoUsuario: String): TResultadoHTTP;
      function RealizarLogin(pEmail: String): TResultadoHTTP;
      function ObterCorridasDoUsuario(pIDDoUsuario, pListaStatus: String): TResultadoHTTP;
      function ObterCorrida(pIDDaCorrida: String): TResultadoHTTP;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure DeveRetornar404ParaRotaInexistente;
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
      [Test]
      procedure DeveObterUmaCorrida;
      [Test]
      procedure NaoPodeObterCorridaComIDInexistente;
      [Test]
      procedure MotoristaDeveAceitarUmaCorrida;
      [Test]
      procedure NaoPodeAceitarUmaCorridaSemIDDoMotorista;
      [Test]
      procedure MotoristaDeveIniciarUmaCorrida;
      [Test]
      procedure NaoPodeIniciarUmaCorridaSemIDDaCorrida;
      [Test]
      procedure SistemaDeveAtualizarAPosicaoDeUmaCorridaIniciada;
      [Test]
      procedure SistemaNaoAtualizarAPosicaoDeUmaCorridaSemIDDaCorrida;
      [Test]
      procedure MotoristaDeveFinalizarUmaCorrida;
      [Test]
      procedure NaoPodeFinalizarUmaCorridaSemIDDaCorrida;
   end;

implementation


{ TControladorMotoristaPOPAPIRESTTeste }

procedure TControladorMotoristaPOPAPIRESTTeste.Inicializar;
begin
   FFabricaRepositorio := TFabricaRepositorioFake.Create;
   FFabricaCasoDeUso   := TFabricaCasoDeUso.Create(FFabricaRepositorio);
   FServidorHTTP       := TServidorHTTPFake.Create;
   FControladorMotoristaPOPAPIREST := TControladorMotoristaPOPAPIREST.Create(FServidorHTTP, FFabricaCasoDeUso);
end;

procedure TControladorMotoristaPOPAPIRESTTeste.Finalizar;
begin
   FControladorMotoristaPOPAPIREST.Destroy;
   FServidorHTTP.Destroy;
   FFabricaCasoDeUso.Destroy;
   FFabricaRepositorio.Destroy;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.DeveRetornar404ParaRotaInexistente;
var lResultado: TResultadoHTTP;
    lParametros: TParametroHTTP;
begin
   lParametros := TParametroHTTP.Create;
   try
      lResultado := FServidorHTTP.Invocar(TMetodoHTTP.GET, '/notfound', lParametros, '');
      try
         Assert.IsTrue(Assigned(lResultado));
         Assert.AreEqual<Integer>(404, lResultado.CodigoDeRespostaHTTP);
      finally
         lResultado.Destroy;
      end;
   finally
      lParametros.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.NaoPodeCriarUmaContaDeUsuarioComCorpoEmFormatoJSONInvalido;
var lResultado: TResultadoHTTP;
    lParametros: TParametroHTTP;
begin
   lParametros := TParametroHTTP.Create;
   try
      lResultado := FServidorHTTP.Invocar(TMetodoHTTP.POST, '/usuario', lParametros, '["invalid", "json", "object"]');
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
      Assert.IsNotEmpty(lResultado.JSON.GetValue<string>('Token'));
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

procedure TControladorMotoristaPOPAPIRESTTeste.MotoristaDeveAceitarUmaCorrida;
var lResultado: TResultadoHTTP;
    lIDDoPassageiro, lIDDoMotorista, lIDDaCorrida: String;
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

   lResultado := CriarContaDeMotorista(Format('vera.root.%d@gmail.com', [Random(100000000)]));
   try
      lIDDoMotorista := lResultado.JSON.GetValue<string>('IDDoUsuario');
   finally
      lResultado.Destroy;
   end;

   lResultado := AceitarUmaCorrida(lIDDoMotorista, lIDDaCorrida);
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(200, lResultado.CodigoDeRespostaHTTP);
      Assert.AreEqual('null', lResultado.JSON.ToJSON);
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.NaoPodeAceitarUmaCorridaSemIDDoMotorista;
var lResultado: TResultadoHTTP;
begin
   lResultado := AceitarUmaCorrida('', '123456789012345678901234567890aa');
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(400, lResultado.CodigoDeRespostaHTTP);
      Assert.Contains(lResultado.JSON.ToJSON, '"Tipo":"EUUIDInvalido"');
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.MotoristaDeveIniciarUmaCorrida;
var lResultado: TResultadoHTTP;
    lIDDoPassageiro, lIDDoMotorista, lIDDaCorrida: String;
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

   lResultado := CriarContaDeMotorista(Format('vera.root.%d@gmail.com', [Random(100000000)]));
   try
      lIDDoMotorista := lResultado.JSON.GetValue<string>('IDDoUsuario');
   finally
      lResultado.Destroy;
   end;

   lResultado := AceitarUmaCorrida(lIDDoMotorista, lIDDaCorrida);
   lResultado.Destroy;

   lResultado := IniciarUmaCorrida(lIDDoMotorista, lIDDaCorrida);
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(200, lResultado.CodigoDeRespostaHTTP);
      Assert.AreEqual('null', lResultado.JSON.ToJSON);
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.NaoPodeIniciarUmaCorridaSemIDDaCorrida;
var lResultado: TResultadoHTTP;
    lIDDoPassageiro, lIDDoMotorista, lIDDaCorrida: String;
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

   lResultado := CriarContaDeMotorista(Format('vera.root.%d@gmail.com', [Random(100000000)]));
   try
      lIDDoMotorista := lResultado.JSON.GetValue<string>('IDDoUsuario');
   finally
      lResultado.Destroy;
   end;

   lResultado := AceitarUmaCorrida(lIDDoMotorista, lIDDaCorrida);
   lResultado.Destroy;

   lResultado := IniciarUmaCorrida(lIDDoMotorista, '');
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(400, lResultado.CodigoDeRespostaHTTP);
      Assert.Contains(lResultado.JSON.ToJSON, '"Tipo":"EUUIDInvalido"');
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.SistemaDeveAtualizarAPosicaoDeUmaCorridaIniciada;
var lResultado: TResultadoHTTP;
    lIDDoPassageiro, lIDDoMotorista, lIDDaCorrida: String;
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

   lResultado := CriarContaDeMotorista(Format('vera.root.%d@gmail.com', [Random(100000000)]));
   try
      lIDDoMotorista := lResultado.JSON.GetValue<string>('IDDoUsuario');
   finally
      lResultado.Destroy;
   end;

   lResultado := AceitarUmaCorrida(lIDDoMotorista, lIDDaCorrida);
   lResultado.Destroy;

   lResultado := IniciarUmaCorrida(lIDDoMotorista, lIDDaCorrida);
   lResultado.Destroy;

   lResultado := AtualizarPosicaoDaCorrida(lIDDaCorrida);
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(200, lResultado.CodigoDeRespostaHTTP);
      Assert.AreEqual('null', lResultado.JSON.ToJSON);
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.SistemaNaoAtualizarAPosicaoDeUmaCorridaSemIDDaCorrida;
var lResultado: TResultadoHTTP;
begin
   lResultado := AtualizarPosicaoDaCorrida('');
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(400, lResultado.CodigoDeRespostaHTTP);
      Assert.Contains(lResultado.JSON.ToJSON, '"Tipo":"EUUIDInvalido"');
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.MotoristaDeveFinalizarUmaCorrida;
var lResultado: TResultadoHTTP;
    lIDDoPassageiro, lIDDoMotorista, lIDDaCorrida: String;
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

   lResultado := CriarContaDeMotorista(Format('vera.root.%d@gmail.com', [Random(100000000)]));
   try
      lIDDoMotorista := lResultado.JSON.GetValue<string>('IDDoUsuario');
   finally
      lResultado.Destroy;
   end;

   lResultado := AceitarUmaCorrida(lIDDoMotorista, lIDDaCorrida);
   lResultado.Destroy;

   lResultado := IniciarUmaCorrida(lIDDoMotorista, lIDDaCorrida);
   lResultado.Destroy;

   lResultado := AtualizarPosicaoDaCorrida(lIDDaCorrida);
   lResultado.Destroy;

   lResultado := FinalizarUmaCorrida(lIDDoMotorista, lIDDaCorrida);
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(200, lResultado.CodigoDeRespostaHTTP);
      Assert.IsNotEmpty(lResultado.JSON.ToJSON);
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.NaoPodeFinalizarUmaCorridaSemIDDaCorrida;
var lResultado: TResultadoHTTP;
    lIDDoPassageiro, lIDDoMotorista, lIDDaCorrida: String;
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

   lResultado := CriarContaDeMotorista(Format('vera.root.%d@gmail.com', [Random(100000000)]));
   try
      lIDDoMotorista := lResultado.JSON.GetValue<string>('IDDoUsuario');
   finally
      lResultado.Destroy;
   end;

   lResultado := AceitarUmaCorrida(lIDDoMotorista, lIDDaCorrida);
   lResultado.Destroy;

   lResultado := IniciarUmaCorrida(lIDDoMotorista, lIDDaCorrida);
   lResultado.Destroy;

   lResultado := AtualizarPosicaoDaCorrida(lIDDaCorrida);
   lResultado.Destroy;

   lResultado := FinalizarUmaCorrida(lIDDoMotorista, '');
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(400, lResultado.CodigoDeRespostaHTTP);
      Assert.Contains(lResultado.JSON.ToJSON, '"Tipo":"EUUIDInvalido"');
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.DeveObterUmaCorrida;
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

   lResultado := ObterCorrida(lIDDaCorrida);
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(200, lResultado.CodigoDeRespostaHTTP);
      Assert.IsNotEmpty(lResultado.JSON.ToJSON);
      Assert.AreEqual(lIDDaCorrida, lResultado.JSON.GetValue<string>('ID'));
      Assert.AreEqual(lIDDoPassageiro, lResultado.JSON.GetValue<TJSONObject>('Passageiro').GetValue<String>('ID'));
      Assert.AreEqual('null', lResultado.JSON.GetValue<TJSONNull>('Motorista').Value);
      Assert.AreEqual('requested', lResultado.JSON.GetValue<string>('Status'));
   finally
      lResultado.Destroy;
   end;
end;

procedure TControladorMotoristaPOPAPIRESTTeste.NaoPodeObterCorridaComIDInexistente;
var lResultado: TResultadoHTTP;
begin
   lResultado := ObterCorrida('123456789012345678901234567890ff');
   try
      Assert.IsTrue(Assigned(lResultado));
      Assert.AreEqual<Integer>(404, lResultado.CodigoDeRespostaHTTP);
      Assert.Contains(lResultado.JSON.ToJSON, '"Tipo":"ERepositorioCorridaNaoEncontrada"');
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
      Result := FServidorHTTP.Invocar(TMetodoHTTP.POST, '/corrida/solicitar', lParametros, lJSONSolicitacaoCorrida.ToJSON);
   finally
      lJSONSolicitacaoCorrida.Destroy;
      lParametros.Destroy;
   end;
end;

function TControladorMotoristaPOPAPIRESTTeste.AceitarUmaCorrida(pIDDoMotorista,
  pIDDaCorrida: String): TResultadoHTTP;
var lJSONAceiteCorrida: TJSONObject;
    lParametros : TParametroHTTP;
begin
   lParametros := TParametroHTTP.Create;
   lJSONAceiteCorrida := TJSONObject.Create;
   try
      lJSONAceiteCorrida.AddPair('IDDoMotorista', pIDDoMotorista);
      lParametros.Add('id', pIDDaCorrida);
      Result := FServidorHTTP.Invocar(TMetodoHTTP.POST, '/corrida/:id/aceitar', lParametros, lJSONAceiteCorrida.ToJSON);
   finally
      lJSONAceiteCorrida.Destroy;
      lParametros.Destroy;
   end;
end;

function TControladorMotoristaPOPAPIRESTTeste.IniciarUmaCorrida(pIDDoMotorista,
  pIDDaCorrida: String): TResultadoHTTP;
var lJSONInicioCorrida: TJSONObject;
    lParametros : TParametroHTTP;
begin
   lParametros := TParametroHTTP.Create;
   lJSONInicioCorrida := TJSONObject.Create;
   try
      lJSONInicioCorrida.AddPair('IDDoMotorista', pIDDoMotorista);
      lParametros.Add('id', pIDDaCorrida);
      Result := FServidorHTTP.Invocar(TMetodoHTTP.POST, '/corrida/:id/iniciar', lParametros, lJSONInicioCorrida.ToJSON);
   finally
      lJSONInicioCorrida.Destroy;
      lParametros.Destroy;
   end;
end;

function TControladorMotoristaPOPAPIRESTTeste.AtualizarPosicaoDaCorrida(
  pIDDaCorrida: String): TResultadoHTTP;
var lJSONAtualizacaoPosicao: TJSONObject;
    lParametros : TParametroHTTP;
begin
   lParametros := TParametroHTTP.Create;
   lJSONAtualizacaoPosicao := TJSONObject.Create;
   try
      lJSONAtualizacaoPosicao.AddPair('Latitude', TJSONNumber.Create(-46));
      lJSONAtualizacaoPosicao.AddPair('Longitude', TJSONNumber.Create(-26));
      lJSONAtualizacaoPosicao.AddPair('Data', DateToISO8601(Now));
      lParametros.Add('id', pIDDaCorrida);
      Result := FServidorHTTP.Invocar(TMetodoHTTP.POST, '/corrida/:id/atualizar_posicao', lParametros, lJSONAtualizacaoPosicao.ToJSON);
   finally
      lJSONAtualizacaoPosicao.Destroy;
      lParametros.Destroy;
   end;
end;

function TControladorMotoristaPOPAPIRESTTeste.FinalizarUmaCorrida(
  pIDDoMotorista, pIDDaCorrida: String): TResultadoHTTP;
var lJSONFinalizacaoCorrida: TJSONObject;
    lParametros : TParametroHTTP;
begin
   lParametros := TParametroHTTP.Create;
   lJSONFinalizacaoCorrida := TJSONObject.Create;
   try
      lJSONFinalizacaoCorrida.AddPair('IDDoMotorista', pIDDoMotorista);
      lParametros.Add('id', pIDDaCorrida);
      Result := FServidorHTTP.Invocar(TMetodoHTTP.POST, '/corrida/:id/finalizar', lParametros, lJSONFinalizacaoCorrida.ToJSON);
   finally
      lJSONFinalizacaoCorrida.Destroy;
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
      Result := FServidorHTTP.Invocar(TMetodoHTTP.GET, '/usuario/:id/corrida', lParametros, '');
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
      lJSONPassaeiro.AddPair('senha', 'S3nh@F0rte');
      Result := FServidorHTTP.Invocar(TMetodoHTTP.POST, '/usuario', lParametros, lJSONPassaeiro.ToJSON);
   finally
      lJSONPassaeiro.Destroy;
      lParametros.Destroy;
   end;
end;

function TControladorMotoristaPOPAPIRESTTeste.CriarContaDeMotorista(pEmail: String): TResultadoHTTP;
var lJSONMotorista: TJSONObject;
    lParametros: TParametroHTTP;
begin
   lParametros := TParametroHTTP.Create;
   lJSONMotorista := TJSONObject.Create;
   try
      lJSONMotorista.AddPair('nome', 'Vera Root');
      lJSONMotorista.AddPair('email', pEmail);
      lJSONMotorista.AddPair('cpf', '524.082.580-73');
      lJSONMotorista.AddPair('passageiro', TJSONBool.Create(False));
      lJSONMotorista.AddPair('motorista', TJSONBool.Create(True));
      lJSONMotorista.AddPair('placaDoCarro', 'XJF1H34');
      lJSONMotorista.AddPair('senha', 'S3nh@F0rte');
      Result := FServidorHTTP.Invocar(TMetodoHTTP.POST, '/usuario', lParametros, lJSONMotorista.ToJSON);
   finally
      lJSONMotorista.Destroy;
      lParametros.Destroy;
   end;
end;

function TControladorMotoristaPOPAPIRESTTeste.ObterContaDeUsuario(pIDDoUsuario: String): TResultadoHTTP;
var lParametros: TParametroHTTP;
begin
   lParametros := TParametroHTTP.Create;
   try
      lParametros.Add('id', pIDDoUsuario);
      Result := FServidorHTTP.Invocar(TMetodoHTTP.GET, '/usuario/:id', lParametros, '');
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
      lParametros.Add('senha', 'S3nh@F0rte');
      Result := FServidorHTTP.Invocar(TMetodoHTTP.POST, '/login', lParametros, '');
   finally
      lParametros.Destroy;
   end;
end;

function TControladorMotoristaPOPAPIRESTTeste.ObterCorrida(pIDDaCorrida: String): TResultadoHTTP;
var lParametros: TParametroHTTP;
begin
   lParametros := TParametroHTTP.Create;
   try
      lParametros.Add('id', pIDDaCorrida);
      Result := FServidorHTTP.Invocar(TMetodoHTTP.GET, '/corrida/:id', lParametros, '');
   finally
      lParametros.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TControladorMotoristaPOPAPIRESTTeste);
end.
