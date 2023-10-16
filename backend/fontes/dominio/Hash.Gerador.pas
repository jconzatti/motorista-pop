unit Hash.Gerador;

interface

uses
   System.SysUtils,
   IdGlobal,
   IdHash,
   IdHashMessageDigest,
   IdHashSHA;

type
   EAlgoritimoHashInvalido = class(EArgumentException);
   {$SCOPEDENUMS ON}
   TAlgoritimoHash = (Nenhum, MD5, SHA1, SHA256, SHA512);
   {$SCOPEDENUMS OFF}
   TAlgoritimoHashHelper = record helper for TAlgoritimoHash
   public
      function Valor: String;
      class function Algoritimo(pValor: String): TAlgoritimoHash; static;
   end;
   TGeradorHash = class
   private
      FAlgoritimo: TAlgoritimoHash;
      function GerarHashMD5(pParametro: String): String;
      function GerarHashSHA1(pParametro: String): String;
      function GerarHashSHA256(pParametro: String): String;
      function GerarHashSHA512(pParametro: String): String;
   public
      constructor Create(pAlgoritimo: TAlgoritimoHash); reintroduce;
      function GerarHash(pParametro: String): String;
      property Algoritimo: TAlgoritimoHash read FAlgoritimo;
   end;

implementation

{ TGeradorHash }

constructor TGeradorHash.Create(pAlgoritimo: TAlgoritimoHash);
begin
   FAlgoritimo := pAlgoritimo;
end;

function TGeradorHash.GerarHash(pParametro: String): String;
begin
   Result := '';
   case Algoritimo of
      TAlgoritimoHash.Nenhum: Result := pParametro;
      TAlgoritimoHash.MD5: Result := GerarHashMD5(pParametro);
      TAlgoritimoHash.SHA1: Result := GerarHashSHA1(pParametro);
      TAlgoritimoHash.SHA256: Result := GerarHashSHA256(pParametro);
      TAlgoritimoHash.SHA512: Result := GerarHashSHA512(pParametro);
   end;
end;

function TGeradorHash.GerarHashMD5(pParametro: String): String;
begin
//   Result := GerarHash(TIdHashMessageDigest5.Create, pParametro);
end;

function TGeradorHash.GerarHashSHA1(pParametro: String): String;
begin
//   Result := GerarHash(TIdHashSHA1.Create, pParametro);
end;

function TGeradorHash.GerarHashSHA256(pParametro: String): String;
begin
//   Result := GerarHash(TIdHashSHA256.Create, pParametro);
end;

function TGeradorHash.GerarHashSHA512(pParametro: String): String;
var lHash: TIdHashSHA512;
begin
   lHash := TIdHashSHA512.Create;
   try
      Result := IdGlobal.IndyLowerCase(lHash.HashStringAsHex(pParametro));
   finally
      lHash.Destroy;
   end;
end;

{ TAlgoritimoHashHelper }

function TAlgoritimoHashHelper.Valor: String;
begin
   Result := 'invalid';
   case Self of
      TAlgoritimoHash.Nenhum: Result := '';
      TAlgoritimoHash.MD5: Result := 'md5';
      TAlgoritimoHash.SHA1: Result := 'sha1';
      TAlgoritimoHash.SHA256: Result := 'sha256';
      TAlgoritimoHash.SHA512: Result := 'sha512';
   end;
end;

class function TAlgoritimoHashHelper.Algoritimo(pValor: String): TAlgoritimoHash;
begin
   pValor := pValor.ToLower;
   if pValor.IsEmpty then
      Result := TAlgoritimoHash.Nenhum
   else
   if pValor.Equals('md5') then
      Result := TAlgoritimoHash.MD5
   else
   if pValor.Equals('sha1') then
      Result := TAlgoritimoHash.SHA1
   else
   if pValor.Equals('sha256') then
      Result := TAlgoritimoHash.SHA256
   else
   if pValor.Equals('sha512') then
      Result := TAlgoritimoHash.SHA512
   else
      raise EAlgoritimoHashInvalido.Create(Format('Valor "%s" para algorítimo hash inválido!', [pValor]));
end;

end.
