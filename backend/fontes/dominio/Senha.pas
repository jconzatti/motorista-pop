unit Senha;

interface

uses
   System.SysUtils,
   System.RegularExpressions,
   Hash.Gerador;

type
   ESenhaPoliticaInvalida = class(EArgumentException);

   TSenha = class
   private
      FValor : String;
      FGeradorHash : TGeradorHash;
      FPrefixo: String;
      constructor Create(pPrefixo, pValor: String; pAlgoritimo: TAlgoritimoHash); reintroduce;
      function ObterAlgoritimoHash: TAlgoritimoHash;
      class procedure ValidarPoliticaDeSenha(pSenha: String);
   public
      destructor Destroy; override;
      class function Criar(pPrefixo, pSenha: String; pAlgoritimo: TAlgoritimoHash): TSenha;
      class function Restaurar(pPrefixo, pHashDaSenha: String; pAlgoritimo: TAlgoritimoHash): TSenha;
      function Validar(pSenha: String): Boolean;
      property Valor: String read FValor;
      property Algoritimo: TAlgoritimoHash read ObterAlgoritimoHash;
      property Prefixo: String read FPrefixo;
   end;

implementation

{ TSenha }

class function TSenha.Criar(pPrefixo, pSenha: String; pAlgoritimo: TAlgoritimoHash): TSenha;
var
   lGeradorHash: TGeradorHash;
   lHashDaSenha: String;
begin
   TSenha.ValidarPoliticaDeSenha(pSenha);
   lGeradorHash := TGeradorHash.Create(pAlgoritimo);
   try
      lHashDaSenha := lGeradorHash.GerarHash(pPrefixo+pSenha);
   finally
      lGeradorHash.Destroy;
   end;
   Result := TSenha.Create(pPrefixo, lHashDaSenha, pAlgoritimo);
end;

class function TSenha.Restaurar(pPrefixo, pHashDaSenha: String; pAlgoritimo: TAlgoritimoHash): TSenha;
begin
   Result := TSenha.Create(pPrefixo, pHashDaSenha, pAlgoritimo);
end;

constructor TSenha.Create(pPrefixo, pValor: String; pAlgoritimo: TAlgoritimoHash);
begin
   FPrefixo := pPrefixo;
   FValor := pValor;
   FGeradorHash := TGeradorHash.Create(pAlgoritimo);
end;

destructor TSenha.Destroy;
begin
   if Assigned(FGeradorHash) then
      FGeradorHash.Destroy;
   inherited;
end;

function TSenha.Validar(pSenha: String): Boolean;
begin
   Result := FValor.Equals(FGeradorHash.GerarHash(FPrefixo+pSenha));
end;

class procedure TSenha.ValidarPoliticaDeSenha(pSenha: String);
begin
   if not TRegEx.IsMatch(pSenha, '^(?=.*[a-z·ÈÌÛ˙‚ÍÓÙ˚„ıÁ])(?=.*[A-Z¡…Õ”⁄¬ Œ‘€√’«])(?=.*\d)(?=.*[@#\$%^&+=!_\?\\/\-\*\[\]\{\}\.\;\:\s]).{8,}$') then
      raise ESenhaPoliticaInvalida.Create('A senha deve ter no mÌnimo 8 caracteres, pelo menos uma letra MAI⁄SCULA, pelo menos uma letra min˙scula, pelo menos um dÌgito numÈrico e pelo menos um caractere especial!');
end;

function TSenha.ObterAlgoritimoHash: TAlgoritimoHash;
begin
   Result := FGeradorHash.Algoritimo;
end;

end.
