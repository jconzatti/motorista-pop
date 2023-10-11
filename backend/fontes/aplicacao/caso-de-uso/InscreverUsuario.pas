unit InscreverUsuario;

interface

uses
   System.SysUtils,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   Repositorio.Fabrica,
   Email.Enviador.Gateway,
   Email;

type
   EInscricaoContaDeUsuarioJaExiste = class(EArgumentException);

   TDadoEntradaInscricaoContaDeUsuario = record
      Nome: String;
      Email: String;
      CPF: String;
      Passageiro: Boolean;
      Motorista: Boolean;
      PlacaDoCarro: String;
   end;

   TDadoSaidaInscricaoContaDeUsuario = record
      IDDoUsuario: String;
   end;

   TInscreverUsuario = class
   private
      FGatewayEnviadorEmail: TGatewayEnviadorEmail;
      RepositorioContaDeUsuario: TRepositorioContaDeUsuario;
      procedure ValidarContaDeUsuarioJaExistenteParaOEMailInformado(pEmail: String);
   public
      constructor Create(pFabricaRepositorio: TFabricaRepositorio); reintroduce;
      destructor Destroy; override;
      function Executar(pEntrada: TDadoEntradaInscricaoContaDeUsuario): TDadoSaidaInscricaoContaDeUsuario;
   end;

implementation

{ TInscreverUsuario }

constructor TInscreverUsuario.Create(pFabricaRepositorio: TFabricaRepositorio);
begin
   RepositorioContaDeUsuario := pFabricaRepositorio.CriarRepositorioContaDeUsuario;
   FGatewayEnviadorEmail := TGatewayEnviadorEmail.Create;
end;

destructor TInscreverUsuario.Destroy;
begin
   FGatewayEnviadorEmail.Destroy;
   RepositorioContaDeUsuario.Destroy;
   inherited;
end;

function TInscreverUsuario.Executar(pEntrada: TDadoEntradaInscricaoContaDeUsuario): TDadoSaidaInscricaoContaDeUsuario;
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
                                   'Verifica��o de Conta',
                                   Format('Por favor, verifique seu c�digo no primeiro acesso %s', [lContaDeUsuario.CodigoDeVerificacao]));
      Result.IDDoUsuario := lContaDeUsuario.ID;
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
            raise EInscricaoContaDeUsuarioJaExiste.Create(Format('J� existe conta de usu�rio criada para o e-mail informado! ID: %s, e-mail: %s!',
                                                        [lContaDeUsuario.ID, lEmail.Valor]));
         finally
            lContaDeUsuario.Destroy;
         end;
      except
         on E: Exception do
         begin
            if not (E is ERepositorioContaDeUsuarioNaoEncontrada) then
               raise;
         end;
      end;
   finally
      lEmail.Destroy;
   end;
end;

end.
