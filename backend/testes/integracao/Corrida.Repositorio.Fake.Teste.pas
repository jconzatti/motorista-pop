unit Corrida.Repositorio.Fake.Teste;

interface

uses
   Corrida.Repositorio.Fake,
   Corrida.Repositorio.Teste,
   DUnitX.TestFramework;

type
   [TestFixture]
   TRepositorioCorridaFakeTeste = class(TRepositorioCorridaTeste)
   public
      [Setup]
      procedure Inicializar; override;
      [TearDown]
      procedure Finalizar; override;
   end;

implementation


{ TRepositorioCorridaFakeTeste }

procedure TRepositorioCorridaFakeTeste.Inicializar;
begin
   FRepositorioCorrida := TRepositorioCorridaFake.Create;
end;

procedure TRepositorioCorridaFakeTeste.Finalizar;
begin
   FRepositorioCorrida.Destroy;
end;

initialization
   TDUnitX.RegisterTestFixture(TRepositorioCorridaFakeTeste);
end.
