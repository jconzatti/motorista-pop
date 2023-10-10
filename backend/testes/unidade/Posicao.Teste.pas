unit Posicao.Teste;

interface

uses
   System.SysUtils,
   System.DateUtils,
   Posicao,
   DUnitX.TestFramework;

type
   [TestFixture]
   TPosicaoTeste = class
   public
      [Test]
      procedure DeveCriarUmaPosicao;
      [Test]
      procedure DeveRestaurarUmaPosicao;
   end;

implementation


{ TPosicaoTeste }

procedure TPosicaoTeste.DeveCriarUmaPosicao;
var lPosicao: TPosicao;
begin
   lPosicao := TPosicao.Criar('3da32233e4d0404687de6d96d345410e', 0, 10, Now);
   try
      Assert.IsNotEmpty(lPosicao.ID);
      Assert.AreEqual('3da32233e4d0404687de6d96d345410e', lPosicao.IDDaCorrida);
      Assert.AreEqual<Double>(0, lPosicao.Coordenada.Latitude);
      Assert.AreEqual<Double>(10, lPosicao.Coordenada.Longitude);
      Assert.AreEqual<TDate>(Date, DateOf(lPosicao.Data));
   finally
      lPosicao.Destroy;
   end;
end;

procedure TPosicaoTeste.DeveRestaurarUmaPosicao;
var lPosicao: TPosicao;
begin
   lPosicao := TPosicao.Restaurar('3da32233e4d0404687de6d96d345410a', '3da32233e4d0404687de6d96d345410e', 0, 10, Now);
   try
      Assert.AreEqual('3da32233e4d0404687de6d96d345410a', lPosicao.ID);
      Assert.AreEqual('3da32233e4d0404687de6d96d345410e', lPosicao.IDDaCorrida);
      Assert.AreEqual<Double>(0, lPosicao.Coordenada.Latitude);
      Assert.AreEqual<Double>(10, lPosicao.Coordenada.Longitude);
      Assert.AreEqual<TDate>(Date, DateOf(lPosicao.Data));
   finally
      lPosicao.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TPosicaoTeste);
end.
