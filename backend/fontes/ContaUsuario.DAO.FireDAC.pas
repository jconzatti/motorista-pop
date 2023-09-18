unit ContaUsuario.DAO.FireDAC;

interface

uses
   Data.DB,
   FireDAC.Comp.Client,
   FireDAC.DApt,
   FireDAC.Phys.SQLite,
   FireDAC.Stan.Async,
   FireDAC.Stan.Def,
   ContaUsuario.DAO;

type
   TDAOContaUsuarioFireDAC = class(TDAOContaUsuario)
   private
      FConexao: TFDConnection;
      function Obter(pSQLSelect: String; pParametros: array of variant; pTiposDeDados: array of TFieldType): TDadoContaUsuario;
   public
      constructor Create;
      destructor Destroy; override;
      procedure Salvar(pDadoContaUsuario: TDadoContaUsuario); override;
      function ObterPorEmail(pEmail: String): TDadoContaUsuario; override;
      function ObterPorID(pID: String): TDadoContaUsuario; override;
   end;

implementation

{ TDAOContaUsuarioFireDAC }

constructor TDAOContaUsuarioFireDAC.Create;
begin
   FConexao := TFDConnection.Create(nil);
   FConexao.DriverName := 'SQLite';
   FConexao.Params.Database := 'C:\Projetos Pessoais\branas.io\motorista-pop\backend\banco-de-dados\motorista-pop.sqlite3';
   FConexao.Params.Add('LockingMode=Normal');
   FConexao.Open;
end;

destructor TDAOContaUsuarioFireDAC.Destroy;
begin
   FConexao.Close;
   FConexao.Destroy;
   inherited;
end;

procedure TDAOContaUsuarioFireDAC.Salvar(pDadoContaUsuario: TDadoContaUsuario);
begin
  inherited;
   FConexao.ExecSQL('INSERT INTO account ('+
                    '    account_id,'+
                    '    name,'+
                    '    email,'+
                    '    cpf,'+
                    '    car_plate,'+
                    '    is_passenger,'+
                    '    is_driver,'+
                    '    date,'+
                    '    is_verified,'+
                    '    verification_code'+
                    ') VALUES ('+
                    '    :account_id,'+
                    '    :name,'+
                    '    :email,'+
                    '    :cpf,'+
                    '    :car_plate,'+
                    '    :is_passenger,'+
                    '    :is_driver,'+
                    '    :date,'+
                    '    :is_verified,'+
                    '    :verification_code'+
                    ')',
                    [pDadoContaUsuario.ID,
                     pDadoContaUsuario.Nome,
                     pDadoContaUsuario.Email,
                     pDadoContaUsuario.CPF,
                     pDadoContaUsuario.PlacaDoCarro,
                     Ord(pDadoContaUsuario.Passageiro),
                     Ord(pDadoContaUsuario.Motorista),
                     pDadoContaUsuario.Data,
                     Ord(pDadoContaUsuario.Verificada),
                     pDadoContaUsuario.CodigoDeVerificacao],
                    [ftString,
                     ftString,
                     ftString,
                     ftString,
                     ftString,
                     ftInteger,
                     ftInteger,
                     ftFloat,
                     ftInteger,
                     ftString]);
end;

function TDAOContaUsuarioFireDAC.ObterPorEmail(pEmail: String): TDadoContaUsuario;
begin
   Result := Obter('SELECT account_id, name, email, cpf, car_plate, '+
                   'is_passenger, is_driver, date, is_verified, '+
                   'verification_code FROM account '+
                   'WHERE email = :email',
                   [pEmail], [ftString]);
end;

function TDAOContaUsuarioFireDAC.ObterPorID(pID: String): TDadoContaUsuario;
begin
   Result := Obter('SELECT account_id, name, email, cpf, car_plate, '+
                   'is_passenger, is_driver, date, is_verified, '+
                   'verification_code FROM account '+
                   'WHERE account_id = :account_id',
                   [pID], [ftString]);
end;

function TDAOContaUsuarioFireDAC.Obter(pSQLSelect: String;
  pParametros: array of variant;
  pTiposDeDados: array of TFieldType): TDadoContaUsuario;
var
   lQueryContaDeUsuario: TFDQuery;
begin
   lQueryContaDeUsuario := TFDQuery.Create(nil);
   try
      lQueryContaDeUsuario.Connection := FConexao;
      lQueryContaDeUsuario.Open(pSQLSelect, pParametros, pTiposDeDados);
      Result.ID           := lQueryContaDeUsuario.FieldByName('account_id').AsString;
      Result.Nome         := lQueryContaDeUsuario.FieldByName('name').AsString;
      Result.Email        := lQueryContaDeUsuario.FieldByName('email').AsString;
      Result.CPF          := lQueryContaDeUsuario.FieldByName('cpf').AsString;
      Result.PlacaDoCarro := lQueryContaDeUsuario.FieldByName('car_plate').AsString;
      Result.Passageiro   := lQueryContaDeUsuario.FieldByName('is_passenger').AsInteger = 1;
      Result.Motorista    := lQueryContaDeUsuario.FieldByName('is_driver').AsInteger = 1;
      Result.Data         := lQueryContaDeUsuario.FieldByName('date').AsFloat;
      Result.Verificada   := lQueryContaDeUsuario.FieldByName('is_verified').AsInteger = 1;
      Result.CodigoDeVerificacao := lQueryContaDeUsuario.FieldByName('verification_code').AsString;
   finally
      lQueryContaDeUsuario.Destroy
   end;
end;

end.
