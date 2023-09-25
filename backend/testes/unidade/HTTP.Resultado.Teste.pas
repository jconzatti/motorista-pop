unit HTTP.Resultado.Teste;

interface

uses
   System.SysUtils,
   System.Classes,
   System.JSON,
   HTTP.Servidor,
   DUnitX.TestFramework;

type
   [TestFixture]
   TResultadoHTTPTeste = class
   public
      [Test]
      procedure DeveCriarUmResutadoHTTPPadrao;
      [Test]
      procedure DeveCriarUmResutadoHTTPComJSON;
      [Test]
      procedure DeveCriarUmResutadoHTTPComJSONECodigoHTTP;
      [Test]
      procedure DeveCriarUmResutadoHTTPComCodigoHTTP;
      [Test]
      procedure DeveCriarUmResutadoHTTPComExcecao;
      [Test]
      procedure DeveCriarUmResutadoHTTPComExcecaoDeArgumento;
      [Test]
      procedure DeveCriarUmResutadoHTTPComExcecaoDeJSON;
      [Test]
      procedure DeveCriarUmResutadoHTTPComExcecaoNaoEncontrado;
   end;

implementation

{ TResultadoHTTPTeste }

procedure TResultadoHTTPTeste.DeveCriarUmResutadoHTTPPadrao;
var
   lResultadoHTTP: TResultadoHTTP;
begin
   lResultadoHTTP := TResultadoHTTP.Create;
   try
      Assert.IsEmpty(lResultadoHTTP.JSON.ToString);
      Assert.AreEqual('null', lResultadoHTTP.JSON.ToJSON);
      Assert.AreEqual(200, lResultadoHTTP.CodigoDeRespostaHTTP);
   finally
      lResultadoHTTP.Destroy;
   end;
end;

procedure TResultadoHTTPTeste.DeveCriarUmResutadoHTTPComJSON;
var
   lResultadoHTTP: TResultadoHTTP;
   lJSON: TJSONObject;
begin
   lJSON := TJSONObject.Create;
   lJSON.AddPair('descricao', 'Uma descrição de teste!');
   lJSON.AddPair('valor', TJSONNumber.Create(45.5));
   lJSON.AddPair('verificado', TJSONTrue.Create);
   lResultadoHTTP := TResultadoHTTP.Create(lJSON);
   try
      Assert.AreEqual(lJSON.ToJSON, lResultadoHTTP.JSON.ToJSON);
      Assert.AreEqual(200, lResultadoHTTP.CodigoDeRespostaHTTP);
   finally
      lResultadoHTTP.Destroy;
      lJSON.Destroy;
   end;
end;

procedure TResultadoHTTPTeste.DeveCriarUmResutadoHTTPComJSONECodigoHTTP;
var
   lResultadoHTTP: TResultadoHTTP;
   lJSON: TJSONObject;
begin
   lJSON := TJSONObject.Create;
   lJSON.AddPair('descricao', 'Uma descrição de teste!');
   lJSON.AddPair('valor', TJSONNumber.Create(45.5));
   lJSON.AddPair('verificado', TJSONTrue.Create);
   lResultadoHTTP := TResultadoHTTP.Create(lJSON, 201);
   try
      Assert.AreEqual(lJSON.ToJSON, lResultadoHTTP.JSON.ToJSON);
      Assert.AreEqual(201, lResultadoHTTP.CodigoDeRespostaHTTP);
   finally
      lResultadoHTTP.Destroy;
      lJSON.Destroy;
   end;
end;

procedure TResultadoHTTPTeste.DeveCriarUmResutadoHTTPComCodigoHTTP;
var
   lResultadoHTTP: TResultadoHTTP;
begin
   lResultadoHTTP := TResultadoHTTP.Create(204);
   try
      Assert.IsEmpty(lResultadoHTTP.JSON.ToString);
      Assert.AreEqual('null', lResultadoHTTP.JSON.ToJSON);
      Assert.AreEqual(204, lResultadoHTTP.CodigoDeRespostaHTTP);
   finally
      lResultadoHTTP.Destroy;
   end;
end;

procedure TResultadoHTTPTeste.DeveCriarUmResutadoHTTPComExcecao;
var
   lResultadoHTTP: TResultadoHTTP;
begin
   try
      raise Exception.Create('Erro!');
   except
      on E: Exception do
      begin
         lResultadoHTTP := TResultadoHTTP.Create(E);
         try
            Assert.AreEqual('{"Erro":"Erro!","Tipo":"Exception"}', lResultadoHTTP.JSON.ToString);
            Assert.AreEqual(500, lResultadoHTTP.CodigoDeRespostaHTTP);
         finally
            lResultadoHTTP.Destroy;
         end;
      end;
   end;
end;

procedure TResultadoHTTPTeste.DeveCriarUmResutadoHTTPComExcecaoDeArgumento;
var
   lResultadoHTTP: TResultadoHTTP;
begin
   try
      raise EArgumentException.Create('Argumento inválido!');
   except
      on E: Exception do
      begin
         lResultadoHTTP := TResultadoHTTP.Create(E);
         try
            Assert.AreEqual('{"Erro":"Argumento inválido!","Tipo":"EArgumentException"}', lResultadoHTTP.JSON.ToString);
            Assert.AreEqual(400, lResultadoHTTP.CodigoDeRespostaHTTP);
         finally
            lResultadoHTTP.Destroy;
         end;
      end;
   end;
end;

procedure TResultadoHTTPTeste.DeveCriarUmResutadoHTTPComExcecaoDeJSON;
var
   lResultadoHTTP: TResultadoHTTP;
begin
   try
      raise EJSONException.Create('Estrutura de JSON inválida!');
   except
      on E: Exception do
      begin
         lResultadoHTTP := TResultadoHTTP.Create(E);
         try
            Assert.AreEqual('{"Erro":"Estrutura de JSON inválida!","Tipo":"EJSONException"}', lResultadoHTTP.JSON.ToString);
            Assert.AreEqual(422, lResultadoHTTP.CodigoDeRespostaHTTP);
         finally
            lResultadoHTTP.Destroy;
         end;
      end;
   end;
end;

procedure TResultadoHTTPTeste.DeveCriarUmResutadoHTTPComExcecaoNaoEncontrado;
var
   lResultadoHTTP: TResultadoHTTP;
begin
   try
      raise EResNotFound.Create('Não encontrado!');
   except
      on E: Exception do
      begin
         lResultadoHTTP := TResultadoHTTP.Create(E);
         try
            Assert.AreEqual('{"Erro":"Não encontrado!","Tipo":"EResNotFound"}', lResultadoHTTP.JSON.ToString);
            Assert.AreEqual(404, lResultadoHTTP.CodigoDeRespostaHTTP);
         finally
            lResultadoHTTP.Destroy;
         end;
      end;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TResultadoHTTPTeste);
end.
