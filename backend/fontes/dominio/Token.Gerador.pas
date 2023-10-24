unit Token.Gerador;

interface

uses
   System.SysUtils,
   System.DateUtils,
   JOSE.Core.JWT,
   JOSE.Core.Builder,
   JOSE.Types.JSON,
   ContaDeUsuario,
   UUID;

type
   TContaDeUsuarioJWTCorpo = class(TJWTClaims)
   strict private
      procedure AtribuirCPF(const Value: string);
      procedure AtribuirEmail(const Value: string);
      procedure AtribuirId(const Value: string);
      procedure AtribuirNome(const Value: string);
      function ObterCPF: string;
      function ObterEmail: string;
      function ObterId: string;
      function ObterNome: string;
   public
      property Id: string read ObterId write AtribuirId;
      property Nome: string read ObterNome write AtribuirNome;
      property Email: string read ObterEmail write AtribuirEmail;
      property CPF: string read ObterCPF write AtribuirCPF;
   end;

   TGeradorToken = class
   strict private
      class var FSegredo: String;
   public
      class function Gerar(pContaDeUsuario: TContaDeUsuario): String;
      class function Segredo: String;
   end;

implementation

const HORAS_PARA_EXPIRAR_TOKEN: Integer = 3;

{ TGeradorToken }

class function TGeradorToken.Gerar(pContaDeUsuario: TContaDeUsuario): String;
var
   lJWT: TJWT;
begin
   lJWT := TJWT.Create(TContaDeUsuarioJWTCorpo);
   try
      lJWT.Claims.Expiration := IncHour(Now, HORAS_PARA_EXPIRAR_TOKEN);
      TContaDeUsuarioJWTCorpo(lJWT.Claims).Id := pContaDeUsuario.ID;
      TContaDeUsuarioJWTCorpo(lJWT.Claims).Nome := pContaDeUsuario.Nome;
      TContaDeUsuarioJWTCorpo(lJWT.Claims).Email := pContaDeUsuario.Email;
      TContaDeUsuarioJWTCorpo(lJWT.Claims).CPF := pContaDeUsuario.CPF;
      Result := TJOSE.SHA256CompactToken(TGeradorToken.Segredo, lJWT);
   finally
      lJWT.Destroy;
   end;
end;

class function TGeradorToken.Segredo: String;
begin
   if TGeradorToken.FSegredo.IsEmpty then
      TGeradorToken.FSegredo := TUUID.Gerar;
   Result := TGeradorToken.FSegredo;
end;

{ TContaDeUsuarioJWTCorpo }

procedure TContaDeUsuarioJWTCorpo.AtribuirCPF(
  const Value: string);
begin
  TJSONUtils.SetJSONValueFrom<string>('cpf', Value, FJSON);
end;

procedure TContaDeUsuarioJWTCorpo.AtribuirEmail(
  const Value: string);
begin
  TJSONUtils.SetJSONValueFrom<string>('email', Value, FJSON);
end;

procedure TContaDeUsuarioJWTCorpo.AtribuirId(const Value: string);
begin
  TJSONUtils.SetJSONValueFrom<string>('id', Value, FJSON);
end;

procedure TContaDeUsuarioJWTCorpo.AtribuirNome(
  const Value: string);
begin
  TJSONUtils.SetJSONValueFrom<string>('nome', Value, FJSON);
end;

function TContaDeUsuarioJWTCorpo.ObterCPF: string;
begin
  Result := TJSONUtils.GetJSONValue('cpf', FJSON).AsString;
end;

function TContaDeUsuarioJWTCorpo.ObterEmail: string;
begin
  Result := TJSONUtils.GetJSONValue('email', FJSON).AsString;
end;

function TContaDeUsuarioJWTCorpo.ObterId: string;
begin
  Result := TJSONUtils.GetJSONValue('id', FJSON).AsString;
end;

function TContaDeUsuarioJWTCorpo.ObterNome: string;
begin
  Result := TJSONUtils.GetJSONValue('nome', FJSON).AsString;
end;

end.
