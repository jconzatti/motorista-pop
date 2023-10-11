unit Repositorio.Fabrica;

interface

uses
   ContaDeUsuario.Repositorio,
   Posicao.Repositorio,
   Corrida.Repositorio;

type
   TFabricaRepositorio = class abstract
   public
      function CriarRepositorioContaDeUsuario: TRepositorioContaDeUsuario; virtual; abstract;
      function CriarRepositorioCorrida: TRepositorioCorrida; virtual; abstract;
      function CriarRepositorioPosicao: TRepositorioPosicao; virtual; abstract;
   end;

implementation

end.
