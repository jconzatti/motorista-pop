unit Corrida.Servico;

interface

uses
   System.SysUtils,
   Data.DB,
   FireDAC.Comp.Client,
   FireDAC.DApt,
   FireDAC.Phys.SQLite,
   FireDAC.Stan.Async,
   FireDAC.Stan.Def,
   FireDAC.Stan.Intf,
   ContaUsuario.Servico;

type
   TDadoSolicitacaoCorrida = record
      IDDoPassageiro: String;
      DeLatitude: Double;
      DeLongitude: Double;
      ParaLatitude: Double;
      ParaLongitude: Double;
   end;

   TDadoCorrida = record
      ID: String;
      IDDoPassageiro: String;
      IDDoMotorista: String;
      Status: String;
      Tarifa: Double;
      Distancia: Double;
      DeLatitude: Double;
      DeLongitude: Double;
      ParaLatitude: Double;
      ParaLongitude: Double;
      Data: TDateTime;
   end;

   TServicoCorrida = class
   private
      FConexao: TFDConnection;
      procedure ValidarContaDeUsuarioEhPassageiro(pIDDoUsuario: String);
      procedure ValidarContaDeUsuarioEhMotorista(pIDDoUsuario: String);
      procedure ValidarPassageiroComTodasAsCorridasConcluidas(pIDDoPassageiro: String);
      procedure ValidarCorridaEstaSolicitada(pIDDaCorrida: String);
   public
      constructor Create;
      destructor Destroy; override;
      function Solicitar(pEntradaDaSolicitacaoDeCorrida: TDadoSolicitacaoCorrida): String;
      procedure Aceitar(pIDDaCorrida, pIDDoMotorista: String);
      function Obter(pID: String): TDadoCorrida;
   end;

implementation

{ TServicoCorrida }

constructor TServicoCorrida.Create;
begin
   FConexao := TFDConnection.Create(nil);
   FConexao.DriverName := 'SQLite';
   FConexao.Params.Database := 'C:\Projetos Pessoais\branas.io\motorista-pop\backend\banco-de-dados\motorista-pop.sqlite3';
   FConexao.Open;
end;

destructor TServicoCorrida.Destroy;
begin
   FConexao.Close;
   FConexao.Destroy;
   inherited;
end;

function TServicoCorrida.Solicitar(pEntradaDaSolicitacaoDeCorrida: TDadoSolicitacaoCorrida): String;
var
   lGUID: TGUID;
   lIDDaCorrida: String;
begin
   ValidarContaDeUsuarioEhPassageiro(pEntradaDaSolicitacaoDeCorrida.IDDoPassageiro);
   ValidarPassageiroComTodasAsCorridasConcluidas(pEntradaDaSolicitacaoDeCorrida.IDDoPassageiro);
   CreateGUID(lGUID);
   lIDDaCorrida := lGUID.ToString;
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
                    [lIDDaCorrida,
                     pEntradaDaSolicitacaoDeCorrida.IDDoPassageiro,
                     'requested',
                     pEntradaDaSolicitacaoDeCorrida.DeLatitude,
                     pEntradaDaSolicitacaoDeCorrida.DeLongitude,
                     pEntradaDaSolicitacaoDeCorrida.ParaLatitude,
                     pEntradaDaSolicitacaoDeCorrida.ParaLongitude,
                     Now],
                    [ftString,
                     ftString,
                     ftString,
                     ftFloat,
                     ftFloat,
                     ftFloat,
                     ftFloat,
                     ftFloat]);
   Result := lIDDaCorrida;
end;

procedure TServicoCorrida.Aceitar(pIDDaCorrida, pIDDoMotorista: String);
begin
   ValidarContaDeUsuarioEhMotorista(pIDDoMotorista);
   ValidarCorridaEstaSolicitada(pIDDaCorrida);
   FConexao.ExecSQL('UPDATE ride SET '+
                    'driver_id = :driver_id, '+
                    'status = :status '+
                    'WHERE ride_id = :ride_id',
                    [pIDDoMotorista, 'accepted', pIDDaCorrida],
                    [ftString, ftString, ftString]);
end;

function TServicoCorrida.Obter(pID: String): TDadoCorrida;
var
   lQueryCorrida: TFDQuery;
begin
   lQueryCorrida := TFDQuery.Create(nil);
   try
      lQueryCorrida.Connection := FConexao;
      lQueryCorrida.Open('SELECT ride_id, passenger_id, driver_id, status, '+
                         'fare, distance, from_lat, from_long, to_lat, to_long, '+
                         'date FROM ride WHERE ride_id = :ride_id', [pID], [ftString]);
      Result.ID             := pID;
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

procedure TServicoCorrida.ValidarContaDeUsuarioEhPassageiro(pIDDoUsuario: String);
var
   lContaDeUsuario: TDadoContaUsuario;
   lServicoDeContaDeUsuario : TServicoContaUsuario;
begin
   lServicoDeContaDeUsuario := TServicoContaUsuario.Create;
   try
      lContaDeUsuario := lServicoDeContaDeUsuario.Obter(pIDDoUsuario);
      if not lContaDeUsuario.Passageiro then
         raise EArgumentException.Create('Conta de usuário não pertence a um passageiro!');
   finally
      lServicoDeContaDeUsuario.Destroy;
   end;
end;

procedure TServicoCorrida.ValidarContaDeUsuarioEhMotorista(pIDDoUsuario: String);
var
   lContaDeUsuario: TDadoContaUsuario;
   lServicoDeContaDeUsuario : TServicoContaUsuario;
begin
   lServicoDeContaDeUsuario := TServicoContaUsuario.Create;
   try
      lContaDeUsuario := lServicoDeContaDeUsuario.Obter(pIDDoUsuario);
      if not lContaDeUsuario.Motorista then
         raise EArgumentException.Create('Conta de usuário não pertence a um motorista!');
   finally
      lServicoDeContaDeUsuario.Destroy;
   end;
end;

procedure TServicoCorrida.ValidarPassageiroComTodasAsCorridasConcluidas(pIDDoPassageiro: String);
var
   lQuantidadeDeCorridasNaoConcluidas: Integer;
begin
   lQuantidadeDeCorridasNaoConcluidas := FConexao.ExecSQLScalar('SELECT COUNT(*) FROM ride '+
                                                                'WHERE passenger_id = :passenger_id '+
                                                                'AND status <> :status',
                                                                [pIDDoPassageiro, 'completed'],
                                                                [ftString, ftString]);
   if lQuantidadeDeCorridasNaoConcluidas > 0 then
      raise EArgumentException.Create('Passageiro possui corridas não concluídas!');
end;

procedure TServicoCorrida.ValidarCorridaEstaSolicitada(pIDDaCorrida: String);
var
   lCorrida: TDadoCorrida;
begin
   lCorrida := Obter(pIDDaCorrida);
   if not lCorrida.Status.Equals('requested') then
      raise EArgumentException.Create('Corrida não solicitada!');
end;

end.
