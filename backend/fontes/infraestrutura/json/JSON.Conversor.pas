unit JSON.Conversor;

interface

uses
   System.SysUtils,
   System.TypInfo,
   System.Rtti,
   System.JSON,
   System.JSON.Types,
   System.JSON.Serializers,
   System.JSON.Writers,
   System.JSON.Readers;

type
   EConversaoJSONComErro = class(EJSONException);

   TConversorJSON = class
   private type
      TDefaultJSONConverter = class(TJsonConverter)
      private
         FContextoRTTI : TRttiContext;
         FValue: TValue;
         function RecordEmBranco(AValue: TValue): Boolean;
      public
         constructor Create;
         destructor Destroy; override;
         function CanConvert(ATypeInf: PTypeInfo): Boolean; override;
         function CanRead: Boolean; override;
         function ReadJson(const AReader: TJsonReader; ATypeInf: PTypeInfo;
            const AExistingValue: TValue;
            const ASerializer: TJsonSerializer): TValue; override;
         procedure WriteJson(const AWriter: TJsonWriter; const AValue: TValue;
            const ASerializer: TJsonSerializer); override;
      end;
   private
      FJsonSerializer: TJsonSerializer;
      FDefaultJSONConverter: TDefaultJSONConverter;
   public
      constructor Create;
      destructor Destroy; override;
      function ConverterParaJSON<T>(pObjeto: T): TJSONValue;
      function ConverterParaObjeto<T>(pJSON: String): T; overload;
      function ConverterParaObjeto<T>(pJSON: TJSONValue): T; overload;
   end;

implementation

{ TConversorJSON }

constructor TConversorJSON.Create;
begin
   FDefaultJSONConverter := TDefaultJSONConverter.Create;
   FJsonSerializer := TJsonSerializer.Create;
   FJsonSerializer.DateTimeZoneHandling := TJsonDateTimeZoneHandling.Utc;
   FJsonSerializer.Converters.Add(FDefaultJSONConverter)
end;

destructor TConversorJSON.Destroy;
begin
   FJsonSerializer.Destroy;
   FDefaultJSONConverter.Destroy;
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

function TConversorJSON.ConverterParaObjeto<T>(pJSON: TJSONValue): T;
begin
   Result := ConverterParaObjeto<T>(pJSON.ToString);
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

{ TConversorJSON.TDefaultJSONConverter }

constructor TConversorJSON.TDefaultJSONConverter.Create;
begin
   FContextoRTTI := TRttiContext.Create;
end;

destructor TConversorJSON.TDefaultJSONConverter.Destroy;
begin
   FContextoRTTI.Free;
   inherited;
end;

function TConversorJSON.TDefaultJSONConverter.CanConvert(ATypeInf: PTypeInfo): Boolean;
begin
   Result := (ATypeInf^.Kind = tkRecord)
             and (RecordEmBranco(FValue));
   if not FValue.IsEmpty then
      FValue := Default(TValue);
end;

function TConversorJSON.TDefaultJSONConverter.CanRead: Boolean;
begin
   Result := False;
end;

function TConversorJSON.TDefaultJSONConverter.ReadJson(const AReader: TJsonReader;
  ATypeInf: PTypeInfo; const AExistingValue: TValue;
  const ASerializer: TJsonSerializer): TValue;
begin
   Result := AExistingValue;
end;

procedure TConversorJSON.TDefaultJSONConverter.WriteJson(const AWriter: TJsonWriter;
  const AValue: TValue; const ASerializer: TJsonSerializer);
begin
   inherited;
   if RecordEmBranco(AValue) then
   begin
      AWriter.WriteNull;
   end else
   begin
      FValue := AValue;
      ASerializer.Serialize(AWriter, AValue);
   end;
end;

function TConversorJSON.TDefaultJSONConverter.RecordEmBranco(AValue: TValue): Boolean;
var
   lTipoRTTI: TRttiType;
   lCampoRTTI: TRttiField;
begin
   Result := True;
   if not AValue.IsEmpty then
   begin
      case AValue.TypeInfo^.Kind of
         tkFloat:
            Result := AValue.AsExtended = 0;
         tkInteger:
            Result := AValue.AsInteger = 0;
         tkString, tkWChar, tkChar, tkLString, tkWString, tkUString:
            Result := AValue.AsString.IsEmpty;
         tkEnumeration:
         begin
            if AValue.TypeInfo = TypeInfo(Boolean) then
               Result := AValue.AsBoolean = False
            else
               Result := PInteger(AValue.GetReferenceToRawData)^ = 0;
         end;
         tkUnknown, tkSet, tkClass, tkMethod, tkVariant, tkMRecord,
         tkInterface, tkClassRef, tkPointer, tkProcedure, tkDynArray, tkArray:
            Result := False;
         tkRecord:
         begin
            lTipoRTTI := FContextoRTTI.GetType(AValue.TypeInfo);
            for lCampoRTTI in lTipoRTTI.GetFields do
            begin
               Result := RecordEmBranco(lCampoRTTI.GetValue(AValue.GetReferenceToRawData));
               if not Result then
                  Break;
            end;
         end;
      end;
   end;
end;

end.
