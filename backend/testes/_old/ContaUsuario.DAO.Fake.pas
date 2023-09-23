unit ContaUsuario.DAO.Fake;

interface

uses
   System.SysUtils,
   System.Generics.Collections,
   ContaUsuario.DAO;

type
   TDAOContaUsuarioFake = class(TDAOContaUsuario)
   private
      class var FTabelaDeContasDeUsuarios: TDictionary<String, TDadoContaUsuario>;
   public
      constructor Create;
      procedure Salvar(pDadoContaUsuario: TDadoContaUsuario); override;
      function ObterPorEmail(pEmail: String): TDadoContaUsuario; override;
      function ObterPorID(pID: String): TDadoContaUsuario; override;
   end;

implementation

{ TDAOContaUsuarioFake }

constructor TDAOContaUsuarioFake.Create;
begin
   if not Assigned(FTabelaDeContasDeUsuarios) then
      FTabelaDeContasDeUsuarios := TDictionary<String, TDadoContaUsuario>.Create;
end;

procedure TDAOContaUsuarioFake.Salvar(pDadoContaUsuario: TDadoContaUsuario);
begin
   inherited;
   FTabelaDeContasDeUsuarios.AddOrSetValue(pDadoContaUsuario.ID, pDadoContaUsuario);

end;

function TDAOContaUsuarioFake.ObterPorEmail(pEmail: String): TDadoContaUsuario;
var
   lUsuario: TDadoContaUsuario;
begin
   for lUsuario in FTabelaDeContasDeUsuarios.Values.ToArray do
   begin
      if lUsuario.Email.Equals(pEmail) then
      begin
         Result := lUsuario;
         Break;
      end;
   end;
end;

function TDAOContaUsuarioFake.ObterPorID(pID: String): TDadoContaUsuario;
begin
   Result := FTabelaDeContasDeUsuarios.Items[pID];
end;

initialization

finalization
   if Assigned(TDAOContaUsuarioFake.FTabelaDeContasDeUsuarios) then
      TDAOContaUsuarioFake.FTabelaDeContasDeUsuarios.Destroy;
end.
