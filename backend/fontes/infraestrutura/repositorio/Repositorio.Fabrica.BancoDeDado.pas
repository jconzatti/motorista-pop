unit Repositorio.Fabrica.BancoDeDado;

interface

uses
   Repositorio.Fabrica,
   BancoDeDado.Conexao,
   ContaDeUsuario.Repositorio,
   Posicao.Repositorio,
   Corrida.Repositorio,
   ContaDeUsuario.Repositorio.BancoDeDado,
   Posicao.Repositorio.BancoDeDado,
   Corrida.Repositorio.BancoDeDado;

type
   TFabricaRepositorioBancoDeDado = class(TFabricaRepositorio)
   private
      FConexaoBancoDeDado: TConexaoBancoDeDado;
   public
      constructor Create(pConexaoBancoDeDado: TConexaoBancoDeDado); reintroduce;
      function CriarRepositorioContaDeUsuario: TRepositorioContaDeUsuario; override;
      function CriarRepositorioCorrida: TRepositorioCorrida; override;
      function CriarRepositorioPosicao: TRepositorioPosicao; override;
   end;

implementation

{ TFabricaRepositorioBancoDeDado }

constructor TFabricaRepositorioBancoDeDado.Create(pConexaoBancoDeDado: TConexaoBancoDeDado);
begin
   FConexaoBancoDeDado := pConexaoBancoDeDado;
end;

function TFabricaRepositorioBancoDeDado.CriarRepositorioContaDeUsuario: TRepositorioContaDeUsuario;
begin
   Result := TRepositorioContaDeUsuarioBancoDeDado.Create(FConexaoBancoDeDado);
end;

function TFabricaRepositorioBancoDeDado.CriarRepositorioCorrida: TRepositorioCorrida;
begin
   Result := TRepositorioCorridaBancoDeDado.Create(FConexaoBancoDeDado);
end;

function TFabricaRepositorioBancoDeDado.CriarRepositorioPosicao: TRepositorioPosicao;
begin
   Result := TRepositorioPosicaoBancoDeDado.Create(FConexaoBancoDeDado);
end;

end.
