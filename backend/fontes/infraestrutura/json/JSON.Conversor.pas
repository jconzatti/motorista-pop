unit JSON.Conversor;

interface

uses
   System.JSON,
   System.JSON.Serializers;

type
   EConversaoJSONComErro = class(EJSONException);

   TConversorJSON = class
   private
      FJsonSerializer: TJsonSerializer;
   public
      constructor Create;
      destructor Destroy; override;
   public
      function ConverterParaJSON<T>(pObjeto: T): TJSONValue;
      function ConverterParaObjeto<T>(pJSON: String): T;
   end;

implementation

{ TConversorJSON }

constructor TConversorJSON.Create;
begin
   FJsonSerializer := TJsonSerializer.Create;
end;

destructor TConversorJSON.Destroy;
begin
   FJsonSerializer.Destroy;
   inherited;
end;

function TConversorJSON.ConverterParaJSON<T>(pObjeto: T): TJSONValue;
var lJSON : String;
begin
   try
      lJSON := FJsonSerializer.Serialize<T>(pObjeto);
      Result := TJSONObject.ParseJSONValue(lJSON, true, true);
   except
      on E: EJsonSerializationException do
         raise EConversaoJSONComErro.Create('Erro ao converter objeto para json: '+E.Message);
   end;
end;

function TConversorJSON.ConverterParaObjeto<T>(pJSON: String): T;
begin
   try
      Result := FJsonSerializer.Deserialize<T>(pJSON);
   except
      on E: EJsonSerializationException do
         raise EConversaoJSONComErro.Create('Erro ao converter json para objeto: '+E.Message);
   end;
end;

end.
