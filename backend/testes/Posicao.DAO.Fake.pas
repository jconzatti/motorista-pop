unit Posicao.DAO.Fake;

interface

uses
   System.SysUtils,
   System.Generics.Collections,
   System.Generics.Defaults,
   Posicao.DAO;

type
   TDAOPosicaoFake = class(TDAOPosicao)
   private
      class var FTabelaDePosicoes: TDictionary<String, TDadoPosicao>;
   public
      constructor Create;
      procedure Salvar(pDadoPosicao: TDadoPosicao); override;
      function ObterListaDePosicoesDaCorrida(pIDDaCorrida: String): TListaDePosicoes; override;
   end;

implementation

{ TDAOPosicaoFake }

constructor TDAOPosicaoFake.Create;
begin
   if not Assigned(FTabelaDePosicoes) then
      FTabelaDePosicoes := TDictionary<string,TDadoPosicao>.Create;
end;

procedure TDAOPosicaoFake.Salvar(pDadoPosicao: TDadoPosicao);
begin
   inherited;
   FTabelaDePosicoes.AddOrSetValue(pDadoPosicao.ID, pDadoPosicao);
end;

function TDAOPosicaoFake.ObterListaDePosicoesDaCorrida(pIDDaCorrida: String): TListaDePosicoes;
var
   lPosicao: TDadoPosicao;
   lPosicoes: TArray<TDadoPosicao>;
begin
   Result := TListaDePosicoes.Create;
   try
      lPosicoes := FTabelaDePosicoes.Values.ToArray;

      TArray.Sort<TDadoPosicao>(
         lPosicoes,
         TComparer<TDadoPosicao>.Construct(
            function(const pPosicao1, pPosicao2: TDadoPosicao): Integer
            begin
               Result := TComparer<TDateTime>.Default.Compare(pPosicao1.Data, pPosicao2.Data);
            end
         )
      );

      for lPosicao in lPosicoes do
      begin
         if lPosicao.IDDaCorrida.Equals(pIDDaCorrida) then
            Result.Add(lPosicao);
      end;
   except
      Result.Destroy;
      raise;
   end;
end;

initialization

finalization
   if Assigned(TDAOPosicaoFake.FTabelaDePosicoes) then
      TDAOPosicaoFake.FTabelaDePosicoes.Destroy;

end.
