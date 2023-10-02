unit ContaDeUsuario.Gateway.HTTP;

interface

uses
   System.SysUtils,
   System.JSON,
   HTTP.Cliente,
   ContaDeUsuario.Gateway;

type
   TGatewayContaDeUsuarioHTTP = class(TGatewayContaDeUsuario)
   private
      FClienteHTTP : TClienteHTTP;
   public
      constructor Create(pClienteHTTP: TClienteHTTP); reintroduce;
      function RealizarLogin(pEmail: String): String; override;
      function ObterPorID(pID: String): TDadoSaidaObtencaoPorIDContaDeUsuario; override;
      function InscreverUsuario(pDadoUsuario: TDadoEntradaInscricaoContaDeUsuario): String; override;
   end;

implementation

{ TGatewayContaDeUsuarioHTTP }

constructor TGatewayContaDeUsuarioHTTP.Create(pClienteHTTP: TClienteHTTP);
begin
   FClienteHTTP := pClienteHTTP;
end;

function TGatewayContaDeUsuarioHTTP.RealizarLogin(pEmail: String): String;
var lJSONUsuarioLogin: TJSONValue;
    lRespostaHTTP: TRespostaHTTP;
begin
   if pEmail.IsEmpty then
      raise EArgumentException.Create('e-mail não informado!');

   lRespostaHTTP := FClienteHTTP.Post(Format('http://localhost:9000/login/%s', [pEmail]), '');
   lJSONUsuarioLogin := TJSONObject.ParseJSONValue(lRespostaHTTP.Dado);
   try
      if lRespostaHTTP.CodigoDeRespostaHTTP <> 200 then
         raise Exception.Create(lJSONUsuarioLogin.GetValue<string>('Erro'));
      Result := lJSONUsuarioLogin.GetValue<string>('IDDoUsuario');
   finally
      lJSONUsuarioLogin.Destroy;
   end;
end;

function TGatewayContaDeUsuarioHTTP.ObterPorID(pID: String): TDadoSaidaObtencaoPorIDContaDeUsuario;
var lJSONUsuario: TJSONValue;
    lRespostaHTTP: TRespostaHTTP;
begin
   if pID.IsEmpty then
      raise EArgumentException.Create('ID de usuário não informado!');

   lRespostaHTTP := FClienteHTTP.Get(Format('http://localhost:9000/usuario/%s', [pID]));
   lJSONUsuario := TJSONObject.ParseJSONValue(lRespostaHTTP.Dado);
   try
      if lRespostaHTTP.CodigoDeRespostaHTTP <> 200 then
         raise Exception.Create(lJSONUsuario.GetValue<string>('Erro'));
      Result.Nome         := lJSONUsuario.GetValue<string>('Nome');
      Result.Email        := lJSONUsuario.GetValue<string>('Email');
      Result.CPF          := lJSONUsuario.GetValue<string>('CPF');
      Result.PlacaDoCarro := lJSONUsuario.GetValue<string>('PlacaDoCarro');
      Result.Motorista    := lJSONUsuario.GetValue<boolean>('Motorista');
      Result.Passageiro   := lJSONUsuario.GetValue<boolean>('Passageiro');
   finally
      lJSONUsuario.Destroy;
   end;
end;

function TGatewayContaDeUsuarioHTTP.InscreverUsuario(pDadoUsuario: TDadoEntradaInscricaoContaDeUsuario): String;
var lJSONUsuario: TJSONValue;
    lRespostaHTTP: TRespostaHTTP;
begin
   lJSONUsuario := TJSONObject.Create;
   try
      TJSONObject(lJSONUsuario).AddPair('Nome', pDadoUsuario.Nome);
      TJSONObject(lJSONUsuario).AddPair('Email', pDadoUsuario.Email);
      TJSONObject(lJSONUsuario).AddPair('CPF', pDadoUsuario.CPF);
      TJSONObject(lJSONUsuario).AddPair('Passageiro', TJSONBool.Create(pDadoUsuario.Passageiro));
      TJSONObject(lJSONUsuario).AddPair('Motorista', TJSONBool.Create(pDadoUsuario.Motorista));
      TJSONObject(lJSONUsuario).AddPair('PlacaDoCarro', pDadoUsuario.PlacaDoCarro);
      lRespostaHTTP := FClienteHTTP.Post('http://localhost:9000/usuario', lJSONUsuario.ToJSON);
   finally
      lJSONUsuario.Destroy;
   end;
   lJSONUsuario := TJSONObject.ParseJSONValue(lRespostaHTTP.Dado);
   try
      if lRespostaHTTP.CodigoDeRespostaHTTP <> 201 then
         raise Exception.Create(lJSONUsuario.GetValue<string>('Erro'));
      Result := lJSONUsuario.GetValue<string>('IDDoUsuario');
   finally
      lJSONUsuario.Destroy;
   end;
end;

end.
