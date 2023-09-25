unit RealizarLogin;

interface

uses
   System.SysUtils,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   Email;

type
   TDadoSaidaRealizacaoLogin = record
      IDDoUsuario: String;
   end;

   TRealizarLogin = class
   private
      RepositorioContaDeUsuario: TRepositorioContaDeUsuario;
   public
      constructor Create(pRepositorioContaUsuario: TRepositorioContaDeUsuario); reintroduce;
      function Executar(pEmail: string): TDadoSaidaRealizacaoLogin;
   end;

implementation

{ TRealizarLogin }

constructor TRealizarLogin.Create(pRepositorioContaUsuario: TRepositorioContaDeUsuario);
begin
   RepositorioContaDeUsuario := pRepositorioContaUsuario;
end;

function TRealizarLogin.Executar(pEmail: string): TDadoSaidaRealizacaoLogin;
var
   lEmail: TEmail;
   lContaDeUsuario: TContaDeUsuario;
begin
   lEmail := TEmail.Create(pEmail);
   try
      lContaDeUsuario := RepositorioContaDeUsuario.ObterPorEmail(lEmail);
      try
         Result.IDDoUsuario := lContaDeUsuario.ID;
      finally
         lContaDeUsuario.Destroy;
      end;
   finally
      lEmail.Destroy;
   end;
end;

end.
