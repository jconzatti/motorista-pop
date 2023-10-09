unit HTTP.Servidor;

interface

uses
   System.SysUtils,
   System.Classes,
   System.Generics.Collections,
   System.JSON;

type
   TMetodoHTTP = (mGET, mPOST);
   TParametroHTTP = TDictionary<String,String>;

   TResultadoHTTP = class
   private
      FJSON: TJSONValue;
      FCodigoDeRespostaHTTP : Integer;
      function ObterCodigoDeRespostaHTTPDaExcecao(pExcecao: Exception): Integer;
   public
      constructor Create; overload;
      constructor Create(pCodigoDeRespostaHTTP: Integer); overload;
      constructor Create(pJSON: TJSONValue);overload;
      constructor Create(pJSON: TJSONValue; pCodigoDeRespostaHTTP: Integer);overload;
      constructor Create(pExcecao: Exception); overload;
      property JSON: TJSONValue read FJSON;
      property CodigoDeRespostaHTTP : Integer read FCodigoDeRespostaHTTP;
   end;

   TCallbackServidorHTTP = function(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP of object;

   TServidorHTTP = class abstract
   public
      procedure Iniciar(pPorta: Integer); virtual; abstract;
      procedure Registrar(pMetodo: TMetodoHTTP; pURL : String; pCallback: TCallbackServidorHTTP); virtual; abstract;
   end;

implementation

{ TResultadoHTTP }

constructor TResultadoHTTP.Create;
begin
   Create(TJSONString.Create);
end;

constructor TResultadoHTTP.Create(pCodigoDeRespostaHTTP: Integer);
begin
   Create(nil, pCodigoDeRespostaHTTP);
end;

constructor TResultadoHTTP.Create(pJSON: TJSONValue);
begin
   Create(pJSON, 200);
end;

constructor TResultadoHTTP.Create(pExcecao: Exception);
begin
   FJSON := TJSONObject.Create;
   try
      TJSONObject(FJSON).AddPair('Erro', pExcecao.Message);
      TJSONObject(FJSON).AddPair('Tipo', pExcecao.ClassName);
      Create(FJSON, ObterCodigoDeRespostaHTTPDaExcecao(pExcecao));
   except
      FJSON.Destroy;
      raise;
   end;
end;

constructor TResultadoHTTP.Create(pJSON: TJSONValue; pCodigoDeRespostaHTTP: Integer);
begin
   FJSON := pJSON;
   if not Assigned(FJSON) then
      FJSON := TJSONString.Create;

   FCodigoDeRespostaHTTP := pCodigoDeRespostaHTTP;
end;

function TResultadoHTTP.ObterCodigoDeRespostaHTTPDaExcecao(pExcecao: Exception): Integer;
begin
   Result := 500;
   if pExcecao is EArgumentException then
      Result := 400
   else if pExcecao is EResNotFound then
      Result := 404
   else if pExcecao is EJSONException then
      Result := 422;
end;

end.
