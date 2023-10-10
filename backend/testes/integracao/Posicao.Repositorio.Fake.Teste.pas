unit Posicao.Repositorio.Fake.Teste;

interface

uses
   Posicao.Repositorio.Teste,
   Posicao.Repositorio.Fake,
   DUnitX.TestFramework;

type
   [TestFixture]
   TRepositorioPosicaoFakeTeste = class(TRepositorioPosicaoTeste)
   public
      [Setup]
      procedure Inicializar; override;
      [TearDown]
      procedure Finalizar; override;
   end;

implementation


{ TRepositorioPosicaoFakeTeste }

procedure TRepositorioPosicaoFakeTeste.Inicializar;
begin
   inherited;
   FRepositorioPosicao := TRepositorioPosicaoFake.Create;
end;

procedure TRepositorioPosicaoFakeTeste.Finalizar;
begin
   inherited;
   FRepositorioPosicao.Destroy;
end;

initialization
   TDUnitX.RegisterTestFixture(TRepositorioPosicaoFakeTeste);
end.
