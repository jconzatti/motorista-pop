unit ContaDeUsuario;

interface

uses
   System.SysUtils,
   UUID,
   Nome,
   CPF,
   Email,
   PlacaDeCarro,
   Hash.Gerador,
   Senha;

type
   EContaDeUsuarioPlacaDoCarroInformada = class(EArgumentException);
   EContaDeUsuarioSenhaInvalida = class(EArgumentException);

   TContaDeUsuario = class
   private
      FID: TUUID;
      FNome: TNome;
      FCPF: TCPF;
      FEmail: TEmail;
      FPassageiro: Boolean;
      FMotorista: Boolean;
      FPlacaDoCarro: TPlacaDeCarro;
      FData: TDateTime;
      FVerificada: Boolean;
      FSenha: TSenha;
      constructor Create(pID: TUUID;
                         pNome: TNome;
                         pEmail: TEmail;
                         pCPF: TCPF;
                         pPassageiro: Boolean;
                         pMotorista: Boolean;
                         pPlacaDoCarro: TPlacaDeCarro;
                         pData: TDateTime;
                         pVerificada: Boolean;
                         pSenha: TSenha); reintroduce;
      function ObterCodigoDeVerificacao: String;
      function ObterCPF: String;
      function ObterEmail: String;
      function ObterID: String;
      function ObterNome: String;
      function ObterPlacaDoCarro: String;
      function ObterAlgoritimoDeHashDaSenha: TAlgoritimoHash;
      function ObterHashDaSenha: String;
   public
      class function CriarPassageiro(pNome, pEmail, pCPF, pSenha: String): TContaDeUsuario;
      class function CriarMotorista(pNome, pEmail, pCPF, pPlacaDoCarro, pSenha: String): TContaDeUsuario;
      class function Criar(pNome: String;
                           pEmail: String;
                           pCPF: String;
                           pPassageiro: Boolean;
                           pMotorista: Boolean;
                           pPlacaDoCarro: String;
                           pSenha: String): TContaDeUsuario;
      class function Restaurar(pID: String;
                               pNome: String;
                               pEmail: String;
                               pCPF: String;
                               pPassageiro: Boolean;
                               pMotorista: Boolean;
                               pPlacaDoCarro: String;
                               pData: TDateTime;
                               pVerificada: Boolean;
                               pCodigoDeVerificacao: String;
                               pHashDaSenha: String;
                               pAlgoritimoHash: TAlgoritimoHash): TContaDeUsuario;
      destructor Destroy; override;
      procedure ValidarSenha(pSenha: String);
      property ID: String read ObterID;
      property Nome: String read ObterNome;
      property CPF: String read ObterCPF;
      property Email: String read ObterEmail;
      property Passageiro: Boolean read FPassageiro;
      property Motorista: Boolean read FMotorista;
      property PlacaDoCarro: String read ObterPlacaDoCarro;
      property Data: TDateTime read FData;
      property Verificada: Boolean read FVerificada;
      property CodigoDeVerificacao: String read ObterCodigoDeVerificacao;
      property HashDaSenha: String read ObterHashDaSenha;
      property AlgoritimoDeHashDaSenha: TAlgoritimoHash read ObterAlgoritimoDeHashDaSenha;
   end;

implementation

{ TContaDeUsuario }

class function TContaDeUsuario.Criar(pNome, pEmail, pCPF: String; pPassageiro, pMotorista: Boolean; pPlacaDoCarro, pSenha: String): TContaDeUsuario;
var
   lPlacaDoCarro : TPlacaDeCarro;
begin
   lPlacaDoCarro := nil;
   if (not pMotorista) and (not pPlacaDoCarro.IsEmpty) then
      raise EContaDeUsuarioPlacaDoCarroInformada.Create('Informada placa do carro, mas a conta de usuário não pertence a um motorista!');
   if pMotorista then
      lPlacaDoCarro := TPlacaDeCarro.Create(pPlacaDoCarro);
   Result := TContaDeUsuario.Create(TUUID.Create(TUUID.Gerar),
                                    TNome.Create(pNome),
                                    TEmail.Create(pEmail),
                                    TCPF.Create(pCPF),
                                    pPassageiro,
                                    pMotorista,
                                    lPlacaDoCarro,
                                    Now,
                                    False,
                                    TSenha.Criar(TUUID.Gerar, pSenha, TAlgoritimoHash.MD5));
end;

class function TContaDeUsuario.CriarMotorista(pNome, pEmail, pCPF, pPlacaDoCarro, pSenha: String): TContaDeUsuario;
begin
   Result := TContaDeUsuario.Criar(pNome, pEmail, pCPF, False, True, pPlacaDoCarro, pSenha);
end;

class function TContaDeUsuario.CriarPassageiro(pNome, pEmail, pCPF, pSenha: String): TContaDeUsuario;
begin
   Result := TContaDeUsuario.Criar(pNome, pEmail, pCPF, True, False, '', pSenha);
end;

class function TContaDeUsuario.Restaurar(pID, pNome, pEmail, pCPF: String;
  pPassageiro, pMotorista: Boolean; pPlacaDoCarro: String; pData: TDateTime;
  pVerificada: Boolean; pCodigoDeVerificacao, pHashDaSenha: String;
  pAlgoritimoHash: TAlgoritimoHash): TContaDeUsuario;
var
   lPlacaDoCarro : TPlacaDeCarro;
begin
   lPlacaDoCarro := nil;
   if not pPlacaDoCarro.IsEmpty then
      lPlacaDoCarro := TPlacaDeCarro.Create(pPlacaDoCarro);
   Result := TContaDeUsuario.Create(TUUID.Create(pID),
                                    TNome.Create(pNome),
                                    TEmail.Create(pEmail),
                                    TCPF.Create(pCPF),
                                    pPassageiro,
                                    pMotorista,
                                    lPlacaDoCarro,
                                    pData,
                                    pVerificada,
                                    TSenha.Restaurar(pCodigoDeVerificacao, pHashDaSenha, pAlgoritimoHash));
end;

procedure TContaDeUsuario.ValidarSenha(pSenha: String);
begin
   if not FSenha.Validar(pSenha) then
      raise EContaDeUsuarioSenhaInvalida.Create('Senha inválida!');
end;

constructor TContaDeUsuario.Create(pID: TUUID;
                                   pNome: TNome;
                                   pEmail: TEmail;
                                   pCPF: TCPF;
                                   pPassageiro: Boolean;
                                   pMotorista: Boolean;
                                   pPlacaDoCarro: TPlacaDeCarro;
                                   pData: TDateTime;
                                   pVerificada: Boolean;
                                   pSenha: TSenha);
begin
   FID                  := pID;
   FNome                := pNome;
   FEmail               := pEmail;
   FCPF                 := pCPF;
   FPassageiro          := pPassageiro;
   FMotorista           := pMotorista;
   FPlacaDoCarro        := pPlacaDoCarro;
   FData                := pData;
   FVerificada          := pVerificada;
   FSenha               := pSenha;
end;

destructor TContaDeUsuario.Destroy;
begin
   if Assigned(FEmail) then
      FEmail.Destroy;
   if Assigned(FCPF) then
      FCPF.Destroy;
   if Assigned(FNome) then
      FNome.Destroy;
   if Assigned(FID) then
      FID.Destroy;
   if Assigned(FPlacaDoCarro) then
      FPlacaDoCarro.Destroy;
   if Assigned(FSenha) then
      FSenha.Destroy;
   inherited;
end;

function TContaDeUsuario.ObterID: String;
begin
   Result := FID.Valor;
end;

function TContaDeUsuario.ObterNome: String;
begin
   Result := FNome.Valor;
end;

function TContaDeUsuario.ObterEmail: String;
begin
   Result := FEmail.Valor;
end;

function TContaDeUsuario.ObterCPF: String;
begin
   Result := FCPF.Valor;
end;

function TContaDeUsuario.ObterPlacaDoCarro: String;
begin
   Result := '';
   if Assigned(FPlacaDoCarro) then
      Result := FPlacaDoCarro.Valor;
end;

function TContaDeUsuario.ObterCodigoDeVerificacao: String;
begin
   Result := FSenha.Prefixo;
end;

function TContaDeUsuario.ObterHashDaSenha: String;
begin
   Result := FSenha.Valor;
end;

function TContaDeUsuario.ObterAlgoritimoDeHashDaSenha: TAlgoritimoHash;
begin
   Result := FSenha.Algoritimo;
end;

end.
