unit Usuario.Teste;

interface

uses
   DUnitX.TestFramework;

type
   [TestFixture]
   TUsuarioTeste = class(TObject)
   public
      [Test]
      procedure DeveRealizarLogin;
   end;

implementation


{ TUsuarioTeste }

procedure TUsuarioTeste.DeveRealizarLogin;
var lUsuario: TUsuario;
begin
   lUsuario := TUsuario.Logar();
end;

initialization
   TDUnitX.RegisterTestFixture(TUsuarioTeste);
end.
