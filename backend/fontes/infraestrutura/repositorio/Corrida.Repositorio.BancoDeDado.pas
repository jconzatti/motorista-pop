unit Corrida.Repositorio.BancoDeDado;

interface

uses
   System.SysUtils,
   Data.DB,
   BancoDeDado.Conexao,
   UUID,
   Corrida,
   Corrida.Status,
   Corrida.Repositorio;

type
   TRepositorioCorridaBancoDeDado = class(TRepositorioCorrida)
   private
      FConexaoBancoDeDado: TConexaoBancoDeDado;
      function ObterListaDeCorridas(pSQLSelect: String; pParametros: array of variant; pTiposDeDados: array of TFieldType): TListaDeCorridas;
   public
      constructor Create(pConexaoBancoDeDado: TConexaoBancoDeDado); reintroduce;
      procedure Salvar(pCorrida: TCorrida); override;
      procedure Atualizar(pCorrida: TCorrida); override;
      function ObterPorID(pID: TUUID): TCorrida; override;
      function ObterListaDeCorridasAtivasDoPassageiro(pIDDoPassageiro: TUUID): TListaDeCorridas; override;
      function ObterListaDeCorridasAtivasDoMotorista(pIDDoMotorista: TUUID): TListaDeCorridas; override;
   end;

implementation

{ TRepositorioCorridaBancoDeDado }

constructor TRepositorioCorridaBancoDeDado.Create(pConexaoBancoDeDado: TConexaoBancoDeDado);
begin
   FConexaoBancoDeDado := pConexaoBancoDeDado;
end;

procedure TRepositorioCorridaBancoDeDado.Salvar(pCorrida: TCorrida);
begin
   inherited;
   FConexaoBancoDeDado.Executar('INSERT INTO ride ('+
                                '    ride_id,'+
                                '    passenger_id,'+
                                '    driver_id,'+
                                '    status,'+
                                '    from_lat,'+
                                '    from_long,'+
                                '    to_lat,'+
                                '    to_long,'+
                                '    date'+
                                ') VALUES ('+
                                '    :ride_id,'+
                                '    :passenger_id,'+
                                '    :driver_id,'+
                                '    :status,'+
                                '    :from_lat,'+
                                '    :from_long,'+
                                '    :to_lat,'+
                                '    :to_long,'+
                                '    :date'+
                                ')',
                                [pCorrida.ID,
                                 pCorrida.IDDoPassageiro,
                                 pCorrida.IDDoMotorista,
                                 pCorrida.Status.Valor,
                                 pCorrida.De.Latitude,
                                 pCorrida.De.Longitude,
                                 pCorrida.Para.Latitude,
                                 pCorrida.Para.Longitude,
                                 pCorrida.Data],
                                [ftString,
                                 ftString,
                                 ftString,
                                 ftString,
                                 ftFloat,
                                 ftFloat,
                                 ftFloat,
                                 ftFloat,
                                 ftFloat]);
end;

procedure TRepositorioCorridaBancoDeDado.Atualizar(pCorrida: TCorrida);
begin
   inherited;
   FConexaoBancoDeDado.Executar('UPDATE ride SET '+
                                'driver_id = :driver_id, '+
                                'status = :status, '+
                                'distance = :distance, '+
                                'fare = :fare '+
                                'WHERE ride_id = :ride_id',
                                [pCorrida.IDDoMotorista,
                                 pCorrida.Status.Valor,
                                 pCorrida.Distancia,
                                 pCorrida.Tarifa,
                                 pCorrida.ID],
                                [ftString,
                                 ftString,
                                 ftFloat,
                                 ftFloat,
                                 ftString]);
end;

function TRepositorioCorridaBancoDeDado.ObterPorID(pID: TUUID): TCorrida;
begin
   FConexaoBancoDeDado.Executar('SELECT ride_id, passenger_id, driver_id, status, '+
                                'fare, distance, from_lat, from_long, to_lat, to_long, '+
                                'date FROM ride WHERE ride_id = :ride_id', [pID.Valor], [ftString]);
   FConexaoBancoDeDado.DataSet.First;
   if FConexaoBancoDeDado.DataSet.Eof then
      raise ECorridaNaoEncontrada.Create(Format('Corrida com ID %s não encontada!', [pID.Valor]));
   Result := TCorrida.Restaurar(FConexaoBancoDeDado.DataSet.FieldByName('ride_id').AsString,
                                FConexaoBancoDeDado.DataSet.FieldByName('passenger_id').AsString,
                                FConexaoBancoDeDado.DataSet.FieldByName('driver_id').AsString,
                                TStatusCorrida.Status(FConexaoBancoDeDado.DataSet.FieldByName('status').AsString),
                                FConexaoBancoDeDado.DataSet.FieldByName('fare').AsFloat,
                                FConexaoBancoDeDado.DataSet.FieldByName('distance').AsFloat,
                                FConexaoBancoDeDado.DataSet.FieldByName('from_lat').AsFloat,
                                FConexaoBancoDeDado.DataSet.FieldByName('from_long').AsFloat,
                                FConexaoBancoDeDado.DataSet.FieldByName('to_lat').AsFloat,
                                FConexaoBancoDeDado.DataSet.FieldByName('to_long').AsFloat,
                                FConexaoBancoDeDado.DataSet.FieldByName('date').AsFloat);
end;

function TRepositorioCorridaBancoDeDado.ObterListaDeCorridasAtivasDoPassageiro(
  pIDDoPassageiro: TUUID): TListaDeCorridas;
begin
   Result := ObterListaDeCorridas('SELECT ride_id, passenger_id, driver_id, status, '+
                                  'fare, distance, from_lat, from_long, to_lat, to_long, '+
                                  'date FROM ride '+
                                  'WHERE passenger_id = :passenger_id '+
                                  'AND status not in (:statusFinalizado, :statusCancelado)',
                                  [pIDDoPassageiro.Valor,
                                   TStatusCorrida.Finalizada.Valor,
                                   TStatusCorrida.Cancelada.Valor],
                                  [ftString, ftString, ftString]);
end;

function TRepositorioCorridaBancoDeDado.ObterListaDeCorridasAtivasDoMotorista(
  pIDDoMotorista: TUUID): TListaDeCorridas;
begin
   Result := ObterListaDeCorridas('SELECT ride_id, passenger_id, driver_id, status, '+
                                  'fare, distance, from_lat, from_long, to_lat, to_long, '+
                                  'date FROM ride '+
                                  'WHERE driver_id = :driver_id '+
                                  'AND status in (:statusAceito, :statusIniciada)',
                                  [pIDDoMotorista.Valor,
                                   TStatusCorrida.Aceita.Valor,
                                   TStatusCorrida.Iniciada.Valor],
                                  [ftString, ftString, ftString]);
end;

function TRepositorioCorridaBancoDeDado.ObterListaDeCorridas(pSQLSelect: String;
  pParametros: array of variant;
  pTiposDeDados: array of TFieldType): TListaDeCorridas;
begin
   Result := TListaDeCorridas.Create;
   try
      FConexaoBancoDeDado.Executar(pSQLSelect, pParametros, pTiposDeDados);
      FConexaoBancoDeDado.DataSet.First;
      while not FConexaoBancoDeDado.DataSet.Eof do
      begin
         Result.Add(TCorrida.Restaurar(FConexaoBancoDeDado.DataSet.FieldByName('ride_id').AsString,
                                       FConexaoBancoDeDado.DataSet.FieldByName('passenger_id').AsString,
                                       FConexaoBancoDeDado.DataSet.FieldByName('driver_id').AsString,
                                       TStatusCorrida.Status(FConexaoBancoDeDado.DataSet.FieldByName('status').AsString),
                                       FConexaoBancoDeDado.DataSet.FieldByName('fare').AsFloat,
                                       FConexaoBancoDeDado.DataSet.FieldByName('distance').AsFloat,
                                       FConexaoBancoDeDado.DataSet.FieldByName('from_lat').AsFloat,
                                       FConexaoBancoDeDado.DataSet.FieldByName('from_long').AsFloat,
                                       FConexaoBancoDeDado.DataSet.FieldByName('to_lat').AsFloat,
                                       FConexaoBancoDeDado.DataSet.FieldByName('to_long').AsFloat,
                                       FConexaoBancoDeDado.DataSet.FieldByName('date').AsFloat));
         FConexaoBancoDeDado.DataSet.Next;
      end;
   except
      Result.Destroy;
      raise;
   end;
end;

end.
