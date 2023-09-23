unit MotoristaPOP.Controlador.API.REST;

interface

uses
   System.SysUtils,
   System.JSON,
   JSON.Conversor,
   HTTP.Servidor,
   InscreverUsuario,
   ObterContaDeUsuario;

type
   TControladorMotoristaPOPAPIREST = class
   private
      FConversorJSON: TConversorJSON;
      FServidorHTTP: TServidorHTTP;
      FInscreverUsuario: TInscreverUsuario;
      FObterContaDeUsuario: TObterContaDeUsuario;
      function ExecutarObterContaDeUsuario(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      function ExecutarInscreverUsuario(pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
      procedure RegistrarRotasDaAPI;
   public
      constructor Create(pServidorHTTP: TServidorHTTP;
                         pInscreverUsuario: TInscreverUsuario;
                         pObterContaDeUsuario: TObterContaDeUsuario); reintroduce;
      destructor Destroy; override;
   end;

implementation

{ TControladorMotoristaPOPAPIREST }

constructor TControladorMotoristaPOPAPIREST.Create(pServidorHTTP: TServidorHTTP;
                                                   pInscreverUsuario: TInscreverUsuario;
                                                   pObterContaDeUsuario: TObterContaDeUsuario);
begin
   FConversorJSON := TConversorJSON.Create;

   FServidorHTTP        := pServidorHTTP;
   FInscreverUsuario    := pInscreverUsuario;
   FObterContaDeUsuario := pObterContaDeUsuario;
   RegistrarRotasDaAPI;
   FServidorHTTP.Iniciar(9000);
end;

destructor TControladorMotoristaPOPAPIREST.Destroy;
begin
   FConversorJSON.Destroy;
   inherited;
end;

procedure TControladorMotoristaPOPAPIREST.RegistrarRotasDaAPI;
begin
   FServidorHTTP.Executar(mPOST, '/usuario', ExecutarInscreverUsuario);
   FServidorHTTP.Executar(mGET, '/usuario/:id', ExecutarObterContaDeUsuario);
end;

function TControladorMotoristaPOPAPIREST.ExecutarInscreverUsuario(
  pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
var
   lIDDoUsuario: String;
   lInscricaoUsuario: TDadoEntradaInscricaoContaDeUsuario;
begin
   try
      lInscricaoUsuario := FConversorJSON.ConverterParaObjeto<TDadoEntradaInscricaoContaDeUsuario>(pConteudo);
      lIDDoUsuario := FInscreverUsuario.Executar(lInscricaoUsuario);
      Result := TResultadoHTTP.Create(TJSONString.Create(lIDDoUsuario), 201);
   except
      on E: Exception do
         Result := TResultadoHTTP.Create(E);
   end;
end;

function TControladorMotoristaPOPAPIREST.ExecutarObterContaDeUsuario(
  pParametros: TParametroHTTP; pConteudo: String): TResultadoHTTP;
var
   lObtencaoUsuario : TDadoSaidaObtencaoContaDeUsuario;
   lJSONObtencaoUsuario: TJSONValue;
begin
   try
      lObtencaoUsuario := FObterContaDeUsuario.Executar(pParametros.Items['id']);
      lJSONObtencaoUsuario := FConversorJSON.ConverterParaJSON<TDadoSaidaObtencaoContaDeUsuario>(lObtencaoUsuario);
      Result := TResultadoHTTP.Create(lJSONObtencaoUsuario);
   except
      on E: Exception do
         Result := TResultadoHTTP.Create(E);
   end;
end;

end.
