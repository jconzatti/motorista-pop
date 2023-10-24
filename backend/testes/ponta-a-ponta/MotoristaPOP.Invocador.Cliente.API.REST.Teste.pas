unit MotoristaPOP.Invocador.Cliente.API.REST.Teste;

interface

uses
   System.SysUtils,
   System.Classes,
   System.Net.URLClient,
   System.Net.HTTPClient,
   System.NetEncoding,
   System.JSON,
   DUnitX.TestFramework;

type
   [TestFixture]
   TClienteInvocadorMotoristaPOPAPIRESTTeste = class(TObject)
   public
      [Test]
      procedure DeveCriarUmaContaDeUsuario;
      [Test]
      procedure DeveRealizarLoginComEmailDoUsuario;
      [Test]
      procedure DeveObterUmaContaDeUsuarioPorID;
      [Test]
      procedure PassageiroDeveSolicitarUmaCorrida;
   end;

implementation


{ TClienteInvocadorMotoristaPOPAPIRESTTeste }

procedure TClienteInvocadorMotoristaPOPAPIRESTTeste.DeveCriarUmaContaDeUsuario;
var lHTTPClient : THTTPClient;
    lHTTPResposta: IHTTPResponse;
    lJSONPassaeiro: TJSONObject;
    lStream: TStringStream;
begin
   lHTTPClient := THTTPClient.Create;
   lJSONPassaeiro := TJSONObject.Create;
   lStream := TStringStream.Create;
   try
      lJSONPassaeiro.AddPair('nome', 'John Doe');
      lJSONPassaeiro.AddPair('email', Format('john.doe.%d@gmail.com', [Random(100000000)]));
      lJSONPassaeiro.AddPair('cpf', '958.187.055-52');
      lJSONPassaeiro.AddPair('passageiro', TJSONBool.Create(True));
      lJSONPassaeiro.AddPair('motorista', TJSONBool.Create(False));
      lJSONPassaeiro.AddPair('senha', 'S3nh@F0rte');
      lStream.WriteString(lJSONPassaeiro.ToJSON);
      lStream.Position := 0;
      lHTTPResposta := lHTTPClient.Post('http://localhost:9000/usuario', lStream);
      Assert.AreEqual<Integer>(201, lHTTPResposta.GetStatusCode);
      Assert.IsNotEmpty(lHTTPResposta.ContentAsString);
   finally
      lStream.Destroy;
      lJSONPassaeiro.Destroy;
      lHTTPClient.Destroy;
   end;
end;

procedure TClienteInvocadorMotoristaPOPAPIRESTTeste.DeveRealizarLoginComEmailDoUsuario;
var lHTTPClient : THTTPClient;
    lHTTPResposta: IHTTPResponse;
    lJSONPassageiroIncricao, lJSONPassagerioLogin: TJSONObject;
    lStream: TStringStream;
    lEmailDoPassageiro, lIDDoPassageiro, lEmailESenhaBase64: string;
    lJSONResultado: TJSONValue;
begin
   lHTTPClient := THTTPClient.Create;
   lJSONPassageiroIncricao := TJSONObject.Create;
   lStream := TStringStream.Create;
   try
      lEmailDoPassageiro := Format('john.doe.%d@gmail.com', [Random(100000000)]);
      lJSONPassageiroIncricao.AddPair('nome', 'John Doe');
      lJSONPassageiroIncricao.AddPair('email', lEmailDoPassageiro);
      lJSONPassageiroIncricao.AddPair('cpf', '958.187.055-52');
      lJSONPassageiroIncricao.AddPair('passageiro', TJSONBool.Create(True));
      lJSONPassageiroIncricao.AddPair('motorista', TJSONBool.Create(False));
      lJSONPassageiroIncricao.AddPair('senha', 'S3nh-F0rte');
      lStream.WriteString(lJSONPassageiroIncricao.ToJSON);
      lStream.Position := 0;
      lHTTPResposta := lHTTPClient.Post('http://localhost:9000/usuario', lStream);
      lJSONResultado := TJSONObject.ParseJSONValue(lHTTPResposta.ContentAsString);
      try
         lIDDoPassageiro := lJSONResultado.GetValue<string>('IDDoUsuario');
      finally
         lJSONResultado.Destroy;
      end;

      lStream.Clear;
      lStream.Position := 0;
      lEmailESenhaBase64 := TBase64Encoding.Base64.Encode(lEmailDoPassageiro+':S3nh-F0rte');
      lHTTPResposta := lHTTPClient.Post('http://localhost:9000/login', lStream, nil, [TNameValuePair.Create('Authorization', Format('basic %s', [lEmailESenhaBase64]))]);
      lJSONPassagerioLogin := TJSONObject(TJSONObject.ParseJSONValue(lHTTPResposta.ContentAsString));
      try
         Assert.AreEqual<Integer>(200, lHTTPResposta.GetStatusCode);
         Assert.IsNotEmpty(lJSONPassagerioLogin.GetValue<string>('Token'));
      finally
         lJSONPassagerioLogin.Destroy;
      end;
   finally
      lStream.Destroy;
      lJSONPassageiroIncricao.Destroy;
      lHTTPClient.Destroy;
   end;
end;

procedure TClienteInvocadorMotoristaPOPAPIRESTTeste.DeveObterUmaContaDeUsuarioPorID;
var lHTTPClient : THTTPClient;
    lHTTPResposta: IHTTPResponse;
    lJSONMotoristaIncricao: TJSONObject;
    lJSONMotoristaLogin: TJSONObject;
    lJSONMotoristaObtido: TJSONObject;
    lStream: TStringStream;
    lJSONResultado: TJSONObject;
    lIDDoMotorista: string;
    lEmailDoMotorista: String;
    lToken, lEmailESenhaBase64: String;
begin
   lToken := '';
   lHTTPClient := THTTPClient.Create;
   lJSONMotoristaIncricao := TJSONObject.Create;
   try
      lStream := TStringStream.Create;
      try
         lEmailDoMotorista := Format('john.doe.%d@gmail.com', [Random(100000000)]);
         lJSONMotoristaIncricao.AddPair('nome', 'John Doe');
         lJSONMotoristaIncricao.AddPair('email', lEmailDoMotorista);
         lJSONMotoristaIncricao.AddPair('cpf', '958.187.055-52');
         lJSONMotoristaIncricao.AddPair('passageiro', TJSONBool.Create(False));
         lJSONMotoristaIncricao.AddPair('motorista', TJSONBool.Create(True));
         lJSONMotoristaIncricao.AddPair('placaDoCarro', 'ABC-5656');
         lJSONMotoristaIncricao.AddPair('senha', 'S3nh@F0rte');
         lStream.WriteString(lJSONMotoristaIncricao.ToJSON);
         lStream.Position := 0;
         lHTTPResposta := lHTTPClient.Post('http://localhost:9000/usuario', lStream);
         lJSONResultado := TJSONObject(TJSONObject.ParseJSONValue(lHTTPResposta.ContentAsString));
         try
            lIDDoMotorista := lJSONResultado.GetValue<string>('IDDoUsuario');
         finally
            lJSONResultado.Destroy;
         end;

         lStream.Clear;
         lStream.Position := 0;
         lEmailESenhaBase64 := TBase64Encoding.Base64.Encode(lEmailDoMotorista+':S3nh@F0rte');
         lHTTPResposta := lHTTPClient.Post('http://localhost:9000/login', lStream, nil, [TNameValuePair.Create('Authorization', Format('basic %s', [lEmailESenhaBase64]))]);
         if lHTTPResposta.GetStatusCode = 200 then
         begin
            lJSONMotoristaLogin := TJSONObject(TJSONObject.ParseJSONValue(lHTTPResposta.ContentAsString));
            try
               lToken := lJSONMotoristaLogin.GetValue<string>('Token');
            finally
               lJSONMotoristaLogin.Destroy;
            end;
         end;
      finally
         lStream.Destroy;
      end;

      lHTTPResposta := lHTTPClient.Get(Format('http://localhost:9000/usuario/%s', [lIDDoMotorista]), nil, [TNameValuePair.Create('Authorization', Format('bearer %s', [lToken]))]);
      lJSONMotoristaObtido := TJSONObject(TJSONObject.ParseJSONValue(lHTTPResposta.ContentAsString));
      try
         Assert.AreEqual<Integer>(200, lHTTPResposta.GetStatusCode);
         Assert.AreEqual('John Doe', lJSONMotoristaObtido.GetValue<string>('Nome'));
         Assert.AreEqual(lJSONMotoristaIncricao.GetValue<string>('email'), lJSONMotoristaObtido.GetValue<string>('Email'));
         Assert.AreEqual('95818705552', lJSONMotoristaObtido.GetValue<string>('CPF'));
         Assert.IsFalse(lJSONMotoristaObtido.GetValue<Boolean>('Passageiro'));
         Assert.IsTrue(lJSONMotoristaObtido.GetValue<Boolean>('Motorista'));
         Assert.AreEqual('ABC5656', lJSONMotoristaObtido.GetValue<string>('PlacaDoCarro'));
      finally
         lJSONMotoristaObtido.Destroy;
      end;
   finally
      lJSONMotoristaIncricao.Destroy;
      lHTTPClient.Destroy;
   end;
end;

procedure TClienteInvocadorMotoristaPOPAPIRESTTeste.PassageiroDeveSolicitarUmaCorrida;
var lHTTPClient : THTTPClient;
    lHTTPResposta: IHTTPResponse;
    lJSONPassageiroIncricao, lJSONPassagerioLogin,
    lJSONSolicitacaoCorrida, lJSONCoordenadaOrigem,
    lJSONCoordenadaDestino, lJSONCorridaSolicitada: TJSONObject;
    lStream: TStringStream;
    lEmailDoPassageiro, lIDDoPassageiro, lEmailESenhaBase64, lToken: string;
    lJSONResultado: TJSONValue;
begin
   lHTTPClient := THTTPClient.Create;
   lJSONPassageiroIncricao := TJSONObject.Create;
   lStream := TStringStream.Create;
   try
      lEmailDoPassageiro := Format('john.doe.%d@gmail.com', [Random(100000000)]);
      lJSONPassageiroIncricao.AddPair('nome', 'John Doe');
      lJSONPassageiroIncricao.AddPair('email', lEmailDoPassageiro);
      lJSONPassageiroIncricao.AddPair('cpf', '958.187.055-52');
      lJSONPassageiroIncricao.AddPair('passageiro', TJSONBool.Create(True));
      lJSONPassageiroIncricao.AddPair('motorista', TJSONBool.Create(False));
      lJSONPassageiroIncricao.AddPair('senha', 'S3nh-F0rte');
      lStream.WriteString(lJSONPassageiroIncricao.ToJSON);
      lStream.Position := 0;
      lHTTPResposta := lHTTPClient.Post('http://localhost:9000/usuario', lStream);
      lJSONResultado := TJSONObject.ParseJSONValue(lHTTPResposta.ContentAsString);
      try
         lIDDoPassageiro := lJSONResultado.GetValue<string>('IDDoUsuario');
      finally
         lJSONResultado.Destroy;
      end;

      lStream.Clear;
      lStream.Position := 0;
      lEmailESenhaBase64 := TBase64Encoding.Base64.Encode(lEmailDoPassageiro+':S3nh-F0rte');
      lHTTPResposta := lHTTPClient.Post('http://localhost:9000/login', lStream, nil, [TNameValuePair.Create('Authorization', Format('basic %s', [lEmailESenhaBase64]))]);
      lJSONPassagerioLogin := TJSONObject(TJSONObject.ParseJSONValue(lHTTPResposta.ContentAsString));
      try
         lToken := lJSONPassagerioLogin.GetValue<string>('Token');
      finally
         lJSONPassagerioLogin.Destroy;
      end;

      lJSONSolicitacaoCorrida := TJSONObject.Create;
      try
         lJSONSolicitacaoCorrida.AddPair('IDDoPassageiro', lIDDoPassageiro);
         lJSONCoordenadaOrigem := TJSONObject.Create;
         lJSONCoordenadaOrigem.AddPair('Latitude', TJSONNumber.Create(-46));
         lJSONCoordenadaOrigem.AddPair('Longitude', TJSONNumber.Create(-26));
         lJSONSolicitacaoCorrida.AddPair('De', lJSONCoordenadaOrigem);
         lJSONCoordenadaDestino := TJSONObject.Create;
         lJSONCoordenadaDestino.AddPair('Latitude', TJSONNumber.Create(-45));
         lJSONCoordenadaDestino.AddPair('Longitude', TJSONNumber.Create(-25));
         lJSONSolicitacaoCorrida.AddPair('Para', lJSONCoordenadaDestino);
         lStream.Clear;
         lStream.WriteString(lJSONSolicitacaoCorrida.ToJSON);
         lStream.Position := 0;
         lHTTPResposta := lHTTPClient.Post('http://localhost:9000/corrida/solicitar', lStream, nil, [TNameValuePair.Create('Authorization', Format('bearer %s', [lToken]))]);
         lJSONCorridaSolicitada := TJSONObject(TJSONObject.ParseJSONValue(lHTTPResposta.ContentAsString));
         try
            Assert.AreEqual<Integer>(200, lHTTPResposta.GetStatusCode);
            Assert.IsNotEmpty(lJSONCorridaSolicitada.GetValue<string>('IDDaCorrida'));
         finally
            lJSONCorridaSolicitada.Destroy;
         end;
      finally
         lJSONSolicitacaoCorrida.Destroy;
      end;
   finally
      lStream.Destroy;
      lJSONPassageiroIncricao.Destroy;
      lHTTPClient.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TClienteInvocadorMotoristaPOPAPIRESTTeste);
end.
