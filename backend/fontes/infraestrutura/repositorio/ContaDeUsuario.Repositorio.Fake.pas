unit ContaDeUsuario.Repositorio.Fake;

interface

uses
   System.SysUtils,
   System.Generics.Collections,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   Email,
   UUID;

type
   TRepositorioContaDeUsuarioFake = class(TRepositorioContaDeUsuario)
   private
      class var FTabelaDeContasDeUsuarios: TObjectDictionary<String, TContaDeUsuario>;
      function ClonarContaDeUsuario(pContaDeUsuario: TContaDeUsuario):TContaDeUsuario;
   public
      procedure Salvar(pContaDeUsuario: TContaDeUsuario); override;
      function ObterPorEmail(pEmail: TEmail): TContaDeUsuario; override;
      function ObterPorID(pID: TUUID): TContaDeUsuario; override;
      constructor Create;
   end;

implementation

{ TRepositorioContaDeUsuarioFake }

constructor TRepositorioContaDeUsuarioFake.Create;
begin
   if not Assigned(FTabelaDeContasDeUsuarios) then
      FTabelaDeContasDeUsuarios := TObjectDictionary<String, TContaDeUsuario>.Create;
end;

procedure TRepositorioContaDeUsuarioFake.Salvar(pContaDeUsuario: TContaDeUsuario);
begin
   inherited;
   if FTabelaDeContasDeUsuarios.ContainsKey(pContaDeUsuario.ID) then
      FTabelaDeContasDeUsuarios.Remove(pContaDeUsuario.ID);
   FTabelaDeContasDeUsuarios.Add(pContaDeUsuario.ID, ClonarContaDeUsuario(pContaDeUsuario));
end;

function TRepositorioContaDeUsuarioFake.ObterPorEmail(pEmail: TEmail): TContaDeUsuario;
var
   lContaDeUsuario: TContaDeUsuario;
begin
   Result := nil;
   for lContaDeUsuario in FTabelaDeContasDeUsuarios.Values.ToArray do
   begin
      if lContaDeUsuario.Email.Equals(pEmail.Valor) then
      begin
         Result := ClonarContaDeUsuario(lContaDeUsuario);
         Break;
      end;
   end;

   if not Assigned(Result) then
      raise EContaDeUsuarioNaoEncontrada.Create(Format('Conta de usuário com email %s não encontada!', [pEmail.Valor]));
end;

function TRepositorioContaDeUsuarioFake.ObterPorID(pID: TUUID): TContaDeUsuario;
begin
   Result := nil;
   if FTabelaDeContasDeUsuarios.ContainsKey(pID.Valor) then
      Result := ClonarContaDeUsuario(FTabelaDeContasDeUsuarios.Items[pID.Valor]);

   if not Assigned(Result) then
      raise EContaDeUsuarioNaoEncontrada.Create(Format('Conta de usuário com ID %s não encontada!', [pID.Valor]));
end;

function TRepositorioContaDeUsuarioFake.ClonarContaDeUsuario(
  pContaDeUsuario: TContaDeUsuario): TContaDeUsuario;
begin
   Result := TContaDeUsuario.Restaurar(pContaDeUsuario.ID,
                                       pContaDeUsuario.Nome,
                                       pContaDeUsuario.Email,
                                       pContaDeUsuario.CPF,
                                       pContaDeUsuario.Passageiro,
                                       pContaDeUsuario.Motorista,
                                       pContaDeUsuario.PlacaDoCarro,
                                       pContaDeUsuario.Data,
                                       pContaDeUsuario.Verificada,
                                       pContaDeUsuario.CodigoDeVerificacao)
end;

initialization

finalization
   if Assigned(TRepositorioContaDeUsuarioFake.FTabelaDeContasDeUsuarios) then
      TRepositorioContaDeUsuarioFake.FTabelaDeContasDeUsuarios.Destroy;

end.
