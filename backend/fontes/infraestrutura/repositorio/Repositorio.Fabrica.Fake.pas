unit Repositorio.Fabrica.Fake;

interface

uses
   Repositorio.Fabrica,
   ContaDeUsuario.Repositorio,
   Posicao.Repositorio,
   Corrida.Repositorio,
   ContaDeUsuario.Repositorio.Fake,
   Posicao.Repositorio.Fake,
   Corrida.Repositorio.Fake;

type
   TFabricaRepositorioFake = class(TFabricaRepositorio)
   public
      function CriarRepositorioContaDeUsuario: TRepositorioContaDeUsuario; override;
      function CriarRepositorioCorrida: TRepositorioCorrida; override;
      function CriarRepositorioPosicao: TRepositorioPosicao; override;
   end;

implementation

{ TFabricaRepositorioFake }

function TFabricaRepositorioFake.CriarRepositorioContaDeUsuario: TRepositorioContaDeUsuario;
begin
   Result := TRepositorioContaDeUsuarioFake.Create;
end;

function TFabricaRepositorioFake.CriarRepositorioCorrida: TRepositorioCorrida;
begin
   Result := TRepositorioCorridaFake.Create;
end;

function TFabricaRepositorioFake.CriarRepositorioPosicao: TRepositorioPosicao;
begin
   Result := TRepositorioPosicaoFake.Create;
end;

end.
