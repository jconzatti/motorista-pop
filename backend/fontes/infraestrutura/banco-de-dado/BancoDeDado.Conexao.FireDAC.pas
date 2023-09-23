unit BancoDeDado.Conexao.FireDAC;

interface

uses
   System.Classes,
   Data.DB,
   FireDAC.Comp.Client,
   FireDAC.DApt,
   FireDAC.Phys.SQLite,
   FireDAC.Stan.Async,
   FireDAC.Stan.Def,
   FireDAC.Stan.Param,
   BancoDeDado.Conexao;

type
   TConexaoBancoDeDadoFireDAC = class(TConexaoBancoDeDado)
   private
      FConexao: TFDConnection;
      FQuery : TFDQuery;
   protected
      function ObterDataSet: TDataSet; override;
   public
      constructor Create;
      destructor Destroy; override;
      procedure Executar(const pComandoSQL: String; const pListaParametro: array of Variant; const pListaTipo: array of TFieldType); overload; override;
   end;

implementation

{ TConexaoBancoDeDadoFireDAC }

constructor TConexaoBancoDeDadoFireDAC.Create;
begin
   FConexao := TFDConnection.Create(nil);
   FConexao.DriverName := 'SQLite';
   FConexao.Params.Database := 'C:\Projetos Pessoais\branas.io\motorista-pop\backend\banco-de-dados\motorista-pop.sqlite3';
   FConexao.Params.Add('LockingMode=Normal');
   FConexao.Open;

   FQuery := TFDQuery.Create(nil);
   FQuery.Connection := FConexao;
end;

destructor TConexaoBancoDeDadoFireDAC.Destroy;
begin
   FQuery.Destroy;
   FConexao.Close;
   FConexao.Destroy;
   inherited;
end;

procedure TConexaoBancoDeDadoFireDAC.Executar(const pComandoSQL: String;
  const pListaParametro: array of Variant;
  const pListaTipo: array of TFieldType);
var I : Integer;
begin
   inherited;
   FQuery.SQL.Text := pComandoSQL;
   for i := Low(pListaTipo) to High(pListaTipo) do
      if pListaTipo[i] <> ftUnknown then
         FQuery.Params[i].DataType := pListaTipo[i];
   for i := Low(pListaParametro) to High(pListaParametro) do
      FQuery.Params[i].Value := pListaParametro[i];
   FQuery.OpenOrExecute;
end;

function TConexaoBancoDeDadoFireDAC.ObterDataSet: TDataSet;
begin
   Result := FQuery;
end;

end.
