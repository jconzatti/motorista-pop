unit Corrida.DAO.Fake;

interface

uses
   System.SysUtils,
   System.Generics.Collections,
   Corrida.DAO;

type
   TDAOCorridaFake = class(TDAOCorrida)
   private
      class var FTabelaDeCorridas: TDictionary<String, TDadoCorrida>;
   public
      constructor Create;
      procedure Salvar(pDadoCorrida: TDadoCorrida); override;
      procedure Atualizar(pDadoCorrida: TDadoCorrida); override;
      function ObterPorID(pID: String): TDadoCorrida; override;
      function ObterListaDeCorridasAtivasPeloIDDoPassageiro(pIDDoPassageiro: String): TListaDeCorridas; override;
      function ObterListaDeCorridasAtivasPeloIDDoMotorista(pIDDoMotorista: String): TListaDeCorridas; override;
   end;

implementation

{ TDAOCorridaFake }

constructor TDAOCorridaFake.Create;
begin
   if not Assigned(FTabelaDeCorridas) then
      FTabelaDeCorridas := TDictionary<string,TDadoCorrida>.Create;
end;

procedure TDAOCorridaFake.Salvar(pDadoCorrida: TDadoCorrida);
begin
   inherited;
   FTabelaDeCorridas.AddOrSetValue(pDadoCorrida.ID, pDadoCorrida);
end;

procedure TDAOCorridaFake.Atualizar(pDadoCorrida: TDadoCorrida);
var lCorrida : TDadoCorrida;
begin
   inherited;
   if FTabelaDeCorridas.TryGetValue(pDadoCorrida.ID, lCorrida) then
   begin
      lCorrida.IDDoMotorista := pDadoCorrida.IDDoMotorista;
      lCorrida.Status        := pDadoCorrida.Status;
      lCorrida.Distancia     := pDadoCorrida.Distancia;
      lCorrida.Tarifa        := pDadoCorrida.Tarifa;
      FTabelaDeCorridas.AddOrSetValue(lCorrida.ID, lCorrida);
   end;
end;

function TDAOCorridaFake.ObterPorID(pID: String): TDadoCorrida;
begin
   Result := FTabelaDeCorridas.Items[pID];
end;

function TDAOCorridaFake.ObterListaDeCorridasAtivasPeloIDDoPassageiro(
  pIDDoPassageiro: String): TListaDeCorridas;
var
   lCorrida: TDadoCorrida;
begin
   Result := TListaDeCorridas.Create;
   try
      for lCorrida in FTabelaDeCorridas.Values.ToArray do
      begin
         if  (lCorrida.IDDoPassageiro.Equals(pIDDoPassageiro))
         and (not lCorrida.Status.Equals('completed')) then
            Result.Add(lCorrida);
      end;
   except
      Result.Destroy;
      raise;
   end;
end;

function TDAOCorridaFake.ObterListaDeCorridasAtivasPeloIDDoMotorista(
  pIDDoMotorista: String): TListaDeCorridas;
var
   lCorrida: TDadoCorrida;
begin
   Result := TListaDeCorridas.Create;
   try
      for lCorrida in FTabelaDeCorridas.Values.ToArray do
      begin
         if  (lCorrida.IDDoMotorista.Equals(pIDDoMotorista))
         and ((lCorrida.Status.Equals('accepted'))
          or  (lCorrida.Status.Equals('in_progress'))) then
            Result.Add(lCorrida);
      end;
   except
      Result.Destroy;
      raise;
   end;
end;

initialization

finalization
   if Assigned(TDAOCorridaFake.FTabelaDeCorridas) then
      TDAOCorridaFake.FTabelaDeCorridas.Destroy;

end.
