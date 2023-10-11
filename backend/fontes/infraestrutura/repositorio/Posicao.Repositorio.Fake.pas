unit Posicao.Repositorio.Fake;

interface

uses
   System.SysUtils,
   System.Generics.Collections,
   System.Generics.Defaults,
   Posicao,
   Posicao.Repositorio,
   UUID;

type
   TRepositorioPosicaoFake = class(TRepositorioPosicao)
   private
      class var FTabelaDePosicoes: TObjectDictionary<String, TPosicao>;
      function ClonarPosicao(pPosicao: TPosicao):TPosicao;
   public
      procedure Salvar(pPosicao: TPosicao); override;
      function ObterListaDePosicoesDaCorrida(pIDDaCorrida: TUUID): TListaDePosicoes; override;
      constructor Create;
   end;

implementation

{ TRepositorioPosicaoFake }

constructor TRepositorioPosicaoFake.Create;
begin
   if not Assigned(FTabelaDePosicoes) then
      FTabelaDePosicoes := TObjectDictionary<String, TPosicao>.Create;
end;

procedure TRepositorioPosicaoFake.Salvar(pPosicao: TPosicao);
begin
   inherited;
   if FTabelaDePosicoes.ContainsKey(pPosicao.ID) then
      FTabelaDePosicoes.Remove(pPosicao.ID);
   FTabelaDePosicoes.Add(pPosicao.ID, ClonarPosicao(pPosicao));
end;

function TRepositorioPosicaoFake.ObterListaDePosicoesDaCorrida(pIDDaCorrida: TUUID): TListaDePosicoes;
var
   lPosicao: TPosicao;
   lPosicoes: TArray<TPosicao>;
begin
   Result := TListaDePosicoes.Create;
   try
      lPosicoes := FTabelaDePosicoes.Values.ToArray;

      TArray.Sort<TPosicao>(
         lPosicoes,
         TComparer<TPosicao>.Construct(
            function(const pPosicao1, pPosicao2: TPosicao): Integer
            begin
               Result := TComparer<TDateTime>.Default.Compare(pPosicao1.Data, pPosicao2.Data);
            end
         )
      );

      for lPosicao in lPosicoes do
      begin
         if lPosicao.IDDaCorrida.Equals(pIDDaCorrida.Valor) then
            Result.Add(ClonarPosicao(lPosicao));
      end;
      if Result.Count = 0 then
         raise ERepositorioPosicaoNaoEncontrada.Create(Format('Nenhuma posição da corrida (ID %s) encontrada!', [pIDDaCorrida.Valor]));
   except
      Result.Destroy;
      raise;
   end;
end;

function TRepositorioPosicaoFake.ClonarPosicao(pPosicao: TPosicao): TPosicao;
begin
   Result := TPosicao.Restaurar(pPosicao.ID,
                                pPosicao.IDDaCorrida,
                                pPosicao.Coordenada.Latitude,
                                pPosicao.Coordenada.Longitude,
                                pPosicao.Data);
end;

initialization

finalization
   if Assigned(TRepositorioPosicaoFake.FTabelaDePosicoes) then
      TRepositorioPosicaoFake.FTabelaDePosicoes.Destroy;

end.
