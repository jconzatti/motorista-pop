unit ContaDeUsuario;

interface

uses
   System.SysUtils,
   UUID,
   Nome,
   CPF,
   Email,
   PlacaDeCarro;

type
   EPlacaDoCarroInformada = class(EArgumentException);

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
      FCodigoDeVerificacao: TUUID;
      constructor Create(pID: String;
                         pNome: String;
                         pEmail: String;
                         pCPF: String;
                         pPassageiro: Boolean;
                         pMotorista: Boolean;
                         pPlacaDoCarro: String;
                         pData: TDateTime;
                         pVerificada: Boolean;
                         pCodigoDeVerificacao: String); reintroduce;
    function ObterCodigoDeVerificacao: String;
    function ObterCPF: String;
    function ObterEmail: String;
    function ObterID: String;
    function ObterNome: String;
    function ObterPlacaDoCarro: String;
   public
      class function CriarPassageiro(pNome, pEmail, pCPF: String): TContaDeUsuario;
      class function CriarMotorista(pNome, pEmail, pCPF, pPlacaDoCarro: String): TContaDeUsuario;
      class function Criar(pNome: String;
                           pEmail: String;
                           pCPF: String;
                           pPassageiro: Boolean;
                           pMotorista: Boolean;
                           pPlacaDoCarro: String): TContaDeUsuario;
      class function Restaurar(pID: String;
                               pNome: String;
                               pEmail: String;
                               pCPF: String;
                               pPassageiro: Boolean;
                               pMotorista: Boolean;
                               pPlacaDoCarro: String;
                               pData: TDateTime;
                               pVerificada: Boolean;
                               pCodigoDeVerificacao: String): TContaDeUsuario;
      destructor Destroy; override;
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
   end;

implementation

{ TContaDeUsuario }

constructor TContaDeUsuario.Create(pID, pNome, pEmail, pCPF: String;
  pPassageiro, pMotorista: Boolean; pPlacaDoCarro: String; pData: TDateTime;
  pVerificada: Boolean; pCodigoDeVerificacao: String);
begin
   FPassageiro   := pPassageiro;
   FMotorista    := pMotorista;
   FData         := pData;
   FVerificada   := pVerificada;

   FPlacaDoCarro := nil;
   if FMotorista then
      FPlacaDoCarro := TPlacaDeCarro.Create(pPlacaDoCarro);

   if not FMotorista then
      if not pPlacaDoCarro.IsEmpty then
         raise EPlacaDoCarroInformada.Create('Informada placa do carro, mas a conta de usuário não pertence a um motorista!');

   FID                  := TUUID.Create(pID);
   FNome                := TNome.Create(pNome);
   FCPF                 := TCPF.Create(pCPF);
   FEmail               := TEmail.Create(pEmail);
   FCodigoDeVerificacao := TUUID.Create(pCodigoDeVerificacao);
end;

destructor TContaDeUsuario.Destroy;
begin
   if Assigned(FCodigoDeVerificacao) then
      FCodigoDeVerificacao.Destroy;
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
   inherited;
end;

class function TContaDeUsuario.Criar(pNome, pEmail, pCPF: String; pPassageiro,
  pMotorista: Boolean; pPlacaDoCarro: String): TContaDeUsuario;
begin
   Result := TContaDeUsuario.Create(TUUID.Gerar, pNome, pEmail, pCPF, pPassageiro, pMotorista, pPlacaDoCarro, Now, False, TUUID.Gerar);
end;

class function TContaDeUsuario.CriarMotorista(pNome, pEmail, pCPF,
  pPlacaDoCarro: String): TContaDeUsuario;
begin
   Result := TContaDeUsuario.Create(TUUID.Gerar, pNome, pEmail, pCPF, False, True, pPlacaDoCarro, Now, False, TUUID.Gerar);
end;

class function TContaDeUsuario.CriarPassageiro(pNome, pEmail,
  pCPF: String): TContaDeUsuario;
begin
   Result := TContaDeUsuario.Create(TUUID.Gerar, pNome, pEmail, pCPF, True, False, '', Now, False, TUUID.Gerar);
end;

class function TContaDeUsuario.Restaurar(pID, pNome, pEmail, pCPF: String;
  pPassageiro, pMotorista: Boolean; pPlacaDoCarro: String; pData: TDateTime;
  pVerificada: Boolean; pCodigoDeVerificacao: String): TContaDeUsuario;
begin
   Result := TContaDeUsuario.Create(pID, pNome, pEmail, pCPF, pPassageiro, pMotorista, pPlacaDoCarro, pData, pVerificada, pCodigoDeVerificacao);
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
   Result := FCodigoDeVerificacao.Valor;
end;

end.
