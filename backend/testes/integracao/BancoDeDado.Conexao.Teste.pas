unit BancoDeDado.Conexao.Teste;

interface

uses
   BancoDeDado.Conexao.Firedac,
   DUnitX.TestFramework;

type
   [TestFixture]
   TConexaoBancoDeDadoFiredacTeste = class
   public
      [Test]
      procedure DeveExecutarComandoSQL;
      [Test]
      procedure NaoPodeExecutarComandoSQLInvalido;
      [Test]
      procedure DeveExecutarComandoSQLSemErro;
   end;

implementation

{ TConexaoBancoDeDadoFiredacTeste }

procedure TConexaoBancoDeDadoFiredacTeste.DeveExecutarComandoSQLSemErro;
var lConexaoBancoDeDado: TConexaoBancoDeDadoFiredac;
begin
   lConexaoBancoDeDado := TConexaoBancoDeDadoFiredac.Create;
   try
      lConexaoBancoDeDado.Executar('select * from ride');
   finally
      lConexaoBancoDeDado.Destroy;
   end;
end;

procedure TConexaoBancoDeDadoFiredacTeste.DeveExecutarComandoSQL;
var lConexaoBancoDeDado: TConexaoBancoDeDadoFiredac;
begin
   lConexaoBancoDeDado := TConexaoBancoDeDadoFiredac.Create;
   try
      Assert.IsTrue(lConexaoBancoDeDado.TentaExecutar('select * from ride'));
   finally
      lConexaoBancoDeDado.Destroy;
   end;
end;

procedure TConexaoBancoDeDadoFiredacTeste.NaoPodeExecutarComandoSQLInvalido;
var lConexaoBancoDeDado: TConexaoBancoDeDadoFiredac;
begin
   lConexaoBancoDeDado := TConexaoBancoDeDadoFiredac.Create;
   try
      Assert.IsFalse(lConexaoBancoDeDado.TentaExecutar('eureka'));
   finally
      lConexaoBancoDeDado.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TConexaoBancoDeDadoFiredacTeste);

end.
