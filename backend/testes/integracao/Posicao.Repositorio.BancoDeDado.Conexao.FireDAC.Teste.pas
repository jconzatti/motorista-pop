unit Posicao.Repositorio.BancoDeDado.Conexao.FireDAC.Teste;

interface

uses
   Posicao.Repositorio.Teste,
   BancoDeDado.Conexao,
   BancoDeDado.Conexao.FireDAC,
   Posicao.Repositorio.BancoDeDado,
   DUnitX.TestFramework;

type
   [TestFixture]
   TRepositorioPosicaoBancoDadoFireDACTeste = class(TRepositorioPosicaoTeste)
   private
      FConexaoBancoDeDado: TConexaoBancoDeDado;
   public
      [Setup]
      procedure Inicializar; override;
      [TearDown]
      procedure Finalizar; override;
   end;

implementation


{ TRepositorioPosicaoBancoDadoFireDACTeste }

procedure TRepositorioPosicaoBancoDadoFireDACTeste.Inicializar;
begin
   inherited;
   FConexaoBancoDeDado := TConexaoBancoDeDadoFireDAC.Create;
   FRepositorioPosicao := TRepositorioPosicaoBancoDeDado.Create(FConexaoBancoDeDado);
end;

procedure TRepositorioPosicaoBancoDadoFireDACTeste.Finalizar;
begin
   inherited;
   FRepositorioPosicao.Destroy;
   FConexaoBancoDeDado.Destroy;
end;

initialization
  TDUnitX.RegisterTestFixture(TRepositorioPosicaoBancoDadoFireDACTeste);
end.
