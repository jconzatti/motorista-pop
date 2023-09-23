unit Posicao.DAO.FireDAC;

interface

uses
   Data.DB,
   FireDAC.Comp.Client,
   FireDAC.DApt,
   FireDAC.Phys.SQLite,
   FireDAC.Stan.Async,
   FireDAC.Stan.Def,
   FireDAC.Stan.Intf,
   Posicao.DAO;

type
   TDAOPosicaoFireDAC = class(TDAOPosicao)
   private
      FConexao: TFDConnection;
   public
      constructor Create;
      destructor Destroy; override;
      procedure Salvar(pDadoPosicao: TDadoPosicao); override;
      function ObterListaDePosicoesDaCorrida(pIDDaCorrida: String): TListaDePosicoes; override;
   end;

implementation

{ TDAOPosicaoFireDAC }

constructor TDAOPosicaoFireDAC.Create;
begin
   FConexao := TFDConnection.Create(nil);
   FConexao.DriverName := 'SQLite';
   FConexao.Params.Database := 'C:\Projetos Pessoais\branas.io\motorista-pop\backend\banco-de-dados\motorista-pop.sqlite3';
   FConexao.Params.Add('LockingMode=Normal');
   FConexao.Open;
end;

destructor TDAOPosicaoFireDAC.Destroy;
begin
   FConexao.Close;
   FConexao.Destroy;
   inherited;
end;

procedure TDAOPosicaoFireDAC.Salvar(pDadoPosicao: TDadoPosicao);
begin
   inherited;
   FConexao.ExecSQL('INSERT INTO position ('+
                    '    position_id,'+
                    '    ride_id,'+
                    '    lat,'+
                    '    long,'+
                    '    date'+
                    ') VALUES ('+
                    '    :position_id,'+
                    '    :ride_id,'+
                    '    :lat,'+
                    '    :long,'+
                    '    :date'+
                    ')',
                    [pDadoPosicao.ID,
                     pDadoPosicao.IDDaCorrida,
                     pDadoPosicao.Latitude,
                     pDadoPosicao.Longitude,
                     pDadoPosicao.Data],
                    [ftString,
                     ftString,
                     ftFloat,
                     ftFloat,
                     ftFloat]);
end;

function TDAOPosicaoFireDAC.ObterListaDePosicoesDaCorrida(
  pIDDaCorrida: String): TListaDePosicoes;
var
   lQueryCorrida: TFDQuery;
   I : Integer;
   lPosicoes : array of TDadoPosicao;
begin
   Result := TListaDePosicoes.Create;
   try
      lQueryCorrida := TFDQuery.Create(nil);
      try
         lQueryCorrida.Connection := FConexao;
         lQueryCorrida.Open('SELECT position_id, ride_id, lat, long, date FROM position '+
                            'WHERE ride_id = :ride_id order by date',
                            [pIDDaCorrida], [ftString]);
         lQueryCorrida.First;
         while not lQueryCorrida.Eof do
         begin
            I := Length(lPosicoes);
            SetLength(lPosicoes, I+1);
            lPosicoes[I].ID          := lQueryCorrida.FieldByName('position_id').AsString;
            lPosicoes[I].IDDaCorrida := lQueryCorrida.FieldByName('ride_id').AsString;
            lPosicoes[I].Latitude    := lQueryCorrida.FieldByName('lat').AsFloat;
            lPosicoes[I].Longitude   := lQueryCorrida.FieldByName('long').AsFloat;
            lPosicoes[I].Data        := lQueryCorrida.FieldByName('date').AsFloat;
            Result.Add(lPosicoes[I]);
            lQueryCorrida.Next;
         end;
      finally
         lQueryCorrida.Destroy
      end;
   except
      Result.Destroy;
      raise;
   end;
end;

end.
