unit MotoristaPOP.Controlador.API.REST.Teste;

interface

uses
   System.SysUtils,
   System.Classes,
   System.Net.HTTPClient,
   System.JSON,
   DUnitX.TestFramework;

type
   [TestFixture]
   TControladorMotoristaPOPAPIRESTTeste = class(TObject)
   public
      [Test]
      procedure DeveCriarUmaContaDeUsuario;
      [Test]
      procedure DeveObterUmaContaDeUsuarioPorID;
      [Test]
      procedure DeveRealizarLoginComEmailDoUsuario;
   end;

implementation


{ TControladorMotoristaPOPAPIRESTTeste }

procedure TControladorMotoristaPOPAPIRESTTeste.DeveCriarUmaContaDeUsuario;
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

procedure TControladorMotoristaPOPAPIRESTTeste.DeveObterUmaContaDeUsuarioPorID;
var lHTTPClient : THTTPClient;
    lHTTPResposta: IHTTPResponse;
    lJSONMotoristaIncricao, lJSONMotoristaObtido: TJSONObject;
    lStream: TStringStream;
    lJSONResultado: TJSONObject;
    lIDDoMotorista: string;
begin
   lHTTPClient := THTTPClient.Create;
   lJSONMotoristaIncricao := TJSONObject.Create;
   try
      lStream := TStringStream.Create;
      try
         lJSONMotoristaIncricao.AddPair('nome', 'John Doe');
         lJSONMotoristaIncricao.AddPair('email', Format('john.doe.%d@gmail.com', [Random(100000000)]));
         lJSONMotoristaIncricao.AddPair('cpf', '958.187.055-52');
         lJSONMotoristaIncricao.AddPair('passageiro', TJSONBool.Create(False));
         lJSONMotoristaIncricao.AddPair('motorista', TJSONBool.Create(True));
         lJSONMotoristaIncricao.AddPair('placaDoCarro', 'ABC-5656');
         lStream.WriteString(lJSONMotoristaIncricao.ToJSON);
         lStream.Position := 0;
         lHTTPResposta := lHTTPClient.Post('http://localhost:9000/usuario', lStream);
         lJSONResultado := TJSONObject(TJSONObject.ParseJSONValue(lHTTPResposta.ContentAsString));
         try
            lIDDoMotorista := lJSONResultado.GetValue<string>('IDDoUsuario');
         finally
            lJSONResultado.Destroy;
         end;
      finally
         lStream.Destroy;
      end;

      lHTTPResposta := lHTTPClient.Get(Format('http://localhost:9000/usuario/%s', [lIDDoMotorista]));
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

procedure TControladorMotoristaPOPAPIRESTTeste.DeveRealizarLoginComEmailDoUsuario;
var lHTTPClient : THTTPClient;
    lHTTPResposta: IHTTPResponse;
    lJSONPassageiroIncricao, lJSONPassagerioLogin: TJSONObject;
    lStream: TStringStream;
    lEmailDoPassageiro, lIDDoPassageiro: string;
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
      lJSONPassageiroIncricao.AddPair('passageiro', TJSONBool.Create(False));
      lJSONPassageiroIncricao.AddPair('motorista', TJSONBool.Create(True));
      lJSONPassageiroIncricao.AddPair('placaDoCarro', 'ABC-5656');
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
      lHTTPResposta := lHTTPClient.Post(Format('http://localhost:9000/login/%s', [lEmailDoPassageiro]), lStream);
      lJSONPassagerioLogin := TJSONObject(TJSONObject.ParseJSONValue(lHTTPResposta.ContentAsString));
      try
         Assert.AreEqual<Integer>(200, lHTTPResposta.GetStatusCode);
         Assert.AreEqual(lIDDoPassageiro, lJSONPassagerioLogin.GetValue<string>('IDDoUsuario'));
      finally
         lJSONPassagerioLogin.Destroy;
      end;
   finally
      lStream.Destroy;
      lJSONPassageiroIncricao.Destroy;
      lHTTPClient.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TControladorMotoristaPOPAPIRESTTeste);
end.
