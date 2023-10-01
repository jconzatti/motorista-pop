unit ContaDeUsuario.Repositorio.BancoDeDado.Conexao.FireDAC.Teste;

interface

uses
   ContaDeUsuario.Repositorio.Teste,
   ContaDeUsuario.Repositorio.BancoDeDado,
   BancoDeDado.Conexao,
   BancoDeDado.Conexao.FireDAC,
   DUnitX.TestFramework;

type
   [TestFixture]
   TRepositorioContaDeUsuarioBancoDeDadoConexaoFireDACTeste = class(TRepositorioContaDeUsuarioTeste)
   private
      FConexaoBancoDeDado: TConexaoBancoDeDado;
   public
      [Setup]
      procedure Inicializar; override;
      [TearDown]
      procedure Finalizar; override;
   end;

implementation

{ TRepositorioContaDeUsuarioBancoDeDadoConexaoFireDACTeste }

procedure TRepositorioContaDeUsuarioBancoDeDadoConexaoFireDACTeste.Inicializar;
begin
   FConexaoBancoDeDado := TConexaoBancoDeDadoFireDAC.Create;
   FRepositorioContaDeUsuario := TRepositorioContaDeUsuarioBancoDeDado.Create(FConexaoBancoDeDado);
end;

procedure TRepositorioContaDeUsuarioBancoDeDadoConexaoFireDACTeste.Finalizar;
begin
   FRepositorioContaDeUsuario.Destroy;
   FConexaoBancoDeDado.Destroy;
end;

initialization
   TDUnitX.RegisterTestFixture(TRepositorioContaDeUsuarioBancoDeDadoConexaoFireDACTeste);
end.
