unit MotoristaPOP.API.Teste;

interface

uses
   System.SysUtils,
   System.Classes,
   System.Net.HTTPClient,
   System.JSON,
   DUnitX.TestFramework;

type
   [TestFixture]
   TAPIMotoristaPOPTeste = class
   public
      [Test]
      procedure DeveCriarUmaContaDePassageiro;
   end;

implementation

procedure TAPIMotoristaPOPTeste.DeveCriarUmaContaDePassageiro;
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

initialization
   TDUnitX.RegisterTestFixture(TAPIMotoristaPOPTeste);
end.
