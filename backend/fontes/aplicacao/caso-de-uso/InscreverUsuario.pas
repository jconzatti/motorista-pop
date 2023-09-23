unit InscreverUsuario;

interface

uses
   System.SysUtils,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   Email.Enviador.Gateway,
   Email;

type
   EContaDeUsuarioJaExiste = class(EArgumentException);

   TDadoEntradaInscricaoContaDeUsuario = record
      Nome: String;
      Email: String;
      CPF: String;
      Passageiro: Boolean;
      Motorista: Boolean;
      PlacaDoCarro: String;
   end;

   TInscreverUsuario = class
   private
      FGatewayEnviadorEmail: TGatewayEnviadorEmail;
      RepositorioContaDeUsuario: TRepositorioContaDeUsuario;
      procedure ValidarContaDeUsuarioJaExistenteParaOEMailInformado(pEmail: String);
   public
      constructor Create(pRepositorioContaUsuario: TRepositorioContaDEUsuario); reintroduce;
      destructor Destroy; override;
      function Executar(pEntrada: TDadoEntradaInscricaoContaDeUsuario): String;
   end;

implementation

{ TInscreverUsuario }

constructor TInscreverUsuario.Create(pRepositorioContaUsuario: TRepositorioContaDEUsuario);
begin
   RepositorioContaDeUsuario := pRepositorioContaUsuario;
   FGatewayEnviadorEmail := TGatewayEnviadorEmail.Create;
end;

destructor TInscreverUsuario.Destroy;
begin
   FGatewayEnviadorEmail.Destroy;
   inherited;
end;

function TInscreverUsuario.Executar(pEntrada: TDadoEntradaInscricaoContaDeUsuario): String;
var lContaDeUsuario : TContaDeUsuario;
begin
   ValidarContaDeUsuarioJaExistenteParaOEMailInformado(pEntrada.Email);
   lContaDeUsuario := TContaDeUsuario.Criar(pEntrada.Nome,
                                            pEntrada.Email,
                                            pEntrada.CPF,
                                            pEntrada.Passageiro,
                                            pEntrada.Motorista,
                                            pEntrada.PlacaDoCarro);
   try
      RepositorioContaDeUsuario.Salvar(lContaDeUsuario);
      FGatewayEnviadorEmail.Enviar(lContaDeUsuario.Email,
                                   'Verificação de Conta',
                                   Format('Por favor, verifique seu código no primeiro acesso %s', [lContaDeUsuario.CodigoDeVerificacao]));
      Result := lContaDeUsuario.ID;
   finally
      lContaDeUsuario.Destroy;
   end;
end;

procedure TInscreverUsuario.ValidarContaDeUsuarioJaExistenteParaOEMailInformado(
  pEmail: String);
var lContaDeUsuario : TContaDeUsuario;
    lEmail: TEmail;
begin
   lEmail := TEmail.Create(pEmail);
   try
      try
         lContaDeUsuario := RepositorioContaDeUsuario.ObterPorEmail(lEmail);
         try
            raise EContaDeUsuarioJaExiste.Create(Format('Já existe conta de usuário criada para o e-mail informado! ID: %s, e-mail: %s!',
                                                        [lContaDeUsuario.ID, lEmail.Valor]));
         finally
            lContaDeUsuario.Destroy;
         end;
      except
         on E: Exception do
         begin
            if not (E is EContaDeUsuarioNaoEncontrada) then
               raise;
         end;
      end;
   finally
      lEmail.Destroy;
   end;
end;

end.
