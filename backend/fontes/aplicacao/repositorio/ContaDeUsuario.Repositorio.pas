unit ContaDeUsuario.Repositorio;

interface

uses
   System.Classes,
   ContaDeUsuario,
   Email,
   UUID;

type
   ERepositorioContaDeUsuarioNaoEncontrada = class(EResNotFound);

   TRepositorioContaDeUsuario = class abstract
   public
      procedure Salvar(pContaDeUsuario: TContaDeUsuario); virtual; abstract;
      function ObterPorEmail(pEmail: TEmail): TContaDeUsuario; virtual; abstract;
      function ObterPorID(pID: TUUID): TContaDeUsuario; virtual; abstract;
   end;

implementation

end.
