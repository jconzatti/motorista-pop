unit ContaUsuario.Servico;

interface

uses
   System.SysUtils,
   System.RegularExpressions,
   Data.DB,
   FireDAC.Comp.Client,
   FireDAC.DApt,
   FireDAC.Phys.SQLite,
   FireDAC.Stan.Async,
   FireDAC.Stan.Def,
   CPF.Validador;

type
   TDadoInscricaoContaUsuario = record
      Nome: String;
      Email: String;
      CPF: String;
      Passageiro: Boolean;
      Motorista: Boolean;
      PlacaDoCarro: String;
   end;

   TDadoContaUsuario = record
      ID: String;
      Nome: String;
      Email: String;
      CPF: String;
      Passageiro: Boolean;
      Motorista: Boolean;
      PlacaDoCarro: String;
      Data: TDateTime;
      Verificada: Boolean;
      CodigoDeVerificacao: String;
   end;

   TServicoContaUsuario = class
   private
      FConexao: TFDConnection;
      FValidadorCPF : TValidadorCPF;
      procedure EnviarEmail(pEmail, pAssunto, pMensagem: String);
      function ConverterData(pData: String): TDateTime;
   public
      constructor Create;
      destructor Destroy; override;
      function Inscrever(pEntradaDaContaDeUsuario: TDadoInscricaoContaUsuario): String;
      function Obter(pID: String): TDadoContaUsuario;
   end;

implementation

{ TServicoContaUsuario }

constructor TServicoContaUsuario.Create;
begin
   FValidadorCPF := TValidadorCPF.Create;
   FConexao := TFDConnection.Create(nil);
   FConexao.DriverName := 'SQLite';
   FConexao.Params.Database := 'C:\Projetos Pessoais\branas.io\motorista-pop\backend\banco-de-dados\motorista-pop.sqlite3';
   FConexao.Open;
end;

destructor TServicoContaUsuario.Destroy;
begin
   FConexao.Close;
   FConexao.Destroy;
   FValidadorCPF.Destroy;
   inherited;
end;

function TServicoContaUsuario.Inscrever(pEntradaDaContaDeUsuario: TDadoInscricaoContaUsuario): String;
var lIDDaContaDeUsuario: String;
    lCodigoDeVerificacaoDaConta: String;
    lGUID: TGUID;
    lQuantidadeDeContasDeUsuario: Integer;
begin
   if not TRegEx.IsMatch(pEntradaDaContaDeUsuario.Nome, '[a-zA-Z] [a-zA-Z]+') then
      raise EArgumentException.Create('Nome inválido!');
   if not TRegEx.IsMatch(pEntradaDaContaDeUsuario.Email, '^(.+)@(.+)$') then
      raise EArgumentException.Create('e-mail inválido!');
   if not FValidadorCPF.Validar(pEntradaDaContaDeUsuario.CPF) then
      raise EArgumentException.Create('CPF inválido!');
   if pEntradaDaContaDeUsuario.Motorista and (not TRegEx.IsMatch(pEntradaDaContaDeUsuario.PlacaDoCarro, '[A-Z]{3}[0-9]{4}')) then
      raise EArgumentException.Create('Placa do carro inválida!');
   lQuantidadeDeContasDeUsuario := FConexao.ExecSQLScalar('SELECT COUNT(*) FROM account WHERE email = :email',
                                                          [pEntradaDaContaDeUsuario.Email], [ftString]);
   if lQuantidadeDeContasDeUsuario > 0 then
      raise Exception.Create('Conta de usuário já existe!');
   CreateGUID(lGUID);
   lIDDaContaDeUsuario := lGUID.ToString;
   CreateGUID(lGUID);
   lCodigoDeVerificacaoDaConta := lGUID.ToString;
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
                    [lIDDaContaDeUsuario,
                     pEntradaDaContaDeUsuario.Nome,
                     pEntradaDaContaDeUsuario.Email,
                     pEntradaDaContaDeUsuario.CPF,
                     pEntradaDaContaDeUsuario.PlacaDoCarro,
                     Ord(pEntradaDaContaDeUsuario.Passageiro),
                     Ord(pEntradaDaContaDeUsuario.Motorista),
                     FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now),
                     0,
                     lCodigoDeVerificacaoDaConta],
                    [ftString,
                     ftString,
                     ftString,
                     ftString,
                     ftString,
                     ftInteger,
                     ftInteger,
                     ftString,
                     ftInteger,
                     ftString]);
   EnviarEmail(pEntradaDaContaDeUsuario.Email,
               'Verificação de Conta',
               Format('Por favor, verifique seu código no primeiro acesso %s', [lCodigoDeVerificacaoDaConta]));
   Result := lIDDaContaDeUsuario;
end;

function TServicoContaUsuario.Obter(pID: String): TDadoContaUsuario;
var
   lQueryContaDeUsuario: TFDQuery;
begin
   lQueryContaDeUsuario := TFDQuery.Create(nil);
   try
      lQueryContaDeUsuario.Connection := FConexao;
      lQueryContaDeUsuario.Open('SELECT name, email, cpf, car_plate, '+
                                'is_passenger, is_driver, date, is_verified, '+
                                'verification_code FROM account '+
                                'WHERE account_id = :account_id',
                                [pID], [ftString]);
      Result.ID           := pID;
      Result.Nome         := lQueryContaDeUsuario.FieldByName('name').AsString;
      Result.Email        := lQueryContaDeUsuario.FieldByName('email').AsString;
      Result.CPF          := lQueryContaDeUsuario.FieldByName('cpf').AsString;
      Result.PlacaDoCarro := lQueryContaDeUsuario.FieldByName('car_plate').AsString;
      Result.Passageiro   := lQueryContaDeUsuario.FieldByName('is_passenger').AsInteger = 1;
      Result.Motorista    := lQueryContaDeUsuario.FieldByName('is_driver').AsInteger = 1;
      Result.Data         := ConverterData(lQueryContaDeUsuario.FieldByName('date').AsString);
      Result.Verificada   := lQueryContaDeUsuario.FieldByName('is_verified').AsInteger = 1;
      Result.CodigoDeVerificacao := lQueryContaDeUsuario.FieldByName('verification_code').AsString;
   finally
      lQueryContaDeUsuario.Destroy
   end;
end;

function TServicoContaUsuario.ConverterData(pData: String): TDateTime;
var
   lFormatacao: TFormatSettings;
begin
   lFormatacao := TFormatSettings.Create;
   lFormatacao.ShortDateFormat := 'yyyy-mm-dd';
   lFormatacao.ShortTimeFormat := 'hh:nn:ss.zzz';
   lFormatacao.DateSeparator := '-';
   lFormatacao.TimeSeparator := ':';
   Result := StrToDateTime(pData, lFormatacao);
end;

procedure TServicoContaUsuario.EnviarEmail(pEmail, pAssunto, pMensagem: String);
begin
   Writeln(pEmail, pAssunto, pMensagem);
end;

end.
