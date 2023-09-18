unit Email.Enviador.Gateway;

interface

uses
   System.SysUtils;

type
   TGatewayEnviadorEmail = class
   public
      procedure Enviar(pEmail, pAssunto, pMensagem: String);
   end;

implementation

{ TGatewayEnviadorEmail }

procedure TGatewayEnviadorEmail.Enviar(pEmail, pAssunto, pMensagem: String);
begin
   Writeln(Format('%s %s %s', [pEmail, pAssunto, pMensagem]));
end;

end.
