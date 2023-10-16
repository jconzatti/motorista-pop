unit ContaDeUsuario.Repositorio.BancoDeDado;

interface

uses
   System.SysUtils,
   System.Generics.Collections,
   Data.DB,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   UUID,
   Email,
   Hash.Gerador,
   BancoDeDado.Conexao;

type
   TRepositorioContaDeUsuarioBancoDeDado = class(TRepositorioContaDeUsuario)
   private
      FConexaoBancoDeDado: TConexaoBancoDeDado;
      function Obter(pSQLSelect: String; pParametros: array of variant; pTiposDeDados: array of TFieldType): TContaDeUsuario;
   public
      procedure Salvar(pContaDeUsuario: TContaDeUsuario); override;
      function ObterPorEmail(pEmail: TEmail): TContaDeUsuario; override;
      function ObterPorID(pID: TUUID): TContaDeUsuario; override;
      constructor Create(pConexaoBancoDeDado: TConexaoBancoDeDado);
   end;

implementation

{ TRepositorioContaDeUsuarioBancoDeDado }

constructor TRepositorioContaDeUsuarioBancoDeDado.Create(
  pConexaoBancoDeDado: TConexaoBancoDeDado);
begin
   FConexaoBancoDeDado := pConexaoBancoDeDado;
end;

procedure TRepositorioContaDeUsuarioBancoDeDado.Salvar(
  pContaDeUsuario: TContaDeUsuario);
begin
   inherited;
   FConexaoBancoDeDado.Executar('INSERT INTO account ('+
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
                                [pContaDeUsuario.ID,
                                 pContaDeUsuario.Nome,
                                 pContaDeUsuario.Email,
                                 pContaDeUsuario.CPF,
                                 pContaDeUsuario.PlacaDoCarro,
                                 Ord(pContaDeUsuario.Passageiro),
                                 Ord(pContaDeUsuario.Motorista),
                                 pContaDeUsuario.Data,
                                 Ord(pContaDeUsuario.Verificada),
                                 pContaDeUsuario.CodigoDeVerificacao],
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

function TRepositorioContaDeUsuarioBancoDeDado.ObterPorEmail(pEmail: TEmail): TContaDeUsuario;
begin
   Result := Obter('SELECT account_id, name, email, cpf, car_plate, '+
                   'is_passenger, is_driver, date, is_verified, '+
                   'verification_code, password, algorithm FROM account '+
                   'WHERE email = :email',
                   [pEmail.Valor], [ftString]);
end;

function TRepositorioContaDeUsuarioBancoDeDado.ObterPorID(pID: TUUID): TContaDeUsuario;
begin
   Result := Obter('SELECT account_id, name, email, cpf, car_plate, '+
                   'is_passenger, is_driver, date, is_verified, '+
                   'verification_code, password, algorithm FROM account '+
                   'WHERE account_id = :account_id',
                   [pID.Valor], [ftString]);
end;

function TRepositorioContaDeUsuarioBancoDeDado.Obter(pSQLSelect: String;
  pParametros: array of variant;
  pTiposDeDados: array of TFieldType): TContaDeUsuario;
begin
   FConexaoBancoDeDado.Executar(pSQLSelect, pParametros, pTiposDeDados);
   FConexaoBancoDeDado.DataSet.First;
   if FConexaoBancoDeDado.DataSet.Eof then
      raise ERepositorioContaDeUsuarioNaoEncontrada.Create('Conta de usuário não encontada!');
   Result := TContaDeUsuario.Restaurar(FConexaoBancoDeDado.DataSet.FieldByName('account_id').AsString,
                                       FConexaoBancoDeDado.DataSet.FieldByName('name').AsString,
                                       FConexaoBancoDeDado.DataSet.FieldByName('email').AsString,
                                       FConexaoBancoDeDado.DataSet.FieldByName('cpf').AsString,
                                       FConexaoBancoDeDado.DataSet.FieldByName('is_passenger').AsInteger = 1,
                                       FConexaoBancoDeDado.DataSet.FieldByName('is_driver').AsInteger = 1,
                                       FConexaoBancoDeDado.DataSet.FieldByName('car_plate').AsString,
                                       FConexaoBancoDeDado.DataSet.FieldByName('date').AsFloat,
                                       FConexaoBancoDeDado.DataSet.FieldByName('is_verified').AsInteger = 1,
                                       FConexaoBancoDeDado.DataSet.FieldByName('verification_code').AsString,
                                       FConexaoBancoDeDado.DataSet.FieldByName('password').AsString,
                                       TAlgoritimoHash.Algoritimo(FConexaoBancoDeDado.DataSet.FieldByName('algorithm').AsString));
end;

end.
