unit RealizarLogin;

interface

uses
   System.SysUtils,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   Repositorio.Fabrica,
   Token.Gerador,
   Email;

type
   ERealizarLoginAutenticacaoFalhada = class(EArgumentException);

   TDadoEntradaRealizacaoLogin = record
      Email: String;
      Senha: String;
   end;

   TDadoSaidaRealizacaoLogin = record
      Token: String;
   end;

   TRealizarLogin = class
   private
      FRepositorioContaDeUsuario: TRepositorioContaDeUsuario;
   public
      constructor Create(pFabricaRepositorio: TFabricaRepositorio); reintroduce;
      destructor Destroy; override;
      function Executar(pEntradaRealizacaoLogin: TDadoEntradaRealizacaoLogin): TDadoSaidaRealizacaoLogin;
   end;

implementation

{ TRealizarLogin }

constructor TRealizarLogin.Create(pFabricaRepositorio: TFabricaRepositorio);
begin
   FRepositorioContaDeUsuario := pFabricaRepositorio.CriarRepositorioContaDeUsuario;
end;

destructor TRealizarLogin.Destroy;
begin
   FRepositorioContaDeUsuario.Destroy;
   inherited;
end;

function TRealizarLogin.Executar(pEntradaRealizacaoLogin: TDadoEntradaRealizacaoLogin): TDadoSaidaRealizacaoLogin;
var
   lEmail: TEmail;
   lContaDeUsuario: TContaDeUsuario;
begin
   lEmail := TEmail.Create(pEntradaRealizacaoLogin.Email);
   try
      try
         lContaDeUsuario := FRepositorioContaDeUsuario.ObterPorEmail(lEmail);
         try
            lContaDeUsuario.ValidarSenha(pEntradaRealizacaoLogin.Senha);
            Result.Token := TGeradorToken.Gerar(lContaDeUsuario);
         finally
            lContaDeUsuario.Destroy;
         end;
      except
         on E: Exception do
            raise ERealizarLoginAutenticacaoFalhada.Create('Autenticação falhada: ' + E.Message);
      end;
   finally
      lEmail.Destroy;
   end;
end;

end.
