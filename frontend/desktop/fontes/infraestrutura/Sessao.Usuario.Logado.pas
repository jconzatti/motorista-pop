unit Sessao.Usuario.Logado;

interface

type
   TSessaoUsuarioLogado = class
   private
      class var FID: String;
   public
      class procedure Registrar(pID: String);
      class function ID: String;
   end;

implementation

{ TSessaoUsuarioLogado }

class function TSessaoUsuarioLogado.ID: String;
begin
   Result := FID;
end;

class procedure TSessaoUsuarioLogado.Registrar(pID: String);
begin
   FID := pID;
end;

end.
