unit Corrida.Repositorio.BancoDeDado.Conexao.FireDAC.Teste;

interface

uses
   BancoDeDado.Conexao,
   BancoDeDado.Conexao.FireDAC,
   Corrida.Repositorio.BancoDeDado,
   Corrida.Repositorio.Teste,
   DUnitX.TestFramework;

type
   [TestFixture]
   TRepositorioCorridaBancoDeDadoConexaoFireDACTeste = class(TRepositorioCorridaTeste)
   private
      FConexaoBancoDeDado: TConexaoBancoDeDado;
   public
      [Setup]
      procedure Inicializar; override;
      [TearDown]
      procedure Finalizar; override;
   end;

implementation


{ TRepositorioCorridaBancoDeDadoConexaoFireDACTeste }

procedure TRepositorioCorridaBancoDeDadoConexaoFireDACTeste.Inicializar;
begin
   inherited;
   FConexaoBancoDeDado := TConexaoBancoDeDadoFireDAC.Create;
   FRepositorioCorrida := TRepositorioCorridaBancoDeDado.Create(FConexaoBancoDeDado);
end;

procedure TRepositorioCorridaBancoDeDadoConexaoFireDACTeste.Finalizar;
begin
   inherited;
   FRepositorioCorrida.Destroy;
   FConexaoBancoDeDado.Destroy;
end;

initialization
   TDUnitX.RegisterTestFixture(TRepositorioCorridaBancoDeDadoConexaoFireDACTeste);
end.
