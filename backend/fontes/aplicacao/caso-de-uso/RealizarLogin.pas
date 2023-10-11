unit RealizarLogin;

interface

uses
   System.SysUtils,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   Repositorio.Fabrica,
   Email;

type
   TDadoSaidaRealizacaoLogin = record
      IDDoUsuario: String;
   end;

   TRealizarLogin = class
   private
      FRepositorioContaDeUsuario: TRepositorioContaDeUsuario;
   public
      constructor Create(pFabricaRepositorio: TFabricaRepositorio); reintroduce;
      destructor Destroy; override;
      function Executar(pEmail: string): TDadoSaidaRealizacaoLogin;
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

function TRealizarLogin.Executar(pEmail: string): TDadoSaidaRealizacaoLogin;
var
   lEmail: TEmail;
   lContaDeUsuario: TContaDeUsuario;
begin
   lEmail := TEmail.Create(pEmail);
   try
      lContaDeUsuario := FRepositorioContaDeUsuario.ObterPorEmail(lEmail);
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
