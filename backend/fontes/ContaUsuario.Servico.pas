unit ContaUsuario.Servico;

interface

uses
   System.SysUtils,
   System.RegularExpressions,
   CPF.Validador,
   ContaUsuario.DAO,
   Email.Enviador.Gateway;

type

   TServicoContaUsuario = class
   private
      FValidadorCPF: TValidadorCPF;
      FDAOContaUsuario: TDAOContaUsuario;
      FGatewayEnviadorEmail: TGatewayEnviadorEmail;
   public
      constructor Create(pDAOContaUsuario: TDAOContaUsuario); reintroduce;
      destructor Destroy; override;
      function Inscrever(pEntradaDaContaDeUsuario: TDadoInscricaoContaUsuario): String;
      function Obter(pID: String): TDadoContaUsuario;
   end;

implementation

{ TServicoContaUsuario }

constructor TServicoContaUsuario.Create(pDAOContaUsuario: TDAOContaUsuario);
begin
   FDAOContaUsuario := pDAOContaUsuario;
   FValidadorCPF := TValidadorCPF.Create;
   FGatewayEnviadorEmail := TGatewayEnviadorEmail.Create;
end;

destructor TServicoContaUsuario.Destroy;
begin
   FGatewayEnviadorEmail.Destroy;
   FValidadorCPF.Destroy;
   inherited;
end;

function TServicoContaUsuario.Inscrever(pEntradaDaContaDeUsuario: TDadoInscricaoContaUsuario): String;
var lGUID: TGUID;
    lContaUsuario: TDadoContaUsuario;
begin
   lContaUsuario := FDAOContaUsuario.ObterPorEmail(pEntradaDaContaDeUsuario.Email);
   if not lContaUsuario.ID.IsEmpty then
      raise Exception.Create('Conta de usuário já existe!');
   if not TRegEx.IsMatch(pEntradaDaContaDeUsuario.Nome, '[a-zA-Z] [a-zA-Z]+') then
      raise EArgumentException.Create('Nome inválido!');
   if not TRegEx.IsMatch(pEntradaDaContaDeUsuario.Email, '^(.+)@(.+)$') then
      raise EArgumentException.Create('e-mail inválido!');
   if not FValidadorCPF.Validar(pEntradaDaContaDeUsuario.CPF) then
      raise EArgumentException.Create('CPF inválido!');
   if pEntradaDaContaDeUsuario.Motorista and (not TRegEx.IsMatch(pEntradaDaContaDeUsuario.PlacaDoCarro, '[A-Z]{3}[0-9]{4}')) then
      raise EArgumentException.Create('Placa do carro inválida!');
   CreateGUID(lGUID);
   lContaUsuario.ID := lGUID.ToString;
   lContaUsuario.Nome         := pEntradaDaContaDeUsuario.Nome;
   lContaUsuario.Email        := pEntradaDaContaDeUsuario.Email;
   lContaUsuario.CPF          := pEntradaDaContaDeUsuario.CPF;
   lContaUsuario.PlacaDoCarro := pEntradaDaContaDeUsuario.PlacaDoCarro;
   lContaUsuario.Passageiro   := pEntradaDaContaDeUsuario.Passageiro;
   lContaUsuario.Motorista    := pEntradaDaContaDeUsuario.Motorista;
   lContaUsuario.Data         := Now;
   lContaUsuario.Verificada   := False;
   CreateGUID(lGUID);
   lContaUsuario.CodigoDeVerificacao := lGUID.ToString;
   FDAOContaUsuario.Salvar(lContaUsuario);
   FGatewayEnviadorEmail.Enviar(pEntradaDaContaDeUsuario.Email,
                                'Verificação de Conta',
                                Format('Por favor, verifique seu código no primeiro acesso %s', [lContaUsuario.CodigoDeVerificacao]));
   Result := lContaUsuario.ID;
end;

function TServicoContaUsuario.Obter(pID: String): TDadoContaUsuario;
begin
   Result := FDAOContaUsuario.ObterPorID(pID);
end;

end.
