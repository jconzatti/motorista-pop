unit ContaDeUsuario.Repositorio.Fake.Teste;

interface

uses
   ContaDeUsuario.Repositorio.Teste,
   ContaDeUsuario.Repositorio.Fake,
   DUnitX.TestFramework;

type
   [TestFixture]
   TRepositorioContaDeUsuarioFakeTeste = class(TRepositorioContaDeUsuarioTeste)
   public
      [Setup]
      procedure Inicializar; override;
      [TearDown]
      procedure Finalizar; override;
   end;

implementation

{ TRepositorioContaDeUsuarioFakeTeste }

procedure TRepositorioContaDeUsuarioFakeTeste.Inicializar;
begin
   FRepositorioContaDeUsuario := TRepositorioContaDeUsuarioFake.Create;
end;

procedure TRepositorioContaDeUsuarioFakeTeste.Finalizar;
begin
   FRepositorioContaDeUsuario.Destroy;
end;

initialization
   TDUnitX.RegisterTestFixture(TRepositorioContaDeUsuarioFakeTeste);

end.
