unit Corrida.Repositorio.Fake;

interface

uses
   System.SysUtils,
   System.Generics.Collections,
   Corrida,
   Corrida.Repositorio,
   Corrida.Status,
   UUID;

type
   TRepositorioCorridaFake = class(TRepositorioCorrida)
   private
      class var FTabelaDeCorridas: TObjectDictionary<String, TCorrida>;
      function ClonarCorrida(pCorrida: TCorrida):TCorrida;
   public
      procedure Salvar(pCorrida: TCorrida); override;
      procedure Atualizar(pCorrida: TCorrida); override;
      function ObterPorID(pID: TUUID): TCorrida; override;
      function ObterListaDeCorridasDoUsuario(pIDDoUsuario: TUUID; pConjuntoDeStatus: TConjuntoDeStatusCorrida): TListaDeCorridas; override;
      constructor Create;
   end;

implementation

{ TRepositorioCorridaFake }

constructor TRepositorioCorridaFake.Create;
begin
   if not Assigned(FTabelaDeCorridas) then
      FTabelaDeCorridas := TObjectDictionary<String, TCorrida>.Create;
end;

procedure TRepositorioCorridaFake.Salvar(pCorrida: TCorrida);
begin
   inherited;
   if FTabelaDeCorridas.ContainsKey(pCorrida.ID) then
      FTabelaDeCorridas.Remove(pCorrida.ID);
   FTabelaDeCorridas.Add(pCorrida.ID, ClonarCorrida(pCorrida));
end;

procedure TRepositorioCorridaFake.Atualizar(pCorrida: TCorrida);
begin
   inherited;
   Salvar(pCorrida);
end;

function TRepositorioCorridaFake.ObterPorID(pID: TUUID): TCorrida;
begin
   Result := nil;
   if FTabelaDeCorridas.ContainsKey(pID.Valor) then
      Result := ClonarCorrida(FTabelaDeCorridas.Items[pID.Valor]);

   if not Assigned(Result) then
      raise ECorridaNaoEncontrada.Create(Format('Corrida com ID %s não encontada!', [pID.Valor]));
end;

function TRepositorioCorridaFake.ObterListaDeCorridasDoUsuario(
  pIDDoUsuario: TUUID;
  pConjuntoDeStatus: TConjuntoDeStatusCorrida): TListaDeCorridas;
var
   lCorrida: TCorrida;
begin
   Result := TListaDeCorridas.Create;
   try
      for lCorrida in FTabelaDeCorridas.Values.ToArray do
      begin
         if  ((lCorrida.IDDoPassageiro.Equals(pIDDoUsuario.Valor))
         or   (lCorrida.IDDoMotorista.Equals(pIDDoUsuario.Valor)))
         and ((pConjuntoDeStatus = [])
         or   (lCorrida.Status in pConjuntoDeStatus)) then
            Result.Add(lCorrida);
      end;
      if Result.Count = 0 then
         raise ENehumaCorridaEncontrada.Create('Nenhuma corrida encontrada!');
   except
      Result.Destroy;
      raise;
   end;
end;

function TRepositorioCorridaFake.ClonarCorrida(pCorrida: TCorrida): TCorrida;
begin
   Result := TCorrida.Restaurar(pCorrida.ID,
                                pCorrida.IDDoPassageiro,
                                pCorrida.IDDoMotorista,
                                pCorrida.Status,
                                pCorrida.Tarifa,
                                pCorrida.Distancia,
                                pCorrida.De.Latitude,
                                pCorrida.De.Longitude,
                                pCorrida.Para.Latitude,
                                pCorrida.Para.Longitude,
                                pCorrida.Data)
end;

initialization

finalization
   if Assigned(TRepositorioCorridaFake.FTabelaDeCorridas) then
      TRepositorioCorridaFake.FTabelaDeCorridas.Destroy;

end.
