unit JSON.Conversor.Serializers;

interface

uses
   System.JSON,
   JSON.Conversor;

type
   TConversorJSONSerializers = class(TConversorJSON)
      function ConverterParaJSON<T>(pObjeto: T): TJSONValue; override;
      function ConverterParaObjeto<T>(pJSON: String): T; override;
   end;

implementation

{ TConversorJSONSerializers }

end.
