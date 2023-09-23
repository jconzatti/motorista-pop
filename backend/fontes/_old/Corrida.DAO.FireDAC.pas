unit Corrida.DAO.FireDAC;

interface

uses
   Data.DB,
   FireDAC.Comp.Client,
   FireDAC.DApt,
   FireDAC.Phys.SQLite,
   FireDAC.Stan.Async,
   FireDAC.Stan.Def,
   FireDAC.Stan.Intf,
   Corrida.DAO;

type
   TDAOCorridaFireDAC = class(TDAOCorrida)
   private
      FConexao: TFDConnection;
      function ObterListaDeCorridas(pSQLSelect: String; pParametros: array of variant; pTiposDeDados: array of TFieldType): TListaDeCorridas;
   public
      constructor Create;
      destructor Destroy; override;
      procedure Salvar(pDadoCorrida: TDadoCorrida); override;
      procedure Atualizar(pDadoCorrida: TDadoCorrida); override;
      function ObterPorID(pID: String): TDadoCorrida; override;
      function ObterListaDeCorridasAtivasPeloIDDoPassageiro(pIDDoPassageiro: String): TListaDeCorridas; override;
      function ObterListaDeCorridasAtivasPeloIDDoMotorista(pIDDoMotorista: String): TListaDeCorridas; override;
   end;

implementation

{ TDAOCorridaFireDAC }

constructor TDAOCorridaFireDAC.Create;
begin
   FConexao := TFDConnection.Create(nil);
   FConexao.DriverName := 'SQLite';
   FConexao.Params.Database := 'C:\Projetos Pessoais\branas.io\motorista-pop\backend\banco-de-dados\motorista-pop.sqlite3';
   FConexao.Params.Add('LockingMode=Normal');
   FConexao.Open;
end;

destructor TDAOCorridaFireDAC.Destroy;
begin
   FConexao.Close;
   FConexao.Destroy;
   inherited;
end;

procedure TDAOCorridaFireDAC.Salvar(pDadoCorrida: TDadoCorrida);
begin
   inherited;
   FConexao.ExecSQL('INSERT INTO ride ('+
                    '    ride_id,'+
                    '    passenger_id,'+
                    '    status,'+
                    '    from_lat,'+
                    '    from_long,'+
                    '    to_lat,'+
                    '    to_long,'+
                    '    date'+
                    ') VALUES ('+
                    '    :ride_id,'+
                    '    :passenger_id,'+
                    '    :status,'+
                    '    :from_lat,'+
                    '    :from_long,'+
                    '    :to_lat,'+
                    '    :to_long,'+
                    '    :date'+
                    ')',
                    [pDadoCorrida.ID,
                     pDadoCorrida.IDDoPassageiro,
                     'requested',
                     pDadoCorrida.DeLatitude,
                     pDadoCorrida.DeLongitude,
                     pDadoCorrida.ParaLatitude,
                     pDadoCorrida.ParaLongitude,
                     pDadoCorrida.Data],
                    [ftString,
                     ftString,
                     ftString,
                     ftFloat,
                     ftFloat,
                     ftFloat,
                     ftFloat,
                     ftFloat]);
end;

procedure TDAOCorridaFireDAC.Atualizar(pDadoCorrida: TDadoCorrida);
begin
   inherited;
   FConexao.ExecSQL('UPDATE ride SET '+
                    'driver_id = :driver_id, '+
                    'status = :status, '+
                    'distance = :distance, '+
                    'fare = :fare '+
                    'WHERE ride_id = :ride_id',
                    [pDadoCorrida.IDDoMotorista,
                     pDadoCorrida.Status,
                     pDadoCorrida.Distancia,
                     pDadoCorrida.Tarifa,
                     pDadoCorrida.ID],
                    [ftString,
                     ftString,
                     ftFloat,
                     ftFloat,
                     ftString]);
end;

function TDAOCorridaFireDAC.ObterPorID(pID: String): TDadoCorrida;
var
   lQueryCorrida: TFDQuery;
begin
   lQueryCorrida := TFDQuery.Create(nil);
   try
      lQueryCorrida.Connection := FConexao;
      lQueryCorrida.Open('SELECT ride_id, passenger_id, driver_id, status, '+
                         'fare, distance, from_lat, from_long, to_lat, to_long, '+
                         'date FROM ride WHERE ride_id = :ride_id', [pID], [ftString]);
      Result.ID             := lQueryCorrida.FieldByName('ride_id').AsString;
      Result.IDDoPassageiro := lQueryCorrida.FieldByName('passenger_id').AsString;
      Result.IDDoMotorista  := lQueryCorrida.FieldByName('driver_id').AsString;
      Result.Status         := lQueryCorrida.FieldByName('status').AsString;
      Result.Tarifa         := lQueryCorrida.FieldByName('fare').AsFloat;
      Result.Distancia      := lQueryCorrida.FieldByName('distance').AsFloat;
      Result.DeLatitude     := lQueryCorrida.FieldByName('from_lat').AsFloat;
      Result.DeLongitude    := lQueryCorrida.FieldByName('from_long').AsFloat;
      Result.ParaLatitude   := lQueryCorrida.FieldByName('to_lat').AsFloat;
      Result.ParaLongitude  := lQueryCorrida.FieldByName('to_long').AsFloat;
      Result.Data           := lQueryCorrida.FieldByName('date').AsFloat;
   finally
      lQueryCorrida.Destroy
   end;
end;

function TDAOCorridaFireDAC.ObterListaDeCorridasAtivasPeloIDDoPassageiro(pIDDoPassageiro: String): TListaDeCorridas;
begin
   Result := ObterListaDeCorridas('SELECT ride_id, passenger_id, driver_id, status, '+
                                  'fare, distance, from_lat, from_long, to_lat, to_long, '+
                                  'date FROM ride '+
                                  'WHERE passenger_id = :passenger_id '+
                                  'AND status <> :status',
                                  [pIDDoPassageiro, 'completed'],
                                  [ftString, ftString]);
end;

function TDAOCorridaFireDAC.ObterListaDeCorridasAtivasPeloIDDoMotorista(pIDDoMotorista: String): TListaDeCorridas;
begin
   Result := ObterListaDeCorridas('SELECT ride_id, passenger_id, driver_id, status, '+
                                  'fare, distance, from_lat, from_long, to_lat, to_long, '+
                                  'date FROM ride '+
                                  'WHERE driver_id = :driver_id '+
                                  'AND status in (:status1, :status2)',
                                  [pIDDoMotorista, 'accepted', 'in_progress'],
                                  [ftString, ftString, ftString]);
end;

function TDAOCorridaFireDAC.ObterListaDeCorridas(pSQLSelect: String;
  pParametros: array of variant;
  pTiposDeDados: array of TFieldType): TListaDeCorridas;
var
   lQueryCorrida: TFDQuery;
   I : Integer;
   lCorridas : array of TDadoCorrida;
begin
   Result := TListaDeCorridas.Create;
   try
      lQueryCorrida := TFDQuery.Create(nil);
      try
         lQueryCorrida.Connection := FConexao;
         lQueryCorrida.Open(pSQLSelect, pParametros, pTiposDeDados);
         lQueryCorrida.First;
         while not lQueryCorrida.Eof do
         begin
            I := Length(lCorridas);
            SetLength(lCorridas, I+1);
            lCorridas[I].ID             := lQueryCorrida.FieldByName('ride_id').AsString;
            lCorridas[I].IDDoPassageiro := lQueryCorrida.FieldByName('passenger_id').AsString;
            lCorridas[I].IDDoMotorista  := lQueryCorrida.FieldByName('driver_id').AsString;
            lCorridas[I].Status         := lQueryCorrida.FieldByName('status').AsString;
            lCorridas[I].Tarifa         := lQueryCorrida.FieldByName('fare').AsFloat;
            lCorridas[I].Distancia      := lQueryCorrida.FieldByName('distance').AsFloat;
            lCorridas[I].DeLatitude     := lQueryCorrida.FieldByName('from_lat').AsFloat;
            lCorridas[I].DeLongitude    := lQueryCorrida.FieldByName('from_long').AsFloat;
            lCorridas[I].ParaLatitude   := lQueryCorrida.FieldByName('to_lat').AsFloat;
            lCorridas[I].ParaLongitude  := lQueryCorrida.FieldByName('to_long').AsFloat;
            lCorridas[I].Data           := lQueryCorrida.FieldByName('date').AsFloat;
            Result.Add(lCorridas[I]);
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
